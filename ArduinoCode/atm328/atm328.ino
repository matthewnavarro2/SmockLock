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
SoftwareSerial mySerial(A0, A1);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);
//uint8_t id;
int fingerID;
String fingerResult;
volatile int finger_status = -1;

int tierRequest();
int sendFinger(String fingerID);
int sendRFID(String RFIDid);

// ESP8266 SETUP
// pin 3 is esp TX
// pin 4 is esp RX
SoftwareSerial esp8266(8, 4);
const byte esp8266IntPin = 3;
int esp8266InterPin = 5;
volatile byte esp8266State = LOW;
String str = "";

// PIR SETUP
// pin 2 is input from PIR sensor
const byte pirPin = 2;
volatile byte pirState = LOW;

// ESP32-CAM SETUP
SoftwareSerial esp32(A2, A3);


// RFID SETUP
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.
String RFIDid;
int rfiD;
String RFIDresult;
String rfMessage;

//LOCK Setup
//int relayPin = 8;

// Tier Variable
///int tier;
String tierR = "";

// Setup Loop (Runs once on startup)
void setup() {
  Serial.begin(19200);
  // OLED Initialization
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
  {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;); // Don't proceed, loop forever
  }

  // Welcome Message
  printOLED("Welcome to SMOCK Lock");

  // Setting the pin modes
  //pinMode(relayPin, OUTPUT);
  pinMode(esp8266InterPin, OUTPUT);
  /*
    // Fingerprint Scanner Initialization
    Serial.println("\n\nAdafruit finger detect test");

    // set the data rate for the sensor serial port
    /finger.begin(57600);

    if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
    } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
    }

    finger.getTemplateCount();
    Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
    Serial.println("Waiting for valid finger...");
  */
  // Begin ESP8266 SoftwareSerial
  //esp8266.begin(9600);
  //esp8266.print("");

  //getFingerprintIDez();
  //delay(1000);

}


// Loop Function (What will be happening over and over)
void loop()
{
  int tier;
  // Attaching the interrupts
  attachInterrupt(digitalPinToInterrupt(pirPin), interrupt_routine1, RISING);
  attachInterrupt(digitalPinToInterrupt(esp8266IntPin), interrupt_routine2, RISING);

  // Sleep until interrupted
  LowPower.powerDown(SLEEP_FOREVER, ADC_OFF, BOD_OFF); // sleep until interrupt

  // Detaching the interrupts
  detachInterrupt(digitalPinToInterrupt(pirPin)); // remove interrupt
  detachInterrupt(digitalPinToInterrupt(esp8266IntPin)); // remove interrupt

  // When the PIR detects motion
  if (pirState == HIGH) {

    //int userCheck[];
    // Shows that the system is awake
    printOLED("Hello");

    // Find tier number through Tier Request
    //printOLED("Getting the tier");
    //tier = tierRequest();
    //printOLED("The tier is");
    //printOLED(String(tier));
    /*
      switch(tier)
      {
      // None
      case 0:

        break;

      // EKEY
      case 1:
        // User Security Check Array
        int userCheck[1];

        break;

      // RFID
      case 2:
        // User Security Check Array
        int userCheck[1];

        // Request RFID
        // Send RFID ID to ESP8266
        break;

      // RFID and EKEY
      case 3:
        // User Security Check Array
        int userCheck[2];

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FP
      case 4:
        // User Security Check Array
        int userCheck[1];

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);
        break;

      // FP EKEY
      case 5:
        // User Security Check Array
        int userCheck[2];

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FP RFID
      case 6:
        // User Security Check Array
        int userCheck[2];

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FP RFID EKEY
      case 7:
        // User Security Check Array
        int userCheck[3];

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(3, userCheck);
        break;

      // FACE
      case 8:
        // User Security Check Array
        int userCheck[1];

        // Turn on ESP32-CAM and wait for a response

        // Determine what to do with the 1 setting
        break;

      // FACE EKEY
      case 9:
        // User Security Check Array
        int userCheck[2];

        // Turn on ESP32-CAM and wait for a response

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FACE RFID
      case 10:
        // User Security Check Array
        int userCheck[2];

        // Turn on ESP32-CAM and wait for a response

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FACE RFID EKEY
      case 11:
        // User Security Check Array
        int userCheck[3];

        // Turn on ESP32-CAM and wait for a response

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(3, userCheck);
        break;

      // FACE FP
      case 12:
        // User Security Check Array
        int userCheck[2];

        // Turn on ESP32-CAM and wait for a response

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Compare the returns
        //result = areSame(2, userCheck);
        break;

      // FACE FP EKEY
      case 13:
        // User Security Check Array
        int userCheck[3];

        // Turn on ESP32-CAM and wait for a response

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Compare the returns
        //result = areSame(3, userCheck);
        break;

      // FACE FP RFID
      case 14:
        // User Security Check Array
        int userCheck[3];

        // Turn on ESP32-CAM and wait for a response

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //sendFinger(fingerID);

        // Request RFID
        // Send RFID ID to ESP8266

        // Compare the returns
        //result = areSame(3, userCheck);
        break;

      // FACE FP RFID EKEY
      case 15:
        // User Security Check Array
        int userCheck[4], result;

        // Turn on ESP32-CAM and wait for a response

        // Get the fingerprint from user
        //fingerID = getFingerID();

        // Send the fingerprint to ESP8266 and wait for response
        //int fingerReturn = sendFinger(fingerID);


        // Request RFID
        // Send RFID ID to ESP8266
        //int rfidReturn = ...

        // Compare the returns
        //result = areSame(4, userCheck);
        break;

      }
    */
    // Turn on ESP32-CAM and wait for a response

    // Get the fingerprint ID from user
    fingerID = fpg();
    printOLED(String(fingerID));

    // Send the fingerprint to ESP8266 and wait for response
    int fpResult = sendFinger("1");
    printOLED(String(fpResult));

    // Request RFID
    //RFIDid = RFIDread();
    //printOLED(RFIDid);
    // Send RFID ID to ESP8266
    //rfiD=sendRFID(RFIDid);

    pirState = LOW;
    printOLED("ZZZ");
    //delay(200);
    display.clearDisplay();
  }

  if (esp8266State == HIGH)
  {
    printOLED("ESP Interrupt");
    //while(esp8266.available()==0)
    //{}
    while (esp8266.available() > 0)
    {
      char c = esp8266.read();
      str.concat(c);
      if (c == '\n')
      {
        printOLED("Recieved");
      }
    }
    // Break the message up into its function and values
    char *request;
    str.toCharArray(request, str.length());
    char *functi = strtok(request, " ");
    char *val = strtok(NULL, "");

    if (strcmp(functi, "enrollFingerID") == 1)
    {

    }
    else if (strcmp(functi, "enrollRFID") == 1)
    {

    }
    else
    {


    }


    printOLED(str);


    str = "";
    esp8266State = LOW;
    printOLED("Im slump");
  }
}

