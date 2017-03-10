public color CTtoHEX(int ct)
{
  ct = ct/100 + 10;
  
  float r = 0;
  float g = 0;
  float b = 0;
  
  //red
  if (ct <= 66) {
    r = 255;
  } else {
    r = ct - 60;
    r = 329.698727446 * pow(r,-0.1332047592);
  }
  
  //green
  if (ct <= 66 ) {
    g = ct;
    g = 99.4708025861 * log(g) - 161.1195681661;
  } else {
    g = ct - 60;
    g = 288.1221695283 * pow(g, -0.0755148492);
  }
  
  //blue
  if (ct >= 66 ) {
    b = 255;
  } else {
    if (ct <= 19) {
      b = 0;
    } else {
      b = ct - 10;
      b = 138.5177312231 * log(b) - 305.0447927307; 
    }
  }
  
  //
  if (r < 0) r = 0;
  if (r > 255) r = 255;
  
  if (g < 0) g = 0;
  if (g > 255) g = 255;
  
  if (b < 0) b = 0;
  if (b > 255) b = 255;
  
  return color(r,g,b);
}