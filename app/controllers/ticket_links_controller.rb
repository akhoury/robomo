class TicketLinksController < ApplicationController
  
  def create
    @ticket_link = TicketLink.create(params[:ticket_link])
    redirect_to ticket_path(@ticket_link.ticket)
  end
  
  def destroy
    @ticket_link = TicketLink.find_by_id(params[:id])
    @ticket_link.destroy
    redirect_to ticket_path(@ticket_link.linked_ticket)
  end

end