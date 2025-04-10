import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'cards_view.dart';
import 'charts_view.dart';
import 'tables_view.dart';
import 'analytics_view.dart';
import 'settings_view.dart';

class DashboardShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleMute;
  final bool isDark;
  final bool isMuted;

  const DashboardShell({
    super.key,
    required this.onToggleTheme,
    required this.onToggleMute,
    required this.isDark,
    required this.isMuted,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;
  final player = AudioPlayer();
  late Timer _timer;
  int occupants = 0;
  double temperature = 0.0, humidity = 0.0, oxygen = 0.0, light = 0.0;
  final random = Random();
  List<Map<String, dynamic>> oxygenTable = [];
  List<Map<String, dynamic>> temperatureTable = [];
  List<Map<String, dynamic>> humidityTable = [];
  List<Map<String, dynamic>> lightTable = [];
  List<Map<String, dynamic>> occupantsTable = [];


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        occupants = random.nextInt(20);
        temperature = 18 + random.nextDouble() * 10;
        humidity = 30 + random.nextDouble() * 40;
        oxygen = 88 + random.nextDouble() * 12;
        light = random.nextDouble() * 100;

        occupantsTable.insert(0, {
          'value': occupants.toString(),
          'time': DateTime.now().toIso8601String().substring(11, 19),
        });
        temperatureTable.insert(0, {
          'value': temperature.toStringAsFixed(1),
          'time': DateTime.now().toIso8601String().substring(11, 19),
        });
        humidityTable.insert(0, {
          'value': humidity.toStringAsFixed(1),
          'time': DateTime.now().toIso8601String().substring(11, 19),
        });
        oxygenTable.insert(0, {
          'value': oxygen.toStringAsFixed(1),
          'time': DateTime.now().toIso8601String().substring(11, 19),
        });
        lightTable.insert(0, {
          'value': light.toStringAsFixed(1),
          'time': DateTime.now().toIso8601String().substring(11, 19),
        });


        if (occupants > 10 && !widget.isMuted) {
          player.play(AssetSource('alert.mp3'));
        }
      });
    });

  }

  @override
  void dispose() {
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CardsView(
        occupants: occupants,
        temperature: temperature,
        humidity: humidity,
        oxygen: oxygen,
        light: light,
      ),
      ChartsView(
        temperature: temperature,
        humidity: humidity,
        oxygen: oxygen,
        light: light,
      ),
      TablesView(
        occupantsData: occupantsTable,
        temperatureData: temperatureTable,
        humidityData: humidityTable,
        oxygenData: oxygenTable,
        lightData: lightTable,
      ),
      AnalyticsView(
        temperatureData: temperatureTable,
        humidityData: humidityTable,
        oxygenData: oxygenTable,
        lightData: lightTable,
      ),

      SettingsView(
        isDark: widget.isDark,
        isMuted: widget.isMuted,
        toggleTheme: widget.onToggleTheme,
        toggleMute: widget.onToggleMute,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Cards'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Charts'),
          NavigationDestination(icon: Icon(Icons.table_chart), label: 'Tables'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
