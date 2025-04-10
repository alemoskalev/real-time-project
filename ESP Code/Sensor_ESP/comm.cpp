#include "comm.h"
#include "globals.h"

HardwareSerial sensorUart(2); // Use UART1 on ESP32

void vTaskSendUART(void *pvParameters) {
  (void) pvParameters;

  for (;;) {
    // Read the data from g_data
    xSemaphoreTake(xDataLock, portMAX_DELAY);
    float t = g_data.temperature;
    float h = g_data.humidity;
    float l = g_data.light;
    float o = g_data.oxygen;
    int   c = g_data.occupantCount;
    xSemaphoreGive(xDataLock);

    // Format as CSV or any string protocol
    String msg = "TEMP=" + String(t,1) +
                 ",HUM=" + String(h,1) +
                 ",LIGHT=" + String(l,1) +
                 ",O2=" + String(o,1) +
                 ",OCC=" + String(c);

    // Gatekeeper for UART
    xSemaphoreTake(xUartLock, portMAX_DELAY);
    sensorUart.println(msg);
    xSemaphoreGive(xUartLock);

    Serial.println("[UART] Sent: " + msg);

    vTaskDelay(pdMS_TO_TICKS(3000));
  }
}