// Checks if all the elements in an array are the same
int areSame(int n, int arr[])
{
  int first = arr[0];
  for (int i = 1; i < n; i++)
  {
    if (arr[i] != first)
    {
      return 0;
    }
  }
  return 1;
}
// Tier Request Function
int tierRequest()
{
  int tierRet;
  esp8266.begin(9600);
  // Tell it to get the tier
  esp8266.println("Tier-");

  // Interrupt the ESP8266
  digitalWrite(esp8266InterPin, HIGH);
  digitalWrite(esp8266InterPin, LOW);

  // Provide a delay
  // Wait for a response from ESP8266
  while (esp8266.available() == 0)
  {}
  while (esp8266.available())
  {
    char t = esp8266.read();
    tierR.concat(t);
    if (t == '\n')
    {
      tierR.trim();
    }
  }
  tierRet = tierR.toInt();
  tierR = "";
  esp8266.end();
  return tierRet;
}

void callESP32()
{
  camSerial.write("P");

  while (camSerial.available())
  {
    char character = mySerial.read();
    Data.concat(character);

    if (character == '\n')
    {
      Serial.print("Received: ");
      Serial.println(Data);

      if(strcmp(Data, "[HTTP Pass]"))
      {
        printOLED("Face Detected");
      }
      else if(strcmp(Data, "[HTTP Fail]"))
      {
        printOLED("Failed to process request");
      }
      else if(strcmp(Data, "[WiFi Fail]"))
      {
        printOLED("Failed to connect the internet");
      }
      else if(strcmp(Data, "[Camera Fail]"))
      {
        delay(5000);

        printOLED("Please reposition face and try again");

        camSerial.print("P");

        if(strcmp(Data, "[HTTP Pass]"))
        {
          printOLED("Face Detected");
        }
        else if(strcmp(Data, "[HTTP Fail]"))
        {
          printOLED("Failed to process request");
        }
        else if(strcmp(Data, "[Camera Fail]"))
        {
          printOLED("Failed to detect face fatal error");
        }
        else if(strcmp(Data, "[WiFi Fail]"))
        {
          printOLED("Failed to connect the internet");
        }
        else
        {
          printOLED("Fatal Error");
        }

      }
      else
      {
        printOLED("Fatal Error");
      }

      Data = "";
    }
  }
}

// RFID Reader Function
String RFIDread()
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
    return String(0);
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial())
  {
    return String(0);
  }

  // Getting the UID from the card at reader
  String content = "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++)
  {
    content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
    content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  content.toUpperCase();
  SPI.end();
  return content.substring(1);
  /*
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
  */
}

