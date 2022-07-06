import 'package:transaccion/data/record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:transaccion/utils/globals.dart' as globals;
import 'package:transaccion/services/database_handler_transaction.dart';

class DatabaseHandlerRecord {
  Future<Database> initializeDB() async {
//    late DatabaseHandlerTransaction handler;

    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'transaccion.db'),
      onCreate: (database, version) async {},
      version: 1,
    );
  }

  armarCondicion(String condicion, query) {
    // condición es sobre que tabla hacer la consulta,

    if (query.length == 0)
      query = condicion;
    else if (query.indexOf(',') !=
        -1) if (query.substring(query.length - 1, query.length) == ',')
      query = 'registro in(' + query.substring(0, query.length - 1) + ')';
    else
      query = 'registro in(' + query + ')';
    else
      query = condicion +
          " and (registro = '" +
          query +
          "' or descripcion like '%" +
          query +
          "%')";

    return query;
  }

  Future<List<Record>> retrieveRecords(String condicion, busqueda) async {
    
    print('retrieveTransactions - globals.instance - ${globals.instance}');
    if (globals.instance == 'Local')
      return await retrieveRecordsSqlLite(condicion, busqueda);
    else
      return await retrieveRecordsMySql(condicion, busqueda);
  }

  Future<List<Record>> retrieveRecordsSqlLite(
      String condicion, busqueda) async {

    busqueda = armarCondicion(condicion, busqueda);
    print('retrieveRegistros.busqueda ${busqueda}');


    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('m_registro', where: '$busqueda', orderBy: 'registro');

    return queryResult.map((e) => Record.fromMap(e)).toList();
  }

  Future<List<Record>> retrieveRecordsMySql(String condicion, busqueda) async {
    // MySql

    busqueda = armarCondicion(condicion, busqueda);
    print('(1/3) retrieveRegistrosMySql: Busqueda - ${busqueda}');

    String consulta =
        'SELECT registro, descripcion, tabla, parametro0, parametro1, parametro2, parametro3 ' +
            'FROM m_registro WHERE ' +
            busqueda +
            ' ORDER BY descripcion';
    print('(2/3) retrieveRecordsMySql: consulta - ${consulta}');
    final List<Record> queryResult = await retrieveRecordsMix(consulta);
    print('(3/3) retrieveRecordsMySql: queryResult - ${queryResult}');
    return queryResult.toList();
  }

  Future<dynamic> retrieveRecordsMix(String consulta) async {
    print('(1/4) retrieveRecordsMix: instanciando MySql');

    late DatabaseHandlerTransaction handler; // definir variable
    handler = DatabaseHandlerTransaction(); // instanciar la variable
    final connection = await handler.initializeDBMySql(); // Ya

    var queryResult = await connection.query(consulta);
    print(
        '(2/4) retrieveRecordsMix: queryResult - ${queryResult}'); // ${row[0]}  ${row[1]}

    final List<Record>? myList = [];
    for (var row in queryResult) {
      final Record myRecord = Record(
          registro: row['registro'],
          descripcion: row['descripcion'],
          tabla: row['tabla'],
          parametro0: row['parametro0'],
          parametro1: row['parametro1'],
          parametro2: row['parametro2'],
          parametro3: row['parametro3']);
      print(
          '(3/4) retrieveRecordsMix: myTransaction - ${myRecord.toString()}'); // ${row[0]}  ${row[1]}
      myList!.add(myRecord);
    }
    await connection.close();
    print('(4/4) retrieveRecordsMix: Mostrando myList - ${myList.toString()}');
    return myList;
  }

  Future<void> ejecutar(String sentencia) async {
    final db = await initializeDB();
    await db.execute(sentencia);
  }

  /// Update using sqflite helper
  /// newData example :-
  /// var newData = {"id": "johndoe92", "name": "John Doe", "email":"abc@example.com", "age": 28}
  ///

}
