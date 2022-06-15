const int buttonPin = 8;     
const int potPin =  A0;      

char val; // Data received from the serial port
int ledPin = 4; // Set the pin to digital I/O 4

int buttonState = 0;         
int potValue;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(potPin, INPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {
  while (Serial.available()) { // If data is available to read,
     val = Serial.read(); // read it and store it in val
  }
    
    if (val == 'H') { // If H was received
        digitalWrite(ledPin, HIGH); // turn the LED on
    } else {
        digitalWrite(ledPin, LOW); // Otherwise turn it OFF
    }
 
  buttonState = digitalRead(buttonPin);
  potValue = analogRead(potPin);
  
  Serial.print(buttonState);
  Serial.print(",");
  Serial.println(potValue);
  
  delay(100);
}
