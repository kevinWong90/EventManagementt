class HomeController < ApplicationController
before_filter :top_header
skip_before_filter :authenticate_user!

	def top_header
		@title = "Home"
	end

	def index
		#similar to sql select ... where visibility... AND owner_id...
		@events = Event.where(:visibility => "Public").where('startDate >= ?',Time.now)			
		#defaul ascending
		@events.sort_by{|e| e[:startDate]}
	end
end
