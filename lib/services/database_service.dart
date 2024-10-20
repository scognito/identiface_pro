import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  late final DatabaseFactory _dbFactory;
  late final Database _db;

  final String dbName = 'database.db';
  static const String usersStoreName = 'users';

  DatabaseService() {
    // Use Web database factory if running on the web, otherwise use IO
    if (kIsWeb) {
      _dbFactory = databaseFactoryWeb;
    } else {
      _dbFactory = databaseFactoryIo;
    }
  }

  Future<void> init() async {
    if (!kIsWeb) {
      // For mobile and desktop, get the application documents directory
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, dbName);
      _db = await _dbFactory.openDatabase(dbPath);
    } else {
      // For the web, directly open the database
      _db = await _dbFactory.openDatabase(dbName);
    }
  }

  Future<String?> getItemByKey(String storeName, String key) async {
    final store = StoreRef<String, String>(storeName);

    final finder = Finder(filter: Filter.byKey(key));
    final recordSnapshot = await store.findFirst(_db, finder: finder);

    return recordSnapshot?.value;
  }

  Future<void> updateItem(String storeName, String key, String value) async {
    final store = StoreRef<String, String>(storeName);
    await store.record(key).put(_db, value);
  }

  Future<void> deleteItem(String storeName, String key) async {
    final store = StoreRef<String, String>(storeName);
    await store.record(key).delete(_db);
  }

  // untested
  Future<List<Map<String, dynamic>>> getItems(String storeName) async {
    final store = intMapStoreFactory.store(storeName);
    final records = await store.find(_db);
    return records.map((snapshot) => snapshot.value).toList();
  }

  Future<void> clearStore(String storeName) async {
    final store = intMapStoreFactory.store(storeName);
    await store.delete(_db);
  }
}
