require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "to_receive_all_emails scope" do
    colin = Factory(:admin)
    michael = Factory(:user)
    mo = Factory(:user, :receive_all_emails => true)

    assert_same_elements [colin, mo], User.to_receive_all_emails
  end

  test "can_edit?" do
    michael = Factory(:user)
    colin = Factory(:admin)
    jeffrey = Factory(:user)

    ticket = Factory(:ticket, :creator => michael)

    assert michael.can_edit?(ticket)
    assert colin.can_edit?(ticket)
    assert !jeffrey.can_edit?(ticket)
  end
end
