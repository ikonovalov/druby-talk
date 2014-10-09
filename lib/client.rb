require 'drb'
require 'benchmark'
require '../lib/config'

include Benchmark, DRb

DRb.start_service
shared_object = DRbObject.new(nil, DrbConfig::server_url)

def doRemoteWork(limit, r_object)
  time = Benchmark.measure do
    0..limit.times do
      r_object.inc(:counter)
      r_object[:last_access] = Time.now
    end unless r_object.nil?

    puts "Last access time = #{r_object[:last_access]} and counter is #{r_object[:counter]}"
  end
  puts CAPTION
  puts time
end

begin
  doRemoteWork 2000, shared_object
rescue DRbConnError => drb_e
  puts "Connection failed. #{drb_e.message}"
end


