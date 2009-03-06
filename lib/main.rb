

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'email_address_grabber'

input_file_path ="/home/anthony/truc.txt"
output_file_path = "test.txt"

f = File.new(input_file_path, "r")
string_to_parse = String.new
while(line = f.gets)
  string_to_parse << line;

end
email_address_grabber = EmailAddressGrabber.new
email_address_grabber.text_to_parse = string_to_parse
puts "Parsing and finding addresses... (this may last a few minutes)"
email_address_grabber.parse_and_find_email_address
puts "Sorting addresses..."
email_address_grabber.sort_email_addresses
email_address_grabber.write_to_file(output_file_path)
puts "OK! Finished writing to : "+Dir.getwd+"/"+output_file_path
      

