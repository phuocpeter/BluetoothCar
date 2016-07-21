#include <SoftwareSerial.h>
SoftwareSerial softSerial(14, 15);

#define ENA 6
#define ENB 3
#define IN1 7
#define IN2 8
#define IN3 5
#define IN4 4

int speed = 100;

void setup() {
  /* Set inputs */
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);

  /* Serial */
  Serial.begin(9600);

  /* Software Serial */
  softSerial.begin(9600);
  softSerial.println("OK");
 
}

void loop() {

  if (Serial.available()) {
    Serial.write(Serial.read());
    softSerial.write(Serial.read());
  }

  if (softSerial.available()) {
    // Checks if the softSerial recevices data
    processCommand(softSerial.read());
  }

}

/* Method: processCommand() */
/**
 * Runs appropriate command based on the
 * character received.
 * @param cmd The character received by serial
 */
void processCommand(char cmd) {
  switch (cmd) {
    case 'f': //Fprward
      digitalWrite(IN1, LOW);  
      digitalWrite(IN2, HIGH);   
      
      digitalWrite(IN4, HIGH);  
      digitalWrite(IN3, LOW);   

      analogWrite(ENB, speed);  
      analogWrite(ENA, speed);
      softSerial.print("Forward");
      break;
    case 'b': //Fprward
      digitalWrite(IN1, HIGH);  
      digitalWrite(IN2, LOW);   
      
      digitalWrite(IN4, LOW);  
      digitalWrite(IN3, HIGH);   

      analogWrite(ENB, speed);  
      analogWrite(ENA, speed);
      softSerial.print("Backward");
      break;
    case 's': // Stop
      digitalWrite(IN1, LOW);  
      digitalWrite(IN2, LOW);   
      
      digitalWrite(IN4, LOW);  
      digitalWrite(IN3, LOW);   
      softSerial.print("Stop");
      break;
    default:
      break;
  }
}

