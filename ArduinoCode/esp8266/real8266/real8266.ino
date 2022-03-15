#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>
#include <SoftwareSerial.h>
#include <ArduinoJson.h>
ESP8266WebServer server(80);

SoftwareSerial atm328(12,15);
const byte atmIntPin = 14;
volatile byte atmState = LOW;
void ICACHE_RAM_ATTR interrupt_routine();

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
}
 
void loop() {

    if (atmState == HIGH)
    {
      Serial.println("Interrupted");
      atmState = LOW;
    }
    else
    {
      server.handleClient(); //Handling of incoming requests 
    }
    
}

void interrupt_routine()
{
   atmState = HIGH;
}

void handleBody() { //Handler for the body path
 
      if (server.hasArg("plain")== false){ //Check if body received
            server.send(200, "text/plain", "Body not received");
            return;
      }
 
      String message = server.arg("plain");
      server.send(200, "text/plain", "We done got them message");
      char str[message.length()];
      char* functi;
      char* val;
      message.toCharArray(str, message.length());
      functi = strtok(str," ");
      val = strtok(NULL, "");

      digitalWrite(13, HIGH);
      atm328.begin(9600);
      atm328.print(functi);
      atm328.print(val);
      digitalWrite(13, LOW);
      
      //Serial.println(functi);
      //Serial.println(val);

      //digitalWrite(13, HIGH);
      //digitalWrite(13, LOW);
      
}
