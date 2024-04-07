import 'package:code_edit/dtos/url.dart';
import 'package:sqflite/sqflite.dart';

class PhantomDatabase {
  static final PhantomDatabase instance = PhantomDatabase._internal();

  static Database? _database;

  PhantomDatabase._internal();

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${UrlFields.tableName} (
          ${UrlFields.id} ${UrlFields.idType},
          ${UrlFields.url} ${UrlFields.requiredTextType},
          ${UrlFields.apiKey} ${UrlFields.textType},
        )
      ''');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/notes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<UrlModel> create(UrlModel note) async {
    final db = await instance.database;
    final id = await db.insert(UrlFields.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<UrlModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      UrlFields.tableName,
      columns: UrlFields.values,
      where: '${UrlFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UrlModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<UrlModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query(UrlFields.tableName);
    return result.map((json) => UrlModel.fromJson(json)).toList();
  }
}
