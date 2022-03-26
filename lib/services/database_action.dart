import 'package:mysql1/mysql1.dart';
import 'package:sqflite/sqflite.dart';

import 'package:transaccion/data/record.dart';
import 'package:transaccion/data/insertar_lectura.dart';
import 'package:transaccion/services/database_handler_transaction.dart';
import 'database_handler_lectura.dart';

Future cargarTransation() async {  // Desde SlqLite -> MySql

  print(' ');
  print('(1/2) Instanciando y recorriendo SqlLite...');
  print(' ');

  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable

  final Database db = await handler.initializeDB(); // get a reference to the database
  List<Map> result = await db.rawQuery('SELECT * FROM m_ejecutar where seguimiento = 12601 order by ejecutar'); // raw query
  result.forEach((row) async { // Recorriendo SqlLite

    print(' ');
    print('(2/2) Datos: ${row}'); // {_id: 2, name: Mary, age: 32}
    print(' ');

    var newData = {"fecha": row['fecha'], "usuario": row['usuario'], "seguimiento": row['seguimiento'].toString(),
      "agenda": row['agenda'].toString(), "documento": row['documento'].toString(), "cuenta": row['cuenta'].toString(),
      "valor": row['valor'].toString(), "observacion": row['observacion'], "mascara": row['mascara'].toString(),
      "archivo0": row['archivo0'], "archivo1": row['archivo1'],
      "archivo2": row['archivo2'], "archivo3": row['archivo3']
    };

    await handler.insertUsingHelperMySql(newData);  // MySql

  });

//  await handler.ejecutar( "update m_registro set descripcion = '3' where registro = 70002"); // Actualizar realizo cargarLectura()
  return true;
}

Future descargarTransaction() async { // Desde MySql --> SqlLite
/*
    host: '200.118.224.78',
    port: 3306,
    user: 'root',
    password: 'Juan2008',
    db: 'gaso'

    host: '107.180.41.52',
    port: 3306,
    user: 'fk6xikl69rt5',
    password: 'F3*Oj1g9gmt*q0',
    db: 'ide0001'

    host: '161.18.227.2',
    port: 3306,
    user: 'root',
    password: 'Juan2008',
    db: 'finan'
*/

  Data dataReg;
  ConnectionSettings settings;

  dataReg = await getRegistro('70001 and tabla = 700') as Data;

  settings = new ConnectionSettings(
      host: '200.118.224.78',
      port: 3306,
      user: 'root',
      password: 'Juan2008',
      db: 'prueba'
  );

  if ( dataReg.p0.length > 0 )
    settings = new ConnectionSettings(
      host: dataReg.p0,
      port: int.parse(dataReg.p1),
      user: dataReg.p2,
      password: dataReg.p3,
      db: dataReg.p4,
    );

  print('(1/5) Iniciando...');
  var connection;
  try{
    /*
    ConnectionSettings settings = new ConnectionSettings(
        host: '200.118.224.78',
        port: 3306,
        user: 'root',
        password: 'Juan2008',
        db: 'prueba'
    );
    */
    print('(2/5) Conexión MySql...');
    connection = await MySqlConnection.connect(settings);
  }
  catch(e){
    print("Unable to connect." + e.toString() );
    return false;
  }

  print('(3/5) Instanciando SqlLite...');
  late DatabaseHandlerLectura handler;
  handler = DatabaseHandlerLectura(); // crear instancia
  await handler.deleteLectura(0); // borrar todos

  print('(4/5) Consulta MySql...');
  String consulta;
  consulta =
      "select le.lectura, co.documento, "
          + "dc.direccion, dc.adicional, mu.descripcion, "
          + "co.numero, le.anterior, le.actual, le.novedad, '' as observacion, "
          + "0 as ejecucion, 1 as proceso, 'Toma lecturas ciclo 1' "
          + "from v_anteriorlectura vl, lectura le, contador co, documento dc, g_registro mu "
          + "WHERE vl.anteriorlectura = le.lectura and le.contador = co.contador and co.documento = dc.documento "
          + "and dc.municipio = mu.registro and co.documento >= 100000 order by le.lectura";

  var results = await connection.query(consulta);
  for (var row in results) {
/*
    var newData = {
      "id": '${row[0]}', "documento": '${row[1]}',
      "direccion": '${row[2]}', "adicional": '${row[3]}', "municipio":'${row[4]}',
      "medidor": '${row[5]}', "anterior": '${row[6]}', "actual": '${row[7]}', "novedad": '${row[8]}', "observacion": '${row[9]}',
      "ejecucion": '${row[10]}', "proceso": '${row[11]}', "descripcion": '${row[12]}'
    };
    print( newData );
*/
    InsertarLectura insertar = InsertarLectura(
      id: row[0], documento: row[1],
      direccion: row[2], adicional: row[3], municipio: row[4],
      medidor: row[5], anterior: row[6].toString(), actual: row[7].toString(), novedad: row[8], observacion: row[9],
      ejecucion: row[10], proceso: row[11], descripcion: row[12]
    );

    List<InsertarLectura> listOfLecturas = [insertar];

    print('(5/5) Insertando SqlLite: ${row[0]}');

    await handler.insertLectura(listOfLecturas);
  }

  await handler.ejecutar( "update m_registro set descripcion = '2' where registro = 70002"); // Actualizar realizo descargarLectura()
  await connection.close(); // Finally, close the connection
  return true;
}

