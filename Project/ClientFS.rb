require 'socket'
 
host = 'localhost'
port = 8000                           

request = "test1.txt\n"
socket = TCPSocket.open(host,port)
puts "Connected to server\n\n"
puts "Sending request to server...."
socket.send(request, 0)
puts "Sent request to server\n\n"
response = socket.recv(1000000)
puts(response)