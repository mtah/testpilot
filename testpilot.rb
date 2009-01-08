require 'inotify'
require 'rubygems'
require 'open4'

class Testpilot

  PROPERTIES = Hash.new
  ACTIONS = Hash.new { |k,v| k[v] = [] }
  attr_accessor :testsuite

  def initialize(testsuite, input, outputs)
  
    $testsuite = testsuite
    
    begin
      require "inputs/#{input}.rb"
    rescue LoadError => e
      warn "Error: could not load 'inputs/#{input}.rb'"
      exit 
    end
    
    outputs.each { |output|
      begin
        require "outputs/#{output}.rb"
      rescue LoadError => e
        warn "Error: could not load 'outputs/#{output}.rb'"
        exit 
      end
    }
    
    i = Inotify.new
    
    i.add_watch(Dir.pwd, Inotify::CREATE | Inotify::MODIFY | Inotify::MOVE)

    @t = Thread.new { 
      i.each_event { |e|
        if property(:extensions).empty? || property(:extensions).include?(File.extname(e.name)) and
          !property(:exclude).include?(e.name)
          run_tests
        end 
      }
     
    }
  end
  
  def self.add_property(name, &block)
    PROPERTIES[name] = block
  end
  
  def self.add_action(name, &block)
    ACTIONS[name] << block
  end

  def run_tests
    
    cmd = property(:command)
    last = cmd.pop
    err = nil
      
    cmd.each { |line|
      status = Open4::popen4(line) { |pid, stdin, stdout, stderr|
        err = stderr.read.strip.gsub(/"/,'\"')
      }
      
      if status.exitstatus != 0
        action :fail, err
        puts err
        return
      end
    }
    
    out = nil
    err = nil

    status = Open4::popen4(last) { |pid, stdin, stdout, stderr|
      out = stdout.read.strip
      err = stderr.read.strip
      puts out
      puts err
    }
    
    if property(:passed, status.exitstatus, out, err)
      action :pass, property(:pass_message, out, err).gsub(/"/,'\"')
    else
      action :fail, property(:fail_message, out, err).gsub(/"/,'\"')
    end

  end
  
  def property(name, *args)
    PROPERTIES[name].call(args)
  end
  
  def action(name, *args)
    threads = []
    
    for block in ACTIONS[name]
      threads << Thread.new(block,args) { |b,args|
        b.call(args)
      }
    end
    
    threads.each { |t| t.join }
  end
  
  def run
    @t.join
  end

end
