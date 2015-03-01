class ApplicationController < ActionController::Base
	before_filter :authenticate_user!  	#By devise
	before_filter :check_whether_any_user_exists

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	# layout :layout_by_resource



	protected

	# def layout_by_resource
	#     if devise_controller?
	#       "devise"
	#     else
	#       "application"
	#     end
	# end

	def random_pass
		o =  [('0'..'9'),('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
		rand_pass = (0...8).map{ o[rand(o.length)] }.join
		return rand_pass
	end

	def only_allow_signed_id
		if !user_signed_in?
			flash[:alert] = "You do not have access to this section."
			redirect_to home_index_path
		end
	end

	def only_allow_super_admins
		if !current_user.isSuper
			flash[:alert] = "You do not have access to this section."
			redirect_to home_index_path
		end
	end

	def check_whether_any_user_exists
		if User.all.count == 0
			params.permit!
			superAdmin = User.new
			superAdmin.name = "super"
			superAdmin.email = "wongka90@gmail.com"
			superAdmin.password = "12345678"
			superAdmin.isSuper = true
			superAdmin.save
		end
	end

	def get_list_of_countries
		@countries = [ "Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Australia","Austria","Azerbaijan",
		"Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi",
		"Cambodia","Cameroon","Canada","Cape Verde","Central African Republic","Chad","Chile","China","Colombi","Comoros","Congo (Brazzaville)","Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Cyprus","Czech Republic",
		"Denmark","Djibouti","Dominica","Dominican Republic",
		"East Timor (Timor Timur)","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia",
		"Fiji","Finland","France",
		"Gabon","Gambia, The","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana",
		"Haiti","Honduras","Hungary",
		"Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy",
		"Jamaica","Japan","Jordan",
		"Kazakhstan","Kenya","Kiribati","Korea, North","Korea, South","Kuwait","Kyrgyzstan",
		"Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg",
		"Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Morocco","Mozambique","Myanmar",
		"Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","Norway",
		"Oman",
		"Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal",
		"Qatar",
		"Romania","Russia","Rwanda",
		"Saint Kitts and Nevis","Saint Lucia","Saint Vincent","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia and Montenegro","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria",
		"Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu",
		"Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan",
		"Vanuatu","Vatican City","Venezuela","Vietnam",
		"Yemen",
		"Zambia", "Zimbabwe" ]
		return @countries
	end
end
