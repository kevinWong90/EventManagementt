class TicketsController < ApplicationController
	before_filter :top_header

	def top_header
		@title = "Ticket"
	end

	def index
		allTickets = current_user.tickets
		@tickets = Array.new
		allTickets.each do |ticket|
			if params[:view_past].nil? && ticket.event.startDate >= Time.now
				@tickets << ticket
			elsif !params[:view_past].nil? && ticket.event.startDate < Time.now
				@tickets << ticket	
			end
		end
	end

	def show
		@ticket = Ticket.find(params[:id])
	end

	def create
		if !params[:purchase].nil?
			event = Event.find(params[:event_id])
			if event.nil?
				redirect_to home_index_path
			else
				allTicketsOfEvent = event.tickets
				currentSeating = 0
				allTicketsOfEvent.each do |tick|
					currentSeating += tick.quantity.to_i
				end
				
				if event.maxCapacity >=  currentSeating + params[:quantity].to_i
					ticket = Ticket.new
					ticket.user = current_user
					ticket.event = event
					ticket.ticketType = params[:ticketType]
					ticket.price = params[:price]
					ticket.quantity = params[:quantity]
					if ticket.save!
						ticket.barcode = generate_ticket_barcode(ticket.id)
						ticket.save!
						redirect_to tickets_index_path
					else
						redirect_to home_index_path
					end
				else
					flash[:notice] = "Event has reached its limit"
					redirect_to home_index_path
				end
			end
		else
			flash[:notice] = "Event has reached its limit"
			redirect_to home_index_path
		end
	end

	def delete_multiple
	    if params[:ticket_ids].nil?
	      redirect_to tickets_index_path, :notice => "No Ticket is selected!"
	    else
	      tickets_selected = Ticket.find(params[:ticket_ids])
	      tickets_selected.each do |t|
	        t.destroy
	      end
	      flash[:notice] = "Ticket(s) deleted successfully."
	      redirect_to tickets_index_path
	    end
  end

  private 
  def generate_ticket_barcode(id)
  	#random_pass is found in application controller
	return id.to_s+random_pass[0,5]
  end

end
