// Included Libraries
#include <NeoSWSerial.h>
#include <Adafruit_Fingerprint.h>
#include <MFRC522.h>
#include <SPI.h>
#include <Wire.h>
#include <LowPower.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Fingeprint Variables
// pin TX is IN from fSensor (GREEN wire)
// pin RX is OUT from fSensor (WHITE wire)
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&Serial);
int fingerID;
String fMessage = "";

// RFID
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.
String RFIDid;
int rfiD;
String RFIDresult;
String rfMessage="";

// Lock Variables
int relayPin = 7;

// ESP32-CAM Variables
NeoSWSerial esp32(A0,A1);
String message="";
int camRet;

// ESP8266 Variables
NeoSWSerial esp8266(8,4);
String str = "";
const byte esp8266IntPin = 3;
int esp8266InterPin = 5;
char* functi;
char* val;
volatile byte esp8266State = LOW;

// PIR Variables
// pin 2 is input from PIR sensor
const byte pirPin = 2;
volatile byte pirState = LOW;

// OLED Variables
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define OLED_RESET     6 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

//Security Array
int secure[3] = {-1, -1, -1};

int counter=0;
void setup() {
  // put your setup code here, to run once:
  finger.begin(9600);
  // OLED Initialization
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
  {
    //Serial.println(F("SSD1306 allocation failed"));
    for (;;); // Don't proceed, loop forever
  }
  pinMode(relayPin, OUTPUT);
  pinMode(esp8266InterPin, OUTPUT);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  esp8266State = LOW;
  attachInterrupt(digitalPinToInterrupt(pirPin), interrupt_routine1, RISING);
  attachInterrupt(digitalPinToInterrupt(esp8266IntPin), interrupt_routine2, RISING);
  LowPower.powerDown(SLEEP_FOREVER, ADC_OFF, BOD_ON); // sleep until interrupt
  detachInterrupt(digitalPinToInterrupt(pirPin)); // remove interrupt
  detachInterrupt(digitalPinToInterrupt(esp8266IntPin)); // remove interrupt
  
  if (pirState == HIGH)
  {
    // Welcome the user
    printOLED("Hello");
    
    /*// Call the ESP32-CAM
    camRet = callESP32();
    if (camRet == -2)
    {
      printOLED("Try Again");
      return;
    }  
    else if(camRet == -1)
    {
       printOLED("Access Denied");
       message="";
       pirState = LOW;
       return;
    }
    else
    {
      //printOLED("ID Found");
      secure[0] = camRet;
      message="";
    }
    printOLED("Put Face Up to Camera");
    delay(1000);*/
    printOLED("Place Fingerprint");
    // Ask for fingerprint and get userID from DB
    fingerID = getFPIDez();

    if(fingerID == -1)
    {
      printOLED("Access Denied");
      pirState = LOW;
      return;
    }
    
    //secure[1] = sendFinger(fingerID);
    message="";
    // Store userID in security check array

    // Ask for RFID and get userID from DB
    RFIDid = RFIDread();
    //secure[2] = sendRFID(RFIDid);
    message="";
    delay(1000);
    // Store userID in security check array
    if ((secure[0] == secure[1]) && (secure[0] != -1) && (secure[1]!=-1))
    {
      printOLED("Access Granted");
      unlockDoor();
      secure[0] = -1;
      secure[1] = -1; 
    }
    else
    {
      printOLED("Access Denied");
      delay(1000);
      printOLED("");
    }
    // Check if all the elements in the security array match
      
      // If all elements match, unlock lock
      //unlockDoor();


    pirState = LOW;
  }
  /*
  if (esp8266State == HIGH)
  {
    esp8266.begin(19200);
    printOLED("ESP8266 Interrupt");
    delay(500);
    while (esp8266.available())
    {
      char c =  esp8266.read();
      message.concat(c);
      if(c == '\n')
      {
        message.trim();
        printOLED(message);
      }
    }
    // Break the message up into its function and values
    //esp8266.end();
    char request[30];
    char idRF[16];
    message.toCharArray(request, message.length());
    functi = strtok(request, "-");
    val = strtok(NULL, "-");
    //Serial.println(functi);
    //Serial.println(strlen(functi));
    if (strcmp(functi, "enrollFinger") == 0)
    {
      enrollFinger((uint8_t)atoi(val));
      if((uint8_t)getFPIDez() == (uint8_t)atoi(val))
      {
        //esp8266.begin(19200);
        esp8266.println("Success");
        esp8266.end();
        printOLED("Sent");
      }
      else
      {
        esp8266.println("Failed");
        esp8266.end();
        printOLED("Sent"); 
      }
    }
    else if (strcmp(functi, "enrollRFID") == 0)
    {
      String newID = RFIDread();
      esp8266.println(newID);
      esp8266.end();
      printOLED("Sent");
    }
    else if (strcmp(functi, "unlockDoor") == 0)
    {
      
      unlockDoor();
      esp8266.println("success");
      esp8266.end();
    }

    message = "";
    esp8266State = LOW;
    //pirState = LOW;
    printOLED("Goodbye");
  }*/
}

