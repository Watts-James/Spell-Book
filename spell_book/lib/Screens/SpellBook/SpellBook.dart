import 'package:flutter/material.dart';
import 'package:spell_book/Widgets/SpeedDial.dart';

class SpellBook extends StatefulWidget {
  const SpellBook({super.key, required this.title});

  final String title;

  @override
  State<SpellBook> createState() => _SpellBookState();
}

class _SpellBookState extends State<SpellBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E6D2),
      appBar: AppBar(
        backgroundColor: Color(0xFF939c6c),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
          ],
        ),
      ),
      floatingActionButton: const CustomSpeedDial(),
    );
  }
}
