$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'email_address_grabber'
require 'yaml'
require 'pop_connector'
require 'imap_connector'

#input_file_path ="/home/anthony/truc.txt"
output_file_path = Dir.pwd+"/"+"result.txt"


puts "Welcome to EmailAddressesGrabber !"
puts "Please enter the path of the result file, default is result.txt in the current directory : "+Dir.pwd+" : "
result_choice= gets.chomp
if(result_choice!="")
  output_file_path = result_choice
end
puts "result will be written to : "+output_file_path

puts "Choose your method of email collecting :"
puts "[1] : from file"
puts "[2] : from a pop3 email acount"
puts "[3] : from an imap email acount"

method = gets.chomp().to_i
case method
when 1
  #collecting from file
  puts "please enter the path of the file containing the addresses : "
  file_path = gets.chomp
  f = File.new(file_path, "r")
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
  puts "OK! Finished writing to : "+output_file_path


when 2
  #collecting pop3
  config = YAML::load(File.open("../config.yml"))
  puts "according to the config.yml file, the pop3 account to process is : "
  puts "login : "+config['pop3']['login']
  puts "host : "+config['pop3']['host']
  puts "processing email addresses search..."
  pop_connector = PopConnector.new(config['pop3']['login'],config['pop3']['password'],config['pop3']['host'],config['pop3']['ssl'],config['pop3']['port'])
  puts "Parsing and finding addresses... (this may last a few minutes)"
  pop_connector.find_senders_and_ccs_addresses
  puts "Sorting addresses..."
  email_address_grabber = EmailAddressGrabber.new
  email_address_grabber.email_addresses_found = pop_connector.senders+pop_connector.ccs
  email_address_grabber.sort_email_addresses
  email_address_grabber.delete_duplicate_elements
  email_address_grabber.write_to_file(output_file_path)
  puts "OK! Finished writing to : "+output_file_path

when 3
  #collecting imap
  config = YAML::load(File.open("../config.yml"))
  puts "according to the config.yml file, the imap account to process is : "
  puts "login : "+config['imap']['login']
  puts "host : "+config['imap']['host']
  puts "processing email addresses search..."
  imap_connector = ImapConnector.new(config['imap']['login'],config['imap']['password'],config['imap']['host'],config['imap']['mailbox'],config['imap']['ssl'],config['imap']['port'])
  puts "Parsing and finding addresses... (this may last a few minutes)"
  imap_connector.find_all_senders_and_ccs_from_all_mailboxes
  puts "Sorting addresses..."
  email_address_grabber = EmailAddressGrabber.new
  email_address_grabber.email_addresses_found = imap_connector.addresses_found
  email_address_grabber.sort_email_addresses
  email_address_grabber.delete_duplicate_elements
  email_address_grabber.write_to_file(output_file_path)
  puts "OK! Finished writing to : "+output_file_path


end
