module Testpilot::CxxTest
  
  Testpilot.add_property :extensions do 
    [".c", ".cpp", ".h"]
  end

  Testpilot.add_property :exclude do 
    ["runner.cpp"]
  end
  
  Testpilot.add_property :passed do |exitcode, stdout, stderr|
    exitcode == 0
  end
  
  Testpilot.add_property :pass_message do |stdout, stderr|
    stdout
  end
  
  Testpilot.add_property :fail_message do |stdout, stderr|
    stdout
  end

  Testpilot.add_property :command do
    ["cxxtestgen --error-printer -o runner.cpp #{$testsuite}",
     "g++ -o runner runner.cpp",
     "./runner"]
  end

end
