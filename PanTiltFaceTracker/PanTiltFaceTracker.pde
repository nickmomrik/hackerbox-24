/*

Heavily inspired by https://www.sparkfun.com/tutorials/304
and the Processing face detection example

*/

import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import processing.serial.*;

Capture video;
OpenCV opencv;

boolean debug = true;

// If using the default camera, set to ""
String cameraName = "USB2.0 WebCamera #2";
int width = 640;
int height = 480;
int scale = 2;
int fps = 30;

Serial port;

char servoTiltPosition = 90;
char servoPanPosition = 90;

// IDs for the Arduino serial command interface.
char panChannel = 0;
char tiltChannel = 1;

// Acceptable error % for the center of the screen.
int acceptedErrorPercent = 8;

// Degree of servo change with each position update
int stepSize = 1;

void setup() {
  size( 640, 480 );
  if ( 0 == cameraName.length() ) {
    video = new Capture( this, width / scale, height / scale, fps );
  } else {
    video = new Capture( this, width / scale, height / scale, cameraName, fps );
  }
  opencv = new OpenCV( this, width / scale, height / scale );
  opencv.loadCascade( OpenCV.CASCADE_FRONTALFACE );  

  video.start();

  if ( debug ) {
    // List COM ports
    //println( Serial.list() );
  }

  // Use the above list to determine which port number to use below
  // Set the baud rate to match what is used in the Arduino sketch
  port = new Serial( this, Serial.list()[3], 57600 );
  
  // Arduino code already does this, but be sure the servos are centered
  port.write( tiltChannel );
  port.write( servoTiltPosition );
  port.write( panChannel );
  port.write( servoPanPosition );
}

void draw() {
  scale( scale );
  opencv.loadImage( video );

  image( video, 0, 0 );

  noFill();
  stroke( 0, 255, 0 );
  strokeWeight( 3 );
  Rectangle[] faces = opencv.detect();

  for ( int i = 0; i < faces.length; i++ ) {
    if ( debug ) {
      println( "Face " + i + ": " + faces[i].x + "," + faces[i].y + " - " + faces[i].width + "x" + faces[i].height );
    }

    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
  }
  
  if ( faces.length > 0 ) {
    // x and y of a face corresponds to the upper left corner of the rectangle
    adjustServos( faces[0].x + ( faces[0].width / 2 ), faces[0].y + ( faces[0].height / 2 ) );
  }

  delay( 1 );
}

void captureEvent( Capture c ) {
  c.read();
}

void adjustServos( int midFaceX, int midFaceY ) {
  int midScreenX = width / scale / 2;
  int midScreenY = height / scale / 2;
  int errorX = width / scale * acceptedErrorPercent / 100;
  int errorY = height / scale * acceptedErrorPercent / 100;
  
  // This is all dependent on how the servos are mounted
  if ( midFaceX < ( midScreenX - errorX ) ) {
    if ( servoPanPosition <= ( 180 - stepSize ) ) {
      servoPanPosition += stepSize;
    }
  } else if ( midFaceX > ( midScreenX + errorX ) ) {
    if ( servoPanPosition >= stepSize ) {
      servoPanPosition -= stepSize;
    }
  }

  if ( midFaceY < ( midScreenY - errorY ) ) {
    if ( servoTiltPosition <= ( 180 - stepSize ) ) {
      servoTiltPosition += stepSize;
    }
  } else if ( midFaceY > ( midScreenY + errorY ) ) {
    if ( servoTiltPosition >= stepSize ) {
      servoTiltPosition -= stepSize;
    }
  }

        
  if ( debug ) {
    int intTilt = servoTiltPosition;
    int intPan = servoPanPosition;
  
    println( "Error %s: " + errorX + " - " + errorY );
    println( "Y: " + midFaceY + " X: " + midFaceX + " T: " + intTilt + " P: " + intPan );
  }
  
  port.write( tiltChannel );
  port.write( servoTiltPosition );
  port.write( panChannel );
  port.write( servoPanPosition );
}