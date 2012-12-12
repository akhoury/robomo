class PostsController < ApplicationController
  before_filter :assign_creator, :only => :create
  belongs_to :ticket
  respond_to :html

  actions :all, :except => [:show, :index, :new, :edit]


  update! do |success, failure|
    failure.html { render :template => "/tickets/show" }
  end

  create! do |success, failure|
    failure.html { render :template => "/tickets/show" }
  end

  def assign_creator
    params[:post][:creator_id] = current_user.id
  end
end
