class EmailAddressGrabber
  attr_writer :text_to_parse
  attr_writer :email_address_found
  attr_accessor :email_addresses_found

  EMAIL_PATTERN = Regexp.new('([a-zA-Z0-9]|[-_&])+\.?([a-zA-Z0-9]|[-_&])*@([a-zA-Z]|[-_&.])*\.{1}(AERO|ARPA|ASIA|BIZ|CAT|COM|COOP|EDU|GOV|INFO|INT|JOBS|MIL|MOBI|MUSEUM|NAME|NET|ORG|PRO|TEL|TRAVEL|XN--JXALPDLP|XN--KGBECHTV|XN--ZCKZAH|[a-z]{2})',true)
  #EMAIL_PATTERN = Regexp.new('([a-zA-Z0-9])+\.{0,1}([a-zA-Z0-9])*@([a-zA-Z])*\.{1}([a-z]{2,4})')
#EMAIL_PATTERN = Regexp.new("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)\b")

  def initialize
    
  end

  def is_email_address_correct
    if @email_address_found.match(EMAIL_PATTERN) && @email_address_found.match(EMAIL_PATTERN).to_a[0].length == @email_address_found.length

      return true
    else
      return false
    end
  end

  def parse_and_find_email_address
    matches = Array.new
    i=0
    while(@text_to_parse.match(EMAIL_PATTERN))
      current_match = @text_to_parse.match(EMAIL_PATTERN).to_a[0]
      addresses_already_equals_to_current = matches.select { |match| match.upcase  ==current_match.upcase  }
      if(addresses_already_equals_to_current.size==0)
        matches.push(current_match)
        i=i+1
        @text_to_parse.slice!(matches[i-1])
      else
        @text_to_parse.slice!(current_match)

      end
      #      puts current_match
    end

    @email_addresses_found= matches
      
  end

  def sort_email_addresses
    @email_addresses_found =  @email_addresses_found.sort{|x,y| x.downcase <=> y.downcase }
  end

  def write_to_file(file_path)
    temp_string = String.new
    @email_addresses_found.each{|email_address| temp_string+=email_address+";\n"}
    File.open(file_path, 'w') {|f| f.write(temp_string) }

    #f =  File.new(file_path, 'w')
    #f.clos
  end


end
