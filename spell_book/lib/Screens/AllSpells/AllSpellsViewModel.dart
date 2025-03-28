import 'package:flutter/material.dart';
import 'package:spell_book/Models/SpellIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'package:spell_book/Models/Spell.dart';

class AllSpellsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<SpellIndex> spellIndexList = [];
  Spell currSpell = getMockSpell();

  Future<void> fetchSpellDetails(String spellIndex) async {
    try {
      isLoading = true;
      notifyListeners();
      final url = 'https://www.dnd5eapi.co/api/spells/$spellIndex';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        currSpell = Spell.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load spell details');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Spell>> getSpells() async {
    final prefs = await sp.SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<Spell> spells = [];

    for (var key in keys) {
      if (key.startsWith('spell_')) {
        final spellJson = prefs.getString(key);
        if (spellJson != null) {
          final Map<String, dynamic> spellMap = jsonDecode(spellJson);
          final spell = Spell.fromJson(spellMap);
          spells.add(spell);
        }
      }
    }

    return spells;
  }

  bool containsSpell(List<Spell> spellList, String spellIndex) {
    return spellList.any((spell) => spell.index == spellIndex);
  }

  Future<void> saveSpell(Spell spell) async {
    final prefs = await sp.SharedPreferences.getInstance();
    final spells = await getSpells();
    if (!containsSpell(spells, spell.index)) {
      try {
        final spellJson = jsonEncode({
          'index': spell.index,
          'name': spell.name,
          'desc': spell.desc,
          'higher_level': spell.higherLevel,
          'range': spell.range,
          'components': spell.components,
          'material': spell.material,
          'ritual': spell.ritual,
          'duration': spell.duration,
          'concentration': spell.concentration,
          'casting_time': spell.castingTime,
          'level': spell.level,
          'attack_type': spell.attackType,
          'damage':
              spell.damage != null
                  ? {
                    'damage_type':
                        spell.damage.damageType != null
                            ? {
                              'index': spell.damage.damageType.index,
                              'name': spell.damage.damageType.name,
                              'url': spell.damage.damageType.url,
                            }
                            : null,
                    'damage_at_slot_level': spell.damage.damageAtSlotLevel?.map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  }
                  : null,
          'school':
              spell.school != null
                  ? {
                    'index': spell.school.index,
                    'name': spell.school.name,
                    'url': spell.school.url,
                  }
                  : null,
          'classes':
              spell.classes
                  ?.map(
                    (spellClass) => {
                      'index': spellClass.index,
                      'name': spellClass.name,
                      'url': spellClass.url,
                    },
                  )
                  ?.toList(),
          'subclasses':
              spell.subclasses
                  ?.map(
                    (subclass) => {
                      'index': subclass.index,
                      'name': subclass.name,
                      'url': subclass.url,
                    },
                  )
                  ?.toList(),
          'url': spell.url,
          'updated_at': spell.updatedAt.toIso8601String(),
        });

        await prefs.setString('spell_${spell.index}', spellJson);
        notifyListeners();
      } catch (e) {
        print('Error encoding spell: $e');
      }
    }
  }

  Future<void> getSpellIndexes(Function(bool) updateLoadingState) async {
    try {
      final spellIndexUrl = 'https://www.dnd5eapi.co/api/2014/spells';
      final response = await http.get(Uri.parse(spellIndexUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'];

        List<SpellIndex> spellIndexes = SpellIndex.fromJsonList(results);

        spellIndexList = spellIndexes;
        updateLoadingState(false);
      } else {
        throw Exception('Failed to load spell index');
      }
    } catch (e) {
      print('Error fetching spell indexes: $e');
      updateLoadingState(false); // Stop loading even if there's an error
    }
  }
}


  // Future<List<Spell>> fetchAllSpellDetails(
  //   List<SpellIndex> spellIndexes,
  // ) async {
  //   List<Spell> fullSpells = [];

  //   for (var spellIndex in spellIndexes) {
  //     try {
  //       Spell fullSpell = await fetchSpellDetails(spellIndex.index);
  //       fullSpells.add(fullSpell);
  //     } catch (e) {
  //       print('Error fetching spell details for ${spellIndex.name}: $e');
  //     }
  //   }

  //   // Return the list of full spells
  //   return fullSpells;
  // }

  // void getSpellIndexesAndFetchDetails() async {
  //   try {
  //     final spellIndexUrl = 'https://www.dnd5eapi.co/api/2014/spells';
  //     final response = await http.get(Uri.parse(spellIndexUrl));

  //     if (response.statusCode == 200) {
  //       // Decode the spell index JSON response
  //       final jsonData = jsonDecode(response.body);
  //       List<dynamic> results = jsonData['results'];

  //       List<SpellIndex> spellIndexes = SpellIndex.fromJsonList(results);

  //       List<Spell> fullSpells = await fetchAllSpellDetails(spellIndexes);

  //       print('Fetched all spell details:');
  //       fullSpells.forEach((spell) {
  //         print('Spell Name: ${spell.name}');
  //       });
  //       spellList = fullSpells;
  //     } else {
  //       throw Exception('Failed to load spell index');
  //     }
  //   } catch (e) {
  //     print('Error fetching spell indexes: $e');
  //     throw Exception('Error fetching spell indexes: $e');
  //   }
  // }