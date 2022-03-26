import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:transaccion/data/lectura.dart';
import 'package:transaccion/data/insertar_lectura.dart';

class DatabaseHandlerLectura {

  Future<Database> initializeDB() async {

    late DatabaseHandlerLectura handler;

    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'transaccion.db'),
      onCreate: (database, version) async {
            //await addLectura();
      },
      version: 1,
    );
  }

  armarCondicion(String query) {

    query = query.trim();

    if ( query.indexOf(',') != -1 )
      if (  query.substring(query.length -1, query.length) == ',')
        query = "l.documento in(" + query.substring(0, query.length -1) + ")";
        else query = "l.documento in(" + query + ")";
    else
    if ( query.length == 0 )
      query = "l.documento > 0";
    else
    if ( query.trim().toUpperCase() == 'TOM' )
      query = "l.ejecucion = 1";
    else
    if ( query.trim().toUpperCase() == 'ACT' )
      query = "l.ejecucion = 0";
    else query = "( l.documento = '" + query + "' or l.direccion like '%" + query + "%' )";

    return 'l.novedad = r.registro and ' + query ; //
  }

  Future<List<Lectura>> retrieveLecturas(String condicion) async {

    condicion = armarCondicion(condicion);
    print('$condicion');

    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('lectura l, g_registro r', //
        where: '$condicion',
        orderBy: 'l.id' );

//    List<Map> maps = await db.query(tableTodo,
//        columns: [columnId, columnDone, columnTitle],
//        where: '$columnId = ?',
//        whereArgs: [id]);

    return queryResult.map((e) => Lectura.fromMap(e)).toList();
  }

  Future<List<Lectura>> retrieveLectura( String condicion, String actual, String desplazamiento ) async {

    condicion = armarCondicion(condicion);
    if (condicion.length == 0)
      condicion = '1 = 1';

    switch (desplazamiento) {
      case 'P': // primero
        condicion = 'l.id = (select min(l.id) from lectura l where ' + condicion.substring(27, condicion.length) +' )';
        break;
      case 'A': // anterior
        condicion = 'l.id = (select max(l.id) from lectura l where l.id < ' + actual + ' and ' + condicion.substring(27, condicion.length) + ' )';
        break;
      case 'S': // siguiente
        condicion = 'l.id = (select min(l.id) from lectura l where l.id > ' + actual + ' and ' + condicion.substring(27, condicion.length) + ' )';
        break;
      case 'U': // último
        condicion = 'l.id = (select max(l.id) from lectura l where ' + condicion.substring(27, condicion.length) +' )';
        break;
    }
    condicion = 'l.novedad = r.registro and ' + condicion;

    print('******************************Condición: $condicion');
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult =
    await db.query(
        'lectura l, g_registro r',
        where: '$condicion',
    );
    return queryResult.map((e) => Lectura.fromMap(e)).toList();
  }

  Future<int> addLectura() async {

    await ejecutar("insert into g_registro "
        "(registro, descripcion, tabla)"
        "values(1, 'RESERVA DEL VERGEL', 100)" );

    await ejecutar("insert into g_registro "
        "(registro, descripcion, tabla)"
        "values(2, 'ALTOS DEL VERGEL', 100)" );

    await ejecutar("insert into lectura "
    "(id, documento, direccion, adicional, municipio, medidor, anterior, actual, novedad, observacion, ejecucion, proceso, descripcion)"
    "values(6, 100001, 'RESERVA DEL VERGEL APTO 666', 'Reserva', 'Ibagué', '1', '1.000', '1.000', 24901, '', 0, 1, 'Lecturas prueba')" );

    InsertarLectura lecturaA = InsertarLectura(id: 1, documento: 100001, direccion: "RESERVA DEL VERGEL APTO 401", adicional: "Reserva", municipio: "Ibagué",
        medidor: "1", anterior: "1.000", actual: "1.000", novedad: 24901, observacion: "",
        ejecucion: 0, proceso: 1, descripcion: 'Lecturas prueba');

    InsertarLectura lecturaB = InsertarLectura(id: 2, documento: 100002, direccion: "RESERVA DEL VERGEL APTO 402", adicional: "Reserva", municipio: "Ibagué",
        medidor: "2", anterior: "2.000", actual: "2.000", novedad: 24901, observacion: "",
        ejecucion: 0, proceso: 1, descripcion: 'Lecturas prueba');

    InsertarLectura lecturaC = InsertarLectura(id: 3, documento: 100003, direccion: "RESERVA DEL VERGEL APTO 403", adicional: "Reserva", municipio: "Ibagué",
        medidor: "3", anterior: "3.000", actual: "3.000", novedad: 24901, observacion: "",
        ejecucion: 0, proceso: 1, descripcion: 'Lecturas prueba');

    InsertarLectura lecturaD = InsertarLectura(id: 4, documento: 100004, direccion: "RESERVA DEL VERGEL APTO 404", adicional: "Reserva", municipio: "Ibagué",
        medidor: "4", anterior: "4.000", actual: "4.000", novedad: 24901, observacion: "",
        ejecucion: 0, proceso: 1, descripcion: 'Lecturas prueba');

    InsertarLectura lecturaE = InsertarLectura(id: 5, documento: 100005, direccion: "RESERVA DEL VERGEL APTO 405", adicional: "Reserva", municipio: "Ibagué",
        medidor: "5", anterior: "5.000", actual: "5.000", novedad: 24901, observacion: "",
        ejecucion: 0, proceso: 1, descripcion: 'Lecturas prueba');

    List<InsertarLectura> listOfLecturas = [
      lecturaA, lecturaB, lecturaC, lecturaD, lecturaE
    ];
    return await this.insertLectura(listOfLecturas);
  }

  Future<int> insertLectura(List<InsertarLectura> listLecturas) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var user in listLecturas){
      result = await db.insert('lectura', user.toMap());
    }
    return result;
  }

  Future<void> deleteLectura(int id) async {
    final db = await initializeDB();
    if (id != 0 ) {
      await db.delete('lectura',
        where: "id = ? ",
        whereArgs: [id],);
    }
    else {
      await db.delete('lectura',);
    }
  }

  Future<void> ejecutar(String sentencia) async {
    final db = await initializeDB();
    await db.execute(sentencia);
  }

  /// Update using sqflite helper
  /// newData example :-
  /// var newData = {"id": "johndoe92", "name": "John Doe", "email":"abc@example.com", "age": 28}
  ///

  Future updateUsingHelper(newData) async {

    print(newData);
    final db = await initializeDB();
    var res = await db.update('lectura', newData,
        where: "id = ? ",
        whereArgs: [newData['id']], );
    return res;
  }

  Future insertUsingHelper(newData) async {

    print('I N S E R T ...');

    print(newData);
    final db = await initializeDB();
    var res = await db.insert('lectura', newData);
    return res;
  }

}
