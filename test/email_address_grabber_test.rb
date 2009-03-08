
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'email_address_grabber'

  class EmailAddressGrabberTest < Test::Unit::TestCase
    def test_class_instanciation
      email_address_grabber = EmailAddressGrabber.new
      assert_not_nil(email_address_grabber,'Class did not instanciate.')
    end

    def test_parse_and_find_email_address
      string_to_parse = 'hello!!!adress989@trucmuche.st!!lkmlklm'
      email_address_grabber = EmailAddressGrabber.new
      email_address_grabber.text_to_parse = string_to_parse
      email_address = email_address_grabber.parse_and_find_email_address
      assert_equal('adress989@trucmuche.st', email_address, 'Did not find the email address correctly')
    end
    def test_parse_and_find_email_address
      string_to_parse = 'adre8787sE7897trio@trucmuche.st;anthony@dahanne.net;bla.bla@truc.machin.bidule.com;Anthony@dahanne.net;anthony@dahanne.net;anthony@dahanne.net;o-u_a&ip@tr-uc.com'
      email_address_grabber = EmailAddressGrabber.new
      email_address_grabber.text_to_parse = string_to_parse
      email_address = email_address_grabber.parse_and_find_email_address
      assert_equal('adre8787sE7897trio@trucmuche.st', email_address[0], 'Did not find the email address correctly')
      assert_equal('anthony@dahanne.net', email_address[1], 'Did not find the email address correctly')
      assert_equal('bla.bla@truc.machin.bidule.com', email_address[2], 'Did not find the email address correctly')
      assert_equal('o-u_a&ip@tr-uc.com', email_address[3], 'Did not find the email address correctly')


    end
    def test_is_email_address_correct
      string_to_parse = 'adre8787sE7897trio@trucmuche.com'
      email_address_grabber = EmailAddressGrabber.new
      assert(email_address_grabber.is_email_address_correct(string_to_parse), 'The email address found was not correct')
    end

    def test_is_email_address_incorrect
      string_to_parse = 'adre8787sE7897trio@trucmuche.i'
      email_address_grabber = EmailAddressGrabber.new
      assert(!email_address_grabber.is_email_address_correct(string_to_parse), 'The email address found was not correct')
    end
    def test_is_email_address_incorrect2
      string_to_parse = 'adre8787sE7897trio@trucmuche.ikjljk'
      email_address_grabber = EmailAddressGrabber.new
      assert(!email_address_grabber.is_email_address_correct(string_to_parse), 'The email address found was not correct')
    end
    def test_sort_email_addresses
      email_address_grabber = EmailAddressGrabber.new
      email_address_grabber.email_addresses_found=Array.new
      email_address_grabber.email_addresses_found.push("f@b.net","1234@truc.net","A@ouai.truc","z@yu.com","Z@io.fr")
      email_address_grabber.sort_email_addresses
      sorted_array =  Array.new
      sorted_array.push("1234@truc.net","A@ouai.truc","f@b.net","Z@io.fr","z@yu.com")
      assert_equal(sorted_array,email_address_grabber.email_addresses_found , "The email addresses given are not sorted")

    end

    def test_export_to_file
      string_to_parse = 'adre8787sE7897trio@trucmuche.st;!!!!anthony@dahanne.net;%%**blabla@truc.com;anthony@dahanne.net;anthony@dahanne.net;anthony@dahanne.net;ouaip@truc.com'
      email_address_grabber = EmailAddressGrabber.new
      email_address_grabber.text_to_parse = string_to_parse
      email_address_grabber.parse_and_find_email_address
      email_address_grabber.write_to_file("email_adresses_to_parse.txt")
      test_file = File.new("email_adresses_to_parse.txt",'r')
      email_addresses_found_in_file = String.new
      while(line= test_file.gets)
        email_addresses_found_in_file << line
      end
      expected_result = "adre8787sE7897trio@trucmuche.st;\nanthony@dahanne.net;\nblabla@truc.com;\nouaip@truc.com;\n"

      assert_equal expected_result, email_addresses_found_in_file, "Couldn't find the addresses in the file"
      File.delete(test_file.path)
    end

    def test_delete_duplicate_elements
      email_address_grabber = EmailAddressGrabber.new
      email_address_grabber.email_addresses_found = ["anthony@truc.com","Anthony@truc.com"]
      email_address_grabber.delete_duplicate_elements
      assert_equal ["anthony@truc.com"], email_address_grabber.email_addresses_found
    end

  end
