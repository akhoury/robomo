class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.find(:all, :order => :name)
  end

  def delete
    ActsAsTaggableOn::Tag.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
