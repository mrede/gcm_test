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

  
end

