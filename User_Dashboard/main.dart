import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/dashboard_shell.dart';

void main() => runApp(const FuturisticDashboard());

class FuturisticDashboard extends StatefulWidget {
  const FuturisticDashboard({super.key});
  @override
  State<FuturisticDashboard> createState() => _FuturisticDashboardState();
}

class _FuturisticDashboardState extends State<FuturisticDashboard> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Sensor Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1F1F39),
          secondary: Color(0xFF29D2E4),
          background: Color(0xFFF5F7FA),
          surface: Color(0xFFFFFFFF),
          onPrimary: Colors.white,
          onBackground: Color(0xFF1A1A1A),
          onSurface: Color(0xFF333333),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF29D2E4),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1F1F39),
          secondary: Color(0xFF29D2E4),
          background: Color(0xFF0B0F2F),
          surface: Color(0xFF1C203C),
          onPrimary: Colors.white,
          onBackground: Color(0xFFEDEDED),
          onSurface: Color(0xFFD1D1D1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF29D2E4),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1C203C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: DashboardShell(
        isDark: _themeMode == ThemeMode.dark,
        isMuted: isMuted,
        onToggleTheme: () {
          setState(() => _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
        },
        onToggleMute: () => setState(() => isMuted = !isMuted),
      ),
    );
  }
}
