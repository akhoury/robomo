require 'test_helper'

class CcUserTest < ActiveSupport::TestCase
  test "has a valid factory" do
    Factory(:cc_user).valid?
  end
end
