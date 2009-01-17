module Console
  Testpilot.add_action :pass do |msg|
    STDOUT.puts msg
  end
  
  Testpilot.add_action :fail do |msg|
    STDERR.puts msg
  end
end
