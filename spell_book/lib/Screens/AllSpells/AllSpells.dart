import 'package:flutter/material.dart';
import 'package:spell_book/Widgets/SpeedDial.dart';
import 'package:spell_book/Screens/AllSpells/AllSpellsViewModel.dart';
import 'package:provider/provider.dart';

class AllSpells extends StatefulWidget {
  const AllSpells({super.key, required this.title});
  final String title;

  @override
  State<AllSpells> createState() => _AllSpellsState();
}

class _AllSpellsState extends State<AllSpells> {
  final AllSpellsViewModel vm = AllSpellsViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<AllSpellsViewModel>(
              context,
              listen: false,
            ).fetchAllSpells();
          },
          child: Text("Call Function"),
        ),
      ),
      floatingActionButton: const CustomSpeedDial(),
    );
  }
}
