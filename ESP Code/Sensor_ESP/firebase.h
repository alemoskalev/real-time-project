#ifndef FIREBASE_H

#define FIREBASE_H
#include <WiFi.h>

#include <HTTPClient.h>

#include <time.h>

#include "globals.h"
#include "sensors.h"


// Firebase and WiFi

void connectWiFi();
void vTaskSendToFirebase(void* pvParameters);

#endif // FIREBASE_H
