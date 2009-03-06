# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'imap_connector'

class ImapConnectorTest < Test::Unit::TestCase
  def test_find_senders_and_ccs_addresses
    imap_connector = ImapConnector.new('login','pass','host')
    imap_connector.find_senders_and_ccs_addresses
    imap_connector.sort_email_addresses(imap_connector.ccs).each() { |email,name| puts name+"  "+email  }
    imap_connector.sort_email_addresses(imap_connector.senders).each() { |email,name| puts name+"  "+email  }
    assert(imap_connector.ccs.size>0,"The ccs list is empty !")
    assert(imap_connector.senders.size>0,"The senders list is empty !")

  end
end
