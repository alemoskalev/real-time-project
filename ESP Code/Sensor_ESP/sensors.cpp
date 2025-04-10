#include "sensors.h"
#include "globals.h"





DHT dht(DHT_PIN, DHT_TYPE);
DFRobot_OxygenSensor oxygen;

// Read Ultrasonic distance in cm
static float readUltrasonicCM(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000); // 30ms => ~5m
  float distance_cm = (duration / 2.0) * 0.0343;
  if(distance_cm == 0 || distance_cm > 400) {
    return 999.0; 
  }
  return distance_cm;
}

// ====================== vTaskReadDHT ======================
void vTaskReadDHT(void *pvParameters) {
  (void) pvParameters;
  dht.begin();

  for (;;) {
    float t = dht.readTemperature();
    float h = dht.readHumidity();
    if (!isnan(t) && !isnan(h)) {
      xSemaphoreTake(xDataLock, portMAX_DELAY);
      g_data.temperature = t;
      g_data.humidity    = h;
      xSemaphoreGive(xDataLock);
    } else {
      Serial.println("[DHT] failed to read");
    }
    vTaskDelay(pdMS_TO_TICKS(2000));
  }
}

// ====================== vTaskReadLight ======================
void vTaskReadLight(void *pvParameters) {
  (void) pvParameters;
  pinMode(LIGHT_PIN, INPUT);

  for (;;) {
    int rawVal = analogRead(LIGHT_PIN);
    // example scaling 0..4095 => 0..1000
    float lightLevel = map(rawVal, 0, 4095, 0, 1000);

    xSemaphoreTake(xDataLock, portMAX_DELAY);
    g_data.light = lightLevel;
    xSemaphoreGive(xDataLock);

    vTaskDelay(pdMS_TO_TICKS(2000));
  }
}

// ====================== vTaskReadO2 ======================
void vTaskReadO2(void *pvParameters) {
  (void) pvParameters;

  Wire.begin(4, 2);  // SDA = GPIO4, SCL = GPIO2

  while (!oxygen.begin(Oxygen_IICAddress)) {
    Serial.println("[O2 Sensor] I2C device not found!");
    vTaskDelay(pdMS_TO_TICKS(1000));
  }

  for (;;) {
    float o2Val = oxygen.getOxygenData(COLLECT_NUMBER);

    xSemaphoreTake(xDataLock, portMAX_DELAY);
    g_data.oxygen = o2Val;
    xSemaphoreGive(xDataLock);

    vTaskDelay(pdMS_TO_TICKS(5000));
  }
}
// ====================== vTaskOccupantCount ======================


enum OccupantState {
  IDLE,
  WAIT_SECOND
};

void vTaskOccupantCount(void *pvParameters) {
  (void) pvParameters;

  pinMode(TRIG1_PIN, OUTPUT); 
  pinMode(ECHO1_PIN, INPUT);
  pinMode(TRIG2_PIN, OUTPUT);
  pinMode(ECHO2_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(ALERT_LED_PIN, OUTPUT);
  digitalWrite(BUZZER_PIN, LOW);
  digitalWrite(ALERT_LED_PIN, LOW);

  OccupantState currentState = IDLE;
  unsigned long triggerTime  = 0;
  int firstSensor = 0;
  int occupantCount = 0;

  for (;;) {
    float dist1 = readUltrasonicCM(TRIG1_PIN, ECHO1_PIN);
    float dist2 = readUltrasonicCM(TRIG2_PIN, ECHO2_PIN);

    bool sensor1Triggered = (dist1 < OCC_THRESHOLD_CM);
    bool sensor2Triggered = (dist2 < OCC_THRESHOLD_CM);

    switch (currentState) {
      case IDLE:
        if (sensor1Triggered && !sensor2Triggered) {
          firstSensor = 1;
          triggerTime = millis();
          currentState = WAIT_SECOND;
        }
        else if (sensor2Triggered && !sensor1Triggered) {
          firstSensor = 2;
          triggerTime = millis();
          currentState = WAIT_SECOND;
        }
        break;

      case WAIT_SECOND:
        if ((millis() - triggerTime) > TIME_WINDOW_MS) {
          currentState = IDLE;
          break;
        }
        if (firstSensor == 1 && sensor2Triggered) {
          occupantCount++;
          Serial.println("[Occupant] Person ENTERED");
          currentState = IDLE;
        }
        else if (firstSensor == 2 && sensor1Triggered) {
          occupantCount--;
          if (occupantCount < 0) occupantCount = 0;
          Serial.println("[Occupant] Person EXITED");
          currentState = IDLE;
        }
        break;
    }

    //  Activate buzzer + LED if full
    if (occupantCount >= MAX_OCCUPANCY) {
      digitalWrite(BUZZER_PIN, HIGH);
      digitalWrite(ALERT_LED_PIN, !digitalRead(ALERT_LED_PIN)); // Blink LED
    } else {
      digitalWrite(BUZZER_PIN, LOW);
      digitalWrite(ALERT_LED_PIN, LOW);
    }

    xSemaphoreTake(xDataLock, portMAX_DELAY);
    g_data.occupantCount = occupantCount;
    xSemaphoreGive(xDataLock);

    vTaskDelay(pdMS_TO_TICKS(500));  // Update every 0.5s
  }
}
