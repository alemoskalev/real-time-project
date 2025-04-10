#include <LiquidCrystal.h>
#include "display.h"
#include "globals.h"


LiquidCrystal lcd(13, 12, 14, 27, 26, 25);  // RS, E, D4, D5, D6, D7

void vTaskLCDDisplay(void *pvParameters) {
  (void) pvParameters;

  lcd.begin(16, 2);
  lcd.clear();

  for (;;) {
    xSemaphoreTake(xDataLock, portMAX_DELAY);
    int count = g_data.occupantCount;
    xSemaphoreGive(xDataLock);

    lcd.setCursor(0, 0);
    lcd.print("Occupants:");
    lcd.setCursor(11, 0);
    lcd.print(count);
    lcd.setCursor(0, 1);
    if (count >= 10) {
      lcd.print("Room FULL");
    } else {
      lcd.print("Room OK");
    }

    vTaskDelay(pdMS_TO_TICKS(2000));
  }
}
