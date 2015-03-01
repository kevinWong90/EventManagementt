class Category < ActiveRecord::Base
#custom validation
validate :checkValidity
    validates :name, :presence => true
	validates :categoryType, :presence => true
	validates :belongsTo, :presence => true
	validates :owner_id, :presence => true

	def self.validOrganizationTypes
		return [
			"Consumer products",
			"Electrionics",
			"Entertainment",
			"Food",
			"Hospitality",
			"Infomation Technology",
			"Infrastructure",
			"Research & Development",
			"Retail",
			"Telecommunications",
			"Others"
		]
	end

	def self.validEventTypes
		return [
			"Art",
			"Business",
			"Food & Drink",
			"Sports & Fitness",
			"Science & Tech",
			"Others"
		]
	end

	def self.validBelongToTypes
		return [
			"Organization",
			"Event"
		]
	end
  
  private
    def checkValidity
		validBelongToChecked = false
	    validTypeChecked = false
	    #make sure it is a belongto
	    validBelongToTypes = Category.validBelongToTypes
	    validBelongToTypes.each do |belongTo| 
	      	if self.belongsTo == belongTo
	      		validBelongToChecked = true
	      		break
	      	end
	    end
	    #add error for belongs to
	    if !validBelongToChecked
			self.errors.add(:belongsTo, "invalid belong to")
		end
	    #make sure it is a valid type
	    #if it belongs to an organization
	    if self.belongsTo == validBelongToTypes[0]
	    	validOrganizationTypes = Category.validOrganizationTypes
		    validOrganizationTypes.each do |orgType| 
			    if self.categoryType == orgType
			      	validTypeChecked = true
			      	break
			    end
		   	end
		#if it belongs to an event
		elsif self.belongsTo == validBelongToTypes[1]
			validEventTypes = Category.validEventTypes
		  	validEventTypes.each do |eventType| 
		      	if self.categoryType == eventType
		      		validTypeChecked = true
		      		break
		      	end
		    end
		end
	   	#add error for type
	    if !validTypeChecked
			self.errors.add(:type, "invalid type")
		end
    end

end
