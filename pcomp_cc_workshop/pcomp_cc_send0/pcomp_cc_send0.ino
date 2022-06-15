void setup() {
  Serial.begin( 9600 );
}

void loop() {
  Serial.println("0"); //send a zero
  delay( 1000 ); //wait 1 second
  Serial.println("1"); //send an one
  delay( 1000 ); //wait 1 second

}
