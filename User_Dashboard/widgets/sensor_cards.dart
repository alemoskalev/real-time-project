import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool alert;
  final Color iconColor;

  const SensorCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.alert,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surface;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (alert)
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              value,
              key: ValueKey(value),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SensorGaugeCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final IconData icon;
  final Color iconColor;

  const SensorGaugeCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value / 100).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percent,
                  color: iconColor,
                  backgroundColor: iconColor.withOpacity(0.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text("${value.toStringAsFixed(1)} $unit",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class SensorOxygenCard extends StatelessWidget {
  final double oxygen;
  const SensorOxygenCard({super.key, required this.oxygen});

  @override
  Widget build(BuildContext context) {
    final alert = oxygen < 95;
    final color = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: alert ? Colors.redAccent : color,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.air, size: 36, color: color),
          const SizedBox(width: 16),
          Expanded(child: Text("Oxygen", style: const TextStyle(fontSize: 18))),
          if (alert) Icon(Icons.warning, color: Colors.redAccent),
          Text("${oxygen.toStringAsFixed(1)} %",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SensorLightCard extends StatelessWidget {
  final double light;
  const SensorLightCard({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    final glow = (light / 100).clamp(0.0, 1.0);
    final color = Colors.yellowAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (glow > 0.3)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 5,
                        color: color.withOpacity(glow),
                      )
                    ],
                  ),
                ),
              Icon(Icons.lightbulb, size: 36, color: color),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(child: Text("Light", style: const TextStyle(fontSize: 18))),
          Text("${light.toStringAsFixed(1)} %",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
