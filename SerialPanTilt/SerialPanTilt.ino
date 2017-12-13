#include <Servo.h>

#define panPin  2
#define tiltPin 3

Servo servoPan, servoTilt;

char panChannel = 0;
char tiltChannel = 1;
char serialChar = 0;

void setup() {
  servoPan.attach( panPin );
  servoTilt.attach( tiltPin );

  servoPan.write( 90 );
  servoTilt.write( 90 );

  Serial.begin( 57600 );

  //while ( ! Serial ) ;
}

void loop() {
  /*
  char buf = ' ';
  
  Serial.println( "PAN? (0-180)" );
  while ( 0 == Serial.available() ) ;

  int pan = Serial.parseInt();       

  Serial.println( pan, DEC );
  servoPan.write( pan );

  clearBuffer();

  Serial.println( "TILT? (0-180)" );
  while ( 0 == Serial.available() ) ;

  int tilt = Serial.parseInt();       

  Serial.println( tilt, DEC );
  servoTilt.write( tilt );

  clearBuffer();
  */

  // https://www.sparkfun.com/tutorials/304
  // Wait for a character on the serial port.
  while ( Serial.available() <= 0 ) ;  

  serialChar = Serial.read();
  if ( serialChar == panChannel ) {
    // Wait
    while ( Serial.available() <= 0 ) ;

    servoPan.write( Serial.read() );
  } else if ( serialChar == tiltChannel ) {
    // Wait
    while ( Serial.available() <= 0 ) ;

    servoTilt.write( Serial.read() );
  }
}

void clearBuffer() {
    // clear keyboard buffer
    while ( Serial.available() > 0 )  {
      Serial.read();
    }
}

