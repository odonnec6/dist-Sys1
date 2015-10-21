//Student ID: dd8c30847b4e9f988a418582fe016b31e04c4f9fd98af1a398fc35f45b3b323f
import java.net.*;
import java.io.*;
import java.io.*; 

public class MultiThreadedServer {
    public static void main(String[] args) throws IOException {

        int port = Integer.parseInt(args[0]);
        boolean listen = true;
        
        try (ServerSocket serverSocket = new ServerSocket(port)) { 
            while (listen) {
	            new MultiThreadedServerThread(serverSocket.accept()).start();
	        }
	    } catch (IOException e) {
            System.err.println("Could not listen on port " + port);
            System.exit(-1);
        }
    }
}
class MultiThreadedServerThread extends Thread { 
    private Socket socket = null;     
    public MultiThreadedServerThread(Socket socket) {       
     super("MultiThreadedServerThread");        
     this.socket = socket;    
    }         
     public void run() {        
      try (           
       		PrintStream out = new PrintStream(socket.getOutputStream(), true);  
        	BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
           ) 
 		   {  String input0, output0;            
              Responses response1 = new Responses();  
                           output0 = response1.processInput(null);   
                                    out.println(output0);   
                                              while ((input0 = in.readLine()) != null) 
                                              { output0 = response1.processInput(input0); 
                                                out.println(output0);          
                                                if (output0.equals("KILL_SERVICE\n")){  
                                                out.println(output0);  
                                                 break;            
                                                }         
                                              } socket.close();  
                                              
                                              } catch (IOException e) {           
                                                 e.printStackTrace();        
                                                }  
  											}
      
     }
class Responses {

    private String response = "HELO text\nIP:[ip address]\nPort:[port number]\nStudentID:[your student ID]\n";

    public String processInput(String input1) {
        String output1 = null;
        String output2 = null;
            if (input1.equals("HELO text\n")) {
                output1 = response;
            } else if (input1.equals("KILL_SERVICE\n")){
                output2 = "Service killed";
            } else {
                output2 = "Unknown message detected";
            }
       return output1;
    }
}


