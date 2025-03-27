import 'package:flutter/material.dart';
import 'package:spell_book/Widgets/SpeedDial.dart';
import 'package:spell_book/Screens/AllSpells/AllSpellsViewModel.dart';
import 'SpellDetailPage.dart';

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
      vm.getSpellIndexes((bool loadingState) {
        setState(() {
          isLoading = loadingState;
        });
      });
    }
  }

  void _showSheet(BuildContext context, spell) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return FutureBuilder(
              future: vm.fetchSpellDetails(spell.index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SpellDetailPage(spell: vm.currSpell);
                }
              },
            );
          },
        );
      },
    );
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
                      onTap: () {
                        _showSheet(context, spell);
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: const CustomSpeedDial(),
    );
  }
}
