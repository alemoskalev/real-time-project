import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final bool isDark;
  final bool isMuted;
  final VoidCallback toggleTheme;
  final VoidCallback toggleMute;

  const SettingsView({
    super.key,
    required this.isDark,
    required this.isMuted,
    required this.toggleTheme,
    required this.toggleMute,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings", style: TextStyle(fontSize: 24, color: color.secondary)),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.dark_mode),
              const SizedBox(width: 12),
              const Expanded(child: Text("Dark Mode")),
              Switch(value: isDark, onChanged: (_) => toggleTheme()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.volume_off),
              const SizedBox(width: 12),
              const Expanded(child: Text("Mute Alerts")),
              Switch(value: isMuted, onChanged: (_) => toggleMute()),
            ],
          ),
        ],
      ),
    );
  }
}
