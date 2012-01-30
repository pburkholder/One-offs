#!/usr/bin/ruby

require 'socket'

puts "Starting up server..."

server=TCPServer.new(2008)

while (session = server.accept) do
    puts "log: Connection from #{session.peeraddr[2]} at #{session.peeraddr[3]}"
    headers = []
    while line = session.gets
        headers << line

        # break when line is empty
        break if line =~ /^[\r\n]+$/
    end
    puts "log: got input from client"
    session.puts "HTTP/1.1 200 OK\nDate: Mon, 30 Jan 2012 21:05:40 GMT\n"
    session.puts "Content-Length: 44\nContent-Type: text/html; charset=UTF-8\n\n"
    session.puts "<html><body><h1>Hi World</h1></body></html>\n"
    session.close
end

