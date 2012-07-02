import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;


public class TelnetServer {
	
	private static final int TELNET_SOCKET = 9999;
	private static final int HEADER_LENGTH = 21;
	
	private static final String EXIT = "quit";
	private static final String DUMP_POSITION = "dump /position";
	private static final String DUMP_ORIENTATION = "dump /orientation";
	
	private double lat;
	private double lon;
	
	private double start_lat;
	private double start_lon;
	private double alt;
	private double ground_elv_m;
	private double ground_elv_ft;  
	private double hdg;
	private double w_rad;
	private double n_rad;
	
	private double ms_per_cir;

	public static void main(String[] args) throws Exception {
		TelnetServer server = new TelnetServer(51.471333, -0.460768, 1000.0, 300.0, 1000.0, 0.0112, -0.019, 60 * 2000); //LHR, 1m per c
		// W : 51.472081,-0.498877
		// N : 51.493782,-0.462313
		server.start();
	}
	
	
	public TelnetServer(double start_lat, double start_lon, double alt, double gelv_m, double gelv_ft, double w_rad, double n_rad, double ms_per_cir) {
		this.start_lat		= start_lat;
		this.start_lon		= start_lon;
		
		this.alt		= alt;
		this.ground_elv_m		= gelv_m;
		this.ground_elv_ft	= gelv_ft;
		
		this.w_rad		= w_rad;
		this.n_rad		= n_rad;
		this.ms_per_cir = ms_per_cir;
		
	}

		
	void start() throws Exception {
		ServerSocket ss = new ServerSocket(TELNET_SOCKET);
		while (true) {
			try {
				System.out.println("Waiting\n");
				Socket s = ss.accept();
				System.out.println("Got connection\n");
				BufferedReader socketReader = 
						new BufferedReader(new InputStreamReader(s.getInputStream()));
				OutputStream os = s.getOutputStream();
				PrintWriter pw = new PrintWriter(os, true);

				boolean first = true;
				
				while (true) {
					String line = socketReader.readLine();
					if (first && line != null && line.length()>HEADER_LENGTH) {
						line = line.substring(HEADER_LENGTH);
					}
					
					first = false;

					if (line == null) {
						System.out.println("Pinging");
						os.write("PING".getBytes());
						os.flush();
						Thread.sleep(1000L);
					}  else {
						System.out.println(">"+line);
						updatePos();
						
						if (DUMP_POSITION.equals(line)) {
							System.out.println("--- Dumping position");
							pw.println(getPositionXML());
						} else if (DUMP_ORIENTATION.equals(line)) {
							System.out.println("--- Dumping orientation");
							pw.println(getOrientationXML());
						} else if (EXIT.equals(line)) {
							System.out.println("Exiting");
							pw.close();
							os.close();
							s.close();
							ss.close();
							s = null;
							ss = null;
							System.exit(0);
						}
					}
				}
			} catch (SocketException e) {
				System.out.println("Disconnect");
			}
		}
	}
	
	private String getOrientationXML() {
		StringBuilder sb = new StringBuilder();
		sb.append("<?xml version=\"1.0\"?>\r\n");
		sb.append("<PropertyList>\r\n");
		sb.append("  <heading-deg type=\"double\">");
		sb.append(hdg);
		sb.append("</heading-deg>\r\n");
		sb.append("  <alpha-deg type=\"double\">0.0</alpha-deg>\r\n");
		sb.append("  <pitch-rate-degps type=\"double\">0.0</pitch-rate-degps>\r\n");
		sb.append("</PropertyList>\r\n");
		sb.append("\r\n");
		sb.append("/> ");
		return sb.toString();	}

	private String getPositionXML() {
		StringBuilder sb = new StringBuilder();
		sb.append("<?xml version=\"1.0\"?>\r\n");
		sb.append("<PropertyList>\r\n");
		sb.append("  <longitude-deg type=\"double\">");
		sb.append(lon);
		sb.append("</longitude-deg>\r\n");
		sb.append("  <latitude-deg type=\"double\">");
		sb.append(lat);
		sb.append("</latitude-deg>\r\n");
		sb.append("  <altitude-ft type=\"double\">");
		sb.append(alt);
		sb.append("</altitude-ft>\r\n");
		sb.append("  <ground-elev-m type=\"double\">");
		sb.append(ground_elv_m);
		sb.append("</ground-elev-m>\r\n");
		sb.append("  <ground-elev-ft type=\"double\">");
		sb.append(ground_elv_ft);
		sb.append("</ground-elev-ft>\r\n");
		sb.append("</PropertyList>\r\n");
		sb.append("\r\n");
		sb.append("/> ");
		return sb.toString();
	}
	
	private void updatePos() {
		double pos_rad = (System.currentTimeMillis() % ms_per_cir)/ms_per_cir * 2 * Math.PI;
		
		hdg = Math.toDegrees(pos_rad + Math.PI);
		
		lat = start_lat + Math.sin(pos_rad) * n_rad;
		lon = start_lon + Math.cos(pos_rad) * w_rad;
		
	}

}