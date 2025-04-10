#ifndef COMM_H
#define COMM_H

#include <HardwareSerial.h>

// UART pins and config
#define UART_TX_PIN 17
#define UART_RX_PIN 16
#define UART_BAUD   9600

extern HardwareSerial sensorUart;

void vTaskSendUART(void *pvParameters);

#endif