Future sincronizar() async {

  Data dataReg;
  ConnectionSettings settings;

  print('Empezar **************************************************************');
  dataReg = await getRegistro('70001 and tabla = 700') as Data;

  settings = new ConnectionSettings(
      host: '200.118.224.78',
      port: 3306,
      user: 'root',
      password: 'Juan2008',
      db: 'prueba'
  );
  if ( dataReg.p0.length > 0 ){
    print('Paso **************************************************************');
    settings = new ConnectionSettings(
      host: dataReg.p0,
      port: int.parse(dataReg.p1),
      user: dataReg.p2,
      password: dataReg.p3,
      db: dataReg.p4,
    );
  }

  int i, j;
  String consulta;

  print('(1/6) Iniciando...');
  var connection;
  try{
/*
    ConnectionSettings settings = new ConnectionSettings(

        host: '200.118.224.78',
        port: 3306,
        user: 'root',
        password: 'Juan2008',
        db: 'prueba'
    );
 */
    print('(2/6) Conexión MySql...');
    connection = await MySqlConnection.connect(settings);
  }
  catch(e){
    print("Unable to connect." + e.toString() );
    return false;
  }

  print('(3/6) Instanciando SqlLite...');
  late DatabaseHandlerTransaction handler;
  handler = DatabaseHandlerTransaction(); // crear instancia

  print('(4/6) Recuperar sentencia desde Mysql...');
  consulta = "select sentencia from g_consulta WHERE consulta = 700";

  var results = await connection.query(consulta);
  for (var row in results) {
    print('(5/6) Sentencias sincronización: ${row[0]}');
    consulta = row[0].toString();
  }

  while ( consulta.length > 0 ) {
    i = consulta.indexOf(";");
    if ( i == -1 )
      j = consulta.length;
    else j = i;

    print('(6/6) Ejecutando sentencia SqlLite: ${consulta.substring( 0 , j)}');
    await handler.ejecutar( consulta.substring( 0 , j) );

    if ( j + 1 >= consulta.length )
      consulta = "";  // No hay mas sentencias
    else {
      consulta = consulta.substring(i + 1, consulta.length ); // Continuar
      consulta = consulta.replaceAll(" +", " ").trim();
    }
  }
  await connection.close(); // Finally, close the connection
  return true;
}

Future getRegistro(String registro) async {

  var arr = ['','','','',''];
  print('(1/2) Instanciando SqlLite getRegistro...');
  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable
  final Database db = await handler.initializeDB(); // get a reference to the database
  List<Map> result = await db.rawQuery('SELECT registro, descripcion, tabla FROM m_registro '
  'where registro = ' + registro.toString() + ' order by registro'); // raw query

  result.forEach((row) async {
    print('(2/2) Mostrando SqlLite getRegistro ${row}');
    arr = row['descripcion'].toString().split('|');
  });

  var dataRegistro = Data(
    p0: arr[0].toString(),
    p1: arr[1].toString(),
    p2: arr[2].toString(),
    p3: arr[3].toString(),
    p4: arr[4].toString(),
  );

  return dataRegistro;
}

Future<Record?> getRegistroByRegistro(String registro) async {

  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable
  final Database db = await handler.initializeDB(); // get a reference to the database
  var result =

  await db.query("m_registro", where: 'registro = $registro');
  return result.map((e) => Record.fromMap(e)).first;
}

