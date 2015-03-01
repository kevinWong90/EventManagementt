class Event < ActiveRecord::Base
   validate :check_date

    #all relations
    has_many :event_user_relations, :dependent => :destroy
	has_many :users, :through => :event_user_relations
	has_many :tickets, :dependent => :destroy

	def self.visibilityTypes
		return [
			"Private",
			"Public"
		]
	end
	def self.eventTypes
		return [
			"Free",
			"Paid"
		]
	end
	#all validations
	validates :name, :presence => true
	validates :visibility, :presence => true, inclusion: {:in => visibilityTypes}
	validates :eventType, :presence => true, inclusion: {:in => eventTypes}
	validates :location, :presence => true 
	validates :postalCode, :presence => true 
	validates :country, :presence => true  
	validates :startDate, :presence => true 
	validates :endDate, :presence => true 
	validates :maxCapacity, :presence => true 
  
  private
  def check_date
	if self.startDate > self.endDate
		errors.add(:startDate, 'Start date cannot be later than end date')
	elsif self.startDate < Time.now
		errors.add(:startDate, 'Start date cannot be earlier than today')
	elsif self.endDate < self.startDate
		errors.add(:endDate, 'End date cannot be earlier than start date')  
	end
  end
end
