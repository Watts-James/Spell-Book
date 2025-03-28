import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class CustomSpeedDial extends StatelessWidget {
  const CustomSpeedDial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Color(0xFF939c6c),
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(color: Color(0xFFF5F5F5)),
      spacing: 12,
      spaceBetweenChildren: 8,
      children: [
        SpeedDialChild(
          child: Icon(Icons.book),
          label: 'Spell Book',
          onTap: () => context.push('/'),
        ),
        SpeedDialChild(
          child: Icon(Icons.star),
          label: 'All Spells',
          onTap: () => context.push('/AllSpells'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'New Spell',
          onTap: () => context.push('/SpellFormPage'),
        ),
      ],
    );
  }
}
