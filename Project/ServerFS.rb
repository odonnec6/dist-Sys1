require 'socket'  
require 'thread'

THREADS = 20
PORTNUMBER = 80
DIRECTORYNAME = "C:\\CS4032\\Project\\"
semaphore = Mutex.new
clients = Queue.new

Releasedthreads = 20

def getFileName(message)
	filename = message.split(" ", 2)
	filename = filename[1].split("\n", 2)
	return filename[0]
end

def getData(message)
	data = message.split("\n", 2)
	return data[1]
end

def openFile(filename)
	file = File.new(filename, "open")
	return file	
end

def readFile(file)
	data =  file.sysread(1000000000)
	file.close
	return data
end

def writeFile(filename, data)
	deleteFile(filename)
	file = File.new(filename, "write")
	file.syswrite(data)
	file.close
end

def deleteFile(filename)
		File.delete(filename)
end

Dir.chdir DIRECTORYNAME

server = TCPServer.open(PORTNUMBER)

workers = (0...THREADS).map do
Thread.new do
	begin
		loop do
		updated = false
		client = clients.pop()
		if (client != nil)
		begin
			loop do 
				begin 
				response = client.recv(1000000)
				puts(response)	
					if (response.casecmp("KILL_SERVICE\n") == 0)
						puts("KILL_SERVICE")
						break
						elsif (response[0...4].casecmp("HELO") == 0)
						answer = response + "IP:" + UDPSocket.open {|s| s.connect("79.155.230.27", 1); s.addr.last} + "\nPort:" + PORTNUMBER.to_s + "\nStudentID:dd8c30847b4e9f988a418582fe016b31e04c4f9fd98af1a398fc35f45b3b323f"
						puts(answer)	
						begin
						client.send(answer, 0)
						elsif (response[0...8].casecmp("Download") == 0)
						filename = getFileName(response)
						file = openFile(filename)
						data = readFile(file)
						begin
						client.send(data, 0)
						elsif (response[0...6].casecmp("Upload") == 0)
						filename = getFileName(response)
						data = getData(response)
						writeFile(filename, data)
						elsif (response[0...6].casecmp("Delete") == 0)
						filename = getFileName(response)
						deleteFile(filename)
						end
						rescue Exception => e
						puts e.message
						puts ("Something went wrong....")
						if (not updated)
						semaphore.synchronize do
						Releasedthreads = Releasedthreads + 1
						end
						end
					break
				end
				end
				client.close
				semaphore.synchronize do
				Releasedthreads = Releasedthreads + 1
				updated = true
				end
				rescue Exception => e
				puts e.message
				puts ("Client disconnect")
				if (not updated)
				semaphore.synchronize do
				Releasedthreads = Releasedthreads + 1
				end
				end
			end
		end
	end
end

loop do
	client = server.accept
	
	puts("Released Threads: " + Releasedthreads.to_s)
	
	if (Releasedthreads > 0)
		clients << client
	
		semaphore.synchronize do
			Releasedthreads -= 1
		end

	else
		puts("Server error!")
		client.close
	end
end
