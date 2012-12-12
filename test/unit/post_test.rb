require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "sets last_post_at on the accompanying ticket on create" do
    ticket = Factory(:ticket)
    assert_nil ticket.reload.last_post_at

    one_week_ago = 1.week.ago
    Timecop.freeze(one_week_ago) do
      post = Factory(:post, :ticket => ticket)
      assert_equal one_week_ago, ticket.reload.last_post_at.to_time
    end

    now = Time.now
    Timecop.freeze(now) do
      post = Factory(:post, :ticket => ticket)
      assert_equal now, ticket.reload.last_post_at.to_time
    end
  end

  test "sets time_to_first_reply on create" do
    ticket = Factory(:ticket)
    ticket.expects(:set_time_to_first_reply)

    post = Factory(:post, :ticket => ticket)
  end
end
