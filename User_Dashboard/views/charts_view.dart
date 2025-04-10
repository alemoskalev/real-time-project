import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sensor_chart_card.dart';

class ChartsView extends StatelessWidget {
  final double temperature, humidity, oxygen, light;

  const ChartsView({
    super.key,
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
        SensorChartCard(
          label: "Temperature",
          icon: Icons.thermostat,
          value: "${temperature.toStringAsFixed(1)} °C",
          color: Colors.orangeAccent,
          values: generateRandomData(temperature),
        ),
        SensorChartCard(
          label: "Humidity",
          icon: Icons.water_drop,
          value: "${humidity.toStringAsFixed(1)} %",
          color: Colors.blueAccent,
          values: generateRandomData(humidity),
        ),
        SensorChartCard(
          label: "Oxygen",
          icon: Icons.air,
          value: "${oxygen.toStringAsFixed(1)} %",
          color: Colors.tealAccent,
          values: generateRandomData(oxygen),
        ),
        SensorChartCard(
          label: "Light",
          icon: Icons.lightbulb,
          value: "${light.toStringAsFixed(1)} %",
          color: Colors.yellowAccent,
          values: generateRandomData(light),
        ),
      ],
    );
  }

  List<FlSpot> generateRandomData(double base) {
    final r = Random();
    return List.generate(
      10,
          (i) => FlSpot(i.toDouble(), base + r.nextDouble() * 6 - 3),
    );
  }
}
