import oscP5.*;
import netP5.*;

public final int MINCT = 2200;                               //lowest  colortemperature available
public final int MAXCT = 9000;                               //highest colortemperature available
final static int MINDIMLEVEL = 0;                            //lowest  dimLevel available for ENLIGHT
final static int MAXDIMLEVEL = 65535;                        //highest dimLevel available for ENLIGHT
final static int MINBRIGHTNESS = 0;                          //lowest  brightness available for ENLIGHT
final static int MAXBRIGHTNESS = 255;                        //highest brightness available for ENLIGHT

String ENLIGHT_IP = "192.168.1.151";                         //this is the standard IP address for the Lighlab
int ENLIGHT_PORT = 11000;                                    //this is the standard communcation port for the Lightlab

OscP5 oscP5;
NetAddress serverAddress;

boolean OSCenabled = false;
boolean serverConnected = false;

void setupEnlight(String ip, int port)
{
  ENLIGHT_PORT = port;                                       //set the correct port (11000 for the Lightlab)
  ENLIGHT_IP = ip;                                           //set the correct IP address (192.168.1.151 for the Lightlab)
  oscP5 = new OscP5(this, ENLIGHT_PORT);                     //open a new OSC port
  serverAddress = new NetAddress(ENLIGHT_IP, ENLIGHT_PORT);  //open a new NET port
  OSCenabled = true; 
  connect();
}

void connect()
{
  OscMessage message = new OscMessage("/Enlight/connect");
  oscP5.send(message, serverAddress);
}

public static final int PB = 0;
public static final int HUE = 100;
public static final int COVE = 200;

public Lamp getHue(int id)
{
  return new Lamp(HUE+id);
}

public Lamp getPB(int id)
{
  return new Lamp(PB+id);
}

public Lamp getCove(int id)
{
  return new Lamp(COVE+id);
}


class Lamp
{
  int lampID;
  
  public Lamp(int id)
  {
    lampID = id;
  }

  void setOn(boolean value)
  {
    int i = 0;
    if (value) i = 1;
    setOn(i);
  }

  void setOn(int value)
  {
    sendMessage("setOn", lampID, value);
  }

  void setBrightness(int value)
  {
    int dim = (int) map(value, 0, 255, 0, MAXDIMLEVEL);
    dim = constrain(dim, 0, MAXDIMLEVEL);
    sendMessage("setDimLevel", lampID, dim);
    println("setBrightness of lamp " + lampID + " to " + value);
  }

  void setBrightness(int value, int time)
  {
    int dim = (int) map(value, 0, 255, 0, MAXDIMLEVEL);
    dim = constrain(dim, 0, MAXDIMLEVEL);
    sendMessage("setDimLevel", lampID, dim, time);
    println("setBrightness of lamp " + lampID + " to " + value + " in " + time + " ms" );
  }

  void setCT(int value)
  {
    sendMessage("setCT", lampID, value);
    println("setCT of lamp " + lampID + " to " + value);
  }

  void setCT(int value, int time)
  {
    sendMessage("setCT", lampID, value, time);
    println("setCT of lamp " + lampID + " to " + value);
  }

  void setRGB(int r, int g, int b)
  {
    sendMessage("setRGB", lampID, r, g, b);
    println("setRGB of lamp " + lampID + " to " + r + "," + g + "," + b);
  }

  void setRGB(int r, int g, int b, int time)
  {
    sendMessage("setRGB", lampID, r, g, b, time);
    println("setRGB of lamp " + lampID + " to " + r + "," + g + "," + b);
  }
}

void sendMessage(String function, int lampID, int... value)
{
  OscMessage message = new OscMessage("/Enlight/"+function);
  message.add(lampID);
  message.add(value.length);
  for (int v:value) message.add(v);
  oscP5.send(message, serverAddress);
  //delay(10);
}

void oscEvent(OscMessage message)
{
  if (message.checkAddrPattern("/Enlight/connect"))
  {
    serverConnected = true;
    println("Server connected");
    
    for (int i = 0; i<message.get(0).intValue(); i++)
    {
      Luminaire l = new Luminaire(i);
      _luminaires.add(l);
    }
  }
  else
  {
    println("message received: " + message);
  }
}





///under development

XML getLuminaires()
{
  XML xml = parseXML("<luminaires></luminaires>");
  for (Luminaire l : _luminaires) xml.addChild(l.getAsXML());
  return xml;
}

String getName(int lampID)
{
  return getLuminaireByID(lampID).getName();
}

boolean getOn(int lampID)
{
  return getLuminaireByID(lampID).getOn();
}

int getDimLevel(int lampID)
{
  return getLuminaireByID(lampID).getDimLevel();
}

int getCT(int lampID)
{
  return getLuminaireByID(lampID).getCT();
}



Luminaire getLuminaireByID(int i)
{
  for (Luminaire l : _luminaires)
  {
    if (l.getID() == i) return l;
  }
  println("no lamp with ID " + i + " could be found");
  return null;
}

ArrayList<Luminaire> _luminaires = new ArrayList<Luminaire>();

class Luminaire
{
  private int lampID;
  private int lampType;
  private String name;
  private int dimLevel;
  private int ct;
  private boolean onState;
  
  public Luminaire(int id)
  {
    setID(id);
  }
  
  int getID() {return lampID;}
  int getLampType() {return lampType;}
  String getName() {return name;}
  int getDimLevel() {return dimLevel;}
  int getCT() {return ct;}
  boolean getOn() {return onState;}
  
  void setID(int value)
  {
    lampID = value;
  }
  
  void setLampType(int value)
  {
    lampType = value;
  }
  
  void setName(String value)
  {
    name = value;
  }
  
  void setDimLevel(int value)
  {
    dimLevel = value;
  }
  
  void setCT(int value)
  {
    ct = value;
  }
  
  void setOn(boolean value)
  {
    onState = value;
  }
  
  XML getAsXML()
  {
    XML xml = parseXML("<luminaire></luminaire>");
    xml.setInt("id", lampID);
    xml.setInt("lampType", lampType);
    xml.setString("name", name);
    xml.setInt("dimLevel", dimLevel);
    xml.setInt("ct", ct);
    xml.setInt("on", onState? 1:0);
    
    return xml;
  }
}



/*
void setName(int lampID, String value)
{
  OscMessage message = new OscMessage("/Enlight/setName");
  message.add(lampID);
  message.add(value);
  oscP5.send(message, serverAddress);
}
*/