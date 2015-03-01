class Organization < ActiveRecord::Base
	#all relations
    has_many :organization_user_relations, :dependent => :destroy
	has_many :users, :through => :organization_user_relations
	
	#all validations
	validates :name, :presence => true
end
