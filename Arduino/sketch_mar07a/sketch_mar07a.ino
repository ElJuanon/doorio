#include <FirebaseESP8266.h>
#include <FirebaseESP8266HTTPClient.h>
#include <FirebaseJson.h>
#include <jsmn.h>

#include <ESP8266WiFi.h>

#define ssid = "EVENTO.";
#define password = "TECNOLOGICO2019";
FirebaseData firebaseData;

void setup(){
  Serial.begin(9600);
  connectWifi();
  Firebase.begin("https://doorio-a8e2e.firebaseio.com/","kU05SzsVmTj6fRx2T5SAVmI7RYThq4IdKS570x60");
}


void connectWifi(){
  WiFi.begin(ssid, password);

  while(WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }

  Serial.println("......");
  Serial.println("WiFi connected... IP Address");
  Serial.println(WiFi.localIP());
}
