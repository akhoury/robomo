require File.dirname(__FILE__) + '/../test_helper'

class TicketLinkTest < ActiveSupport::TestCase
  
  setup do
    @controller.instance_variable_set :@current_user, Factory(:admin)
    @ticket1 = Factory(:ticket, :summary => "created ticket")
    @ticket2 = Factory(:ticket, :summary => "create second ticket")
  end
  
  test "presence of two tickets per link" do
    
    ticket_link = Factory.build(:ticket_link)
    
    assert !ticket_link.save
    
  end
  
  test "uniqueness of links made" do
    ticket_link1 = Factory.build(:ticket_link, :ticket_id => @ticket1.id, :linked_ticket_id => @ticket2.id)
    ticket_link2 = Factory.build(:ticket_link, :ticket_id => @ticket2.id, :linked_ticket_id => @ticket1.id)
    
    assert ticket_link1.save
    assert !ticket_link2.save
  end
  
  
end