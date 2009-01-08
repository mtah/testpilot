module Testpilot::Audio
  
  Testpilot.add_action :pass do
    system "mpg123 -q resources/sounds/pass.mp3"
  end
  
  Testpilot.add_action :fail do
    system "mpg123 -q resources/sounds/fail.mp3"
  end

end
