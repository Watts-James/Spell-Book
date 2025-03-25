import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spell_book/Router/Router.dart';

class AllSpells extends StatefulWidget {
  const AllSpells({super.key, required this.title});
  final String title;
  @override
  State<AllSpells> createState() => _AllSpellsState();
}

class _AllSpellsState extends State<AllSpells> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: Icon(Icons.book),
            label: 'Spell Book',
            onTap: () => appRouter.go('/'),
          ),
          SpeedDialChild(
            child: Icon(Icons.star),
            label: 'All Spells',
            onTap: () => appRouter.go('/AllSpells'),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
