module Mumbles
  def self.notify(title,msg)
    system "mumbles-send \"#{title}\" \"#{msg}\""
  end
end
