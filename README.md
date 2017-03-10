# TU/e Office Living Lab API
Processing sketch for communication with the lighting system in the TU/e Office Living Lab (LG0.35), as well as the Lightlab (LG-1.18). Make sure to install the OSCP5 library in Processing before using this sketch. Download it at https://github.com/sojamo/oscp5

new in v1.0.3
- added setBrightness functionality (0-255)
- added Philips Hue and iColor Cove functionality
- No longer use the lampID directly in the function, instead first create a lamp instance to call a function: 
  "setBrightness(lampID, value)" is now "getPB(lampID).setBrightness(value)"

new in v1.0.2
- possible to set fadeTime and colorFadeTime for the luminaires

new in v1.0.1
- added RGB functionality to the Enlight PowerBalance luminaires

Future work:
- add support for Philips Hue lights
- add support for Philips Color Kinetics iColor Coves
- add notifications for presence sensing

For questions, email me!
