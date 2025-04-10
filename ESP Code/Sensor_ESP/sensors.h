#ifndef SENSORS_H
#define SENSORS_H

#include <DHT.h>
#include <Wire.h>
#include "DFRobot_OxygenSensor.h"
#define DHT_PIN        15
#define DHT_TYPE       DHT22

#define LIGHT_PIN      34    // analog input
#define TRIG1_PIN      18
#define ECHO1_PIN      19
#define TRIG2_PIN      5
#define ECHO2_PIN      21

#define COLLECT_NUMBER      10
#define Oxygen_IICAddress   ADDRESS_3  // Adjust based on DIP switch

#define OCC_THRESHOLD_CM 100
#define TIME_WINDOW_MS   1000 // 1 second

// We’ll define the sensor tasks here
void vTaskReadDHT(void *pvParameters);
void vTaskReadLight(void *pvParameters);
void vTaskReadO2(void *pvParameters);
void vTaskOccupantCount(void *pvParameters);

#endif
