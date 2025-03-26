import 'dart:convert';

class SpellIndex {
  final String index;
  final String name;
  final int level;
  final String url;

  SpellIndex({
    required this.index,
    required this.name,
    required this.level,
    required this.url,
  });

  factory SpellIndex.fromJson(Map<String, dynamic> json) {
    return SpellIndex(
      index: json['index'],
      name: json['name'],
      level: json['level'],
      url: json['url'],
    );
  }

  // A static method to decode the list of spells
  static List<SpellIndex> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SpellIndex.fromJson(json)).toList();
  }
}
