#!/usr/bin/ruby

require 'socket'

puts "Starting up server..."

server=TCPServer.new(2008)
n=0

while (session = server.accept) do
    n = n + 1
    puts "log: Connection #{n} from #{session.peeraddr[2]} at #{session.peeraddr[3]}"
    headers = []
    while line = session.gets
        headers << line

        # break when line is empty
        break if line =~ /^[\r\n]+$/
    end
    puts "log: got input from client"
    if ( n % 4 != 0 ) 
        session.puts "HTTP/1.1 200 OK\nDate: Mon, 30 Jan 2012 21:05:40 GMT\n"
        session.puts "Content-Length: 44\nContent-Type: text/html; charset=UTF-8\n\n"
        session.puts "<html><body><h1>Hi World</h1></body></html>\n"
    else
        session.puts "HTTP/1.1 503 Service Unavailable\nDate: Mon, 30 Jan 2012 21:05:40 GMT\n"
        session.puts "Content-Length: 10\nContent-Type: text/html\n\n"
        session.puts "Not Avail\n"
    end
    session.close
end

