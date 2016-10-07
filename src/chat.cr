require "kemal"
require "pg"
require "option_parser"
require "http/server"
require "./app/message"

bind = "0.0.0.0"
port = 8080

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end


conn = PG.connect("postgres://user:password@localhost:5432/db_name")

sockets = [] of HTTP::WebSocket

public_folder "src/assets"

get "/" do
  render "src/views/index.ecr"
end

ws "/" do |socket|
  sockets.push socket

  

  socket.send Message.all(conn).to_json
  
  socket.on_message do |message|
    Message.from_json(message).insert(conn)
    sockets.each do |a_socket|
      begin
        a_socket.send Message.all(conn).to_json
      rescue
        sockets.delete(a_socket)
        puts "Closing Socket: #{socket}"
      end
    end
  end
  
  socket.on_close do |_|
    sockets.delete(socket)
    puts "Closing Socket: #{socket}"
  end
end

Kemal.run