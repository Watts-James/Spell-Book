import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

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
    notifyListeners();
    return spells;
  }

  Future<void> getSpellStorage(String spellIndex) async {
    final prefs = await sp.SharedPreferences.getInstance();
    try {
      final spellJson = prefs.getString('spell_$spellIndex');
      if (spellJson == null) {
        return null; // Return null if no spell was found
      }
      final Map<String, dynamic> spellMap = jsonDecode(spellJson);
      currSpell = Spell.fromJson(spellMap); // Convert JSON to Spell model
    } catch (e) {
      print('Error retrieving spell: $e');
      return null; // Return null if there was an error
    }
  }

  Future<void> fetchSpellDetails(String spellIndex) async {
    try {
      isLoading = true;
      notifyListeners();
      final url = 'https://www.dnd5eapi.co/api/spells/$spellIndex';
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        currSpell = Spell.fromJson(jsonDecode(response.body));
      } else {
        try {
          print("trying from storage");
          await getSpellStorage(spellIndex);
        } catch (e) {
          throw Exception('Failed to load spell details');
        }
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

  Future<void> deleteSpell(String spellIndex) async {
    final prefs = await sp.SharedPreferences.getInstance();
    await prefs.remove('spell_$spellIndex');
    // Refresh the spell list after deletion
    await getSpells((bool loadingState) {});
    notifyListeners(); // Notify listeners after the list is updated
  }
}
