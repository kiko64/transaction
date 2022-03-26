import 'package:transaccion/data/record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandlerRecord {

  Future<Database> initializeDB() async {

    late DatabaseHandlerRecord handler;

    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'transaccion.db'),
      onCreate: (database, version) async {
      },
      version: 1,
    );
  }


  armarCondicion(String condicion, query) {  // condición es sobre que tabla hacer la consulta,

    if ( query.length == 0 )
      query = condicion;
    else
    if ( query.indexOf(',') != -1 )
      if (  query.substring(query.length -1, query.length) == ',')
        query = 'registro in(' + query.substring(0, query.length -1) + ')';
      else query = 'registro in(' + query + ')';
    else
      query = condicion + " and (registro = '" +
        query + "' or descripcion like '%" + query + "%')";

    return query;
  }


  Future<List<Record>> retrieveRegistros(String condicion, busqueda) async {

    busqueda = armarCondicion(condicion, busqueda);
    print('retrieveRegistros.busqueda ${busqueda}');
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('m_registro',
        where: '$busqueda',
        orderBy: 'registro' );

//    List<Map> maps = await db.query(tableTodo,
//        columns: [columnId, columnDone, columnTitle],
//        where: '$columnId = ?',
//        whereArgs: [id]);

    return queryResult.map((e) => Record.fromMap(e)).toList();
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
