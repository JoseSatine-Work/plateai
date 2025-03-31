import 'dart:convert';

class Item {
  final int? id;
  final String imagePath; // Path to the saved image
  final Map<String, dynamic> data;

  Item({this.id, required this.imagePath, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'data': jsonEncode(data), // Convert Map to JSON string
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      imagePath: map['imagePath'],
      data: jsonDecode(map['data']), // Convert JSON string back to Map
    );
  }
}
