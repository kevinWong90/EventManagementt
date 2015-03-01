class Ticket < ActiveRecord::Base
	#all relations
	belongs_to :event
	belongs_to :user

	def self.ticketTypes
		return [
			"Normal",
			"VIP",
			"Invitation"
		]
	end
	
	#all validations
	validates :ticketType, presence: true, inclusion: {:in => ticketTypes}
	validates :user, presence: true
	validates :event, presence: true
	validates :price, presence: true
	validates :quantity, presence: true

end
