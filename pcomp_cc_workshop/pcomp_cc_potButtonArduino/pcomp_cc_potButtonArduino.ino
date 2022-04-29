const int buttonPin = 8;     
const int potPin =  A0;      

int buttonState = 0;         
int potValue;

void setup() {
  Serial.begin(9600);

  pinMode(potPin, INPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {

  buttonState = digitalRead(buttonPin);
  potValue = analogRead(potPin);
  
  Serial.print(buttonState);
  Serial.print(",");
  Serial.println(potValue);
  
  delay(100);
}
