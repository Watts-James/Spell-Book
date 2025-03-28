import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:spell_book/Screens/AllSpells/AllSpellsViewModel.dart';

class SpellDetailPage extends StatelessWidget {
  final Spell spell;
  final Future<void> Function(Spell) buttonAction;

  const SpellDetailPage({
    super.key,
    required this.spell,
    required this.buttonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spell Details', style: TextStyle(fontSize: 24)),
        backgroundColor: Color(0xFF939c6c),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () async {
              await buttonAction(spell);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spell.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),

              _buildSpellOverview(),

              Divider(thickness: 1, color: Colors.grey.shade400),

              _buildSectionTitle("Description"),
              ...spell.desc.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(line, style: TextStyle(fontSize: 16)),
                ),
              ),

              SizedBox(height: 12),

              if (spell.higherLevel.isNotEmpty) _buildHigherLevel(),

              Divider(thickness: 1, color: Colors.grey.shade400),

              _buildSectionTitle("Spell Effects"),
              _buildSpellEffects(),

              SizedBox(height: 12),

              _buildClassesAndSubclasses(),

              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpellOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level: ${spell.level}',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
        Text(
          'Range: ${spell.range}',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
        Text(
          'Casting Time: ${spell.castingTime}',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildHigherLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Higher Level Effects"),
        ...spell.higherLevel.map(
          (effect) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              effect,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpellEffects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEffectRow("Damage:", spell.damage.damageType.name),
        _buildEffectRow("Ritual:", spell.ritual ? "Yes" : "No"),
        _buildEffectRow("Concentration:", spell.concentration ? "Yes" : "No"),
        _buildEffectRow("Duration:", spell.duration),
      ],
    );
  }

  Widget _buildEffectRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesAndSubclasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Classes"),
        ...spell.classes.map(
          (spellClass) => Text(
            spellClass.name,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
        SizedBox(height: 8),
        _buildSectionTitle("Subclasses"),
        ...spell.subclasses.map(
          (subclass) => Text(
            subclass.name,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
