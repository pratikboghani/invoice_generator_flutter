import 'dart:io';
import 'package:invoice_generator/components/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/note.dart';
import '../components/utils.dart';

class DatabaseHelper {
  static const dbname = 'items.db';
  static const dbversion = 1;
  DatabaseHelper._pc();
  static final DatabaseHelper instance = DatabaseHelper._pc();
  // static Database _database;
  Future<Database> get database async {
    // if (database != null) return database;
    Database database = await _initDatabase();
    return database;
  }

  _initDatabase() async {
    Directory datadir = await getApplicationDocumentsDirectory();
    String dbPath = join(datadir.path, dbname);
    return await openDatabase(dbPath,
        version: dbversion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Item.tblname}(
    ${Item.iname} TEXT NOT NULL
    )
    ''');
    await db.insert(
        Item.tblname, Item(iName: '2.MP 4B08 8 CH DAHUVA DVR').toMap());
    await db.insert(
        Item.tblname, Item(iName: '2.MP 4A08 8 CH DAHUVA DVR').toMap());
    await db.insert(Item.tblname, Item(iName: '2 TB WD HDD').toMap());
    await db.insert(Item.tblname, Item(iName: '1 TB WD HDD').toMap());
    await db.insert(Item.tblname, Item(iName: '4 TB WD & TOSHIBA HDD').toMap());
    await db.insert(Item.tblname, Item(iName: '8 CH POWER SUPPLY').toMap());
    await db.insert(Item.tblname, Item(iName: '4 CH POWER SUPPLY').toMap());
    await db.insert(Item.tblname, Item(iName: '16 CH POWER SUPPLY').toMap());
    await db.insert(Item.tblname, Item(iName: 'BNC+DC PIN').toMap());
    await db.insert(Item.tblname, Item(iName: 'SOLID 3+1 CABLE/MTR').toMap());
    await db.insert(Item.tblname, Item(iName: 'IMSTALLATION CHARGE').toMap());
    await db.execute('''
    CREATE TABLE ${InvoiceData.tblname}(
    ${InvoiceData.year} TEXT NOT NULL,
    ${InvoiceData.invoiceNumber} TEXT NOT NULL
    )
    ''');
    await db.insert(
        InvoiceData.tblname,
        InvoiceData(
                iNumber: '1',
                iYear: Utils.formatYear(DateTime.now()).toString())
            .toMap());
  }

  Future<int> insert(Item i) async {
    Database db = await database;
    return await db.insert(Item.tblname, i.toMap());
  }

  Future<int> insertInvoice(InvoiceData i) async {
    Database db = await database;
    return await db.insert(InvoiceData.tblname, i.toMap());
  }

  Future<int> update(Item i) async {
    Database db = await database;
    return await db.update(Item.tblname, i.toMap(),
        where: '${Item.iname}=?', whereArgs: [i.iName]);
  }

  Future<int> updateInvoice(InvoiceData i) async {
    Database db = await database;
    return await db.update(InvoiceData.tblname, i.toMap());
  }

  Future<int> delete(String strName) async {
    Database db = await database;
    return await db
        .delete(Item.tblname, where: '${Item.iname}=?', whereArgs: [strName]);
  }

  Future<List<Item>> fetchItems() async {
    Database db = await database;
    List<Map<String, dynamic>> items = await db.query(Item.tblname);
    return items.length == 0 ? [] : items.map((e) => Item.fromMap(e)).toList();
  }

  Future<List<InvoiceData>> fetchInvoice() async {
    Database db = await database;
    List<Map<String, dynamic>> invdatalist =
        await db.query(InvoiceData.tblname);
    return invdatalist.length == 0
        ? []
        : invdatalist.map((e) => InvoiceData.fromMap(e)).toList();
  }
}
