module Mpg123
  def self.notify(title, msg)
    system "mpg123 -q resources/sounds/fail.mp3"
  end
end
