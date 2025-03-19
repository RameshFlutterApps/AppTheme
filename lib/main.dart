import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* My Sample application for app theme changes
* */

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      _themeMode =
          theme == 'dark'
              ? ThemeMode.dark
              : theme == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    });
  }

  void _toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      prefs.setString('themeMode', isDark ? 'dark' : 'light');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: ThemeSettingsScreen(
        themeMode: _themeMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class ThemeSettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(bool) onThemeChanged;

  ThemeSettingsScreen({required this.themeMode, required this.onThemeChanged});

  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  bool get isDarkMode => widget.themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.view_sidebar),
        backgroundColor: Colors.blueAccent.shade100,
        title: Text('Theme Settings'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              widget.onThemeChanged(!isDarkMode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPreviewCard(),
            const SizedBox(height: 16),
            _buildThemeSettings(),
            const SizedBox(height: 16),
            _buildStatusSection(),
            const SizedBox(height: 26),
            Container(
              alignment: Alignment.center,
              width: 180, // Thickness of the line
              height: 5, // Height of the line
              color: Colors.grey.shade500, // Color of the line
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _previewBox(
              'Light Mode',
              'This mode typically features dark text on a light background (e.g., black text on a white or light gray background, It is the traditional display setting, designed to mimic the look of ink on paper, It is generally considered optimal for readability in well-lit environments.',
              Colors.grey[100]!,
              Colors.black,
            ),
            const SizedBox(height: 50),
            _previewBox(
              'Dark Mode',
              'This mode reverses the contrast, displaying light text on a dark background (e.g., white text on a black or dark gray background), It is designed to reduce the amount of light emitted by the screen, It is often preferred in low-light environments to minimize eye strain.',
              Colors.black87,
              Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewBox(
    String title,
    String description,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) => widget.onThemeChanged(value),
              ),
              SwitchListTile(
                title: Text('Use System Settings'),
                value: widget.themeMode == ThemeMode.system,
                onChanged: (value) {
                  setState(() {
                    widget.onThemeChanged(
                      value ? ThemeMode.system == ThemeMode.dark : isDarkMode,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    String themeText = isDarkMode ? "Dark Mode" : "Light Mode";
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Current Theme: $themeText', style: TextStyle(fontSize: 16)),
              Text(
                'System Preference: ${widget.themeMode == ThemeMode.system ? "System Default" : themeText}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Last Updated: ${DateTime.now().toLocal().toString().split('.')[0]}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
