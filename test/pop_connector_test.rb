# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'pop_connector'

class PopConnectorTest < Test::Unit::TestCase
  def test_find_senders_and_ccs_addresses
    pop_connector = PopConnector.new('login', 'pass', 'host')
    pop_connector.find_senders_and_ccs_addresses
    #pop_connector.senders.each { |address| puts "From: " + address }
    #pop_connector.ccs.each { |address| puts "Cc: "+  address }
    #puts  pop_connector.ccs[1]
    assert(pop_connector.senders.length>0,"No From addresses found while scanning the mailbox")
    assert(pop_connector.ccs.length>0,"No CC addresses found while scanning the mailbox")
   

  end

  def test_find_from_address
    address_found = PopConnector.find_from_address("blablalkjkljk\n From: truc@machin.com")
    assert_equal "truc@machin.com", address_found, "Address not found"
  end
  def test_find_cc_addresses
    addresses_found = PopConnector.find_cc_addresses("blablalkjkljk\n From: truc@machin.com\n Cc: bof@truc.com,bidule@ouai.fr,youpi@super.us\n")
    assert_equal(["bof@truc.com","bidule@ouai.fr","youpi@super.us"], addresses_found, "Addresses not found")
  end
  def test_find_cc_addresses_one_address
    addresses_found = PopConnector.find_cc_addresses("blablalkjkljk\n From: truc@machin.com\n Cc: bof@truc.com")
    assert_equal(["bof@truc.com"], addresses_found, "Address not found")
  end
end
