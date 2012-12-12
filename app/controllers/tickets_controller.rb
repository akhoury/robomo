class TicketsController < ApplicationController
  before_filter :find_tags, :only => :index
  before_filter :assign_creator, :only => :create
  before_filter :find_ticket_and_assign_last_modified_by, :only => [:change_state, :update, :mark_as_duplicate, :mark_as_exclusive_with]
  respond_to :html

  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag' 

  has_scope :sorted, :using => [:col, :dir], :default => {:col => 'last_updated', :dir => 'desc'}
  has_scope :matching
  has_scope :page, :default => 1
  has_scope :state
  has_scope :scheduled
  has_scope :tagged_with, :type => :array 
  has_scope :created_at

  # TODO: this is a bit of a lame hack to always include the creator with
  # InheritedResources. I don't feel great about it.
  has_scope :with_creator, :default => 1

  new! do |format|
    @ticket.assets.build
  end

  edit! do |format|
    @ticket.assets.build
  end

  show! do |format|
    @post = @ticket.posts.build
    @post.assets.build
  end

  # no support for distinct values in autocomplete macro. jerks.
  def autocomplete_tickets
    query = "summary ilike ?"
    args = ["%#{params[:term]}%"]
    if params[:term] =~ /^\d+$/
      query += " or id = ?" 
      args << params[:term].to_i
    end
    render :json => (Ticket.select('id, summary').where(query, *args).map do |i| 
      {:label => "#{i.id} : #{i.summary}", :value => i.id}
    end)
  end

  def autocomplete_ticket_sprint_tag
    render :json => Ticket.select('distinct sprint_tag').where("sprint_tag ilike ?", "#{params[:term]}%").map(&:sprint_tag).map {|i| {:label => i, :value => i}}
  end

  def mark_as_duplicate
    ticket = Ticket.find params[:id]
    duplicate = Ticket.find params[:duplicate_id]
    ticket.duplicates << duplicate
    if ticket.save
      flash[:notice] = "Idea marked as a duplicate of #{duplicate.id} - #{duplicate.summary}"
    else 
      flash[:error] = "Something went wrong marking this idea as a duplicate."
    end
    redirect_to :action => :show
  end

  def mark_as_exclusive_with
    ticket = Ticket.find params[:id]
    other = Ticket.find params[:exclusive_with_id]
    ticket.exclusions << other
    if ticket.save
      flash[:notice] = "Idea marked as a exclusive with #{other.id} - #{other.summary}"
    else 
      flash[:error] = "Something went wrong marking this idea as a duplicate."
    end
    redirect_to :action => :show
  end

  def index
    super do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def delete
    @ticket = Ticket.find_by_id(params[:id])
    @ticket.destroy
    flash[:notice] = "Idea #{@ticket.id} deleted"
    redirect_to :action => :index
  end

  def perform_search
    @search_term = params[:search][:term]
    @tickets = Ticket
    @tickets = @tickets.where("sprint_tag ilike :tag", {:tag => "%#{@search_term}%"}) if @search_term.present?
    @tickets = @tickets.where(:state => params[:search][:state]) if params[:search][:state].present?
    @tickets = @tickets.page(params[:page])
    params[:state] = 'search'
    render :action => "index"
  end

  def change_state
    @ticket.send(params[:transition])
    redirect_to ticket_path(@ticket)
  end

  def assign_creator
    params[:ticket][:creator_id] = current_user.id
    params[:ticket][:last_modified_by] = current_user.id
  end

  def find_ticket_and_assign_last_modified_by
    @ticket = Ticket.find_by_id(params[:id])
    @ticket.update_attributes(:last_modified_user => current_user)
    @ticket.save
  end
  
  def find_tags
    @tagged_tickets = apply_scopes(Ticket, params.reject{|k,v| k == 'page'})
  end
end
