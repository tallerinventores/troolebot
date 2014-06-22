#include <DistanceGP2Y0A21YK.h>
#include <Bounce2.h>
#include <Servo.h>

//steering turn degrees
#define TURN_RIGHT 100//STRAIGHT+10
#define STRAIGHT 90
#define TURN_LEFT 80//STRAIGHT-10
//steering calculated turn degrees
#define TURN_R6 99//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.8571)
#define TURN_R5 97//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.7143)
#define TURN_R4 96//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.5714)
#define TURN_R3 94//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.4286)
#define TURN_R2 93//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.2851)
#define TURN_R1 91//STRAIGHT+((TURN_RIGHT-STRAIGHT)*0.1429)
#define TURN_L1 89//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.1429)
#define TURN_L2 87//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.2851)
#define TURN_L3 86//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.4286)
#define TURN_L4 84//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.5714)
#define TURN_L5 83//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.7143)
#define TURN_L6 81//STRAIGHT-((STRAIGHT-TURN_LEFT)*0.8571)
//motor direction
#define MOTOR_FORWARD 1
#define MOTOR_REVERSE 2
#define MOTOR_CURRENT 3
//motor speed
#define MOTOR_STOP 0x00
#define MOTOR_S0 0x00
#define MOTOR_S1 0x01
#define MOTOR_S2 0x02
#define MOTOR_S3 0x03
#define MOTOR_S4 0x04
#define MOTOR_S5 0x05
#define MOTOR_S6 0x06
#define MOTOR_S7 0x07
#define MOTOR_S8 0x08
#define MOTOR_S9 0x09
//display spacial commands
#define DISP_BLANK 0xFF
#define DISP_LATCH 0x0F
//rc commands
#define RC_ACK 0x10
#define RC_SYNC 0x11
#define RC_GET 0x12
#define RC_LIGHT_ON 0x13
#define RC_LIGHT_OFF 0x14
#define RC_CLAXON_ON 0x15
#define RC_CLAXON_OFF 0x16
#define RC_FORW 0x17
#define RC_REV 0x18
#define RC_SPEED_0 0x20
#define RC_SPEED_1 0x21
#define RC_SPEED_2 0x22
#define RC_SPEED_3 0x23
#define RC_SPEED_4 0x24
#define RC_SPEED_5 0x25
#define RC_SPEED_6 0x26
#define RC_SPEED_7 0x27
#define RC_SPEED_8 0x28
#define RC_SPEED_9 0x29
#define RC_SET_STEERING_L7 0x31
#define RC_SET_STEERING_L6 0x32 
#define RC_SET_STEERING_L5 0x33
#define RC_SET_STEERING_L4 0x34
#define RC_SET_STEERING_L3 0x35
#define RC_SET_STEERING_L2 0x36
#define RC_SET_STEERING_L1 0x37
#define RC_SET_STEERING_LR 0x38
#define RC_SET_STEERING_R1 0x39
#define RC_SET_STEERING_R2 0x3A
#define RC_SET_STEERING_R3 0x3B
#define RC_SET_STEERING_R4 0x3C
#define RC_SET_STEERING_R5 0x3D
#define RC_SET_STEERING_R6 0x3E
#define RC_SET_STEERING_R7 0x3F
//rc constants
#define RC_SYNCPERIOD 500
//time constants
#define EXPIRETIME 2000

DistanceGP2Y0A21YK dist;
Servo steering;
Bounce button = Bounce();

/*
   board A: GND - L - C - BTN - DP - 8 - 4 - 2 - 1 - VCC
   board B: GND - RF - LF - DST - SRV - PWM - RLY - VCC -- GND - VCC
   xbee: 0013A200 40B2EF0A
*/

void setup() {
  pinMode(2, OUTPUT); //lights
  pinMode(3, OUTPUT); //claxon
  pinMode(4, OUTPUT); //motor rly
  pinMode(5, INPUT); //left floor
  pinMode(6, INPUT); //right floor
  pinMode(7, INPUT); //button
  steering.attach(9); //pwm servo
  pinMode(10, OUTPUT); //pwm motor
  pinMode(13, OUTPUT); //serial sync
  dist.begin(A0); //sharp
  pinMode(A1, OUTPUT); //bcd a
  pinMode(A2, OUTPUT); //bcd b
  pinMode(A3, OUTPUT); //bcd c
  pinMode(A4, OUTPUT); //bcd d
  pinMode(A5, OUTPUT); //display dp
  steering.write(STRAIGHT);
  disp(DISP_BLANK, false);
  button.attach(7);
  button.interval(5);
  Serial.begin(9600);
}

