#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>
//#include <SoftwareSerial.h>
#include <ArduinoJson.h>

// Sets the local webserver port to 80
ESP8266WebServer server(80);

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
String localIp;

// Setup Function
void setup() {
 
    Serial.begin(19200);
    //Serial1.begin(19200);
    WiFiManager wifiManager;
    //wifiManager.resetSettings();
    wifiManager.autoConnect("AutoConnectAP");
    //Serial.print("Connected to WiFi. IP:");
    server.on("/body", handleBody); //Associate the handler function to the path
    //atm328.begin(19200);
    server.begin(); //Start the server
    //Serial.println("Server listening");
    pinMode(13, OUTPUT);
    attachInterrupt(digitalPinToInterrupt(atmIntPin),interrupt_routine,RISING);
    localIp = WiFi.localIP().toString().c_str();
    mac = WiFi.macAddress();
    //Serial.println(localIp);
    //Serial.println(mac);
    updateIp(mac, localIp);
}

// Main Loop Function
void loop() {
    
    // If the ESP8266 has been interrupted by atmega328
    if (atmState == HIGH)
    {
      //Serial.flush();
      //Serial.println("Interrupted");
      // Grab the incomming message 
      while(Serial.available()==0){}
      while(Serial.available())
      {
        char c = Serial.read();
        request.concat(c);
        if (c == '\n')
        {
          //request.trim();
        }
        Serial.flush();
      }
      
      if(!request.equals(""))
      {
        // Break the message up into its function and values
        char mes[150];
        request.toCharArray(mes, request.length());
        functi = strtok(mes,"-");
        val = strtok(NULL, "-");
        //Serial.println(functi);
        //Serial.println(val);
        // Checks if we are requesting the tier
        if (strcmp(functi, "sendFinger") == 0)
        {
          int fpResult = sendFinger(val);
          Serial.println(String(fpResult));
        }
  
        // If we are sending the RFID ID
        else if (strcmp(functi, "sendRFID") == 0)
        {
          int rfidResult = sendRFID(val);
          Serial.println(String(rfidResult));
        }
        
        // If an unrecognized command has been sent
        else
        {
          
        }
      }
      else
      {
        //atm328.println("Try Again");
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

  // Interrupts the atmega328p
  digitalWrite(13, HIGH);
  
  // Sends the message to the atmega328p
  Serial.println(message);
 
  // Resets the interrupt signal for the atmega328p
  digitalWrite(13, LOW);
  delay(500);
  while(!Serial.available()){}
  while(Serial.available())
  {
    char c = Serial.read();
    request.concat(c);
    if (c == '\n')
    {
      //request.trim();
      //digitalWrite(13, HIGH);
    }
    Serial.flush();
  }

  server.send(200, "text/plain", request);
  request = "";
}



// Function to compare the fingerID to database
int sendFinger(String id)
{
  // Set the api path
  const char *fingerPath = "http://smocklock2.herokuapp.com/api/compareFinger";

  // Creating the json document to be used in the POST request
  String json;
  DynamicJsonDocument doc(100);
  DynamicJsonDocument doc2(100);
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
    http.end();
    if (httpResponseCode == 200)
    {
      payload.toCharArray(mes, payload.length());
      deserializeJson(doc2, mes);
      int fpResult = doc2["userId"].as<int>();
      //Serial.println(String(fpResult));
      return fpResult;
    }
    else
    {
      //Serial.print("HTTP Response code: ");
      //Serial.println(httpResponseCode);
      return -1;
    }
    
    // Free resources
    //http.end();
  }
  
  // If we are not connected to WiFi
  else {
    //Serial.println("WiFi Disconnected");
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
  DynamicJsonDocument doc(100);
  DynamicJsonDocument doc2(100);
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


int updateIp(String mac, String Ip)
{
  // Set the api path
  const char *ipPath = "http://smocklock2.herokuapp.com/api/updateIP";

  // Creating the json document to be used in the POST request
  String json;
  DynamicJsonDocument doc(100);
  DynamicJsonDocument doc2(100);
  char mes[1024];
  
  // Inputting the parameters for the api
  doc["macAdd"] = mac;
  doc["ip"] = Ip;
  
  // Serializeing the document into a JSON string
  serializeJson(doc, json);
  
  // If WiFi is connected
  if(WiFi.status()== WL_CONNECTED){
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, ipPath);

    // If you need an HTTP request with a content type: application/json, use the following:
    http.addHeader("Content-Type", "application/json");
    int httpResponseCode = http.POST(json);
    String payload = http.getString();
    if (httpResponseCode == 200)
    {
      payload.toCharArray(mes, payload.length());
      deserializeJson(doc2, mes);
      String ipResult = doc2["error"].as<String>();
      //Serial.println(ipResult);
      return 1;
    }
    else
    {
      //Serial.print("HTTP Response code: ");
      //Serial.println(httpResponseCode);
      return -1;
    }
    
    // Free resources
    http.end();
  }
  
  // If we are not connected to WiFi
  else {
    //Serial.println("WiFi Disconnected");
    return -1;
  }
}
