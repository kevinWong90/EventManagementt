class UsersController < ApplicationController
	skip_before_filter :authenticate_user!, :except => [:index , :show]

	def index
	end

	def show
	end

	#all get request
	def change_password
		@change_password = true
		if !params[:id].nil? 
		  	user = User.find(params[:id])
		 	if !user.nil?
		  		@user = user
		  	end
		elsif user_signed_in?
			@user = user_signed_in 
		end
	  	if @user.nil?
	  		flash[:alert] = "You are not authorized."
	  		redirect_to home_index_path
	  	end
	end

 	# all post request
 	def registration
 		if params[:password] == params[:password_confirmation]
  			user = User.new
  			user.email = params[:email]
  			user.name = params[:name]
  			user.password = params[:password]
  			user.save!
  			UserMailer.new_user(user, user.password).deliver
  			flash[:notice] = "Acct created"
  			redirect_to new_user_session_path
  		else
  			flash[:alert] = "Passwords does not match. Please enter again"
  			render new_user_registration_path
  		end
 	end

	def request_change_password
		email = params[:email]
		user =  User.find_by_email(email)
		if user.nil?
			flash[:notice] = "User not found"
			redirect_to users_forget_password_path
		else
			path = '/users/change_password'
			flash[:notice] = "An email has been sent"
			UserMailer.forget_password(user, request.protocol.to_s+request.host_with_port.to_s+path).deliver
		  	redirect_to home_index_path
	  	end
 	end

	def update_password
		user = User.find(params[:id])
  		if params[:password] == params[:password_confirmation]
  			user.password = params[:password]
  			user.save!
  			UserMailer.change_password_confirmation(user, user.password).deliver
  			redirect_to home_index_path
  		else
  			flash[:alert] = "Passwords does not match. Please enter again"
  			render users_change_password_path(:id => params[:id])
  		end
 	end
end
