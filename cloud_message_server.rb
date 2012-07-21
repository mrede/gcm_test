# This is the server that stores registered devices and sends messages out to them

require 'sinatra'
require "sinatra/reloader" if development?
require 'gcm'
require 'apns'
require 'data_mapper'

require 'json'



configure :development do
	puts "DEV"
  enable :logging, :dump_errors, :raise_errors

  DataMapper::Logger.new($stdout, :debug)


  # A MySQL connection:
  DataMapper.setup(:default, 'mysql://root@localhost/guff')

  require_relative 'dave.rb'

  	DataMapper.finalize
	
	DataMapper.auto_upgrade!

end

configure :stage do
  enable :logging, :dump_errors, :raise_errors

  DataMapper::Logger.new($stdout, :debug)

  DataMapper.setup(:default, 'mysql://guff:guff@localhost/gcm_guff')

  require_relative 'dave.rb'

        DataMapper.finalize

        DataMapper.auto_upgrade!
end

configure :production do
  DataMapper.setup :default, ENV['DATABASE_URL']
  set :protection, :except => :json_csrf
end


get '/sendMessage' do

	@d = Device.new
	@d.pushMessage("#{params[:msg]}")

	"Done"


end

get '/httpclient' do


	
	clnt = HTTPClient.new()
	clnt.set_cookie_store("cookie.dat")
	uri ="https://msg.guff.me.uk/android/unregister"

	puts
	puts '= GET content directly'

	body = { 'keyword' => 'ruby', 'lang' => 'en' }
	res = clnt.post(uri, body)
	puts res




end

get '/ios/register' do

	puts "Params #{params}"
	#task=register&appname=Badge%20Test&appversion=1.0
	#&deviceuid=378b3e0d9d6ac5128aa28bd60183bf5e2aca5b7d&devicetoken=df297b340abd49d0514a573a336fb6fc83ea180a9482e7b0e7fc19460224746e&
	#devicename=EggPad&devicemodel=iPad&deviceversion=5.1.1&pushbadge=enabled&pushalert=enabled&pushsound=enabled 

	@device = Device.new(
		:type 			=> 'ios',
	    :app_name      => params[:appname],
	    :app_version       => params[:appversion],
	    :uid       	 => params[:deviceuid],
	    :token       => params[:devicetoken],
	    :name       => params[:devicename],
	    :model_name       => params[:devicemodel],
	    :version       	  => params[:deviceversion],
	    :push_badge       	  => params[:pushbadge] == 'enabled',
	    :push_alert       	  => params[:pushalert] == 'enabled',
	    :push_sound       	  => params[:pushsound] == 'enabled',
	    
	    
	    :created_at => Time.now
	)
	#validate
	
    


end

def registerResponse

    if @device.save
    	content_type :json
	    { :res => '1', :id => @device.id }.to_json
	else
		dev = Device.first(:uid => "#{params[:deviceuid]}")
		if (!dev.id.nil?) 
			puts "Device exists"
			content_type :json
	    	{ :res => '2', :id => @device.id }.to_json
		else
			puts "Failed to save: #{@device.errors.inspect}"
			content_type :json
	    	{ :res => '0' }.to_json
		end
	    

    end


end


post '/android/register' do
	puts "GET Register #{params}"
	
	@device = Device.new(
		:type 		=> 'android',
		:uid 		=> params[:regId],
		:token 		=> params[:regId]
	)

	if @device.save
    	content_type :json
	    { :res => '1', :id => @device.id }.to_json
	else
		dev = Device.first(:uid => "#{params[:deviceuid]}")
		if (!dev.id.nil?) 
			puts "Device exists"
			content_type :json
	    	{ :res => '2', :id => @device.id }.to_json
		else
			puts "Failed to save: #{@device.errors.inspect}"
			content_type :json
	    	{ :res => '0' }.to_json
		end
	    

	registerResponse
	
end

post '/android/unregister' do
	@dev = Device.first(:uid => "#{params[:regId]}")
	if !@dev.nil?
		@dev.destroy
	end
end

