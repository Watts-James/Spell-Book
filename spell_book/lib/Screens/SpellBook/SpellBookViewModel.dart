import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpellBookViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<Spell> spellList = [];
  Spell currSpell = getMockSpell();

  Future<List<Spell>> getSpells(Function(bool) updateLoadingState) async {
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
    updateLoadingState(false);
    spellList = spells;
    return spells;
  }

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

  void setCurrSpell(Spell spell) {
    currSpell = spell;
  }

  //   Future<void> saveSpell(Spell spell) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final spellJson = jsonEncode({
  //     'index': spell.index,
  //     'name': spell.name,
  //     'desc': spell.desc,
  //     'higher_level': spell.higherLevel,
  //     'range': spell.range,
  //     'components': spell.components,
  //     'material': spell.material,
  //     'ritual': spell.ritual,
  //     'duration': spell.duration,
  //     'concentration': spell.concentration,
  //     'casting_time': spell.castingTime,
  //     'level': spell.level,
  //     'attack_type': spell.attackType,
  //     'damage': {
  //       'damage_type': {
  //         'index': spell.damage.damageType.index,
  //         'name': spell.damage.damageType.name,
  //         'url': spell.damage.damageType.url,
  //       },
  //       'damage_at_slot_level': spell.damage.damageAtSlotLevel,
  //     },
  //     'school': {
  //       'index': spell.school.index,
  //       'name': spell.school.name,
  //       'url': spell.school.url,
  //     },
  //     'classes': spell.classes
  //         .map((spellClass) => {
  //               'index': spellClass.index,
  //               'name': spellClass.name,
  //               'url': spellClass.url
  //             })
  //         .toList(),
  //     'subclasses': spell.subclasses
  //         .map((subclass) => {
  //               'index': subclass.index,
  //               'name': subclass.name,
  //               'url': subclass.url
  //             })
  //         .toList(),
  //     'url': spell.url,
  //     'updated_at': spell.updatedAt.toIso8601String(),
  //   });

  //   await prefs.setString('spell_${spell.index}', spellJson);
  // }
}