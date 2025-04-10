#ifndef CLOUD_H
#define CLOUD_H

#include <ArduinoIoTCloud.h>
#include <Arduino_ConnectionHandler.h>

// WiFi credentials
extern const char SSID[];
extern const char PASS[];

// Cloud device & thing
extern const char THING_ID[];
extern const char BOARD_ID[];
extern const char DEVICE_KEY[];

// The "cloud variables"
extern float humidityCloud;
extern float lightLevelCloud;
extern float oxygenCloud;
extern float temperatureCloud;
extern int   occupantCountCloud;

// Setup
void initProperties(); // registers the above variables
void initCloud();

#endif
