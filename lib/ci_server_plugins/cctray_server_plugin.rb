require 'chicanery/cctray'
require 'chicanery'
require 'pry'

module Blinky
  module CCTrayServer
    include Chicanery
     
    def watch_cctray_server url, options = {}    
      server Chicanery::Cctray.new 'blinky build', url, options

      counter = 0
      when_run do |current_state|
        puts "********************"
        builds = current_state[:servers]["blinky build"]
        builds.keys.sort.each {|k| puts "#{k}\t\t#{builds[k][:activity]}\t\t#{builds[k][:last_build_status]}"}
        if (counter % 2) == 0 && current_state.building?
          building!
          puts "BUILDING"
        elsif current_state.has_failure?
          failure!
          puts "FAILURE"
        else
          success!
          puts "SUCCESS"
        end
        counter += 1
      end
      
      begin
        run_every 2 
      rescue => e
        warning!
        raise e
      end
    end
  end
end