// Function to send fingerprint to ESP8266
// This will definitely need to be expanded on
int sendFinger(String FingerId)
{
  char ret[1024];
  esp8266.begin(9600);
  // Tell it to get the tier
  esp8266.println("sendFinger-1-");

  // Interrupt the ESP8266
  digitalWrite(esp8266InterPin, HIGH);
  digitalWrite(esp8266InterPin, LOW);

  // Provide a delay
  // Wait for a response from ESP8266
  while (esp8266.available() == 0)
  {}
  while (esp8266.available())
  {
    char t = esp8266.read();
    fingerResult.concat(t);
    if (t == '\n')
    {
      printOLED(fingerResult);
    }
  }
  fingerResult.toCharArray(ret, fingerResult.length());
  fingerResult.trim();
  int ans = fingerResult.toInt();
  esp8266.end();
  return ans;
  /*
    //String fpMessage;
    //esp8266.begin(9600);
    //fpMessage = "sendFinger-";
    //fpMessage += fingerID;
    //fpMessage += "-";
    char ret[1024];

    // Tell it to get compare fp
    //esp8266.print("sendFinger-");
    //esp8266.print(fingerID);
    //esp8266.println("-");
    esp8266.println("sendFinger-1-");
    digitalWrite(esp8266InterPin, HIGH);
    digitalWrite(esp8266InterPin, LOW);
    printOLED("Fingerprint Sent");

    // Provide a delay

    // Wait for a response from ESP8266
    while(esp8266.available()>0)
    {
    char t = esp8266.read();
    fingerResult.concat(t);
    if (t == '\n')
    {
      printOLED(fingerResult);
    }
    }
    fingerResult.toCharArray(ret,fingerResult.length());
    esp8266.end();
    return atoi(ret);
  */
}

// Function to send fingerprint to ESP8266
// This will definitely need to be expanded on
int sendRFID(String RFIDId)
{
  char ret[1024];
  rfMessage = "sendRFID-";
  //rfMessage = rfMessage + RFIDId;
  //rfMessage = rfMessage + "-";

  Serial.println(rfMessage);

  esp8266.begin(9600);
  // Tell it to get the tier
  esp8266.println(rfMessage);

  // Interrupt the ESP8266
  digitalWrite(esp8266InterPin, HIGH);
  digitalWrite(esp8266InterPin, LOW);

  // Provide a delay
  // Wait for a response from ESP8266
  while (esp8266.available() == 0)
  {}
  while (esp8266.available())
  {
    char t = esp8266.read();
    RFIDresult.concat(t);
    if (t == '\n')
    {
      printOLED(RFIDresult);
    }
  }
  RFIDresult.toCharArray(ret, RFIDresult.length());
  RFIDresult.trim();
  int ans = RFIDresult.toInt();
  esp8266.end();
  return ans;
}

void interrupt_routine1() {
  pirState = HIGH;
}
void interrupt_routine2() {
  esp8266State = HIGH;
  //pirState = LOW;
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
}


// Function for fingerprint sensor startup
// want to change serial prints to oled
void fingerInitalize()
{
  finger.begin(57600);
  if (finger.verifyPassword()) {
    printOLED("Found fingerprint sensor!");
  } else {
    printOLED("Did not find fingerprint sensor :(");
    while (1) {
      delay(1);
    }
  }
  finger.getTemplateCount();
  printOLED("Sensor contains "); printOLED(String(finger.templateCount)); printOLED(" templates");
}

// PIR wake function
// Low-power mode settings will need to be added
void waitToWake()
{
  while (true)
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

int enrollFinger(int id)
{
  Serial.println("Ready to enroll a fingerprint!");
  Serial.println("Please type in the ID # (from 1 to 127) you want to save this finger as...");
  id = 4;
  if (id == 0) {// ID #0 not allowed, try again!
    return;
  }
  printOLED("Enrolling ID #");
  printOLED(String(id));
  //getFingerprintEnroll();
}

int fpg()
{
  finger.begin(57600);
  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) {
      delay(1);
    }
  }

  finger.getTemplateCount();
  Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  printOLED("Waiting for valid finger...");
  int fpi = getFPIDez();
  mySerial.end();
  return fpi;
}

// returns -1 if failed, otherwise returns ID #
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

int getFPIDez()
{
  int counter = 0;
  int counter1 = 0;
  while (1)
  {
    if (counter > 3 )
    {
      return -1;
    }
    else
    {
      uint8_t p = finger.getImage();
      printOLED("Place Finger");
      if (p != FINGERPRINT_OK)
      {
        if (counter1 > 3)
        {
          return -1;
        }
        else
        {
          printOLED("Try Again");
          counter1++;
        }
      }
      else
      {
        p = finger.image2Tz();
        if (p != FINGERPRINT_OK)  return -1;

        p = finger.fingerFastSearch();
        if (p != FINGERPRINT_OK)  return -1;

        if (finger.confidence < 100)
        {
          printOLED("Try Again");
          counter++;
        }
        else
        {
          // found a match!
          Serial.print("Found ID #"); Serial.print(finger.fingerID);
          Serial.print(" with confidence of "); Serial.println(finger.confidence);
          return finger.fingerID;
        }
      }
    }
  }
}


uint8_t getFingerprintEnroll(int id) {

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
