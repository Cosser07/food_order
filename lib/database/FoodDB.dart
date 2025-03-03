import 'dart:io';
import 'package:foodonlineshop/model/food_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FoodDB {
  String dbName;

  FoodDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertFood(FoodItem food) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('foods'); // ใช้ store ชื่อ 'foods'

    Future<int> keyID = store.add(db, food.toJson());
    db.close();
    return keyID;
  }

  Future<List<FoodItem>> loadAllFoods() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('foods');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('name', false)])); // เรียงตามชื่อ (หรือตาม id)

    List<FoodItem> foods = [];

    for (var record in snapshot) {
      FoodItem item = FoodItem.fromJson(record.value as Map<String, dynamic>);
      item.id = record.key.toString(); // ใช้ key จาก Sembast เป็น id
      foods.add(item);
    }
    db.close();
    return foods;
  }

  Future<void> deleteFood(String id) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('foods');
    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, int.parse(id))),
    );
    db.close();
  }

  Future<void> updateFood(FoodItem food) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('foods');

    await store.update(
      db,
      food.toJson(),
      finder: Finder(filter: Filter.equals(Field.key, int.parse(food.id))),
    );

    db.close();
  }
}