class UserMailer < ActionMailer::Base
  default :from => "wongka90@gmail.com"

	def forget_password(user, rqst)
		@name = user.name
		@address = rqst+'?id='+user.id.to_s
		mail(:to => user.email, :subject => "Did you forget your password?")
	end

	def new_user(user, pw)
		@userEmail = user.email
		@userPassword = pw
		@address = "http://localhost:3000"
		mail(:to => user.email, :subject => "Congratulations with your registration!")
	end

	def change_password_confirmation(user, pw)
		@name = user.name
		@userPW = pw
		@address = "http://localhost:3000"
		mail(:to => user.email, :subject => "You have successfully changed your password!")
	end
end
