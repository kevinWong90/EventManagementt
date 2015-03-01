class OrganizationUserRelation < ActiveRecord::Base
	#all relations
	belongs_to :organization
	belongs_to :user

	def self.userRoles
		return [
			"Admin",
			"Member"
		]
	end
	
	#all validations
	validates :userRole, inclusion: {:in => userRoles}
	validates :user_id, :uniqueness => { :scope => :organization_id }
	validates :user, presence: true
	validates :organization, presence: true
end
