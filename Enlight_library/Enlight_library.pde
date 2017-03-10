/**
 * ENLIGHT communcation 
 * by Thomas van de Werff
 * version 1.0.3 (10-03-2017)
 *
 * control the Enlight system with processing
 */

/* 
  The following functions are available in this version:
  
  setBrightness(0,255);            //set the brightness of a lamp                                  (int lampID, int brightness [0-255])
  setBrightness(0,255,100);        //set the brightness of a lamp with a fadeTime in milliseconds  (int lampID, int brightness, int fadeTime [0-...])
  setCT(0,MAXCT);                  //set the color temperature in Kelvin                           (int lampID, int ct [1700-8000])
  setCT(0,MINCT,100);              //set the ct of a lamp with a fadeTime in milliseconds          (int lampID, int ct, int fadeTime [0-...])
  setRGB(0,255,0,0);               //set the color of a lamp in RGB                                (int lampID, int red, int green, int blue [0-255])
  setRGB(0,255,0,0,100);           //set the color of a lamp with a fadeTime in milliseconds       (int lampID, int red, int green, int blue, int fadeTime [0-...])
  setOn(0,true);                   //turn a lamp on or off                                         (int lampID, bool onState [true/false])
  setOn(0,1);                      //turn a lamp on or off                                         (int lampID, int onState [0-1])
*/


void setup()
{
  size(640,480);
  
  //this function initiates the Enlight communcation. Make sure to fill in the correct IP address and PORT!
  setupEnlight("192.168.1.151", 11000); 
}

void draw()
{
  /* Put your own code here & remove the following */
  
  background(0);
  
  noStroke();
  for (int i = 0; i<width; i++)
  {
    color c = CTtoHEX(1700 + (8000-1700)/width*i);
    
    for (int j = 0; j<height; j++)
    {
      float b = 255 - (255.0/height*j);
      fill(c, b);
      rect(i,j,1,1);
    }
  }
  
  int margin = 16;
  
  fill(255);
  text("ct (Kelvin) -->", margin*2, height - margin);
  translate(width/2, height/2);
  rotate(PI/2*3);
  text("dimLevel (0-65535) -->", -height/2 + margin*2, -width/2 + margin);
}

//You can remove this as well

long pressTime = 0;
void mousePressed()
{
  pressTime = millis();
}

void mouseReleased()
{
  int ct = (int) map(mouseX,0,width,MINCT,MAXCT);
  int dimLevel = (int) map(mouseY,height,0,0,MAXDIMLEVEL);

  int longPress = int(millis() - pressTime);
  int lampID = 0;
  setDimLevel(lampID,dimLevel, longPress);
  setCT(lampID, ct, longPress); 
}