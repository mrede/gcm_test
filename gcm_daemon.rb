require 'rubygems'
require 'daemons'

pwd = Dir.pwd
Daemons.run_proc('cloud_message_server.rb', {:dir_mode =&gt; :normal, :dir =&gt; "/opt/pid/sinatra}) do
Dir.chdir(pwd)
exec "ruby cloud_message_server.rb"
end
