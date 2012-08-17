require 'rubygems'
require 'daemons'

pwd = Dir.pwd
Daemons.run_proc('gcm_daemon.rb', {:dir_mode =&gt; :normal, :dir =&gt; "/opt/pid/sinatra}) do
Dir.chdir(pwd)
exec "ruby gcm_daemon.rb"
end
