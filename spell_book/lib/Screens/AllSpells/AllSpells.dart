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
  bool isLoading = true;

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
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF939c6c),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SpellDetailPage(
                    spell: vm.currSpell,
                    buttonAction: (spell) => vm.saveSpell(spell),
                  );
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
      backgroundColor: Color(0xFFF0E6D2),
      appBar: AppBar(
        backgroundColor: Color(0xFF939c6c),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF939c6c)),
                ),
              )
              : ListView.builder(
                itemCount: vm.spellIndexList.length,
                itemBuilder: (context, index) {
                  final spell = vm.spellIndexList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        _showSheet(context, spell);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spell.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Level: ${spell.level}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[600],
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: const CustomSpeedDial(),
    );
  }
}
