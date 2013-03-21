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
    start_server(server_port)
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

  def restart_server(sender)
    stop_server
    start_server(server_port)
  end

  private

  def server_port
    port_box.intValue + 1
  end

  def start_server(port)
    @server.kill if @server
    @server = Server.new(port)
  end

  def stop_server
    @server.kill if @server
    @server = nil
  end

  class Server
    def initialize(port)
      @server = TCPServer.open(port)
    end

    def run
      @thread = Thread.new do
        loop do
          Thread.start(@server.accept) do |s|
            lambda {|res| res }.call(s.read)
            s.close
          end
        end
      end
    end

    def stop
      @thread.kill
    end
  end
end
