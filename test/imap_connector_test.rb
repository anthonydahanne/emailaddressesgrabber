# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'imap_connector'

class ImapConnectorTest < Test::Unit::TestCase
  def test_find_senders_and_ccs_addresses
    config = YAML::load(File.open("config.yml"))
    imap_connector = ImapConnector.new(config['imap']['login'],config['imap']['password'],config['imap']['host'],config['imap']['mailbox'],config['imap']['ssl'],config['imap']['port'])
    imap_connector.find_senders_and_ccs_addresses('INBOX')
    imap_connector.sort_email_addresses(imap_connector.ccs).each() { |email,name| puts name+"  "+email  }
    imap_connector.sort_email_addresses(imap_connector.senders).each() { |email,name| puts name+"  "+email  }
    assert(imap_connector.ccs.size>0,"The ccs list is empty !")
    assert(imap_connector.senders.size>0,"The senders list is empty !")

  end

  def test_find_all_mailboxes
    config = YAML::load(File.open("config.yml"))
    imap_connector = ImapConnector.new(config['imap']['login'],config['imap']['password'],config['imap']['host'],config['imap']['mailbox'],config['imap']['ssl'],config['imap']['port'])
    imap_connector.find_all_mailboxes
    expected_mailboxes = ["INBOX/sent-mail","INBOX"]
    assert_equal(expected_mailboxes, imap_connector.mailboxes, "Did not find the expected mailboxes !")

  end

  def test_find_all_addresses_from_all_mailboxes
    config = YAML::load(File.open("config.yml"))
    imap_connector = ImapConnector.new(config['imap']['login'],config['imap']['password'],config['imap']['host'],config['imap']['mailbox'],config['imap']['ssl'],config['imap']['port'])
    imap_connector.find_all_senders_and_ccs_from_all_mailboxes
    assert(imap_connector.addresses_found.size>0,"The addresses list is empty !")

  end


end
