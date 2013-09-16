import java.io.UnsupportedEncodingException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Random;


public class TelnetServer {
	
	private static final long SLEEP_TIME = 500L;
	
	private Random rnd = new Random();
	
	private static final int TELNET_SOCKET = 9999; // the port used by the server
	private static final String ipAddress = ""; //TODO: add this
	
	private double lat; // latitude
	private double lon; // longitude
	private int rpm;
	private float speed;
	
	private double start_lat; // starting latitude
	private double start_lon; // starting longitude
	private double alt; //altitude
	private double hdg; // heading
	private double w_rad;
	private double n_rad;
	
	private double ms_per_cir; // ... per circle

	private long updateTime = 0;
	private static final int MIN_UPDATE_TIME = 5000;

	public static void main(String[] args) throws Exception {
		TelnetServer server = new TelnetServer(51.471333, -0.460768, 5000.0, 1666.66, 5000.0, 0.0112, -0.019, 60 * 2000); //LHR, 1m per c
		// W : 51.472081,-0.498877
		// N : 51.493782,-0.462313
		server.start();
	}
	
	
	public TelnetServer(double start_lat, double start_lon, double alt, double gelv_m, double gelv_ft, double w_rad, double n_rad, double ms_per_cir) {
		this.start_lat		= start_lat;
		this.start_lon		= start_lon;
		
		this.alt		= alt;
		
		this.w_rad		= w_rad;
		this.n_rad		= n_rad;
		this.ms_per_cir = ms_per_cir;
		
	}

		
	void start() throws Exception {
		while (true) {
	        DatagramSocket serverSocket = new DatagramSocket(9876);
            byte[] sendData = new byte[1024];
            while(true)
            {
            	  updatePos();

                  InetAddress IPAddress = InetAddress.getByName("192.168.1.41"); //TODO: configure for device

                  MessageBuilder mb = new MessageBuilder();
                  
                  mb
                  .withFloat(speed)	//  SPEED
                  .withInt(rpm)			//  RPM
                  .withDouble(hdg)	//  HEADING
                  .withDouble(alt)	//  ALTITUDE
                  .withFloat(0.0f)	//  CLIMB_RATE
                  .withFloat(0.0f)	//  PITCH,
                  .withFloat(0.0f)	//  ROLL
                  .withDouble(lat)	//  LATITUDE
                  .withDouble(lon)	//  LONGITUDE
                  .withFloat(0.0f)	//  SECONDS
                  .withFloat(0.0f)	//  TURN_RATE
                  .withFloat(0.0f)	//  SLIP
                  .withFloat(0.0f)	//  INDICATED_HEADING
                  .withFloat(0.0f)	//  FUEL1
                  .withFloat(0.0f)	//  FUEL2,
                  .withFloat(0.0f)	//  OIL_PRESS
                  .withFloat(0.0f)	//  OIL_TEMP
                  .withFloat(0.0f)	//  AMP
                  .withFloat(0.0f)	//  VOLT
                  .withFloat(0.0f)	//  NAV1_TO
                  .withFloat(0.0f)	//  NAV1_FROM
                  .withFloat(0.0f)	//  NAV1_DEFLECTION
                  .withFloat(0.0f)	//  NAV1_SEL_RADIAL
                  .withFloat(0.0f)	//  NAV2_TO
                  .withFloat(0.0f)	//  NAV2_FROM
                  .withFloat(0.0f)	//  NAV2_DEFLECTION,
                  .withFloat(0.0f)	//  NAV2_SEL_RADIAL
                  .withFloat(0.0f)	//  ADF_DEFLECTION
                  .withFloat(0.0f)	//  ELEV_TRIM,
                  .withFloat(0.0f)	//  FLAPS
                  ;
                  
                  sendData = mb.getBytes();
                  DatagramPacket sendPacket =
                  new DatagramPacket(sendData, sendData.length, IPAddress, TELNET_SOCKET);
                  serverSocket.send(sendPacket);
                  
                  System.out.println("Sent packet");
                  
                  Thread.sleep(SLEEP_TIME);
            }
		}
	}
	

	
	private void updatePos() { // calculates latitude, longitude and heading for virtual plane
		double pos_rad = (System.currentTimeMillis() % ms_per_cir)/ms_per_cir * 2 * Math.PI;
		
		hdg = Math.toDegrees(pos_rad + Math.PI);
		
		lat = start_lat + Math.sin(pos_rad) * n_rad;
		lon = start_lon + Math.cos(pos_rad) * w_rad;
		
		if (System.currentTimeMillis() > updateTime) {
			updateTime = System.currentTimeMillis() + MIN_UPDATE_TIME + rnd.nextInt(MIN_UPDATE_TIME);
			
			//TODO: make this a bit more flexible
			alt = rnd.nextDouble();
			rpm = rnd.nextInt();
			//speed = rnd.nextFloat();
			
			speed = 500f;
			
			System.out.println("Changing");
			
		}
	}
	
	private static class MessageBuilder {
		private static final char SEP = ':';
		final StringBuilder sb;
		
		public MessageBuilder() {
			sb = new StringBuilder();
		}
		
		public MessageBuilder withFloat(float f) {
			sb.append(f);
			sb.append(SEP);
			return this;
		}
		
		public MessageBuilder withInt(int i) {
			sb.append(i);
			sb.append(SEP);
			return this;
		}
		
		public MessageBuilder withDouble(double d) {
			sb.append(d);
			sb.append(SEP);
			return this;
		}
		
		public byte[] getBytes() {
			try {
				return sb.toString().getBytes("UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}		
			return null;

		}
		
	}

}



