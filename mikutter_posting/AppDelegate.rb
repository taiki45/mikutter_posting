#
#  AppDelegate.rb
#  mikutter_posting
#
#  Created by Taiki on 3/21/13.
#  Copyright 2013 osakana. All rights reserved.
#
require 'socket'
require 'json'
require 'thread'

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
    if queue.num_waiting > 0
      queue.push(tweet_box.stringValue)
    else
      client {|s| s.write(tweet_box.stringValue) }
    end
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

  def queue
    @queue ||= Queue.new
  end

  def server_port
    port_box.intValue + 1
  end

  def start_server(port)
    @server.kill if @server
    @server = Server.new(port, tweet_box, queue)
    @server.run
  end

  def stop_server
    @server.kill if @server
    @server = nil
  end

  class Server
    def initialize(port, tweet_box, queue)
      @server = TCPServer.open(port)
      @tweet_box = tweet_box
      @queue = queue
    end

    def run
      @thread = Thread.new do
        loop do
          Thread.start(@server.accept) do |s|
            res = JSON.parse(s.gets)
            set_reply("@#{res['screen_name']} ")
            msg = @queue.pop
            s.write(msg)
            s.close
          end
        end
      end
    end

    def kill
      @thread.kill if @thread
    end

    private

    def set_reply(str)
      @tweet_box.setStringValue(str)
    end
  end
end
