import 'dart:io';
import 'package:path_provider/path_provider.dart';


Future<String> get _localPath async {
  // Donde voy a guardar el archivo properties.
  final directory = (await getApplicationDocumentsDirectory()).path;
  print('getApplicationDocumentsDirectory: $directory');
  return directory;
}

Future<File> get _localFile async {
  // Referencia del archivo
  final path = await _localPath;
  return File('$path/properties.txt');
}

Future<File> appendPropertiesDB(String contents) async {
  // Adiciona al archivo
  final file = await _localFile;
  return file.writeAsString('$contents\n', mode: FileMode.append);
}

Future<File> writePropertiesDB(String contents) async {
  // ReEscribir el archivo
  final file = await _localFile;
  return file.writeAsString('$contents');
}

Future<String> streamPropertiesDB(buscar) async {
  // Leer archivo

  var arr = [];
  String resultado = '';

  try {
    final file = await _localFile;
    var lines = await file.readAsLines();
    for (var element in lines) {
      arr = element.toString().toString().split('|');
      if (arr.length >= 0) {
        if (arr[0] == buscar) {
          // && arr[6] == 1
          return element.toString();
        }
      }

      print('(1/1) streamPropertiesDB: Elemento - ${element.toString()}');
      resultado = element.toString() + ' ' + resultado.toString();
    }
//        if (element.contains(RegExp(r'^hello'))) {
//          return element;
//        }
//      return "not found";

  } catch (e) {
    return 'An error occurred: $e';
  }
  print('4/4 ${resultado.toString()}');

  return resultado;
}

Future<String> readPropertiesDB() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString(); // Leer el archivo
    return contents;
  } catch (e) {
    // Si encuentras un error, regresamos 0
    return 'Vacio...';
  }
}

Future initialPropertiesDB() async {
  // ReEscribir el archivo
  await writePropertiesDB('Local|0|0|Ocobo||local|1|\n');
  await appendPropertiesDB('Web|200.118.224.78|3306|root|Juan2008|prueba|1|\n');
  await appendPropertiesDB(
      'WebGo|72.167.59.130|3306|root_ide|_l+eVNb8h3mQ|ide0001|1|\n');
//    await appendPropertiesDB('Web|72.167.59.130|3306|root_ide|x=JPPN4n~q29|ide0001|1|\n');
}

Future<List<String>> listPropertiesDB() async {
  // Leer archivo

  int i = 0;
  var arr = [];
  List<String> list = ['', '', ''];

  try {
    final file = await _localFile;
    var lines = await file.readAsLines();
    print('(1/3) listPropertiesDB: Lineas - ${lines.toString()} ');
    for (var element in lines) {
      if (element.toString().trim().length > 0) {
        arr = element.toString().toString().split('|');
        print(
            '(2/3) listPropertiesDB: Tamaño - ${arr.length.toString()}, estado - ${arr[6].toString()}');
//          if (arr.length >= 6 && int.parse(arr[6].toString()) == 1) {
        list[i] = arr[0].toString();
        i++;
//          }
      }
    }
  } catch (e) {
    print('error ');
    initialPropertiesDB();
    list[0] = 'Local';
    list[1] = 'Web';
    list[2] = 'WebGo';
    return list;
  }

  print('(3/3) listPropertiesDB: Lista - ${list.toString()}');

  if (list.length == 0) {
    initialPropertiesDB();
    list[0] = 'Local';
    list[1] = 'Web';
    list[2] = 'WebGo';
  }

  return list;
}
