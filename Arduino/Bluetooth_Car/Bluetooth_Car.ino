#include <SoftwareSerial.h>
SoftwareSerial softSerial(14, 15);

#define ENA 6
#define ENB 3
#define IN1 7
#define IN2 8
#define IN3 5
#define IN4 4
#define TRIG 9
#define ECHO 10

#define SAFE_DISTANCE 10

int speed = 100;
bool autopilot = false;
bool backMode = false;

void setup() {
  /* Set inputs */
  pinMode(ENA, OUTPUT);
  pinMode(ENB, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  /* Serial */
  Serial.begin(9600);

  /* Software Serial */
  softSerial.begin(9600);
  softSerial.println("OK");
 
}

void loop() {

  if (Serial.available()) {
    //Serial.write(Serial.read());
    processCommand(Serial.read());
    softSerial.write(Serial.read());
  }

  if (softSerial.available()) {
    // Checks if the softSerial recevices data
    processCommand(softSerial.read());
  }
  
  if (autopilot) {
    int distance = measureDistance();
    Serial.println(distance);
    softSerial.print(distance);
    backMode = (distance <= 50);
    if (backMode) {
      processCommand('l');
    } else {
      processCommand('f');
    }
    delayMicroseconds(100);
  }

}

/**
 * Measures and returns the distance between an object in front.
 */
int measureDistance() {
  unsigned long duration;
  digitalWrite(TRIG, 0);
  delayMicroseconds(2);
  digitalWrite(TRIG, 1);
  delayMicroseconds(5);
  digitalWrite(TRIG, 0);
  
  duration = pulseIn(ECHO, HIGH);
  return int(duration / 2 / 29.412);
}

/* Method: processCommand() */
/**
 * Runs appropriate command based on the
 * character received.
 * @param cmd The character received by serial
 */
void processCommand(char cmd) {
  switch (cmd) {
    case 'f': //Forward
      digitalWrite(IN1, LOW);  
      digitalWrite(IN2, HIGH);   
      
      digitalWrite(IN4, HIGH);  
      digitalWrite(IN3, LOW);   

      analogWrite(ENB, speed);  
      analogWrite(ENA, speed);
      Serial.println("Forward");
      softSerial.print("Forward");
      break;
    case 'b': // Backward
      digitalWrite(IN1, HIGH);  
      digitalWrite(IN2, LOW);   
      
      digitalWrite(IN4, LOW);  
      digitalWrite(IN3, HIGH);   

      analogWrite(ENB, speed);  
      analogWrite(ENA, speed);
      Serial.println("Backward");
      softSerial.print("Backward");
      break;
    case 's': // Stop
      digitalWrite(IN1, LOW);  
      digitalWrite(IN2, LOW);   
      
      digitalWrite(IN4, LOW);  
      digitalWrite(IN3, LOW);   
      softSerial.print("Stop");
      autopilot = false;
      break;
    case 'r': // Right
     digitalWrite(IN1, HIGH);  
     digitalWrite(IN2, LOW);   
      
     digitalWrite(IN4, HIGH);  
     digitalWrite(IN3, LOW); 

     analogWrite(ENB, speed);  
     analogWrite(ENA, speed);  
     break;
   case 'l': // Left
     digitalWrite(IN1, LOW);  
     digitalWrite(IN2, HIGH);   
      
     digitalWrite(IN4, LOW);  
     digitalWrite(IN3, HIGH); 

     analogWrite(ENB, speed);  
     analogWrite(ENA, speed);  
     break;
    case 'a': // Autopilot Mode
      autopilot = true;
      break;
    default:
      break;
  }
}