void loop() {
  static boolean pushed = false;
  static boolean changemode = false;
  static boolean updatesync = false;
  static boolean synced = false;
  byte inbuffer = 0;
  static byte mode = 0;
  static byte updatemotion = MOTOR_CURRENT;
  static byte updatespeed = MOTOR_STOP;
  static unsigned long updatemode = 0;
  static unsigned long debugdelay = 0;
  static unsigned long rcsyncexpire = 0;

  button.update();
  if (button.read()) pushed = true;
  else if (pushed == true) { //falling edge
    pushed = false;
    changemode = true;
    updatemode = millis();
    mode++;
    if (mode > 9) mode = 0;
    digitalWrite(10, HIGH);
  }
  if (changemode) { //mode changing
    if (updatemode + 2000 > millis()) {
      disp(mode, true);
    }
    else changemode = false;
  }
  else { //new mode
    disp(DISP_LATCH, false);
    switch (mode) {
      case 0:
        //switch off
        disp(0, false);
        motor(MOTOR_REVERSE, MOTOR_STOP);
        steering.detach();
        digitalWrite(2, LOW);
        digitalWrite(3, LOW);
        break;
      case 1:
        //debug
        if (debugdelay + 500 < millis()) {
          debugdelay = millis();
          Serial.println("INPUTS:");
          Serial.print("  Sharp - ");
          Serial.println(dist.getDistanceCentimeter());
          Serial.print("  Left CNY - ");
          Serial.println(!digitalRead(5));
          Serial.print("  Right CNY - ");
          Serial.println(!digitalRead(6));
        }
        break;
      case 2:
        steering.attach(9);
        steering.write(TURN_LEFT);
        //line follower
        break;
      case 3:
        steering.attach(9);
        steering.write(TURN_RIGHT);
        //avoid obstacle
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        //rc
        steering.attach(9);
        if (rcsyncexpire < millis()) synced = false;
        else synced = true;
        while(Serial.available()) {
          inbuffer = Serial.read();
          if (synced) {
            updatesync = false;
            switch (inbuffer) {
              case RC_SYNC:
                rcsyncexpire = EXPIRETIME + millis();
                Serial.write(RC_ACK);
                break;
              case RC_GET:
                Serial.print("\n ");
                Serial.print(dist.getDistanceCentimeter());
                Serial.print("\t ");
                Serial.print(!digitalRead(5));
                Serial.print("\t ");
                Serial.println(!digitalRead(6));
                break;
              case RC_LIGHT_ON:
                digitalWrite(2, HIGH);
                break;
              case RC_LIGHT_OFF:
                digitalWrite(2, LOW);
                break;
              case RC_CLAXON_ON:
                digitalWrite(3, HIGH);
                break;
              case RC_CLAXON_OFF:
                digitalWrite(3, LOW);
                break;
              case RC_FORW:
                updatemotion = MOTOR_FORWARD;
                updatespeed = MOTOR_STOP;
                break;
              case RC_REV:
                updatemotion = MOTOR_REVERSE;
                updatespeed = MOTOR_STOP;
                break;
              case RC_SPEED_0:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S0;
                break;
              case RC_SPEED_1:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S1;
                break;
              case RC_SPEED_2:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S2;
                break;
              case RC_SPEED_3:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S3;
                break;
              case RC_SPEED_4:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S4;
                break;
              case RC_SPEED_5:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S5;
                break;
              case RC_SPEED_6:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S6;
                break;
              case RC_SPEED_7:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S7;
                break;
              case RC_SPEED_8:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S8;
                break;
              case RC_SPEED_9:
                updatemotion = MOTOR_CURRENT;
                updatespeed = MOTOR_S9;
                break;
              case RC_SET_STEERING_L7:
                steering.write(TURN_LEFT);
                break;
              case RC_SET_STEERING_L6:
                steering.write(TURN_L6);
                break;
              case RC_SET_STEERING_L5:
                steering.write(TURN_L5);
                break;
              case RC_SET_STEERING_L4:
                steering.write(TURN_L4);
                break;
              case RC_SET_STEERING_L3:
                steering.write(TURN_L3);
                break;
              case RC_SET_STEERING_L2:
                steering.write(TURN_L2);
                break;
              case RC_SET_STEERING_L1:
                steering.write(TURN_L1);
                break;
              case RC_SET_STEERING_LR:
                steering.write(STRAIGHT);
                break;
              case RC_SET_STEERING_R1:
                steering.write(TURN_R1);
                break;
              case RC_SET_STEERING_R2:
                steering.write(TURN_R2);
                break;
              case RC_SET_STEERING_R3:
                steering.write(TURN_R3);
                break;
              case RC_SET_STEERING_R4:
                steering.write(TURN_R4);
                break;
              case RC_SET_STEERING_R5:
                steering.write(TURN_R5);
                break;
              case RC_SET_STEERING_R6:
                steering.write(TURN_R6);
                break;
              case RC_SET_STEERING_R7:
                steering.write(TURN_RIGHT);
                break;
              default:
                delay(1);
            }
          }
          else {
            if (inbuffer == RC_SYNC) {
              synced = true;
              rcsyncexpire = EXPIRETIME + millis();
              Serial.write(RC_ACK);
            }
          }
        }
        if (synced) {
          digitalWrite(13, HIGH);
          motor(updatemotion, updatespeed);
        }
        else {
          digitalWrite(13, LOW);
          updatemotion = MOTOR_FORWARD;
          updatespeed = MOTOR_STOP;
          motor(MOTOR_FORWARD, MOTOR_STOP);
        }
    }
  }
}

