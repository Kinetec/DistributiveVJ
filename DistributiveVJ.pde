/*
Distributive VJ Platform using SpaceBrew and Arduino w/ Processing

Prototyping Interactive Spaces Using SpaceBrew
NYU ITP
Spring 2014
Professor Brett Renfer

Credits:
Kate Godwin
Oscar Klingspor
Michael Ricca
*/

import spacebrew.*;
import processing.serial.*;
import ddf.minim.*;
 
Minim minim;
AudioInput in;
 
float prevVolume, prevVolume2;
 
float volume = 0;
float volume2 = 0;


//int touchshield;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

String server="sandbox.spacebrew.cc";
String name="VJ Touch Arduino";
String description ="This is a TochShield to SpaceBrew test";


Spacebrew sb;

void setup() 
{
  size(200, 200);
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );
  sb.addPublish( "touchrange", "range", 0 ); 
  sb.addPublish( "volumeout", "range", 0 ); 
 

  sb.connect(server, name, description );
  
   minim = new Minim(this);
  minim.debugOn();  
  in = minim.getLineIn(Minim.MONO, 1024);      // get a line in from Minim, default bit depth is 16
  
}

/* Gets a smooth value from the input, with regards to the previous values
 *   @param input is the new input
 *   @param previous is the reference
 *   @param factor is a number between 0 and 1 determining the weight of smoothing
 */
float getSmoothed(float input, float previous, float factor){
  return lerp(input, previous, factor);
}


void draw()
{
  
  //TODO: See if this is the right scale
//  volume = pow( 2, in.right.level() ) ;
  volume = in.right.level()*2000;
  float smoothed = getSmoothed(volume, prevVolume, .5f);
  sb.send( "volumeout", (int) volume );
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    //touchshield = val;
    sb.send( "touchrange", val );
    
  }
  println(smoothed);
  prevVolume = volume;
  prevVolume2 = volume2;
}
