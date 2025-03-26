import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:spell_book/Models/SpellIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class AllSpellsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Spell> spellList = [];
  List<SpellIndex> spellIndexList = [];

  // Method to fetch spell details
  Future<Spell> fetchSpellDetails(String spellIndex) async {
    print('fetching: $spellIndex');
    final url = 'https://www.dnd5eapi.co/api/2014/spells/$spellIndex';

    // Send a GET request to the API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the request is successful, parse the response
      return Spell.fromJson(jsonDecode(response.body));
    } else {
      // If the request fails, throw an exception
      throw Exception('Failed to load spell details');
    }
  }

  Future<List<Spell>> fetchAllSpellDetails(
    List<SpellIndex> spellIndexes,
  ) async {
    List<Spell> fullSpells = [];

    for (var spellIndex in spellIndexes) {
      try {
        // Fetch full spell details for each index
        Spell fullSpell = await fetchSpellDetails(spellIndex.index);
        fullSpells.add(fullSpell);
      } catch (e) {
        // Handle any errors (optional)
        print('Error fetching spell details for ${spellIndex.name}: $e');
      }
    }

    // Return the list of full spells
    return fullSpells;
  }

  void getSpellIndexesAndFetchDetails() async {
    try {
      // Example: Fetch spell index data (you may have already done this part)
      final spellIndexUrl = 'https://www.dnd5eapi.co/api/2014/spells';
      final response = await http.get(Uri.parse(spellIndexUrl));

      if (response.statusCode == 200) {
        // Decode the spell index JSON response
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'];

        // Convert to a list of SpellIndex objects
        List<SpellIndex> spellIndexes = SpellIndex.fromJsonList(results);

        // Fetch full spell details for each spell index and store in Spells
        List<Spell> fullSpells = await fetchAllSpellDetails(spellIndexes);

        // You can now use the fullSpells list
        print('Fetched all spell details:');
        fullSpells.forEach((spell) {
          print('Spell Name: ${spell.name}');
        });
        spellList = fullSpells;
      } else {
        throw Exception('Failed to load spell index');
      }
    } catch (e) {
      print('Error fetching spell indexes: $e');
      throw Exception('Error fetching spell indexes: $e');
    }
  }

  void getSpellIndexes() async {
    print("inside get spell indexes");
    try {
      final spellIndexUrl = 'https://www.dnd5eapi.co/api/2014/spells';
      final response = await http.get(Uri.parse(spellIndexUrl));

      print(response.statusCode);
      if (response.statusCode == 200) {
        // Decode the spell index JSON response
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'];

        // Convert to a list of SpellIndex objects
        List<SpellIndex> spellIndexes = SpellIndex.fromJsonList(results);
        spellIndexList = spellIndexes;

        print(spellIndexList);
      } else {
        throw Exception('Failed to load spell index');
      }
    } catch (e) {
      print('Error fetching spell indexes: $e');
      throw Exception('Error fetching spell indexes: $e');
    }
  }
}
