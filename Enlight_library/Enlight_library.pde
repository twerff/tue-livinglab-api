/**
 * ENLIGHT communcation 
 * by Thomas van de Werff
 * version 1.0.5 (06-10-2017)
 *
 * control the Enlight system with processing
 */

/* 
  The following functions are available in this version:
  
  getPB(0)                       //get the PowerBalance with id 0
  getHue(0)                      //not available right now: get the Hue lamp with id 0
  getCove(0)                     //not available right now: get the iColor Cove with id 0
  
  getPB(0).setBrightness(255);   //set the brightness of PowerBalance 0 to 255              (int brightness [0-255])
    setBrightness(255,100);      //set the brightness with a fadeTime in milliseconds       (int brightness, int fadeTime [0-...])
    setCT(MAXCT);                //set the color temperature in Kelvin                      (int ct [1700-8000])
    setCT(MINCT,100);            //set the ct of a lamp with a fadeTime in milliseconds     (int ct, int fadeTime [0-...])
    setRGB(255,0,0);             //set the color of a lamp in RGB                           (int red, int green, int blue [0-255])
    setRGB(255,0,0,100);         //set the color of a lamp with a fadeTime in milliseconds  (int red, int green, int blue, int fadeTime [0-...])
    setOn(true);                 //turn a lamp on or off                                    (boolean onState [true/false])
    setOn(1);                    //turn a lamp on or off                                    (int onState [0-1])
*/


void setup()
{
  //this function initiates the Enlight communcation. Make sure to fill in the correct IP address and PORT!
  //in the lightlab use IP 192.168.1.36 and PORT 11000
  //in the office lab use IP 192.168.1.102 and PORT 12000
  setupEnlight("192.168.1.36", 11000); 
  
  size(640,480);  
  drawGrid();
}

void draw()
{
  
}

void drawGrid()
{
  background(0);
  
  noStroke();
  for (int i = 0; i<width; i++)
  {
    color c = CTtoHEX(MINCT + (MAXCT-MINCT)/width*i);
    
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
  //get the values from the position of the mouse
  int brightness = (int) map(mouseY,height,0,MINBRIGHTNESS,MAXBRIGHTNESS);
  int ct = (int) map(mouseX,0,width,MINCT,MAXCT);
  int r = (int) red(get(mouseX,mouseY));
  int g = (int) green(get(mouseX,mouseY));
  int b = (int) blue(get(mouseX,mouseY));
  int longPress = int(millis() - pressTime);
  
  //update all enlight lamps
  for (int i = 0; i< 20; i++)
  {
    getPB(i).setBrightness(brightness, longPress);
    getPB(i).setCT(ct, longPress);
  }
  
  //update all hue lamps
  //for (int i = 0; i< 3; i++)
  //{
  //  getHue(i).setCT(ct,longPress);
  //  getHue(i).setBrightness(brightness,longPress);
  //}
  
  //update all color coves
  //for (int i = 0; i< 5; i++)
  //{
  //  getCove(i).setRGB(r,g,b,longPress);
  //}
  
  
}