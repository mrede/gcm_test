require 'httpclient'
require 'json'
require 'securerandom'


class CloudMessageClient

	include DataMapper::Resource

	property :id, Serial
  	property :server_id, Integer
  	property :uid, String, :length => 20..500 #Unique ID to be stored on local client

	SERVER = "https://msg.guff.me.uk"

	def self.registerDevice(params)
		#ios or android
		puts " Parmas #{params}"
		if (params.has_key?("devicemodel"))

		else

			clnt = HTTPClient.new()
			clnt.set_cookie_store("cookie.dat")
			puts "seinding to: #{SERVER}/android/register"
			uri ="#{SERVER}/android/register"

			
			res = clnt.post(uri, params)
			puts "Result of Post to android register #{res.content}"

			# Parse ID
			jRes = JSON.parse(res.content)

			case jRes['res']
			when 0
				puts "Failed"
			when 1 
				puts "Success!. ID of result: #{jRes['id']}"
			when 2
				puts "Exists already. ID of result: #{jRes['id']}"
			end

			if (jRes['res'].to_i > 0)
				jRes['id']
				@localDevice = CloudMessageClient.create(
					server_id: jRes['id'],
					uid: SecureRandom.uuid
				)
				@localDevice
			else
				nil
			end
		end
	end

	def self.sendMessage(users, msg)
		clnt = HTTPClient.new()
		clnt.set_cookie_store("cookie.dat")
		
		uri ="#{SERVER}/sendMessage"
		puts "USERS #{users}"
		@users = users.map { |u| u }.join ','
		parms = {
			:msg => msg,
			:users => @users
		}
		puts "PARAMS #{users} to #{parms}"
		res = clnt.get(uri, parms)
		puts "Result of Post to android register #{res.content}"
	end
end