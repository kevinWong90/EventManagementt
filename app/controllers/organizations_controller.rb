class OrganizationsController < ApplicationController
	before_filter :top_header
	before_filter :only_allow_super_admins, :except => [:index , :show]

	def top_header
		@title = "Organization"
	end

	def index
		if current_user.isSuper
			@organizations = Organization.all
		else
			allOrganizationUserRelation = current_user.organization_user_relations
			@organizations = Array.new
			allOrganizationUserRelation.each do |relation|
				@organizations << relation.organization
			end
		end
	end

	def new
		@organization = Organization.new
		@categoriesType = Category.validOrganizationTypes
	end

	def create
		if !params[:create].nil?

			params.permit!
			organization = Organization.new(params[:organization])
			#check admin
			admin = User.find_by_email(params[:userEmail])
			newUser = false;
			if admin.nil?
				admin = User.new
				admin.email = params[:userEmail]
				admin.password = random_pass
				admin.password_confirmation = admin.password
				admin.name = "admin"
				newUser = true
			end
		

			if organization.save! && admin.save!
				#check category
				category = Category.new
				category.name = params[:categoryName]
				category.categoryType = params[:categoryName]
				category.belongsTo = "Organization"
				category.owner_id = organization.id
				category.save!
				#create relationship with admin
				relationship = OrganizationUserRelation.new
				relationship.userRole = "Admin"
				relationship.organization = organization
				relationship.user = admin
				relationship.save!
				if newUser
					UserMailer.new_user(admin, admin.password).deliver
				else
				end
				flash[:success] = "Organization has been created"
			else
				flash[:error] = "Error in creation of Organization."
			end
		end
		redirect_to organizations_path
	end

	def edit
		@organization = Organization.find(params[:id])
	end

	def update
		params.permit!
		@organization = Organization.find(params[:id])
		@organization.name = params[:name]

		@organization.website = params[:website]
		@organization.generalEmail = params[:generalEmail]
		@organization.description = params[:description]
		if @organization.save!
			flash[:success] = "Organization has been updated"
		else
			flash[:error] = "Organization is not updated due to some errors."
		end
		redirect_to organizations_path
	end

	def show
		@organization = Organization.find(params[:id])
		if !@organization.nil?
			#similar to sql select ... where belongsTo... AND owner_id...
			@categories = Category.where(:belongsTo => "Organization").where(:owner_id => @organization.id)
		end
	end

	def destroy
		@organization = Organization.find(params[:id])

      	if @organization.destroy
      		flash[:success] = "Organization has been deleted"
      		redirect_to organizations_path
    	end
    	
	end

	def delete_multiple
	    if params[:organization_ids].nil?
	      redirect_to organizations_path, :notice => "No Organization is selected!"
	    else
	      organizations_selected = Organization.find(params[:organization_ids])
	      organizations_selected.each do |o|
	        o.destroy
	      end
	      flash[:notice] = "Organization(s) deleted successfully."
	      redirect_to organizations_path
	    end
  end
end
