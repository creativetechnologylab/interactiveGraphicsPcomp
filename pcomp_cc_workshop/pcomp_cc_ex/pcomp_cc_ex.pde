float max_distance;

void setup() {
  size(640, 360); 
  noStroke();
  max_distance = dist(0, 0, width, height);
}

void draw() {
  background(0);

  for(int i = 0; i <= width; i += 20) {
    for(int j = 0; j <= height; j += 20) {
      float size = dist(mouseX, height/2, i, j);
      float x = map(mouseX, 0, width, 30,150);
      size = size/max_distance * x;
      ellipse(i, j, size, size);
    }
  }
  if (mousePressed == true){
  filter(INVERT);

  }
}
