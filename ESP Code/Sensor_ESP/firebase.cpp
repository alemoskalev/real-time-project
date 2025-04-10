#include "firebase.h"
const char* ssid = "Sneaky";
const char* password = "sneaky721";
const char* firebaseHost = "https://realtime-a5389-default-rtdb.firebaseio.com";

void connectWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
}

void vTaskSendToFirebase(void* pvParameters) {
  while (true) {
    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      String url = String(firebaseHost) + "/sensors.json";
      time_t now;
      time(&now);
      if (xSemaphoreTake(xDataLock, pdMS_TO_TICKS(100)) == pdTRUE) {
        String json = "{";
        json += "\"occupants\":" + String(g_data.occupantCount) + ",";
        json += "\"temperature\":" + String(g_data.temperature, 2) + ",";
        json += "\"humidity\":" + String(g_data.humidity, 2) + ",";
        json += "\"oxygen\":" + String(g_data.oxygen, 2) + ",";
        json += "\"light\":" + String(g_data.light, 2) + ",";
        json += "\"timestamp\":" + String((unsigned long)now);
        json += "}";
        xSemaphoreGive(xDataLock);
        if (http.begin(url)) {
          http.addHeader("Content-Type", "application/json");
          int code = http.POST(json);
          String res = http.getString();
          Serial.printf("[Firebase] HTTP %d\n", code);
          Serial.println(res);
          http.end();
        } else {
          Serial.println("HTTP begin failed");
        }
      } else {
        Serial.println("Semaphore timeout while accessing sensor data");
      }
    } else {
      Serial.println("WiFi not connected");
    }
    vTaskDelay(pdMS_TO_TICKS(5000));
  }
}