int callESP32()
{
  esp32.begin(19200);
  delay(100);
  esp32.println("TakePic");
  while(!esp32.available()){}
  delay(100);
  while (esp32.available())
  {
    char c = (char)esp32.read();
    message.concat(c);
    if(c == '\n')
    {
      message.trim();
    }
    esp32.flush();
  }
  esp32.end();
  if (message.equals("CCF"))
  {
    //printOLED("Camera Failed");
    //printOLED("Try Again");
    message = "";
    return -2;
  }
  else if (message.equals("HPF"))
  {
    printOLED("Connection Error");
    message = "";
    return -1;
  }
  else if (message.equals("FND"))
  {
    printOLED("Move In");
    printOLED("To Camera");
    message = "";
    return -2;
  }
  else if (message.equals("HPF1"))
  {
    printOLED("Connection Error");
    return -1;
  }
  else
  {
    return message.toInt();
  }
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
  delay(600);
  display.clearDisplay();
}

void printOLEDD(String statement, int del)
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
  delay(del*1000);
  display.clearDisplay();
}

void unlockDoor()
{
  digitalWrite(relayPin, HIGH);
  delay(10000);
  digitalWrite(relayPin, LOW); 
}

int sendFinger(int fID)
{
  esp8266.begin(19200);
  digitalWrite(esp8266InterPin, HIGH);
  digitalWrite(esp8266InterPin, LOW);

  fMessage = "sendFinger-";
  fMessage.concat(String(fID));
  fMessage.concat("-");
  //esp8266.begin(19200);
  //esp8266.flush();
  //printOLED(fMessage);
  //esp8266.begin(19200);
  esp8266.println(fMessage);
  while(esp8266.available()==0){}
  while (esp8266.available())
  {
     char c =  esp8266.read();
     message.concat(c);
     if(c == '\n')
     {
       //message.trim();
       //printOLED(message);
     }
   }
   message.trim();
   esp8266.end();
   return message.toInt();
}

// Retrieves Fingerprint
// returns -1 if failed, otherwise returns ID #
int getFPIDez() {
  int count = 0;
  uint8_t p = finger.getImage();
 
  while (p != FINGERPRINT_OK){
     if (count == 30)
     {
        printOLED("Access Denied");
        return -1;
     }
     p = finger.getImage();
     count++;
  }

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK)  return -1;
  
  // found a match!
  printOLED("Found ID");
  return finger.fingerID; 
}

uint8_t enrollFinger(uint8_t id)
{
  //Serial.println("Ready to enroll a fingerprint!");
  //Serial.println("Please type in the ID # (from 1 to 127) you want to save this finger as...");
  //id = 4;
  //if (id == 0) {// ID #0 not allowed, try again!
  //  return;
  //}
  printOLED("Enrolling ID #");
  printOLED(String(id));
  getFingerprintEnroll(id);
}

uint8_t getFingerprintEnroll(uint8_t Fid) {

  int p = -1;
  printOLED("Waiting for valid finger to enroll as #"); printOLED(String(Fid));
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
  }

  // OK success!

  p = finger.image2Tz(1);
  if (p != FINGERPRINT_OK)  return -1;
  
  printOLED("Remove finger");
  delay(200);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  printOLED("ID "); printOLED(String(Fid));
  p = -1;
  printOLED("Place same finger again");
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
  }

  // OK success!

  p = finger.image2Tz(2);
  if (p == FINGERPRINT_OK) {
    printOLED("Image Converted");
  }
  // OK converted!
  printOLED("Creating model for #"); printOLED(String(Fid));
  
  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    printOLED("Prints matched!");
  }
  
  printOLED("ID "); printOLED(String(Fid));
  p = finger.storeModel(Fid);
  if (p == FINGERPRINT_OK) {
    printOLED("Stored!");
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
  delay(500);
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
  //SPI.end();
  //mfrc522.PCD_SoftPowerDown();
  printOLED("Card Found");
  return content.substring(1);
}

// Function to send fingerprint to ESP8266
// This will definitely need to be expanded on
int sendRFID(String RFIDId)
{
  esp8266.begin(19200);
  digitalWrite(esp8266InterPin, HIGH);
  digitalWrite(esp8266InterPin, LOW);

  rfMessage = "sendRFID-";
  rfMessage.concat(RFIDId);
  rfMessage.concat("-");
  //esp8266.begin(19200);
  //esp8266.flush();
  //printOLED(fMessage);
  //esp8266.begin(19200);
  esp8266.println(rfMessage);
  while(esp8266.available()==0){}
  while (esp8266.available())
  {
     char c =  esp8266.read();
     message.concat(c);
     if(c == '\n')
     {
       //message.trim();
       //printOLED(message);
     }
   }
   message.trim();
   esp8266.end();
   return message.toInt();
}



void interrupt_routine1() {
  pirState = HIGH;
}

void interrupt_routine2() {
  esp8266State = HIGH;
}
