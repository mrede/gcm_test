require 'sinatra'
require 'gcm'
include 'logger'



# Convenience method
def logger; settings.logger; end


get '/hi' do
	puts "YO #{params}"
  "Hello World!"
end

get '/android/register' do
	puts "GET Register #{params}"
	
	"TEST #{params}"
	
end

post '/android/register' do
	puts "POST Register #{params}"
	
	"TEST #{params}"
	
end

post '/android/unregister' do
	puts "Unregister #{params}"
	"OK"
end

get '/android/testsend' do
	

	"Android {params}"
	gcm = GCM.new("AIzaSyCzpzGd9mwfJWfQMTBJYLC62Lyz9oMrwX4")
	registration_ids= ["APA91bGsP_MNyUx3vfhSNW5l7LsE-vhvRUxZxWSEfVLogQNuZeEqGWWNIgYuJ1zHQll-OmIFHGvl8mH7uwgc84pJ5UQQX4c7za-nBG0f5_REHPG4yXRWkVoery0F9QDjOCvQLgC7XSnuwLDyYCKdWUUAV4COP2EuPg"] # an array of one or more client registration IDs
	options = {data: {message: "SHEEEEEEIT"}, collapse_key: "updated_score"}
	response = gcm.send_notification(registration_ids, options)

	options = "HELLO #{response}"
end