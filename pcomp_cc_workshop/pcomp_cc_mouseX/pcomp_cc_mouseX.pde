void setup() {
  size(800, 800);
   background(255);
}

void draw() {
  strokeWeight(1);
  stroke(random(125),25,125);
  line(mouseX, 0, mouseX, height);
  
  if (mousePressed == true) {
    saveFrame("line-######.png"); //save the image
    background(255); //clear the canvas, aka restart
  }

}
