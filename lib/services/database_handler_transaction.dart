import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:transaccion/data/transactiox.dart';
import 'package:transaccion/data/insert_transaction.dart';

import 'database_action.dart';

class DatabaseHandlerTransaction {
  Future<Database> initializeDB() async {
    late DatabaseHandlerTransaction handler;

    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'transaccion.db'),
      onCreate: (database, version) async {
/*
        await database.execute(
          'CREATE TABLE g_registro (registro INTEGER PRIMARY KEY, ' +
          'descripcionregistro TEXT NOT NULL, tabla INTEGER NOT NULL)',
        );
        await database.execute("insert into g_registro values(70002, '1', 700)");
*/
        await database.execute('CREATE TABLE m_registro('
                'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'tabla INTEGER NOT NULL,registro INTEGER NOT NULL,' +
            'descripcion TEXT,parametro0 TEXT,' +
            'parametro1 TEXT,parametro2 TEXT,parametro3 TEXT)');

        await database.execute('CREATE TABLE m_auxiliar('
                'auxiliar INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'identificacion INTEGER NOT NULL,tipo INTEGER NOT NULL,' +
            'nombres TEXT,apellidos TEXT,' +
            'favorito TEXT,direccion TEXT,' +
            'municipio INTEGER NOT NULL,telefono TEXT,e_mail TEXT,' +
            'relacion INTEGER NOT NULL)');

        await database.execute('CREATE TABLE m_ejecutar('
                'ejecutar INTEGER PRIMARY KEY AUTOINCREMENT,' +
            'fecha TEXT,usuario TEXT,' +
            'seguimiento INTEGER NOT NULL,agenda INTEGER NOT NULL,' +
            'documento INTEGER NOT NULL,cuenta INTEGER NOT NULL,' +
            'valor INTEGER NOT NULL,observacion TEXT,' +
            'registro TEXT,mascara INTEGER NOT NULL,' +
            'archivo0 TEXT,archivo1 TEXT,' +
            'archivo2 TEXT,archivo3 TEXT)');

        print('1/4');
        await database.execute(
            "insert into m_registro values(1, 700, 70001, '200.118.224.78|3306|root|Juan2008|prueba|', '0', '', '', '')");
        await database.execute(
            "insert into m_registro values(2, 700, 70002, '1', '0', '', '', '')");

        print('2/4');
        await database.execute(
            "insert into m_registro values(3,126,12601,'Preparación','0','','','')");
        await database.execute(
            "insert into m_registro values(4,126,12602,'Autorizada','0','','','')");
        await database.execute(
            "insert into m_registro values(5,126,12603,'En proceso','0','','','')");
        await database.execute(
            "insert into m_registro values(6,126,12604,'Ejecutada','0','','','')");
        await database.execute(
            "insert into m_registro values(7,126,12605,'Cancelada','0','','','')");

        print('3/4');
        await database.execute(
            "insert into m_registro values(8,210,21001,'Cédula de ciudadanía','CC','','','')");
        await database.execute(
            "insert into m_registro values(9,210,21005,'Nit','NIT','','','')");
        await database.execute(
            "insert into m_registro values(10,210,21015,'Tarjeta de identidad','TI','','','')");
        await database.execute(
            "insert into m_registro values(11,210,21016,'General','GE','','','')");

        print('4/4');
        await database.execute(
            "insert into m_registro values(12,10301,895,'Cargar recaudo GanaGana','33003','0','0','0')");
        await database.execute(
            "insert into m_registro values(13,10301,14057,'Crear lecturas ','33003','0','0','0')");
        await database.execute(
            "insert into m_registro values(14,10301,14058,'Preparar conceptos de facturas gas','33003','0','0','0')");
        await database.execute(
            "insert into m_registro values(15,10301,14199,'Traslado de cuotas a novedad','33003','0','0','0')");
        await database.execute(
            "insert into m_registro values(16,10301,14900,'Imprimir facturas y envio email','33003','0','0','0')");
        await database.execute(
            "insert into m_registro values(17,10301,14060,'Proceso masivo facturas gas','33006','14000','0','0.0')");
        await database.execute(
            "insert into m_registro values(18,10301,14198,'Ejecutar traslado de cuotas a novedad','33006','14100','0','0.0')");

        await database.execute(
            "insert into m_registro values(19,10327,0,'n/a','0','','','')");

        await database.execute(
            "insert into m_registro values(20,10343,0,'n/a','0','','','')");
        await database.execute(
            "insert into m_registro values(21,10343,1,'Caja principal','0','','','')");
        await database.execute(
            "insert into m_registro values(22,10343,2,'Colombia Aho. No 71800000898','0','','','')");

        await database.execute(
            "insert into m_registro values(41,10320,0,'n/a','0','0','','')");
        await database.execute(
            "insert into m_registro values(42,10320,216,'MARIA NELLY HERNANDEZ DENARANJO','14100','308','','')");
        await database.execute(
            "insert into m_registro values(133,10320,8,'JHONATAN ISRAEL ALVAREZ ROJAS','14100','392','','')");

        await database.execute(
            "insert into m_registro values(43,10320,242,'MARIA NELLY HERNANDEZ DENARANJO','14000','308','','')");
        await database.execute(
            "insert into m_registro values(44,10320,100381,'MARIA NELLY HERNANDEZ DENARANJO','14000','308','','')");

        //await addTransaction();
      },
      version: 1,
    );
  }

  armarCondicion(String query) {
    query = query.trim();

    if (query.indexOf(',') !=
        -1) if (query.substring(query.length - 1, query.length) == ',')
      query = 'e.ejecutar in(' + query.substring(0, query.length - 1) + ')';
    else
      query = 'e.ejecutar in(' + query + ')';
    else if (query.length == 0)
      query = 'e.ejecutar > 0';
    else if (query.trim().toUpperCase() == 'TOM')
      query = 'e.ejecucion = 1';
    else if (query.trim().toUpperCase() == 'ACT')
      query = 'e.ejecucion = 0';
    else
      query = "( e.ejecutar = '" +
          query +
          "' or a.descripcion like '%" +
          query +
          "%' )";

    return '(e.agenda = a.registro and a.tabla = 10301) and '
            '((e.mascara = m.registro and m.tabla = 10327 and e.agenda = m.parametro0) or (e.mascara = 0 and m.tabla = 10327)) and ' +
        '(e.documento = d.registro and d.tabla = 10320) and ' +
        '(e.cuenta = c.registro and c.tabla = 10343) and ' +
        '(e.seguimiento = s.registro and s.tabla = 126) and ' +
        query; //
  }

  Future<List<Transactiox>> retrieveTransaction(
      String condicion, String actual, String desplazamiento) async {
    condicion = armarCondicion(condicion);
    if (condicion.length == 0) condicion = '1 = 1';

    switch (desplazamiento) {
      case 'P': // primero
        condicion =
            'e.ejecutar = (select min(e.ejecutar) from m_ejecutar e where ' +
                condicion.substring(27, condicion.length) +
                ' )';
        break;
      case 'A': // anterior
        condicion =
            'e.ejecutar = (select max(e.ejecutar) from m_ejecutar e where e.ejecutar < ' +
                actual +
                ' and ' +
                condicion.substring(27, condicion.length) +
                ' )';
        break;
      case 'S': // siguiente
        condicion =
            'e.ejecutar = (select min(e.ejecutar) from m_ejecutar e where e.ejecutar > ' +
                actual +
                ' and ' +
                condicion.substring(27, condicion.length) +
                ' )';
        break;
      case 'U': // último
        condicion =
            'e.ejecutar = (select max(e.ejecutar) from m_ejecutar e where ' +
                condicion.substring(27, condicion.length) +
                ' )';
        break;
    }
    condicion = 'e.seguimiento = s.registro and ' + condicion;

    print('******************************Condición: $condicion');
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.query(
      'm_ejecutar e, m_registro s',
      where: '$condicion',
    );

    return queryResult.map((e) => Transactiox.fromMap(e)).toList();
  }

  Future<List<Transactiox>> retrieveTransactions(
      String condicion, int criterio) async {
    condicion = armarCondicion(condicion);
    print('$condicion');

    print('$criterio'); // Es para la seleeción segun el m_ejecutar.seguimiento
    if (criterio != 0)
      condicion = condicion + ' and e.seguimiento = ' + criterio.toString();

    String consulta =
        'SELECT e.ejecutar, e.fecha, e.usuario, e.seguimiento, e.agenda, e.documento, '
                'e.cuenta, e.valor, e.observacion, e.registro, e.mascara, '
                'e.archivo0, e.archivo1, e.archivo2, e.archivo3, '
                'a.descripcion as desAgenda, '
                'a.parametro0 as parAgenda0, a.parametro1 as parAgenda1, a.parametro2 as parAgenda2, a.parametro3 as parAgenda3, '
                'm.descripcion as desMascara, '
                'd.descripcion as desDocumento, '
                'c.descripcion as desCuenta, '
                's.descripcion as desSeguimiento '
                'from m_ejecutar e, m_registro a, m_registro m, m_registro d, m_registro c, m_registro s '
                'where ' +
            condicion +
            ' ' +
            'order by e.ejecutar';

    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(consulta);

//    await db.query('m_ejecutar e, m_registro s',
//        where: '$condicion',
//        orderBy: 'e.ejecutar' );

    return queryResult.map((e) => Transactiox.fromMap(e)).toList();

//    List<Map> maps = await db.query(tableTodo,
//        columns: [columnId, columnDone, columnTitle],
//        where: '$columnId = ?',
//        whereArgs: [ejecutar]);
  }

  Future<int> addTransaction() async {
    await ejecutar("insert into g_registro "
        "(registro, descripcion, tabla)"
        "values(1, 'RESERVA DEL VERGEL', 100)");

    await ejecutar("insert into g_registro "
        "(registro, descripcion, tabla)"
        "values(2, 'ALTOS DEL VERGEL', 100)");

    await ejecutar("insert into m_ejecutar "
        "(id, documento, direccion, adicional, municipio, medidor, anterior, actual, novedad, observacion, ejecucion, proceso, descripcion)"
        "values(6, 100001, 'RESERVA DEL VERGEL APTO 666', 'Reserva', 'Ibagué', '1', '1.000', '1.000', 24901, '', 0, 1, 'Lecturas prueba')");

    InsertTransaction transactionA = InsertTransaction(
        ejecutar: 1,
        fecha: '',
        usuario: '',
        seguimiento: null,
        agenda: null,
        documento: 100001,
        cuenta: 1,
        valor: 1,
        observacion: '',
        registro: '',
        mascara: 1,
        archivo0: '',
        archivo1: '',
        archivo2: '',
        archivo3: '');

    InsertTransaction transactionB = InsertTransaction(
        ejecutar: 2,
        fecha: '',
        usuario: '',
        seguimiento: null,
        agenda: null,
        documento: 100001,
        cuenta: 1,
        valor: 1,
        observacion: '',
        registro: '',
        mascara: 1,
        archivo0: '',
        archivo1: '',
        archivo2: '',
        archivo3: '');

    List<InsertTransaction> listOfTransactions = [transactionA, transactionB];
    return await this.insertTransaction(listOfTransactions);
  }

  Future<int> insertTransaction(
      List<InsertTransaction> listTransactions) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in listTransactions) {
      result = await db.insert('m_ejecutar', user.toMap());
    }
    return result;
  }

  Future<void> ejecutar(String sentencia) async {
    final db = await initializeDB();
    await db.execute(sentencia);
  }

  Future insertUsingHelper(newData) async {
    print(newData);
    final db = await initializeDB();
    var res = await db.insert('m_ejecutar', newData);
    return res;
  }

  Future updateUsingHelper(newData) async {
    print(newData);
    final db = await initializeDB();
    var res = await db.update(
      'm_ejecutar',
      newData,
      where: "ejecutar = ? ",
      whereArgs: [newData['ejecutar']],
    );
    return res;
  }

  Future<void> deleteTransaction(int ejecutar) async {
    final db = await initializeDB();
    if (ejecutar != 0) {
      await db.delete(
        'm_ejecutar',
        where: "ejecutar = ? ",
        whereArgs: [ejecutar],
      );
    } else {
      await db.delete(
        'm_ejecutar',
      );
    }
  }

  Future<dynamic> initializeDBMySql(String condicion) async {
    Data dataReg;
    dataReg = await getRegistro(condicion) as Data;

    ConnectionSettings settings = new ConnectionSettings(
      host: dataReg.p0,
      port: int.parse(dataReg.p1),
      user: dataReg.p2,
      password: dataReg.p3,
      db: dataReg.p4,
    );

    print('(1/2) Iniciando conexión MySql...');
    var connection;
    try {
      print('(2/2) Conectando MySql...');
      connection = await MySqlConnection.connect(settings);
    } catch (e) {
      print('Unable to connect.' + e.toString());
    }
    return connection;
  }

  Future<List<Transactiox>> retrieveTransactionsMySql(
      String condicion, int criterio) async {
    condicion = armarCondicion(condicion);
    print('$condicion');

    print('$criterio'); // Es para la seleeción segun el m_ejecutar.seguimiento
    if (criterio != 0)
      condicion = condicion + ' and e.seguimiento = ' + criterio.toString();

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
            condicion +
            ' ' +
            "order by e.ejecutar";

    print(' ');
    print(consulta);
    print(' ');

    final connection = await initializeDBMySql('70001 and tabla = 700');

    print(' ');
    print('(3/3) Pasando datos MySql...');

    var queryResult = await connection.query(consulta);

    await connection
        .close(); // Error: type Result is not a subtype of type List<Map<String, Object>>
    // Como paso el query => List<Map<String, Object>>
    // final List<Map<String, Object?>> queryResult = await connection.query(consulta);

    print('(3/3) YA CASI:::: Pasando datos MySql...');
    print('..................................');

    print(queryResult);

    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
    List<Transactiox> queryResultMap =
        queryResult.map((mapquery) => Transactiox.fromMap(mapquery)).toList();
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');

    print(queryResultMap);

    return queryResultMap;
  }

  Future insertUsingHelperMySql(newData) async {
    String cadena = "insert into g_ejecutar values(0," +
        "'" +
        newData['fecha'] +
        "', " +
        "'" +
        newData['usuario'] +
        "', " +
        newData['seguimiento'].toString() +
        ", " +
        newData['agenda'].toString() +
        ", " +
        newData['documento'].toString() +
        ", " +
        newData['cuenta'].toString() +
        ", " +
        newData['valor'].toString() +
        ", " +
        "'" +
        newData['observacion'] +
        "', '0', " +
        newData['mascara'].toString() +
        ", " +
        "'" +
        newData['archivo0'] +
        "', " +
        "'" +
        newData['archivo1'] +
        "', " +
        "'" +
        newData['archivo2'] +
        "', " +
        "'" +
        newData['archivo3'] +
        "') ";

    print(' ');
    print(cadena);
    print(' ');

    var connection = await initializeDBMySql('70001 and tabla = 700');
    var res = await connection.query(cadena);
    await connection.close(); // Finally, close the connection

    return res;
  }

  Future updateUsingHelperMySql(newData) async {
    String cadena = "UPDATE g_ejecutar set " +
        "fecha = '" +
        newData['fecha'] +
        "', " +
        "seguimiento = " +
        newData['seguimiento'].toString() +
        ", " +
        "agenda = " +
        newData['agenda'].toString() +
        ", " +
        "documento = " +
        newData['documento'].toString() +
        ", " +
        "cuenta = " +
        newData['cuenta'].toString() +
        ", " +
        "valor = " +
        newData['valor'].toString() +
        ", " +
        "observacion = '" +
        newData['observacion'] +
        "', " +
        "mascara = " +
        newData['mascara'].toString() +
        ", " +
        "archivo0 = '" +
        newData['archivo0'] +
        "', " +
        "archivo1 = '" +
        newData['archivo1'] +
        "', " +
        "archivo2 = '" +
        newData['archivo2'] +
        "', " +
        "archivo3 = '" +
        newData['archivo3'] +
        "' " +
        "where ejecutar = " +
        newData['ejecutar'].toString();
    print(cadena);

    var connection = await initializeDBMySql('70001 and tabla = 700');
    var res = await connection.query(cadena);
    await connection.close(); // Finally, close the connection

    return res;
  }

  Future deleteUsingHelperMySql(newData) async {
    String cadena = "UPDATE g_ejecutar set " +
        "seguimiento = " +
        newData['seguimiento'].toString() +
        ", " +
        "observacion = '" +
        newData['observacion'] +
        "' " +
        "where ejecutar = " +
        newData['ejecutar'].toString() +
        " and seguimiento = 12601";
    print(cadena);

    var connection = await initializeDBMySql('70001 and tabla = 700');
    var res = await connection.query(cadena);
    await connection.close(); // Finally, close the connection

    return res;
  }
}
