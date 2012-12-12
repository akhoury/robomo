class CcUsersController < ApplicationController
  def create
    super do |format|
      @ticket = @cc_user.ticket
      format.html { render :partial => "tickets/cced_users"}
    end
  end

  def destroy
    super do |format|
      @ticket = @cc_user.ticket
      format.html { render :partial => "tickets/cced_users"}
    end
  end
end
