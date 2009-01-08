module Testpilot::JUnit
  
  Testpilot.add_property :extensions do 
    [".java"]
  end

  Testpilot.add_property :exclude do 
    []
  end
  
  Testpilot.add_property :passed do |exitcode, stdout, stderr|
    exitcode == 0
  end
  
  Testpilot.add_property :pass_message do |stdout, stderr|
    stdout
  end
  
  Testpilot.add_property :fail_message do |stdout, stderr|
    stdout.grep(/failure:/).to_s
  end
  
  Testpilot.add_property :command do
    basename = $testsuite.split(".")[0]
    ["javac MyTests.java",
     "junit -text #{basename}"]
  end

end
