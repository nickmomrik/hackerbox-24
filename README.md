# HackerBox #0024: Vision Quest

Check out [my unboxing video and value analysis](https://nick.blog/2017/10/30/hackerbox-0024-vision-quest/) as well as the [Instructable for the box](https://www.instructables.com/id/HackerBox-0024-Vision-Quest/).

I'll put any of my custom or modified code here.

## Pan & Tilt Face Tracking
**SerialPanTilt** is a basic Arduino sketch for controlling the pan and tilt servos over the serial port.

**PanTiltFaceTracker** is the code to use in Processing that uses OpenCV for face tracking and sends commands through the serial port to the Arduino. It attempts to keep the first face in the middle of the screen.
