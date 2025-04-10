#include "cloud.h"

// 1) WiFi Credentials
const char SSID[]      = "Sneaky";
const char PASS[]      = "sneaky721";

// 2) Device and Thing IDs
const char THING_ID[]  = "b7b13393-839d-42bb-941d-99cb204dcdc7";
const char BOARD_ID[]  = "e9fe0c2d-a2c8-47eb-b473-fe0d6b7b5ccc";
const char DEVICE_KEY[] = "w2kz!rF6yChPYMZIQ#hDlXR@R";

// 3) Cloud variables
float humidityCloud;
float lightLevelCloud;
float oxygenCloud;
float temperatureCloud;
int   occupantCountCloud;

// 4) Connection handler
WiFiConnectionHandler ArduinoIoTPreferredConnection(SSID, PASS);

// 5) Register each variable with the IoT Cloud
void initProperties() {
  ArduinoCloud.addProperty(humidityCloud,      READ, ON_CHANGE, NULL);
  ArduinoCloud.addProperty(lightLevelCloud,    READ, ON_CHANGE, NULL);
  ArduinoCloud.addProperty(oxygenCloud,        READ, ON_CHANGE, NULL);
  ArduinoCloud.addProperty(temperatureCloud,   READ, ON_CHANGE, NULL);
  ArduinoCloud.addProperty(occupantCountCloud, READ, ON_CHANGE, NULL);
}

// 6) Initialize the Cloud
void initCloud() {
  ArduinoCloud.setBoardId(BOARD_ID);
  ArduinoCloud.setSecretDeviceKey(DEVICE_KEY);
  ArduinoCloud.setThingId(THING_ID);

  // Highest debug level for logs
  setDebugMessageLevel(4);
  ArduinoCloud.printDebugInfo();

  // Register your variables
  initProperties();

  // Begin Cloud
  ArduinoCloud.begin(ArduinoIoTPreferredConnection);

  // (If your library supported manual time calls, they'd go here. 
  // But your version doesn't, so rely on auto time sync.)
}
