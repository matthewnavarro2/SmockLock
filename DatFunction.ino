
//Dis dat function for the calling of the ESP32
int callESP32() 
{
  // put your main code here, to run repeatedly:
  mySerial.write("P");

  while (!mySerial.available())
  {
          
  }

  while (mySerial.available())
  {
    char c = (char)mySerial.read();
    Data.concat(c);
    Serial.println(c);
  
    if(c == '\n')
    {
      Serial.print("Received: ");
      Serial.println(Data);
    }
  }
  
  if(strcmp(Data, "[HTTP PASS]") == 0)
  {
   printOLED("Face Detected");
        
   char c = (char)mySerial.read();
        
   return c.toInt();
  }
  else if(strcmp(Data, "[HTTP Fail]") == 0)
  {
    printOLED("Failed to process request");
    return 0;
  }
  else if(strcmp(Data, "[Camera Fail]") == 0)
  {
    printOLED("Please move into view");
    return 0;
  }
  else if(strcmp(Data, "[Detect Fail]") == 0)
  {
    printOLED("Could not detect any face");
    return 0;
  }
 Data = "";
}


//For the ATM calling it
//Dis da function for calling the ESP32
for(i = 0; i <= 5; i++)
{
    int ESPret = callESP32()
    if(ESPret != 0)
        break;
}

security_matrix[whereever] = ESPret;