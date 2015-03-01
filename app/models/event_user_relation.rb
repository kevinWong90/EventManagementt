class EventUserRelation < ActiveRecord::Base
	#all relations
	belongs_to :event
	belongs_to :user

	def self.userRoles
		return [
			"Admin",
			"Editor"
		]
	end
	
	#all validations
	validates :userRole, inclusion: {:in => userRoles}
	validates :user_id, :uniqueness => { :scope => :event_id }
	validates :user, presence: true
	validates :event, presence: true
end
