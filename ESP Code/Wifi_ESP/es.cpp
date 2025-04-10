#include "es.h"
#include "cloud.h" // We need occupantCountCloud, etc.

volatile int   g_occupantCount = 0;
volatile float g_temperature   = 0.0f;
volatile float g_humidity      = 0.0f;
volatile float g_oxygen        = 0.0f;
volatile float g_light         = 0.0f;

// We use a single mutex for data gating
SemaphoreHandle_t xGlobalLock = NULL;

// UART pins (define according to your wiring)
#define UART_RX 16
#define UART_TX 17
#define UART_BAUD 9600

HardwareSerial sensorUart(2); // Using UART2

// (A) Receive + Parse sensor data from UART
void vTaskReceiveUARTData(void *pvParameters) {
  (void) pvParameters;
  sensorUart.begin(UART_BAUD, SERIAL_8N1, UART_RX, UART_TX);
  String input = "";

  for (;;) {
    while (sensorUart.available()) {
      char c = sensorUart.read();
      if (c == '\n') {
        // Full message received
        input.trim();

        if (input.startsWith("TEMP=")) {
          float temp, hum, light, o2;
          int occ;

          int parsed = sscanf(input.c_str(),
            "TEMP=%f,HUM=%f,LIGHT=%f,O2=%f,OCC=%d",
            &temp, &hum, &light, &o2, &occ
          );

          if (parsed == 5) {
            xSemaphoreTake(xGlobalLock, portMAX_DELAY);
            g_temperature = temp;
            g_humidity    = hum;
            g_light       = light;
            g_oxygen      = o2;
            g_occupantCount = occ;
            xSemaphoreGive(xGlobalLock);

            Serial.println("=== UART Data Received ===");
            Serial.println(input);
            Serial.println("==========================");
          } else {
            Serial.println("[UART] Failed to parse input");
          }
        }

        input = ""; // Reset for next line
      } else {
        input += c;
      }
    }

    vTaskDelay(pdMS_TO_TICKS(50));
  }
}

// (B) Copy from local dummy data to the Cloud "extern" variables
void vTaskCopyToCloudVars(void *pvParameters) {
  (void) pvParameters;

  for (;;) {
    if (ArduinoCloud.connected()) {
      xSemaphoreTake(xGlobalLock, portMAX_DELAY);
      occupantCountCloud = g_occupantCount;
      temperatureCloud   = g_temperature;
      humidityCloud      = g_humidity;
      oxygenCloud        = g_oxygen;
      lightLevelCloud    = g_light;
      xSemaphoreGive(xGlobalLock);

      Serial.println("[DataCopy] Cloud vars updated from local");
    } else {
      Serial.println("[DataCopy] Not connected to Cloud, skipping copy");
    }

    vTaskDelay(pdMS_TO_TICKS(2000));
  }
}

// (C) Cloud Runner
void vTaskCloudRunner(void *pvParameters) {
  (void) pvParameters;
  vTaskDelay(pdMS_TO_TICKS(8000));

  for (;;) {
    ArduinoCloud.update();

    if (ArduinoCloud.connected()) {
      Serial.println("[CloudRunner] connected? Yes");
    } else {
      Serial.println("[CloudRunner] connected? No");
    }

    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}
