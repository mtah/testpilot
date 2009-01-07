require 'inotify'
require 'inputs/cxxtest.rb'
require 'outputs/libnotify.rb'
require 'outputs/mpg123.rb'

class Testpilot

  def initialize
    @i = Inotify.new
    @wd = @i.add_watch(Dir.pwd, Inotify::MODIFY)
    @input = CxxTest
    @outputs = [Mpg123, Libnotify]

    @t = Thread.new do
      @i.each_event do |e|
        runTests("MyTestSuite.h") unless @input.temporaries.include?(e.name)
      end
    end
  end
  
  def runTests(testsuite)
    @input.testCmds(testsuite).each do |cmd|
      system cmd
    end
    
    if @input.pass?($?)
      output("PASS", "Tests passed")
    else
      output("FAIL", "Tests failed")
    end
  end
  
  def output(title, msg)
    threads = []
    
    for o in @outputs
      threads << Thread.new(o) { |output|
        output.notify(title,msg)
      }
    end
    
    threads.each { |t| t.join }
  end
  
  def run
    @t.join
  end

end

Testpilot.new.run
