#include <Arduino.h>
#include "globals.h"
#include "sensors.h"
#include "display.h"
#include "comm.h"
#include "firebase.h"

void setup() {
  Serial.begin(115200);
  delay(1000);
  connectWiFi();
  Serial.println("== Sensor Node for Room Monitoring in multiple files ==");

  // Initialize hardware serial for sensors -> cloud communication
  sensorUart.begin(UART_BAUD, SERIAL_8N1, UART_RX_PIN, UART_TX_PIN);

  // Create semaphores
  xDataLock = xSemaphoreCreateMutex();
  xUartLock = xSemaphoreCreateMutex();
  

  // Launch tasks
  xTaskCreate(vTaskReadDHT,          "ReadDHT",         4096, NULL, 1, NULL);
  xTaskCreate(vTaskReadLight,        "ReadLight",       4096, NULL, 1, NULL);
  xTaskCreate(vTaskReadO2,           "ReadO2",          4096, NULL, 1, NULL);
  xTaskCreate(vTaskOccupantCount,    "OccupantCount",   4096, NULL, 1, NULL);
  xTaskCreate(vTaskLCDDisplay,       "LCDUpdate",       4096, NULL, 1, NULL);
  xTaskCreate(vTaskSendToFirebase, "FirebaseSend", 6000, NULL, 1, NULL);
  xTaskCreate(vTaskSendUART,         "UartSend",        4096, NULL, 1, NULL);

  Serial.println("== All tasks launched! ==");
}

void loop() {
  // Nothing here, everything runs in tasks
}
