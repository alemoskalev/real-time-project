import 'package:flutter/material.dart';
import '../widgets/sensor_cards.dart';


class CardsView extends StatelessWidget {
  final int occupants;
  final double temperature, humidity, oxygen, light;

  const CardsView({
    super.key,
    required this.occupants,
    required this.temperature,
    required this.humidity,
    required this.oxygen,
    required this.light,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SensorCard(
          label: "Occupants",
          value: "$occupants",
          icon: Icons.people,
          alert: occupants > 10,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        SensorGaugeCard(
          label: "Temperature",
          value: temperature,
          unit: "°C",
          icon: Icons.thermostat,
          iconColor: Colors.orangeAccent,
        ),
        SensorGaugeCard(
          label: "Humidity",
          value: humidity,
          unit: "%",
          icon: Icons.water_drop,
          iconColor: Colors.blueAccent,
        ),
        SensorOxygenCard(oxygen: oxygen),
        SensorLightCard(light: light),
      ],
    );
  }
}
