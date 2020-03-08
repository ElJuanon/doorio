#include <ArduinoJson.h>

#include <WiFiUdp.h>



#include <Firebase.h>
#include <FirebaseHttpClient.h>
#include <FirebaseArduino.h>
#include <FirebaseError.h>
#include <FirebaseObject.h>

// Wireless RFID Door Lock Using NodeMCU
// Created by LUIS SANTOS & RICARDO VEIGA
// 7th of June, 2017


#include <Wire.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>

#define Relay D1


#define GreenLed D3
#define RedLed D8

#define FIREBASE_HOST "https://doorio-a8e2e.firebaseio.com/"
#define FIREBASE_AUTH "kU05SzsVmTj6fRx2T5SAVmI7RYThq4IdKS570x60"

//Wireless name and password
const char* ssid     = "Puro Sinaloa"; // replace with you wireless network name
const char* password = ""; //replace with you wireless network password

WiFiUDP ntpUDP;

int time_buffer = 3000; // amount of time in miliseconds that the relay will remain open

void setup() {
  pinMode(Relay, OUTPUT);
  digitalWrite(Relay,0);

  
  Serial.begin(115200);    // Initialize serial communications

  // We start by connecting to a WiFi network

  Serial.println("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  wifi_connected();
  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  leds_off();
  
 // timeClient.begin();
    
  delay(3000);

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  
}

void leds_off() {
//analogWrite(BlueLed, 0);   // turn the LED off
  analogWrite(GreenLed, 0);   // turn the LED off
  analogWrite(RedLed, 0);   // turn the LED off
}

void reject() {
  analogWrite(RedLed, 767);   // turn the Red LED on
  delay(2000);
  leds_off(); 
}

void authorize() {
  
  analogWrite(GreenLed, 767);   // turn the Green LED on
  digitalWrite(Relay,1);
  delay(time_buffer);              // wait for a second 
  digitalWrite(Relay,0);
  leds_off(); 
}

void wifi_connected () {
  
  delay(3000);  
}

void connection_failed() {
  
  delay(3000);
  leds_off();   
}

// Helper routine to dump a byte array as hex values to Serial
void dump_byte_array(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

void loop() {

  int authorized_flag = 0;


////-------------------------------------------------SERVER----------------------------------------------

  
  // Use WiFiClient class to create TCP connections
  //WiFiClient client;
  //const int httpPort = 80;
  //if (!client.connect(host, httpPort)) {
  //  Serial.println("connection failed");
  //  connection_failed();
  //  return;
  //}
  
  delay(10);

  // Read all the lines of the reply from server and print them to Serial
  //String line;
  //while(client.available()){
  //   line = client.readStringUntil('\n');
  //   
  //  if(line==content){
  //    authorized_flag=1;
  //  }
  //}

 

  

  

    Firebase.setString("Archivo1","El Erik es Guapo");
  

}
