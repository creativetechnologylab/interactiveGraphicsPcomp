/**
 * Yellowtail
 * by Golan Levin (www.flong.com). 
 * 
 * Click, drag, and release to create a kinetic gesture.
 * 
 * Yellowtail (1998-2000) is an interactive software system for the gestural 
 * creation and performance of real-time abstract animation. Yellowtail repeats 
 * a user's strokes end-over-end, enabling simultaneous specification of a 
 * line's shape and quality of movement. Each line repeats according to its 
 * own period, producing an ever-changing and responsive display of lively, 
 * worm-like textures.
 */
import processing.serial.*; //import the library

Serial myPort; // name the serial port
String val; //create variable for the incoming value from Arduino

int datanum = 2; //number of data receiving from Arduino

int buttonState; //create variable for button
int potValue; //create variable for pot

import java.awt.Polygon;

Gesture gestureArray[];
final int nGestures = 36;  // Number of gestures
final int minMove = 3;     // Minimum travel for a new point
int currentGestureID;

Polygon tempP;
int tmpXp[];
int tmpYp[];


void setup() {
  size(1024, 768, P2D);
  background(0, 0, 0);
  noStroke();
  
  printArray(Serial.list());
  String portName = Serial.list()[5];//1st port =[0], 2nd port = [2] etc
  
  // set baud rate 9600, has to the same as Arduino
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');//create buffer, \n = next line
  currentGestureID = -1;
  gestureArray = new Gesture[nGestures];
  for (int i = 0; i < nGestures; i++) {
    gestureArray[i] = new Gesture(width, height);
  }
  clearGestures();
}


void draw() {
  background(0);

  updateGeometry();
  float green = map(potValue, 0, 1023, 0, 255); 
  fill(255, green, 0);
  for (int i = 0; i < nGestures; i++) {
    renderGesture(gestureArray[i], width, height);
  }
  if (buttonState == 1) { // replace mousePressed to potValue
    saveFrame("tail-######.png"); //save the image
    clearGestures();
  }
  
}

void mousePressed() {
  currentGestureID = (currentGestureID+1) % nGestures;
  Gesture G = gestureArray[currentGestureID];
  G.clear();
  G.clearPolys();
  G.addPoint(mouseX, mouseY);
}


void mouseDragged() {
  if (currentGestureID >= 0) {
    Gesture G = gestureArray[currentGestureID];
    if (G.distToLast(mouseX, mouseY) > minMove) {
      G.addPoint(mouseX, mouseY);
      G.smooth();
      G.compile();
    }
  }
}


void keyPressed() {
  if (key == '+' || key == '=') {
    if (currentGestureID >= 0) {
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = min(96, th+1);
      gestureArray[currentGestureID].compile();
    }
  } else if (key == '-') {
    if (currentGestureID >= 0) {
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = max(2, th-1);
      gestureArray[currentGestureID].compile();
    }
  } else if (key == ' ') {
    clearGestures();
  }else if (key == 'H' || key == 'h') {
    myPort.write('H');
  }else if (key == 'L' || key == 'l') {
    myPort.write('L');
  }
}


void renderGesture(Gesture gesture, int w, int h) {
  if (gesture.exists) {
    if (gesture.nPolys > 0) {
      Polygon polygons[] = gesture.polygons;
      int crosses[] = gesture.crosses;

      int xpts[];
      int ypts[];
      Polygon p;
      int cr;

      beginShape(QUADS);
      int gnp = gesture.nPolys;
      for (int i=0; i<gnp; i++) {

        p = polygons[i];
        xpts = p.xpoints;
        ypts = p.ypoints;

        vertex(xpts[0], ypts[0]);
        vertex(xpts[1], ypts[1]);
        vertex(xpts[2], ypts[2]);
        vertex(xpts[3], ypts[3]);

        if ((cr = crosses[i]) > 0) {
          if ((cr & 3)>0) {
            vertex(xpts[0]+w, ypts[0]);
            vertex(xpts[1]+w, ypts[1]);
            vertex(xpts[2]+w, ypts[2]);
            vertex(xpts[3]+w, ypts[3]);

            vertex(xpts[0]-w, ypts[0]);
            vertex(xpts[1]-w, ypts[1]);
            vertex(xpts[2]-w, ypts[2]);
            vertex(xpts[3]-w, ypts[3]);
          }
          if ((cr & 12)>0) {
            vertex(xpts[0], ypts[0]+h);
            vertex(xpts[1], ypts[1]+h);
            vertex(xpts[2], ypts[2]+h);
            vertex(xpts[3], ypts[3]+h);

            vertex(xpts[0], ypts[0]-h);
            vertex(xpts[1], ypts[1]-h);
            vertex(xpts[2], ypts[2]-h);
            vertex(xpts[3], ypts[3]-h);
          }

          // I have knowingly retained the small flaw of not
          // completely dealing with the corner conditions
          // (the case in which both of the above are true).
        }
      }
      endShape();
    }
  }
}

void updateGeometry() {
  Gesture J;
  for (int g=0; g<nGestures; g++) {
    if ((J=gestureArray[g]).exists) {
      if (g!=currentGestureID) {
        advanceGesture(J);
      } else if (!mousePressed) {
        advanceGesture(J);
      }
    }
  }
}

void advanceGesture(Gesture gesture) {
  // Move a Gesture one step
  if (gesture.exists) { // check
    int nPts = gesture.nPoints;
    int nPts1 = nPts-1;
    Vec3f path[];
    float jx = gesture.jumpDx;
    float jy = gesture.jumpDy;

    if (nPts > 0) {
      path = gesture.path;
      for (int i = nPts1; i > 0; i--) {
        path[i].x = path[i-1].x;
        path[i].y = path[i-1].y;
      }
      path[0].x = path[nPts1].x - jx;
      path[0].y = path[nPts1].y - jy;
      gesture.compile();
    }
  }
}

void clearGestures() {
  for (int i = 0; i < nGestures; i++) {
    gestureArray[i].clear();
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
