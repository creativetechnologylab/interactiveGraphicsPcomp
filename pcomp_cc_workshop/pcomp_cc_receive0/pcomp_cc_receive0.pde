import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }
  background(255);             
  if (val == 0) {              
    fill(0,255,0);
      text("I got a zero", 40, 120); 
  } 
  else {                       // If the serial value is not 0,
    fill(255,0,0);
      text("No zero", 40, 120); 
  }
}
