require File.dirname(__FILE__) + '/../test_helper'

class TicketTest < ActiveSupport::TestCase
  test "self.matching(something)" do
    cat_description = Factory(:ticket, :description => "cats are adorable")
    cat_summary = Factory(:ticket, :summary => "do you think cats are adorable?")
    cat_reproduction = Factory(:ticket, :summary => "when two felines really love each other... baby cats")

    something_not_cat_related = Factory(:ticket)

    assert_same_elements [cat_description, cat_summary, cat_reproduction], Ticket.matching('cats')
  end

  test "sorting" do
    Timecop.freeze(5.days.ago) do
      @first = Factory(:ticket) 
    end
    @second = Factory(:ticket)

    assert_equal [@first, @second], Ticket.sorted('created_at', 'asc').all
    assert_equal [@second, @first], Ticket.sorted('created_at', 'desc').all
  end

  test "set_time_to_first_reply" do
    t = nil

    Timecop.freeze(Time.parse("2010-02-04 10:23:10")) do
      t = Factory(:ticket)
    end

    # adding a first post sets the time
    Timecop.freeze(Time.parse("2010-02-04 11:23:10")) do
      Factory(:post, :ticket => t)
      assert_equal 3600, t.reload.time_to_first_reply_in_seconds
    end

    # adding a new post won't change it
    Timecop.freeze(Time.parse("2010-02-04 11:28:10")) do
      Factory(:post, :ticket => t)
      assert_equal 3600, t.reload.time_to_first_reply_in_seconds
    end
  end

  test "thread_members" do
    michael = Factory(:user)
    jeffrey = Factory(:user)
    mav = Factory(:user)

    t = Factory(:ticket, :creator => michael)
    assert_equal [michael], t.thread_members

    Factory(:post, :creator => jeffrey, :ticket => t)
    assert_equal [michael, jeffrey], t.reload.thread_members

    Factory(:post, :creator => michael, :ticket => t)
    assert_equal [michael, jeffrey], t.reload.thread_members

    Factory(:post, :creator => mav, :ticket => t)
    assert_equal [michael, jeffrey, mav], t.reload.thread_members
  end

  test "users_to_cc" do
    michael = Factory(:user)
    jeffrey = Factory(:user)
    mav = Factory(:user)

    t = Factory(:ticket, :creator => michael)
    assert_equal [michael], t.thread_members
    assert_equal [], t.reload.users_to_cc

    Factory(:post, :creator => jeffrey, :ticket => t)
    assert_equal [michael, jeffrey], t.reload.thread_members
    assert_equal [], t.reload.users_to_cc

    Factory(:cc_user, :user => mav, :ticket => t)
    assert_equal [mav], t.reload.users_to_cc
  end

  context "states" do
    setup do
      @t = Factory(:ticket)
    end
    should "start off as pending" do
      assert_equal 'submitted', @t.state
    end
    should "be able to be moved into in_progress state" do
      @t.begin_work
      assert_equal 'in_progress', @t.reload.state
    end
    should "be able to mark as postponed" do
      @t.postpone
      assert_equal 'postponed', @t.reload.state
    end
    should "be able to be scheduled for estimation" do
      @t.schedule_for_estimation
      assert_equal 'scheduled_for_estimation', @t.reload.state
    end
    should "be able to be marked as estimated" do
      @t.mark_estimated
      assert_equal 'estimated', @t.reload.state
    end
    context "after estimation" do
      setup do
        @t.mark_estimated
      end
      should "be able to move to submitted again" do
        @t.submitted
        assert_equal 'submitted', @t.reload.state
      end
      should "be able to have work begun on it" do
        @t.begin_work
        assert_equal 'in_progress', @t.reload.state
      end
      should "be able to be released" do
        @t.release
        assert_equal 'released', @t.reload.state
      end
    end
    context "after scheduling for estimation" do
      setup do
        @t.schedule_for_estimation
      end
      should "be able to move to submitted again" do
        @t.submitted
        assert_equal 'submitted', @t.reload.state
      end
      should "be able to have work begun on it" do
        @t.begin_work
        assert_equal 'in_progress', @t.reload.state
      end
      should "be able to be released" do
        @t.release
        assert_equal 'released', @t.reload.state
      end
      should "be able to go to scheduled for estimation" do
        @t.schedule_for_estimation
        assert_equal 'scheduled_for_estimation', @t.reload.state
      end
    end
    context "after being started" do
      setup do
        @t.begin_work
      end
      should "be able to move to submitted again" do
        @t.submitted
        assert_equal 'submitted', @t.reload.state
      end
      should "be able to be released" do
        @t.release
        assert_equal 'released', @t.reload.state
      end
      should "be able to be marked as estimated" do
        @t.mark_estimated
        assert_equal 'estimated', @t.reload.state
      end
      context "after being released" do
        setup do
          @t.release
        end
        should "not be able to be marked as scheduled for estimation or estimated" do
          @t.schedule_for_estimation
          assert_equal 'released', @t.reload.state
          @t.mark_estimated
          assert_equal 'released', @t.reload.state
        end
      end
    end
  end
  
  test 'scheduled named scope' do
    ticket1 = Factory(:ticket, :sprint_tag => '049', :state => 'submitted')
    ticket2 = Factory(:ticket, :state => 'scheduled_for_estimation')
    ticket3 = Factory(:ticket, :state => 'released')    
    assert Ticket.scheduled.include?(ticket1)
    assert !Ticket.scheduled.include?(ticket2)
    assert !Ticket.scheduled.include?(ticket3)
  end
  
  test 'importance' do
    ticket = Factory(:ticket)
    assert !ticket.update_attributes(:importance => 5)
    assert_equal :importance, ticket.errors.first.first
  end
end
