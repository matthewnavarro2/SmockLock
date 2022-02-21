#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

const char ssid = "TP-Link_DECC";
const char* password = "9542584446";
const char* serverName = "http://smocklock2.herokuapp.com/api";

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastTime = 0;
// Timer set to 10 minutes (600000)
//unsigned long timerDelay = 600000;
// Set timer to 5 seconds (5000)
unsigned long timerDelay = 5000;

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
 
  Serial.println("Timer set to 5 seconds (timerDelay variable), it will take 5 seconds before publishing the first reading.");
}

void loop() {
  // put your main code here, to run repeatedly:

}

void sendToServer()
{
  //Send an HTTP POST request every 10 minutes
  if ((millis() - lastTime) > timerDelay) {
    //Check WiFi connection status
    if(WiFi.status()== WL_CONNECTED){
      WiFiClient client;
      HTTPClient http;

      // Your Domain name with URL path or IP address with path
      http.begin(client, serverName);

      // Specify content-type header
      //http.addHeader("Content-Type", "application/x-www-form-urlencoded");
      // Data to send with HTTP POST
      //String httpRequestData = "api_key=tPmAT5Ab3j7F9&sensor=BME280&value1=24.25&value2=49.54&value3=1005.14";
      // Send HTTP POST request
      //int httpResponseCode = http.POST(httpRequestData);

      // If you need an HTTP request with a content type: application/json, use the following:
      http.addHeader("Content-Type", "application/json");
      int httpResponseCode = http.POST("{"login":"m","password":"m"}");
      String payload = http.getString();

      Serial.println(payload);
      // If you need an HTTP request with a content type: text/plain
      //http.addHeader("Content-Type", "text/plain");
      //int httpResponseCode = http.POST("Hello, World!");

      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);

      // Free resources
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}  
}

// Function to print back to OLED screen if the server needs to communicate with user
void printToOLED()
{
  
}

// Function to request the security tier level of lock
int tierRequest()
{
  if(WiFi.status()== WL_CONNECTED){
      WiFiClient client;
      HTTPClient http;
 
      char fullPath = serverName;
      char apiPath = "/tierRequest";
      strcat(fullPath, apiPath);
    
      // Your Domain name with URL path or IP address with path
      http.begin(client, fullPath);
    
      // If you need an HTTP request with a content type: application/json, use the following:
      http.addHeader("Content-Type", "application/json");
      int httpResponseCode = http.POST("{"login":"m","password":"m"}");
      String payload = http.getString();
    
      //Serial.print("HTTP Response code: ");
      //Serial.println(httpResponseCode);
    
      // Free resources
      http.end();
  }
  else
  {
    Serial.println("WiFi Disconnected"); 
  }
  
}

// Function to compare fingerprint 
void compareFinger(fingerID)
{
  
}

// Function to enroll a fingerprint id into database
// Will need to figure out how to incorporate a name
void enrollFinger(fingerID)
{
  
}


// Function to compare RFID ID
void compareRFID()
{

}

// Function that unlocks the door
void unlock()
{
  
}

// Function that cleans up after a full use and sends atmega328 back to sleep
void finish()
{
  
}