void motor(byte motion, byte speedval) {
  static byte currentmotion = 0;
  
  if ((motion == currentmotion) || (motion == MOTOR_CURRENT))  {
    setspeed(speedval);
  }
  else {
    setspeed(MOTOR_STOP);
    delay(100);
    if (motion == MOTOR_FORWARD) digitalWrite(4, HIGH);
    else digitalWrite(4, LOW);
    delay(50);
    setspeed(speedval);
    currentmotion = motion;
  }
}

void setspeed(byte value) {
  static unsigned long speeddelay = 0;
  static byte timebase = 0;
  
  if (speeddelay + 10 < millis()) {
    speeddelay = millis();
    timebase++;
    if (timebase > 9) timebase = 0;
    if (value <= timebase) digitalWrite(10, HIGH);
    else digitalWrite(10, LOW);
  }
}

void disp(byte printvalue, boolean printmode) {
  switch (printvalue) {
    case 0:
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      digitalWrite(A4, LOW);
      break;
    case 1:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      digitalWrite(A4, LOW);
      break;
    case 2:
      digitalWrite(A1, LOW);
      digitalWrite(A2, HIGH);
      digitalWrite(A3, LOW);
      digitalWrite(A4, LOW);
      break;
    case 3:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, HIGH);
      digitalWrite(A3, LOW);
      digitalWrite(A4, LOW);
      break;
    case 4:
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, HIGH);
      digitalWrite(A4, LOW);
      break;
    case 5:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, LOW);
      digitalWrite(A3, HIGH);
      digitalWrite(A4, LOW);
      break;
    case 6:
      digitalWrite(A1, LOW);
      digitalWrite(A2, HIGH);
      digitalWrite(A3, HIGH);
      digitalWrite(A4, LOW);
      break;
    case 7:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, HIGH);
      digitalWrite(A3, HIGH);
      digitalWrite(A4, LOW);
      break;
    case 8:
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      digitalWrite(A4, HIGH);
      break;
    case 9:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      digitalWrite(A4, HIGH);
      break;
    case DISP_LATCH:
      break;
    default:
      digitalWrite(A1, HIGH);
      digitalWrite(A2, HIGH);
      digitalWrite(A3, HIGH);
      digitalWrite(A4, HIGH);
  }
  if (printmode) digitalWrite(A5, HIGH);
  else digitalWrite(A5, LOW);
}
