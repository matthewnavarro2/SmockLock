#include <SoftwareSerial.h>
#include <Adafruit_Fingerprint.h>

// pin A0 is IN from fSensor (GREEN wire)
// pin A1 is OUT from fSensor (WHITE wire)
SoftwareSerial fingerSerial(A0, A1);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&fingerSerial);
uint8_t id;
int fingerID;

// pin 3 is esp TX
// pin 4 is esp RX 
SoftwareSerial esp8266(3,4);
String str;

// pin 5 is input from PIR sensor
int pirPin = 5;
int pirStat = 0;

/
int esp32_inPin = A2;
int esp32_outPin = A3;

int speakerPin = 6;

void setup() {
  
  pinMode(pirPin, INPUT);
  pinMode(3, INPUT);
  pinMode(4,OUTPUT);
  pinMode(esp32_inPin, INPUT);
  pinMode(esp32_outPin, OUTPUT);
 

  fingerInitialize();
}

// This will eventually be the main loop function
void mainLoop()
{
  // wait to leave sleep mode
  waitToWake();

  // once out of sleep, request tier rank
  int tierRank = 0;

  // create a switch based system based on tier rank (for right now we will use max rank)
    // turn on esp32-cam and wait for response
    esp32Wake();
    
    // request the user to input fingerprint
    fingerID = getFingerprintIDez();
    
    // send fingerprint to server and wait for response
    sendFinger(fingerID);
    
    // ask user to place RFID key near sensor

    // send RFID to server
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.begin(9600);
  delay(50);
  fingerID = getFingerprintIDez();
  delay(100);
  Serial.end();
  esp8266.begin(115200);
  esp8266.print(fingerID);
  esp8266.end();
}

// Function to send fingerprint to ESP8266
// This will definitely need to be expanded on
void sendFinger()
{
  esp8266.begin(9600);
  esp8266.print(fingerID);
  esp8266.end()
}

// Function to activate ESP32-CAM
void esp32Wake()
{
  digitalWrite(outputPin, HIGH);
  while(true)
  {
    if(digitalRead(esp32_inPin) == HIGH)
    {
      break; 
    }
  }
}


// Function for fingerprint sensor startup
// want to change serial prints to oled 
void fingerInitalize()
{
  Serial.begin(9600);
  finger.begin(57600);
  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
  }
  finger.getTemplateCount();
  Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  Serial.end()
}

// PIR wake function
// Low-power mode settings will need to be added
void waitToWake()
{
  while(true)
  {
    pirStat = digitalRead(pirPin);
    if (pirStat == HIGH)
    {
      break;
    }
  }
}

uint8_t readnumber(void) {
  uint8_t num = 0;
  
  while (num == 0) {
    while (! Serial.available());
    num = Serial.parseInt();
  }
  return num;
}

int enrollFinger()
{
  Serial.println("Ready to enroll a fingerprint!");
  Serial.println("Please type in the ID # (from 1 to 127) you want to save this finger as...");
  id = 4;
  if (id == 0) {// ID #0 not allowed, try again!
     return;
  }
  Serial.print("Enrolling ID #");
  Serial.println(id);
  getFingerprintEnroll();
}

int getFingerprintIDez() {
  uint8_t p = finger.getImage();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK)  return -1;
  
  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID); 
  Serial.print(" with confidence of "); Serial.println(finger.confidence);
  return finger.fingerID; 
}

uint8_t getFingerprintEnroll() {

  int p = -1;
  Serial.print("Waiting for valid finger to enroll as #"); Serial.println(id);
  delay(5);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }

  // OK success!

  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }
  
  Serial.println("Remove finger");
  delay(2000);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  Serial.print("ID "); Serial.println(id);
  p = -1;
  Serial.println("Place same finger again");
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.print(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }

  // OK success!

  p = finger.image2Tz(2);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }
  
  // OK converted!
  Serial.print("Creating model for #");  Serial.println(id);
  
  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    Serial.println("Prints matched!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
    Serial.println("Fingerprints did not match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }   
  
  Serial.print("ID "); Serial.println(id);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    Serial.println("Stored!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    Serial.println("Could not store in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    Serial.println("Error writing to flash");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }   
}
