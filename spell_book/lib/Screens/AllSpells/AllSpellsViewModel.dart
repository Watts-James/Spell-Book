import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllSpellsViewModel extends ChangeNotifier {
  // final Spell _spell = Spell(name: 'Test Spell', level: 9);

  // Spell get spell => _spell;

  // Post? post;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAllSpells() async {
    //  http.get(Uri.parse('https://www.dnd5eapi.co/api/2014/spells'));
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://www.dnd5eapi.co/api/2014/spells'),
      );

      if (response.statusCode == 200) {
        // post = Post.fromJson(json.decode(response.body));
        final data = jsonDecode(response.body);

        print("data: $data");
      } else {
        errorMessage = "Failed to load post";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
