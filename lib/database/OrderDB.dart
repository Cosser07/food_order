import 'dart:io';
import 'package:foodonlineshop/model/order_item.dart';
import 'package:foodonlineshop/model/food_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class OrderDB {
  String dbName;

  OrderDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertOrder(OrderItem order) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('orders'); // ใช้ store ชื่อ 'orders'

    Future<int> keyID = store.add(db, order.toJson());
    db.close();
    return keyID;
  }

  Future<List<OrderItem>> loadAllOrders() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('orders');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('id', false)])); // เรียงตาม id

    List<OrderItem> orders = [];

    for (var record in snapshot) {
      OrderItem order = OrderItem.fromJson(record.value as Map<String, dynamic>);
      order.id = record.key.toString(); // ใช้ key จาก Sembast เป็น id
      orders.add(order);
    }
    db.close();
    return orders;
  }

  Future<void> deleteOrder(String id) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('orders');
    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, int.parse(id))),
    );
    db.close();
  }

  Future<void> updateOrder(OrderItem order) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('orders');

    await store.update(
      db,
      order.toJson(),
      finder: Finder(filter: Filter.equals(Field.key, int.parse(order.id))),
    );

    db.close();
  }
}