require 'net/imap'
class ImapConnector
  #
  #  attr_writer :login
  #  attr_writer :password
  #  attr_writer :host
  #  attr_writer :ssl
  #  attr_writer :port
  #  attr_writer :mailbox
  attr_reader :senders
  attr_reader :ccs

  def initialize(login,password,host,mailbox='INBOX',ssl=false,port=143)
    @imap = Net::IMAP.new(host, port, ssl)
    #login
    @imap.login(login, password)
    @imap.examine(mailbox)
  end
  def find_senders_and_ccs_addresses
    uids = @imap.uid_search(['ALL'])
    @senders = Hash.new
    @ccs =Hash.new
    @imap.uid_fetch(uids, ['ENVELOPE']).each do |data|
      begin
        ccs = data.attr['ENVELOPE'].cc
        if ccs != nil
          ccs.each do|cc|
            #puts 'cc  : '+cc.mailbox+'@'+cc.host
            if(cc.name!=nil)
              @ccs[cc.mailbox+'@'+cc.host]=cc.name
            else
              @ccs[cc.mailbox+'@'+cc.host]=cc.mailbox
            end
          end

        end
        if data.attr['ENVELOPE'].sender[0] !=nil
          name = ''
          mailbox =''
          host=''
          if(data.attr['ENVELOPE'].sender[0].name!=nil)
            name = data.attr['ENVELOPE'].sender[0].name
          end
          if(data.attr['ENVELOPE'].sender[0].mailbox!=nil)
            mailbox = data.attr['ENVELOPE'].sender[0].mailbox
          end
          if(data.attr['ENVELOPE'].sender[0].host!=nil)
            host = data.attr['ENVELOPE'].sender[0].host
          end
          if(name!='')
            @senders[mailbox+'@'+host] = name
          else
            @senders[mailbox+'@'+host] =mailbox
          end
          #puts 'sender : '+name +' : '+mailbox+'@'+host

        end
      rescue => e
        puts "Error during parse of "+data.attr['ENVELOPE'].to_s
        puts e.to_s
      end
    end
  end

  def sort_email_addresses(addresses_hash)
    addresses_hash =  addresses_hash.sort{|x,y| x[1].downcase <=> y[1].downcase }
  end

end
