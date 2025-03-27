import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:spell_book/Models/SpellIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllSpellsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Spell> spellList = [];
  List<SpellIndex> spellIndexList = [];
  Spell currSpell = getMockSpell();

  Future<void> fetchSpellDetails(String spellIndex) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify UI that loading has started

      print('Fetching: $spellIndex');
      final url = 'https://www.dnd5eapi.co/api/spells/$spellIndex';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        currSpell = Spell.fromJson(jsonDecode(response.body)); // Update spell
      } else {
        throw Exception('Failed to load spell details');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
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
