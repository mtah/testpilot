module Testpilot::Mumbles
  
  Testpilot.add_action :pass do |result|
    system "mumbles-send \"PASS\" \"#{result}\""
  end
  
  Testpilot.add_action :fail do |result|
    system "mumbles-send \"FAIL\" \"#{result}\""
  end

end
