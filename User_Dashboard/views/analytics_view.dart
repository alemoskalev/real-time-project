import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class AnalyticsView extends StatefulWidget {
  final List<Map<String, dynamic>> temperatureData;
  final List<Map<String, dynamic>> humidityData;
  final List<Map<String, dynamic>> oxygenData;
  final List<Map<String, dynamic>> lightData;

  const AnalyticsView({
    super.key,
    required this.temperatureData,
    required this.humidityData,
    required this.oxygenData,
    required this.lightData,
  });

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  String selectedMetric = 'Average';

  double computeValue(List<Map<String, dynamic>> data, String metric) {
    final values = data.map((e) => double.tryParse(e['value'] ?? '') ?? 0).toList();
    if (values.isEmpty) return 0;

    switch (metric) {
      case 'Average':
        return values.average;
      case 'Median':
        return values.length % 2 == 0
            ? (values..sort())[(values.length ~/ 2) - 1]
            : (values..sort())[values.length ~/ 2];
      case 'Min':
        return values.reduce((a, b) => a < b ? a : b);
      case 'Max':
        return values.reduce((a, b) => a > b ? a : b);
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            value: selectedMetric,
            items: ['Average', 'Median', 'Min', 'Max']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => selectedMetric = val!),
            dropdownColor: Theme.of(context).colorScheme.surface,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            decoration: InputDecoration(
              labelText: "Select Metric",
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color.secondary, width: 2),
              ),
              prefixIcon: const Icon(Icons.analytics_outlined, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SummaryCard(
                title: "Temperature",
                value: "${computeValue(widget.temperatureData, selectedMetric).toStringAsFixed(1)} °C",
                icon: Icons.thermostat,
                color: Colors.orangeAccent,
              ),
              SummaryCard(
                title: "Humidity",
                value: "${computeValue(widget.humidityData, selectedMetric).toStringAsFixed(1)} %",
                icon: Icons.water_drop,
                color: Colors.blueAccent,
              ),
              SummaryCard(
                title: "Oxygen",
                value: "${computeValue(widget.oxygenData, selectedMetric).toStringAsFixed(1)} %",
                icon: Icons.air,
                color: Colors.tealAccent,
              ),
              SummaryCard(
                title: "Light",
                value: "${computeValue(widget.lightData, selectedMetric).toStringAsFixed(1)} %",
                icon: Icons.lightbulb,
                color: Colors.yellowAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
            color: color.withOpacity(0.3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          Text(value, style: TextStyle(fontSize: 18, color: color)),
        ],
      ),
    );
  }
}
