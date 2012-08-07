class Device
  include DataMapper::Resource
  
  property :id, Serial
  property :type, String
  property :uid, String, :length => 20..500
  property :token, String, :length => 500
  property :app_name, String
  property :app_version, String
  property :name, String
  property :model_name, String
  property :version, String
  property :push_badge, Boolean
  property :push_alert, Boolean
  property :push_sound, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

  # good old fashioned manual validation
  validates_length_of :uid, :max => 500, :min => 20

  def sendAndroid(msg)
    
    gcm = GCM.new("AIzaSyApi3xdQz1b7r7E8k3fiUkUe9J22iEUUM0")
#   gcm = GCM.new("AIzaSyCzpzGd9mwfJWfQMTBJYLC62Lyz9oMrwX4")
  

    devices = Device.all(:type => 'android', :fields => [:uid])
    tokens = devices.collect{|d| d.uid}
    
    
    options = {data: {message: "#{msg}"}, message: "#{msg}"}
    response = gcm.send_notification(tokens, options)

    puts "GCM Response #{response}"
  end

  def sendIos(msg)
    devices = Device.all(:type => 'ios')

    #APNS.pem  = '/Users/ben/sites/Label/gcm_sinatra/development.pem'
    APNS.pem  = '/home/passenger/gcm_test/development.pem'

    notifications = Array.new

    devices.each do |d|
      notifications.push(APNS::Notification.new(d.token, :alert => "#{msg}", :badge => 1, :sound => 'default'))
    end

    #APNS.send_notification(device_token, 'Hello iPhone!' )
    APNS.send_notifications(notifications)
  end

  def pushMessage(msg)
    sendIos(msg)
    sendAndroid(msg)
    
  end
end

