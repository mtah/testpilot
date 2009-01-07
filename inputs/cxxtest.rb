module CxxTest

  def self.temporaries  # TODO: do not want this here
    ["runner.cpp", "runner"]
  end
  
  def self.pass?(exitcode)
    exitcode == 0
  end
  
  def self.testCmds(testsuite)
    ["cxxtestgen --error-printer -o runner.cpp #{testsuite}",
     "g++ -o runner runner.cpp",
     "./runner"]
  end
end
