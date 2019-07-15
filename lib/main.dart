import 'package:flutter/material.dart';
import 'package:memorymap/views/memorymap.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Map',
      home: MemoryMap(),
    );
  }
}
