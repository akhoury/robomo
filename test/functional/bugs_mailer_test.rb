require File.dirname(__FILE__) + '/../test_helper'

class BugsMailerTest < ActionMailer::TestCase
  setup do
    @colin = Factory(:admin, :email => "colin@bugs.com")
    @michael = Factory(:user, :email => "michael@bugs.com")
    @jeffrey = Factory(:user, :email => "jeffrey@bugs.com")
    @mo = Factory(:user, :email => "mo@bugs.com", :receive_all_emails => true)
  end

  context "notification emails" do
    setup do
      assert_no_emails
      @t = Factory(:ticket, :creator => @michael)
    end
    should "creating a ticket should send an email to receive_all_emails list" do
      assert_emails 1
      email = ActionMailer::Base.deliveries.last
      assert_same_elements [@colin, @mo].map(&:email), email.to
      assert_match /New Ticket/, email.subject
    end

    should "adding a post to a ticket should send an email to everybody on the thread except the poster" do
      @p = Factory(:post, :ticket => @t, :creator => @jeffrey)
      assert_emails 2
      email = ActionMailer::Base.deliveries.last
      assert_same_elements [@colin, @mo, @michael].map(&:email), email.to
      assert_match /New Post to/, email.subject
    end

    should "Send an email to everybody on the cc list" do
      cc = Factory(:cc_user, :user => @jeffrey, :ticket => @t)
      @t.reload

      @p = Factory(:post, :ticket => @t, :creator => @michael)
      assert_emails 2
      email = ActionMailer::Base.deliveries.last
      assert_same_elements [@colin, @mo, @jeffrey].map(&:email), email.to
      assert_match /New Post to/, email.subject
    end
  end
end
