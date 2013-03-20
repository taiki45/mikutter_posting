#
#  AppDelegate.rb
#  mikutter_posting
#
#  Created by Taiki on 3/21/13.
#  Copyright 2013 osakana. All rights reserved.
#
require 'socket'

class AppDelegate
  attr_accessor :window
  attr_accessor :tweet_box
  attr_accessor :host_box
  attr_accessor :port_box
  
  def applicationDidFinishLaunching(a_notification)
  end
  
  def client
    socket = TCPSocket.new(host_box.stringValue, port_box.intValue)
    yield socket
    socket.close
  end
  
  def clear
    tweet_box.setStringValue("")
  end
  
  def send_text(sender)
    client {|s| s.write(tweet_box.stringValue) }
    clear
  end
  
  def clear_text(sender)
    clear
  end
end