Future<Record> retrieveBusqueda(String busqueda, condicion ) async {

  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable
  final Database db = await handler.initializeDB(); // get a reference to the database
  var result =

  await db.rawQuery('SELECT ' + busqueda + ', tabla, parametro0, parametro1, parametro2, parametro3 '
      'from m_registro '
      'where ' + condicion );

//    List<Map> maps = await db.query(tableTodo,
//        columns: [columnId, columnDone, columnTitle],
//        where: '$columnId = ?',
//        whereArgs: [id]);

  return result.map((e) => Record.fromMap(e)).first;
}

Future verificarSqlLite() async {
  print('(1/2) Instanciando SqlLite...');
  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable
  final Database db = await handler.initializeDB(); // get a reference to the database
//  List<Map> result = await db.rawQuery('SELECT * FROM m_registro order by registro'); // raw query
  List<Map> result = await db.rawQuery('SELECT * FROM m_ejecutar order by 1'); // raw query
  result.forEach((row) async {
    print('  ');
    print('(2/2) Mostrando SqlLite ${row}');
//    row['actual'].toString();
  });
  return true;
}

Future verificarMySql() async { // Desde MySql --> SqlLite
/*
  Data dataReg;
  ConnectionSettings settings;

  dataReg = await getRegistro('70001 and tabla = 700') as Data;

  settings = new ConnectionSettings(
      host: '200.118.224.78',
      port: 3306,
      user: 'root',
      password: 'Juan2008',
      db: 'prueba'
  );

  if ( dataReg.p0.length > 0 )
    settings = new ConnectionSettings(
      host: dataReg.p0,
      port: int.parse(dataReg.p1),
      user: dataReg.p2,
      password: dataReg.p3,
      db: dataReg.p4,
    );

  print('(1/4) Iniciando conexión MySql...');
  var connection;
  try{
    /*
    ConnectionSettings settings = new ConnectionSettings(
        host: '200.118.224.78',
        port: 3306,
        user: 'root',
        password: 'Juan2008',
        db: 'prueba'
    );
    */
    print('(2/4) Conexión MySql...');
    connection = await MySqlConnection.connect(settings);
  }
  catch(e){
    print("Unable to connect." + e.toString() );
    return false;
  }
*/
  late DatabaseHandlerTransaction handler;  // definir variable
  handler = DatabaseHandlerTransaction(); // instanciar la variable

  var connection = await handler.initializeDBMySql('70001 and tabla = 700');

  print('(3/4) Recorrido MySql...');
  String consulta =
      "SELECT e.ejecutar, e.fecha, e.usuario, e.seguimiento, e.agenda, e.documento, " +
      "e.cuenta, e.valor, e.observacion, e.registro, e.mascara, " +
      "e.archivo0, e.archivo1, e.archivo2, e.archivo3, " +
      "a.descripcion as desAgenda, " +
      "a.parametro0 as parAgenda0, a.parametro1 as parAgenda1, a.parametro2 as parAgenda2, a.parametro3 as parAgenda3, " +
      "m.descripcion as desMascara, " +
      "d.descripcion as desDocumento, " +
      "c.descripcion as desCuenta, " +
      "s.descripcion as desSeguimiento " +

      "from g_ejecutar e, m_registro a, m_registro m, m_registro d, m_registro c, m_registro s " +
      "where " +
      "(e.agenda = a.registro and a.tabla = 10301) and " +
      "((e.mascara = m.registro and m.tabla = 10327 and e.agenda = m.parametro0) or (e.mascara = 0 and m.tabla = 10327)) and " +
      "(e.documento = d.registro and d.tabla = 10320) and " +
      "(e.cuenta = c.registro and c.tabla = 10343) and " +
      "(e.seguimiento = s.registro and s.tabla = 126) " +

      "order by e.ejecutar";

  var results = await connection.query(consulta);
  for (var row in results) {
    print('(4/4) Mostrando: ${row}'); // ${row[0]}  ${row[1]}
  }

  await connection.close(); // Finally, close the connection
  return true;
}

class Data {
  String p0;
  String p1;
  String p2;
  String p3;
  String p4;
  Data({required this.p0, required this.p1, required this.p2, required this.p3, required this.p4});
}