#ifndef GLOBALS_H
#define GLOBALS_H

#include <Arduino.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/semphr.h>

#define BUZZER_PIN    23   
#define ALERT_LED_PIN 33   // LED to indicate "Room Full"
#define MAX_OCCUPANCY 10


// Data structure holding all sensor info
typedef struct {
  float temperature;
  float humidity;
  float light;
  float oxygen;
  int   occupantCount;
} SensorData;

// Extern references so other files can access them
extern SensorData g_data;       // Our global sensor data
extern SemaphoreHandle_t xDataLock;  // Mutex for sensor data
extern SemaphoreHandle_t xUartLock;  // Gatekeeper for UART

#endif
