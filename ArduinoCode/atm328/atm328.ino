#include <SoftwareSerial.h>
#include <Adafruit_Fingerprint.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <LowPower.h>
#include <MFRC522.h>

// OLED SETUP
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define OLED_RESET     4 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// FINGERPRINT SENSOR SETUP
// pin A0 is IN from fSensor (GREEN wire)
// pin A1 is OUT from fSensor (WHITE wire)
SoftwareSerial fingerSerial(A0, A1);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&fingerSerial);
uint8_t id;
int fingerID;

// ESP8266 SETUP
// pin 3 is esp TX
// pin 4 is esp RX 
SoftwareSerial esp8266(8,4);
const byte esp8266IntPin = 3;
int esp8266InterPin = 5;
volatile byte esp8266State = LOW;
String str;

// PIR SETUP
// pin 2 is input from PIR sensor
const byte pirPin = 2;
volatile byte pirState = LOW;

// ESP32-CAM SETUP
int esp32_inPin = A2;
int esp32_outPin = A3;

// RFID SETUP
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.

//LOCK Setup
int relayPin = 8;

// Setup Loop (Runs once on startup)
void setup() {
  
  // OLED Initialization
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) 
  {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }
  
  // Welcome Message
  printOLED("Welcome to SMOCK Lock");
  
  // Setting the pin modes
  pinMode(8, INPUT);
  pinMode(4,OUTPUT);
  pinMode(esp32_inPin, INPUT);
  pinMode(esp32_outPin, OUTPUT);
  pinMode(relayPin, OUTPUT);
  pinMode(esp8266InterPin, OUTPUT);

  // Fingerprint Scanner Initialization
  fingerInitalize();
}

// This will eventually be the main loop function
/*
void mainLoop()
{
  // put your main code here, to run repeatedly:
  
  // the interrupt must be attached each loop
  attachInterrupt(digitalPinToInterrupt(pirPin),interrupt_routine,RISING);
  attachInterrupt(digitalPinToInterrupt(esp8266IntPin),interrupt_routine,RISING);
  LowPower.powerDown(SLEEP_FOREVER,ADC_OFF,BOD_OFF); // sleep until interrupt
  if(digitalRead(pirPin) == HIGH)
  {
    detachInterrupt(digitalPinToInterrupt(pirPin)); // remove interrupt
  }
  else if(digitalRead(esp8266IntPin) == HIGH)
  {
    detachInterrupt(digitalPinToInterrupt(esp8266IntPin)); // remove interrupt
  }
  
  
  // When the PIR detects motion
  if (state==HIGH){
    
    // Shows that the system is awake
    printOLED("Im woke");

    // Find tier number through Tier Request

    // Make a switch case based on tier
    
    // Turn on ESP32-CAM and wait for a response
    esp32Wake();
    
    // Get the fingerprint from user 
    fingerID = getFingerprintIDez();

    // Send the fingerprint to ESP8266 and wait for response
    sendFinger();
    
    // Request RFID

    // Send RFID ID to ESP8266 and wait for response

    delay(500);
  }
  
  // Goes to sleep after finishing
  if (state==HIGH){
    state = LOW;
    printOLED("Im slump");
  }
}
*/
// Loop Function (What will be happening over and over)
void loop() { 
  
  // the interrupt must be attached each loop
  attachInterrupt(digitalPinToInterrupt(pirPin),interrupt_routine1,RISING);
  attachInterrupt(digitalPinToInterrupt(esp8266IntPin),interrupt_routine2,RISING);
  LowPower.powerDown(SLEEP_FOREVER,ADC_OFF,BOD_OFF); // sleep until interrupt
  detachInterrupt(digitalPinToInterrupt(pirPin)); // remove interrupt
  detachInterrupt(digitalPinToInterrupt(esp8266IntPin)); // remove interrupt
  
  // When the PIR detects motion
  if (pirState==HIGH){
    
    // Shows that the system is awake
    printOLED("Im woke");

    // Find tier number through Tier Request

    // Turn on ESP32-CAM and wait for a response

    // Get the fingerprint from user 
    fingerID = getFingerprintIDez();

    // Send the fingerprint to ESP8266 and wait for response
    //sendFinger(fingerID)
    
    // Request RFID
    int ans = 0; 
    ans = RFIDread();
    
    // Send RFID ID to ESP8266 and wait for response
    if (ans == 1){
      digitalWrite(esp8266InterPin, HIGH);
      digitalWrite(esp8266InterPin, LOW);
      //digitalWrite(relayPin, HIGH);
      //digitalWrite(relayPin, LOW);
      
    }
  }

  else if(esp8266State == HIGH)
  {
   printOLED("ESP Interrupt");
   esp8266.begin(9600);
   functi = esp8266.read();
    val = esp8266.read();
   esp8266.end();
   printOLED(functi);
   printOLED(val);   
  }
  
  // Goes to sleep after finishing
  if (pirState==HIGH){
    pirState = LOW;
    printOLED("Im slump");
  }
  // Goes to sleep after finishing
  else if(esp8266State == HIGH){
    esp8266State == LOW;
    printOLED("Im slump");
  }
}

// RFID Reader Function
int RFIDread()
{
  // Initialization
  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522

  // Instruction to the user
  printOLED("Put key up to reader\n");

  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent()) 
  {
    printOLED("No card found");
    return 0;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) 
  {
    return 0;
  }

  // Getting the UID from the card at reader
  String content= "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) 
  {
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  content.toUpperCase();
  
  // Compares the UID at the reader to stored cards
  if (content.substring(1) == "82 15 C9 1B" || content.substring(1) == "E0 84 2E 1B" || content.substring(1) == "33 66 5D 9B" || content.substring(1) == "93 1B E5 1B") //change here the UID of the card/cards that you want to give access
  {
    printOLED("Authorized access");
    return 1;
    delay(3000);
  }
 
  else {
    printOLED(" Access denied");
    return 0;
    delay(3000);
  }
}

// Function to send fingerprint to ESP8266
// This will definitely need to be expanded on
void sendFinger()
{
  esp8266.begin(9600);
  esp8266.print(fingerID);
  esp8266.end();
  printOLED("Fingerprint Sent");
}

void interrupt_routine1(){
  pirState = HIGH;
}
void interrupt_routine2(){
  esp8266State = HIGH;
}

// Function to print to the OLED screen
void printOLED(String statement)
{
  display.clearDisplay();

  display.setTextSize(2);      // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE); // Draw white text
  display.setCursor(0, 0);     // Start at top-left corner
  display.cp437(true);         // Use full 256 char 'Code Page 437' font

  // Not all the characters will fit on the display. This is normal.
  // Library will draw what it can and the rest will be clipped.
  display.write(statement.c_str());
  display.display();
  delay(2000);
}

// Function to activate ESP32-CAM
void esp32Wake()
{
  digitalWrite(esp32_outPin, HIGH);
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
  Serial.end();
}

// PIR wake function
// Low-power mode settings will need to be added
void waitToWake()
{
  while(true)
  {
    if (digitalRead(pirPin) == HIGH)
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
  printOLED("Enrolling ID #");
  printOLED(String(id));
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
  printOLED("Found ID #"); 
  printOLED(String(finger.fingerID)); 
  printOLED(" with confidence of "); 
  printOLED(String(finger.confidence));
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
