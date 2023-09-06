// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart' as sql;
//
//
// class SQLHelper {
//   static const _databaseUser = 'database_user.db';
//
//   static Future<sql.Database> db() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseUser,);
//     return sql.openDatabase(
//       path,
//       version: 1,
//        onCreate:
//            (sql.Database database, int version) async {
//             await createTablesLogin(database,version);
//       },
//     );
//   }
//   static Future<void> createTablesLogin(sql.Database database, int version) async {
//     await database.execute("""CREATE TABLE User(
//         account TEXT PRIMARY KEY NOT NULL,
//         password TEXT
//       )""");
//   }
//
//   static Future<void> createData(String account, String? password) async {
//     final db = await SQLHelper.db();
//     final data = {'account': account, 'password': password};
//     await db.insert('User', data);
//   }
//
//   static Future<List<Map<String, dynamic>>> getAllData() async{
//     final db = await SQLHelper.db();
//     return db.query('User');
//   }
//
//   static Future<List<Map<String, dynamic>>>doLogin({required String account, required String password}) async {
//     final db = await SQLHelper.db();
//     return db.query('User', where: 'account=? and password=?', whereArgs: [account, password]);
//   }
//
// }