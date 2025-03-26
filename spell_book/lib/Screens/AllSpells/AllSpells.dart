import 'package:flutter/material.dart';
import 'package:spell_book/Widgets/SpeedDial.dart';
import 'package:spell_book/Screens/AllSpells/AllSpellsViewModel.dart';
import 'package:spell_book/Models/SpellIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllSpells extends StatefulWidget {
  const AllSpells({super.key, required this.title});
  final String title;

  @override
  State<AllSpells> createState() => _AllSpellsState();
}

class _AllSpellsState extends State<AllSpells> {
  final AllSpellsViewModel vm = AllSpellsViewModel();
  bool isLoading = true; // A flag to track loading state

  @override
  void initState() {
    super.initState();
    if (vm.spellIndexList.isEmpty) {
      print("Fetching spells...");
      // Call the method in the ViewModel and pass the callback to update loading state
      vm.getSpellIndexes((bool loadingState) {
        setState(() {
          isLoading = loadingState;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading spinner while fetching
              : ListView.builder(
                itemCount: vm.spellIndexList.length,
                itemBuilder: (context, index) {
                  final spell = vm.spellIndexList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        spell.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Level: ${spell.level}'),
                    ),
                  );
                },
              ),
      floatingActionButton: const CustomSpeedDial(),
    );
  }
}
