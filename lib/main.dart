import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // Use this method to change the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: FadingTextAnimation(
        changeTheme: changeTheme,
        themeMode: _themeMode,
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Function(ThemeMode) changeTheme;
  final ThemeMode themeMode;

  FadingTextAnimation({required this.changeTheme, required this.themeMode});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isVisible = true;
  Color _textColor = Colors.black;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = _textColor;
        return AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _textColor = selectedColor;
                });
                Navigator.of(context).pop();
              },
              child: Text("Select"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.changeTheme(
                Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
          IconButton(icon: Icon(Icons.palette), onPressed: _pickColor),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            // Tab 1
            child: GestureDetector(
              onTap: toggleVisibility,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
            ),
          ),
          // Tab 2
          Center(
            child: GestureDetector(
              onTap: toggleVisibility,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
