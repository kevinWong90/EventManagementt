class EventsController < ApplicationController
	
	before_filter :top_header

	def top_header
		@title = "Event"
	end

	def index
		allEventUserRelation = current_user.event_user_relations
		@ownEvents = Array.new
		allEventUserRelation.each do |relation|
			event = relation.event
			if params[:view_past].nil? && event.startDate >= Time.now
				@ownEvents << event
			elsif !params[:view_past].nil? && event.startDate < Time.now
				@ownEvents << event	
			end
		end
		@attendedEvents = Array.new
		allTickets = current_user.tickets
		allTickets.each do |ticket|
			event = ticket.event
			if params[:view_past].nil? && event.startDate >= Time.now
				@attendedEvents << event
			elsif !params[:view_past].nil? && event.startDate < Time.now
				@attendedEvents << event	
			end
		end
		@ownEvents = @ownEvents.uniq
		@attendedEvents = @attendedEvents.uniq
	end

	def visitor_page
		@event = Event.find(params[:id])
		if !@event.nil?
			#similar to sql select ... where belongsTo... AND owner_id...
			@categories = Category.where(:belongsTo => "Event").where(:owner_id => @event.id)
		end
		if @event.eventType == "Free"
			@ticketTypes = ["Normal"]
			@pricing = [0]
		#if the eventType is payable handle different pricing here for diff tickettypes
		else
			@ticketTypes = ["Normal"]
			@pricing = [0]
		end
		@quantities = [1,2,3,4,5,6,7,8,9,10]

	end

	def new
		@event = Event.new
		@categoriesType = Category.validEventTypes
		@visibilityTypes = Event.visibilityTypes
		@eventTypes = Event.eventTypes
		@countries = get_list_of_countries

		@organizations = Array.new
		allOrganizationUserRelation = current_user.organization_user_relations
		allOrganizationUserRelation.each do |relation|
			if relation.userRole == "Admin"
				@organizations << relation.organization
			end
		end
	end

	def create
		if !params[:create].nil?

			params.permit!
			event = Event.new(params[:event])
			event.visibility = params[:visibilityType];
			event.eventType = params[:eventType];
			event.country = params[:country];
			
			eventParams = params[:event]

			sdate = DateTime.new( 
					eventParams["startDate(1i)"].to_i, #year
                    eventParams["startDate(2i)"].to_i, #mth
                    eventParams["startDate(3i)"].to_i, #day
                   	eventParams["startDate(4i)"].to_i, #hour
                    eventParams["startDate(5i)"].to_i, #min
                    0 								   #sec
                	)	
			edate = DateTime.new( 
					eventParams["endDate(1i)"].to_i, 
                    eventParams["endDate(2i)"].to_i, 
                    eventParams["endDate(3i)"].to_i, 
                    eventParams["endDate(4i)"].to_i, 
                    eventParams["endDate(5i)"].to_i, 
                    0)
			event.startDate = sdate
			event.endDate = edate
			if event.save!
				#check category
				category = Category.new
				category.name = params[:categoryName]
				category.categoryType = params[:categoryName]
				category.belongsTo = "Event"
				category.owner_id = event.id
				category.save!
				#create relationship with admin
				relationship = EventUserRelation.new
				relationship.userRole = "Admin"
				relationship.event = event
				relationship.user = current_user
				relationship.organization_id = params[:organization_id]
				relationship.save!
				flash[:success] = "Event has been created"
			else
				flash[:error] = "Error in creation of Event."
			end
		end
		redirect_to events_path
	end

	def edit
		@event = Event.find(params[:id])
		@categoriesType = Category.validEventTypes
		@visibilityTypes = Event.visibilityTypes
		@eventTypes = Event.eventTypes
		@countries = get_list_of_countries

		@organizations = Array.new
		allOrganizationUserRelation = current_user.organization_user_relations
		allOrganizationUserRelation.each do |relation|
			if relation.userRole == "Admin"
				@organizations << relation.organization
			end
		end
	end

	def update
		if params[:update].nil?
			params.permit!
			event = Event.find(params[:id])
			event.name = params[:name]
			event.location = params[:location]
			event.postalCode = params[:postalCode]
			event.maxCapacity = params[:maxCapacity]
			event.visibility = params[:visibilityType];
			event.eventType = params[:eventType];
			event.country = params[:country];
			
			eventParams = params[:event]

			sdate = DateTime.new( 
					eventParams["startDate(1i)"].to_i, #year
		            eventParams["startDate(2i)"].to_i, #mth
		            eventParams["startDate(3i)"].to_i, #day
		           	eventParams["startDate(4i)"].to_i, #hour
		            eventParams["startDate(5i)"].to_i, #min
		            0 								   #sec
		        	)	
			edate = DateTime.new( 
					eventParams["endDate(1i)"].to_i, 
		            eventParams["endDate(2i)"].to_i, 
		            eventParams["endDate(3i)"].to_i, 
		            eventParams["endDate(4i)"].to_i, 
		            eventParams["endDate(5i)"].to_i, 
		            0)
			event.startDate = sdate
			event.endDate = edate
			if event.save!
				#check category
				category = Category.where(:belongsTo => "Event").where(:owner_id => event.id).first
				category.name = params[:categoryName]
				category.categoryType = params[:categoryName]
				category.save!
				#create relationship with admin
				relationship = current_user.event_user_relations.where(:event_id => event.id).first
				relationship.organization_id = params[:organization_id]
				relationship.save!
				flash[:success] = "Event has been updated"
			else
				flash[:error] = "Error in creation of Event."
			end
		end
		redirect_to events_path
	end

	def show
		@event = Event.find(params[:id])
		if !@event.nil?
			#similar to sql select ... where belongsTo... AND owner_id...
			@categories = Category.where(:belongsTo => "Event").where(:owner_id => @event.id)
		end
		
		if !current_user.event_user_relations.where(:event_id => @event.id).where(:userRole => "Admin").empty?
			@tickets = @event.tickets
		end
	end

	def destroy
		@event = Event.find(params[:id])

      	if @event.destroy
      		flash[:success] = "Event has been deleted"
      		redirect_to events_path
    	end
    	
	end

	def delete_multiple
	    if params[:event_ids].nil?
	      redirect_to events_path, :notice => "No Event is selected!"
	    else
	      events_selected = Event.find(params[:event_ids])
	      events_selected.each do |e|
	        e.event_user_relations.destroyAll(:user_id => current_user.id)
	      	if e.event_user_relations.empty?
	      		e.destroy
	      	end
	      end
	      flash[:notice] = "Event(s) deleted successfully."
	      redirect_to events_path
	    end
  	end
end
