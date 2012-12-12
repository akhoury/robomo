require File.dirname(__FILE__) + '/../test_helper'

class TicketLinksControllerTest < ActionController::TestCase
  setup do
    @controller.instance_variable_set :@current_user, Factory(:admin)
    @ticket1 = Factory(:ticket, :summary => "created ticket")
    @ticket2 = Factory(:ticket, :summary => "create second ticket")
  end
  
  test "create" do
    
    assert_equal 0, TicketLink.count
    post :create, :ticket_link => {:ticket_id => @ticket1.id, :linked_ticket_id => @ticket2.id}
    assert_response :redirect
    assert_equal 1, TicketLink.count
  end
  
  test "destroy" do
    ticketlink = Factory :ticket_link, :ticket_id => @ticket1.id, :linked_ticket_id => @ticket2.id
    
    post :destroy, :id => ticketlink.id
    assert_response :redirect
    assert_equal 0, TicketLink.count
  end
end