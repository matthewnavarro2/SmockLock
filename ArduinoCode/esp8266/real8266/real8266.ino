#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>
#include <SoftwareSerial.h>
#include <ArduinoJson.h>

// Sets the local webserver port to 80
ESP8266WebServer server(80);

// Serial connection to the atmega328p
SoftwareSerial atm328(12,15);

// Interrupt pin for atmega328p
const byte atmIntPin = 14;

// Interrupt state for atmega328p
volatile byte atmState = LOW;

// Interrupt function initialization
void ICACHE_RAM_ATTR interrupt_routine();

String request = "";

String mac;
char* functi;
char* val;

// Setup Function
void setup() {
 
    Serial.begin(115200);
    WiFiManager wifiManager;
    //wifiManager.resetSettings();
    wifiManager.autoConnect("AutoConnectAP");
    Serial.print("Connected to WiFi. IP:");
    server.on("/body", handleBody); //Associate the handler function to the path
 
    server.begin(); //Start the server
    Serial.println("Server listening");
    pinMode(13, OUTPUT);
    attachInterrupt(digitalPinToInterrupt(atmIntPin),interrupt_routine,RISING);
    atm328.begin(9600);
    atm328.print("");
    mac = WiFi.macAddress();
    // need to add the api to send the macAddress to database
}

// Main Loop Function
void loop() {
    
    // If the ESP8266 has been interrupted by atmega328
    if (atmState == HIGH)
    {
      Serial.println("Interrupted");
      
      // Grab the incomming message 
      while(atm328.available())
      {
        char c = atm328.read();
        request.concat(c);
        if (c == '\n')
        {
          Serial.print(request);
          request.trim();
          Serial.println(request.length());
        }
      }
      
      if(!request.equals(""))
      {
        // Break the message up into its function and values
        char mes[1024];
        request.toCharArray(mes, request.length());
        functi = strtok(mes,"-");
        val = strtok(NULL, "-");
        Serial.println(functi);
        Serial.println(val);
        // Checks if we are requesting the tier
        if (strcmp(functi, "Tier") == 0)
        {
          int tierL = getTier();
          atm328.println(String(tierL));
        }
  
        // If we are sending the fingerprint ID
        else if (strcmp(functi, "sendFinger") == 0)
        {
          int fpResult = sendFinger(val);
          atm328.println(String(fpResult));
        }
  
        // If we are sending the RFID ID
        else if (strcmp(functi, "sendRFID") == 0)
        {
          int rfidResult = sendRFID(val);
          atm328.println(String(rfidResult));
        }
        
        // If an unrecognized command has been sent
        else
        {
          
        }
      }
      else
      {
        atm328.println("Try Again");
      }
      

      // Reset the request string
      request = "";

      // Reset the interrupt state 
      atmState = LOW;
    }

    // Check for incoming requests from the app
    else
    {
      server.handleClient(); //Handling of incoming requests 
    }
    
}

// What happens when the atmega328 interrupts the ESP8266
void interrupt_routine()
{
   atmState = HIGH;
}

// Handles the HTTP requests from the app
void handleBody()
{
  // Checks if request contained a message
  if (server.hasArg("plain")== false){ //Check if body received
        server.send(200, "text/plain", "Body not received");
        return;
  }

  // Grabs the message from the request
  String message = server.arg("plain");
  
  // Sends the response message back
  server.send(200, "text/plain", "We done got them message");

  // Interrupts the atmega328p
  digitalWrite(13, HIGH);

  // Sends the message to the atmega328p
  atm328.println(message);

  // Resets the interrupt signal for the atmega328p
  digitalWrite(13, LOW);
  
}

// Function to retrieve the tier level from the database
int getTier()
{
  Serial.println(mac);
  int tierLevel;
  // Set the api path
  const char *tierPath = "http://smocklock2.herokuapp.com/api/tierRequest";

  // Creating the json document to be used in the POST request
  String json;
  DynamicJsonDocument doc(1024);
  DynamicJsonDocument doc2(1024);
  char mes[1024];
  // Inputting the parameters for the document
  doc["macAdd"] = mac;

  // Serializeing the document into a JSON string
  serializeJson(doc, json);
  
  // If WiFi is connected
  if(WiFi.status()== WL_CONNECTED){
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, tierPath);

    // If you need an HTTP request with a content type: application/json, use the following:
    http.addHeader("Content-Type", "application/json");
    int httpResponseCode = http.POST(json);
    String payload = http.getString();
    if (httpResponseCode == 200)
    {
      payload.toCharArray(mes,payload.length());
      deserializeJson(doc2,mes);
      tierLevel = doc2["tier"].as<int>();
    }
    else
    {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
    }
    
    // Free resources
    http.end();
  }
  
  // If we are not connected to WiFi
  else {
    Serial.println("WiFi Disconnected");
  }
  return tierLevel;
}

// Function to compare the fingerID to database
int sendFinger(String id)
{
  // Set the api path
  const char *fingerPath = "http://smocklock2.herokuapp.com/api/compareFinger";

  // Creating the json document to be used in the POST request
  String json;
  DynamicJsonDocument doc(1024);
  DynamicJsonDocument doc2(1024);
  char mes[1024];
  
  // Inputting the parameters for the api
  doc["macAdd"] = mac;
  doc["fp"] = id;
  
  // Serializeing the document into a JSON string
  serializeJson(doc, json);
  
  // If WiFi is connected
  if(WiFi.status()== WL_CONNECTED){
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, fingerPath);

    // If you need an HTTP request with a content type: application/json, use the following:
    http.addHeader("Content-Type", "application/json");
    int httpResponseCode = http.POST(json);
    String payload = http.getString();
    if (httpResponseCode == 200)
    {
      payload.toCharArray(mes, payload.length());
      deserializeJson(doc2, mes);
      int fpResult = doc2["userId"].as<int>();
      Serial.println(String(fpResult));
      return fpResult;
    }
    else
    {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      return -1;
    }
    
    // Free resources
    http.end();
  }
  
  // If we are not connected to WiFi
  else {
    Serial.println("WiFi Disconnected");
    return -1;
  }
}

// Function to compare the RFID ID to database
int sendRFID(String id)
{
  // Set the api path
  const char *rfidPath = "http://smocklock2.herokuapp.com/api/compareRFID";

  // Creating the json document to be used in the POST request
  String json;
  DynamicJsonDocument doc(1024);
  DynamicJsonDocument doc2(1024);
  char mes[1024];
  
  // Inputting the parameters for the api
  doc["macAdd"] = mac;
  doc["rfid"] = id;
  
  // Serializeing the document into a JSON string
  serializeJson(doc, json);
  
  // If WiFi is connected
  if(WiFi.status()== WL_CONNECTED){
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, rfidPath);

    // If you need an HTTP request with a content type: application/json, use the following:
    http.addHeader("Content-Type", "application/json");
    int httpResponseCode = http.POST(json);
    String payload = http.getString();
    if (httpResponseCode == 200)
    {
      payload.toCharArray(mes, payload.length());
      deserializeJson(doc2, mes);
      int RFIDresult = doc2["userId"].as<int>();
      return RFIDresult;
    }
    else
    {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      return -1;
    }
    
    // Free resources
    http.end();
  }
  
  // If we are not connected to WiFi
  else {
    Serial.println("WiFi Disconnected");
    return -1;
  }
}
