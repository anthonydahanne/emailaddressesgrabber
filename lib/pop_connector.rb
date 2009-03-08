require 'net/pop'

class PopConnector
FROM_EMAIL_PATTERN = Regexp.new('(From: )(([a-zA-Z0-9]|[-_&])+\.?([a-zA-Z0-9]|[-_&])*@([a-zA-Z]|[-_&.])*\.{1}(AERO|ARPA|ASIA|BIZ|CAT|COM|COOP|EDU|GOV|INFO|INT|JOBS|MIL|MOBI|MUSEUM|NAME|NET|ORG|PRO|TEL|TRAVEL|XN--JXALPDLP|XN--KGBECHTV|XN--ZCKZAH|[a-z]{2}))',true)
CCS_EMAIL_PATTERN = Regexp.new('(Cc: )(.*)$',true)

  attr_reader :senders
  attr_reader :ccs
  def initialize(login,password,host,is_apop=false,port=110)
    @pop = Net::POP3.new(host,port,is_apop)
    @pop.start(login, password)             # (1)
    
  end

  def find_senders_and_ccs_addresses
    if @pop.mails.empty?
      @senders = nil
      @ccs=nil
    else
      @senders=[]
      @ccs=[]
      @pop.each_mail do |m|   # or "pop.mails.each ..."   # (2)
        @senders.push(PopConnector.find_from_address(m.pop))
        ccs_addresses = PopConnector.find_cc_addresses(m.pop)
        ccs_addresses.each { |i|@ccs.push(i)  } unless ccs_addresses==nil
        @senders.compact!
        @ccs.compact!
      end
    end
    @pop.finish
  end

  def self.find_from_address(message)
    #parse message and find "From" field and the address associated to it
    message.match(FROM_EMAIL_PATTERN).to_a[2]
  end

  def self.find_cc_addresses(message)
    #parse message and find "CC" field and the addresses associated to it
    addresses_separated_by_semi_colums =  message.match(CCS_EMAIL_PATTERN).to_a[2]
    if(addresses_separated_by_semi_colums==nil)
      return nil
    end
    return addresses_separated_by_semi_colums.split(/,/)
  end

end
