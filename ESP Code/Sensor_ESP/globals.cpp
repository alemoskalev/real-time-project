#include "globals.h"

// Actually define our global data struct here
SensorData g_data = {
  0.0f,  // temperature
  0.0f,  // humidity
  0.0f,  // light
  0.0f,  // oxygen
  0      // occupantCount
};

// Define our semaphores
SemaphoreHandle_t xDataLock = NULL;
SemaphoreHandle_t xUartLock = NULL;
