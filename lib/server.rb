require 'drb'

require '../lib/config'
require 'pry'

class RServer

  def initialize(url)
    @url = url
  end

  def share(shared)
    begin
      @drbServer = DRb.start_service(@url, shared) # replace localhost with 0.0.0.0 to allow conns from outside
      @drbServer.thread.join
    end
  end

end

shared_hash = {:counter => 0}

def shared_hash.inc(elem)
  binding.pry if self[:counter] < 5
  self[elem] = self[elem].next
end

remote = RServer.new DrbConfig::server_url
remote.share(shared_hash)