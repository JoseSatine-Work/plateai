import 'package:flutter_application_1/app/Controllers/storage_controller.dart';
import 'package:flutter_application_1/app/Models/item.dart';

class ItemRepository {
  final dbHelper = StorageController.instance;

  Future<void> insertItem(Item item) async {
    final db = await dbHelper.database;
    await db.insert('items', item.toMap());
  }

  Future<List<Item>> fetchItems() async {
    final db = await dbHelper.database;
    final maps = await db.query('items');
    return List.generate(
      maps.length,
      (i) => Item.fromMap(maps[i]),
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await dbHelper.database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
