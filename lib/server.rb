require 'drb'

require '../lib/config'
require 'pry'

shared_hash = {:counter => 0}

def shared_hash.inc(elem)
  binding.pry if self[:counter] < 5
  self[elem] = self[elem].next
end

begin
  drbServer = DRb.start_service(DrbConfig::server_url, shared_hash) # replace localhost with 0.0.0.0 to allow conns from outside
  drbServer.thread.join
rescue Errno::EADDRINUSE => e
  puts e.message << '. Use another port.'
rescue Exception => e
  puts 'Another fail: ' << e.message
end