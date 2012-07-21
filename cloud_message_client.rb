require 'httpclient'
require 'json'


class CloudMessageClient

	server = "https://msg.guff.me.uk"

	def self.registerDevice(params)
		#ios or android
		if (params.has_key("devicemodel"))

		else

			clnt = HTTPClient.new()
			clnt.set_cookie_store("cookie.dat")
			uri ="#{server}/android/unregister"

			puts
			puts '= GET content directly'

			
			res = clnt.post(uri, params)
			puts "Result of Post to android register #{res}"

			# Parse ID
			jRes = JSON.parse(res)

			case jRes.res
			when 0
				puts "Failed"
			when 1 
				puts "Success!. ID of result: #{jRes.id}"
			when 2
				puts "Exists already. ID of result: #{jRes.id}"
			

		end
	end
end