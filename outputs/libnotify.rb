module Libnotify
  def self.notify(title,msg)
    system "notify-send \"#{title}\" \"#{msg}\""
  end
end
