module Testpilot::Mumbles
  
  Testpilot.add_action :pass do |result|
    system "notify-send \"PASS\" \"#{result}\""
  end
  
  Testpilot.add_action :fail do |result|
    system "notify-send \"FAIL\" \"#{result}\""
  end

end
