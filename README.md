# Real-Time Smart Room Monitoring System

This project outlines a comprehensive, scalable IoT-based Room Monitoring System utilizing ESP32 microcontrollers. It tracks and monitors environmental conditions and occupancy in real-time. Data is collected from various sensors, processed, transmitted, and visualized through a user-friendly Flutter dashboard integrated with Arduino IoT Cloud and Firebase.

## Project Directory Structure

```
SmartRoomMonitoring/
|
├── ESP Code/
│   ├── Sensor_ESP/
│   │   ├── main.cpp
│   │   ├── sensors.cpp
│   │   ├── firebase.cpp
│   │   ├── display.cpp
│   │   ├── comm.cpp
│   │   ├── globals.cpp
│   │   └── headers
│   └── Wifi_ESP/
│       ├── main.cpp
│       ├── es.cpp
│       ├── cloud.cpp
│       └── headers
|
├── User_Dashboard/
│   ├── main.dart
│   ├── views/
│   │   ├── dashboard_shell.dart
│   │   ├── charts_view.dart
│   │   ├── tables_view.dart
│   │   ├── analytics_view.dart
│   │   ├── cards_view.dart
│   │   └── charts_view.dart
│   │
│   └── widgets/
│       ├── sensor_cards.dart
│       ├── sensor_chart_card.dart
│       └── sensor_table_card.dart
|
├── uml diagrams/
│   ├── system_design_uml.png
│   └── class_diagram.png
|
├── circuit diagram.png
|
└── README.md
```

## Technologies and Tools

### ESP32 Microcontroller Nodes
- Programming Language: C++
- Framework: Arduino Core with FreeRTOS
- Integrated Development Environment (IDE): Arduino IDE
- Sensors: DHT22 (Temperature & Humidity), Analog Light Sensor, DFRobot Oxygen Sensor, Ultrasonic Sensors
- Communication Protocols: UART, I2C, WiFi
- Cloud Integration: Firebase, Arduino IoT Cloud

### Flutter User Dashboard
- Programming Language: Dart
- Framework: Flutter SDK
- Integrated Development Environment (IDE): Android Studio
- Libraries: fl_chart, audioplayers, google_fonts

## System Architecture

### Sensor ESP32 Node
- Collects real-time data from environmental sensors.
- Implements occupancy tracking with a dual ultrasonic sensor system.
- Provides local alerts via LCD display and buzzer.
- Transmits formatted sensor data to the WiFi ESP32 Node using UART.
- Optional Firebase integration for data logging.

### WiFi ESP32 Node
- Receives and parses UART data from Sensor Node.
- Synchronizes parsed data with Arduino IoT Cloud for remote monitoring.

### Flutter User Dashboard
- Visualizes real-time and historical sensor data.
- Features include dynamic cards, historical data charts, detailed tables, and comprehensive analytics.
- User settings allow theme switching and alert management.

## Features

- Real-time monitoring of multiple environmental metrics: temperature, humidity, oxygen, and ambient light.
- Accurate occupancy tracking and alerting mechanisms.
- Robust UART-based communication between microcontrollers.
- Local alerting via LCD and audible alerts.
- Secure cloud storage and real-time data synchronization.
- Interactive Flutter dashboard featuring real-time analytics and historical data visualization.

## Diagrams and Documentation

- Circuit diagrams detailing sensor connections are available under `/circuit diagram/`.
- UML diagrams illustrating system architecture and software classes can be found in `/uml diagrams/`.

## Deployment Instructions

### ESP32 Nodes
1. Open and compile `main.cpp` for both Sensor and WiFi ESP32 Nodes using the Arduino IDE.
2. Ensure the required libraries (DHT.h, WiFi.h, HTTPClient.h, DFRobot_OxygenSensor.h, LiquidCrystal.h) are installed.
3. Upload firmware to each ESP32 device via USB.
4. Physically connect UART interfaces (TX/RX) between Sensor and WiFi nodes.

### Flutter Dashboard
1. Open the User_Dashboard project folder in Android Studio.
2. Execute `flutter pub get` to install project dependencies.
3. Deploy the application to an emulator or a connected mobile device.

**Note:** The dashboard currently simulates sensor data. For integration with actual sensor data, connect to Arduino IoT Cloud or Firebase.

## Potential Enhancements
- Integration of live sensor data with Flutter dashboard through RESTful APIs or MQTT.
- Expansion of the sensor suite to include additional parameters such as CO₂, motion detection, and noise level.
- Advanced data analytics with comprehensive historical data logging.
- Implementation of remote environmental control actions.

## Licensing
This project is available under the MIT License.

## Contributors
- Aleksandr Moskalev - Project Lead & Firmware Development & Documentation
- Harikant Sharma - Flutter Application Developer
- Kaushal Khadka - Hardware Integration & Wireless Integration

We encourage feedback and collaborative improvements to this project.

