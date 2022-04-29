import processing.serial.*; //import the library

Serial myPort; // name the serial port
String val; //create variable for the incoming value from Arduino

int datanum = 2; //number of data receiving from Arduino

int buttonState; //create variable for button
int potValue; //create variable for pot

void setup() {
  size(800, 800); //set the canvas
  background(255); //make a white background
  
  //optional, for you to find the right port you are using
  printArray(Serial.list());
  String portName = Serial.list()[2];//1st port =[0], 2nd port = [2] etc
  
  // set baud rate 9600, has to the same as Arduino
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');//create buffer, \n = next line
}

void draw() {
  strokeWeight(1); 
  stroke(random(125),25,125); //stroke colour
  
  //the value we got from pot is 0-1023, 1023 is larger than the canvas size 800
  //so we have to map the range to 0-width(800)
  //float is variable with decimal place
  float position = map(potValue, 0, 1023, 0, width); 
  line(position, 0, position, height); //replace mouseX with position
  
  if (buttonState == 1) { // replace mousePressed to potValue
    saveFrame("line-######.png"); //save the image
    background(255); //clear the canvas, aka restart
  }

}


//instead of reading data in the draw() loop
//we use serialEvent for reading data only when data is available
//set with bufferUntil() above,
//reading data function will only be triggered after a specific character is read

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
