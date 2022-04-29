import processing.serial.*; //import the library

Serial myPort; // name the serial port
String val; //create variable for the incoming value from Arduino

int datanum = 2; //number of data receiving from Arduino

int buttonState; //create variable for button
int potValue; //create variable for pot

float max_distance;

void setup() {
  size(640, 360); 
  noStroke();
  max_distance = dist(0, 0, width, height);
  
  //optional, for you to find the right port you are using
  printArray(Serial.list());
  String portName = Serial.list()[2];//1st port =[0], 2nd port = [2] etc
  
  // set baud rate 9600, has to the same as Arduino
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');//create buffer, \n = next line
  
}

void draw() {
  background(0);

  for(int i = 0; i <= width; i += 20) {
    for(int j = 0; j <= height; j += 20) {
      float position = map(potValue, 0, 1023, 0, width);
      float size = dist(position, height/2, i, j);
      float x = map(position, 0, width, 30,150);
      size = size/max_distance * x;
      ellipse(i, j, size, size);
    }
  }
  if (buttonState == 1){
  filter(INVERT);

  }
}

void serialEvent( Serial myPort){
  val = myPort.readStringUntil('\n'); //get data until next line as one set of data
  if (val != null) //if you are not getting nothing
  {
    val = trim(val);//Removes whitespace characters from the beginning and end of a String
    
    //separate a set of data by "," and transform it to an array of data
    int[] vals = int(splitTokens(val, ",")); 
    
    if(vals.length >= datanum){
       buttonState = vals[0]; //the 1st value from array of data
       potValue = vals[1] ; //the 2nd value 
    
      println(buttonState + "," + potValue);
    }
  }
}
