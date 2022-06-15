import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

int datanum = 0; //number of data receiving from Arduino
int value1; 

void setup() 
{
  size(200, 200);
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  background(255);             
  if (value1 == 0) {              
    fill(0,255,0);
      text("I got a zero", 40, 120); 
  } 
  else {                       // If the serial value is not 0,
    fill(255,0,0);
      text("No zero", 40, 120); 
  }
}

void serialEvent( Serial myPort){
  val = myPort.readStringUntil('\n');
  if (val != null)
  {
    val = trim(val);
    int[] vals = int(splitTokens(val, ","));
    
    if(vals.length >= datanum){
       value1 = vals[0];
    
      //multiple data from arduino if needed
      //value2 = vals[1] ;
    
      println(value1);
    }
  }
}
