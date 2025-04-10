#ifndef ES_H
#define ES_H

#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/semphr.h>

// Shared global data
extern volatile int   g_occupantCount;
extern volatile float g_temperature;
extern volatile float g_humidity;
extern volatile float g_oxygen;
extern volatile float g_light;

extern SemaphoreHandle_t xGlobalLock;

// Tasks
void vTaskReceiveUARTData(void *pvParameters);  // NEW
void vTaskCopyToCloudVars(void *pvParameters);
void vTaskCloudRunner(void *pvParameters);

#endif
