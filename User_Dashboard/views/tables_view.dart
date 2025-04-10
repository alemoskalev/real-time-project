import 'package:flutter/material.dart';
import '../widgets/sensor_table_card.dart';

class TablesView extends StatelessWidget {
  final List<Map<String, dynamic>> occupantsData;
  final List<Map<String, dynamic>> temperatureData;
  final List<Map<String, dynamic>> humidityData;
  final List<Map<String, dynamic>> oxygenData;
  final List<Map<String, dynamic>> lightData;

  const TablesView({
    super.key,
    required this.occupantsData,
    required this.temperatureData,
    required this.humidityData,
    required this.oxygenData,
    required this.lightData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SensorTableCard(
          label: "Occupants",
          icon: Icons.people,
          color: Theme.of(context).colorScheme.primary,
          data: occupantsData,
        ),
        SensorTableCard(
          label: "Temperature",
          icon: Icons.thermostat,
          color: Colors.orangeAccent,
          data: temperatureData,
        ),
        SensorTableCard(
          label: "Humidity",
          icon: Icons.water_drop,
          color: Colors.blueAccent,
          data: humidityData,
        ),
        SensorTableCard(
          label: "Oxygen",
          icon: Icons.air,
          color: Colors.tealAccent,
          data: oxygenData,
        ),
        SensorTableCard(
          label: "Light",
          icon: Icons.lightbulb,
          color: Colors.yellowAccent,
          data: lightData,
        ),
      ],
    );
  }
}
