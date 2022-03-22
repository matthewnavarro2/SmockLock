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
void setup() 
{
    Serial.begin(19200);
    esp32.begin(9600);

    // OLED Initialization
    if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS))
    {
        Serial.println(F("SSD1306 allocation failed"));
        for (;;); // Don't proceed, loop forever
    }

    printOLED("Welcome to SMOCK Lock");


}

void loop()
{
    esp32.write("P");

    while (esp32.available())
    {
        char character = mySerial.read(); // Receive a single character from the software serial port
        Data.concat(character); // Add the received character to the receive buffer
        if (character == '\n')
        {
            printOLED(Data);

            Data = "";
        }

        delay(2000);
    }
}

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