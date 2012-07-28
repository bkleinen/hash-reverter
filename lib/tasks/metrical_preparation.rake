# http://www.ruby-forum.com/topic/202257
require File.expand_path("../../../lib/tasks/metrical_workaround", __FILE__)
include MetricalWorkaround

namespace :metrical do 
  desc "revert hash syntax 1.9 => 1.8 as dirty workaround"
  task :revert, :verbose do |t,args|
    replace_hashes(args[:verbose])
  end
end

