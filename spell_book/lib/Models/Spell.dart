import 'dart:convert';

class Spell {
  final String index;
  final String name;
  final List<String> desc;
  final List<String> higherLevel;
  final String range;
  final List<String> components;
  final String? material;
  final bool ritual;
  final String duration;
  final bool concentration;
  final String castingTime;
  final int level;
  final String? attackType;
  final Damage damage;
  final School school;
  final List<SpellClass> classes;
  final List<Subclass> subclasses;
  final String url;
  final DateTime updatedAt;

  Spell({
    required this.index,
    required this.name,
    required this.desc,
    required this.higherLevel,
    required this.range,
    required this.components,
    this.material,
    required this.ritual,
    required this.duration,
    required this.concentration,
    required this.castingTime,
    required this.level,
    this.attackType,
    required this.damage,
    required this.school,
    required this.classes,
    required this.subclasses,
    required this.url,
    required this.updatedAt,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      index: json['index'] ?? '',
      name: json['name'] ?? '',
      desc: List<String>.from(json['desc'] ?? []),
      higherLevel: List<String>.from(json['higher_level'] ?? []),
      range: json['range'] ?? '',
      components: List<String>.from(json['components'] ?? []),
      material: json['material'],
      ritual: json['ritual'] ?? false,
      duration: json['duration'] ?? '',
      concentration: json['concentration'] ?? false,
      castingTime: json['casting_time'] ?? '',
      level: json['level'] ?? 0,
      attackType: json['attack_type'],
      damage:
          json['damage'] != null
              ? Damage.fromJson(json['damage'])
              : Damage(
                damageType: DamageType(index: '', name: '', url: ''),
                damageAtSlotLevel: {},
              ),
      school:
          json['school'] != null
              ? School.fromJson(json['school'])
              : School(index: '', name: '', url: ''),
      classes:
          (json['classes'] as List?)
              ?.map((e) => SpellClass.fromJson(e))
              .toList() ??
          [],
      subclasses:
          (json['subclasses'] as List?)
              ?.map((e) => Subclass.fromJson(e))
              .toList() ??
          [],
      url: json['url'] ?? '',
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }
}

class Damage {
  final DamageType damageType;
  final Map<int, String> damageAtSlotLevel;

  Damage({required this.damageType, required this.damageAtSlotLevel});

  factory Damage.fromJson(Map<String, dynamic> json) {
    return Damage(
      damageType: DamageType.fromJson(json['damage_type']),
      damageAtSlotLevel:
          json['damage_at_slot_level'] != null
              ? Map<int, String>.from(
                json['damage_at_slot_level'].map(
                  (key, value) => MapEntry(int.parse(key), value),
                ),
              )
              : {}, // Return an empty map if 'damage_at_slot_level' is null
    );
  }
}

class DamageType {
  final String index;
  final String name;
  final String url;

  DamageType({required this.index, required this.name, required this.url});

  factory DamageType.fromJson(Map<String, dynamic> json) {
    return DamageType(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class School {
  final String index;
  final String name;
  final String url;

  School({required this.index, required this.name, required this.url});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(index: json['index'], name: json['name'], url: json['url']);
  }
}

class SpellClass {
  final String index;
  final String name;
  final String url;

  SpellClass({required this.index, required this.name, required this.url});

  factory SpellClass.fromJson(Map<String, dynamic> json) {
    return SpellClass(
      index: json['index'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class Subclass {
  final String index;
  final String name;
  final String url;

  Subclass({required this.index, required this.name, required this.url});

  factory Subclass.fromJson(Map<String, dynamic> json) {
    return Subclass(index: json['index'], name: json['name'], url: json['url']);
  }
}

Spell getMockSpell() {
  return Spell(
    index: 'fireball',
    name: 'Fireball',
    desc: [
      'A bright streak flashes from your pointing finger to a point you choose.',
    ],
    higherLevel: [
      'When you cast this spell using a spell slot of 4th level or higher, the damage increases.',
    ],
    range: '150 feet',
    components: ['V', 'S', 'M'],
    material: 'A tiny ball of bat guano and sulfur',
    ritual: false,
    duration: 'Instantaneous',
    concentration: false,
    castingTime: '1 action',
    level: 3,
    attackType: 'ranged',
    damage: Damage(
      damageType: DamageType(
        index: 'fire',
        name: 'Fire',
        url: '/api/damage-types/fire',
      ),
      damageAtSlotLevel: {3: '8d6', 4: '9d6', 5: '10d6'},
    ),
    school: School(
      index: 'evocation',
      name: 'Evocation',
      url: '/api/magic-schools/evocation',
    ),
    classes: [
      SpellClass(index: 'wizard', name: 'Wizard', url: '/api/classes/wizard'),
      SpellClass(
        index: 'sorcerer',
        name: 'Sorcerer',
        url: '/api/classes/sorcerer',
      ),
    ],
    subclasses: [
      Subclass(index: 'evoker', name: 'Evoker', url: '/api/subclasses/evoker'),
    ],
    url: '/api/spells/fireball',
    updatedAt: DateTime.now(),
  );
}
