import 'package:flutter/material.dart';
import 'package:spell_book/Models/SpellIndex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'package:spell_book/Models/Spell.dart';

class AllSpellsViewModel extends ChangeNotifier {
  String? errorMessage;

  Future<void> saveSpell(Spell spell) async {
    final prefs = await sp.SharedPreferences.getInstance();
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
