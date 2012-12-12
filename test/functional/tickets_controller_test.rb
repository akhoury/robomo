require File.dirname(__FILE__) + '/../test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @controller.instance_variable_set :@current_user, Factory(:admin)
  end

  test "index" do
    tickets = 20.times.map { Factory(:ticket) }

    get :index
    assert_same_elements tickets, assigns(:tickets)
  end

  test "new" do
    get :new
    assert_response :success
    [:description, :sprint_tag, :summary].each do |field|
      assert_select "textarea[name='ticket[#{field}]'], input[name='ticket[#{field}]']", 1
    end
    assert_select("input[name='ticket[importance]']", 4){|e| assert "[type=radio]"}
    assert_select("input[name='ticket[readiness]']", 5){|e| assert "[type=radio]"}
  end

  test "create" do
    ticket = Factory.build(:ticket, :summary => "created ticket")

    assert_equal nil, Ticket.find_by_summary("created ticket")
    post :create, :ticket => ticket.attributes.symbolize_keys.slice(:summary, :description, :readiness, :importance)
    assert_response :redirect
    assert Ticket.find_by_summary "created ticket"
  end

  test "show" do
    ticket = Factory(:ticket)
    get :show, :id => ticket.id
    assert_response :ok
    assert_select '*', /#{ticket.summary}/
  end

  test "pagination doesn't change tag list" do
    20.times {|i| Factory(:ticket, :tag_list => "tag-#{i}") }
    get :index, :page => 200
    assert_response :ok
    assert_select 'tbody tr', :count => 0 
    assert_select "#tag-cloud a", :count => 20
  end

  test "change_state" do
    ticket = Factory(:ticket)
    assert 'submitted', ticket.state
    post :change_state, :transition => 'begin_work', :id => ticket.id
    assert 'in_progress', ticket.reload.state
  end

  test "should show submission date" do
    Timecop.freeze(5.days.ago) do
      Factory(:ticket, :summary => 'cybernetic hedgehogs for all!')
    end

    get :index 
    assert_select 'tr td:last-child time', :text => 5.days.ago.strftime('%m/%d/%Y')
  end

  test "tag cloud links should not have the current page in them" do
    100.times {Factory(:ticket, :tag_list => 'wombat,combat')}
    get :index, :page => 2
    assert_select '#tag-cloud a' do |links|
      links.each do |link|
        assert_no_match /page/, link.attributes['href']
      end
    end
  end 

  context "tag clouds on tagged pages should allow drill-down" do
    setup do
      @one = Factory(:ticket, :tag_list => 'one')
      @two = Factory(:ticket, :tag_list => 'one,two')
      @three = Factory(:ticket, :tag_list => 'one,two,three')
    end

    should "work with no tags active" do
      get :index
      assert_same_elements [@one, @two, @three], assigns(:tickets)
      assert_select '#tag-cloud a' do |links|
        assert_equal 3, links.length
        links.each do |link|
          assert %w{one two three}.member? tagged_with_from_uri(link).first
        end
      end
    end

    should "work with one tag active" do
      get :index, :tagged_with => ['one']
      assert_same_elements [@one, @two, @three], assigns(:tickets)
      assert_select '#tag-cloud a' do |links|
        assert_equal 2, links.length
        links.each do |link|
          tags = tagged_with_from_uri(link)
          assert tags.member?("one")
          assert tags.member?("two") || tags.member?("three")
        end
      end
    end

    should "work with two tags active" do
      get :index, :tagged_with => ['one', 'two']
      assert_same_elements [@two, @three], assigns(:tickets)
      assert_select '#tag-cloud a' do |links|
        assert_equal 1, links.length
        link = links.first
        assert_same_elements %w{one two three}, tagged_with_from_uri(link)
      end
    end

    should "work with all tags active" do
      get :index, :tagged_with => ['one', 'two', 'three']
      assert_same_elements [@three], assigns(:tickets)
      assert_select '#tag-cloud a', :count => 0 
    end
  end

  def tagged_with_from_uri(link)
    CGI.parse(URI::parse(link.attributes['href']).query)['tagged_with[]']
  end

  test "search" do
    cat_description = Factory(:ticket, :description => "cats are adorable")
    cat_summary = Factory(:ticket, :summary => "do you think cats are adorable?")
    cat_reproduction = Factory(:ticket, :summary => "when two felines really love each other... baby cats")

    something_not_cat_related = Factory(:ticket)

    get :index, :matching => "cats"
    assert_same_elements [cat_description, cat_summary, cat_reproduction], assigns(:tickets)
  end
end
