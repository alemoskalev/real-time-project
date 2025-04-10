#include <Arduino.h>
#include <WiFi.h>
#include "cloud.h"
#include "es.h"

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("Starting ESP32 FreeRTOS + IoT Cloud Test...");

  // 1) WiFi
  WiFi.begin(SSID, PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected");
  Serial.println(WiFi.localIP());

  // 2) initCloud to set board ID, secret, thing ID
  initCloud();

  // 3) Create our mutex
  xGlobalLock = xSemaphoreCreateMutex();

  // 4) Launch tasks
  // generate data
  xTaskCreate(vTaskReceiveUARTData, "UART Receive", 4096, NULL, 1, NULL);

  xTaskCreate(vTaskCopyToCloudVars, "DataCopy", 4096, NULL, 1, NULL);

  // run the cloud update logic
  xTaskCreate(vTaskCloudRunner, "CloudRunner", 8192, NULL, 1, NULL);

  Serial.println("All FreeRTOS tasks launched!");
}

void loop() {
  // intentionally empty
}
