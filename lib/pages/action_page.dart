import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:transaccion/data/record.dart';
import 'package:transaccion/services/database_action.dart';

late bool _saving = false;
//late Registro control;

/*
late Registro control = {
  'registro': 2,
  'descripcionregistro' : '---------',
  'tabla' : 700
} as Registro;
*/

class AccionesPage extends StatefulWidget {

  @override
  AccionesPage({Key? key, required this.control}) : super(key: key);
  Record control;

  @override
  _AccionesPageState createState() => _AccionesPageState();
}

class _AccionesPageState extends State<AccionesPage> {

  @override
  initState() {
    _cargar();
    _saving = false;
    super.initState();
  }

  _cargar() async {

    widget.control = await getRegistroByRegistro('70002 and tabla = 700') as Record;
    if (widget.control != null) {
      print(widget.control.descripcion.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<void> _refrescar(bool cual) async {
      await _cargar();
      setState(() {
        _saving = cual;
      });
    }

    Widget widgetSicronizar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width:  300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.cached,
            color: Colors.white,
            size: 30.0,
          ),
          label: Text('Sincronizar', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            _refrescar(true);

            if (await sincronizar()) {
              _refrescar(false);
              _showToastOk(true);
            }
            else {
              _refrescar(false);
              _showToastOk(false);
            }

          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    Widget widgetDescargarLectura =  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width: 300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.file_download_outlined,
            color: Colors.white,
            size: 30.0,
          ),
          label: Text('Descargar al móvil', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            _refrescar(true);

            if(await descargarTransaction()) {  // MySql -> SqlLite
              _refrescar(false);
              _showToastOk(true);
            }
            else {
              _refrescar(false);
              _showToastOk(false);
            }

          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            shadowColor: Colors.grey,
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    Widget widgetCargarTransaction = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width: 300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.file_upload_outlined,
            color: Colors.white,
            size: 30.0,
          ),

          label: Text('Cargar al servidor', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            _refrescar(true);

            if(await cargarTransation()) { // SqlLite -> MySql
              _refrescar(false);
              _showToastOk(true);
            }
            else {
              _refrescar(false);
              _showToastOk(false);
            }

          },
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            onPrimary: Colors.white,
            shadowColor: Colors.grey,
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    Widget widgetVerificarSqlLite = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width:  300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.check,
            color: Colors.white,
            size: 30.0,
          ),
          label: Text('Verificar SqlLite', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            _refrescar(true);

            if (await verificarSqlLite()) {
              _refrescar(false);
              _showToastOk(true);
            }
            else {
              _refrescar(false);
              _showToastOk(false);
            }

          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    Widget widgetVerificarMySql = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width:  300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.check_box,
            color: Colors.white,
            size: 30.0,
          ),
          label: Text('Verificar MySql', style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            _refrescar(true);

            if (await verificarMySql()) {
              _refrescar(false);
              _showToastOk(true);
            }
            else {
              _refrescar(false);
              _showToastOk(false);
            }

          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(title: Text('Acciones')),
        body: LoadingOverlay(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
//                    if ( control == null)
//                      widgetSicronizar,
//                    if ( control != null && control.descripcionregistro.toString() != '2')
                      widgetSicronizar,
                    if ( widget.control != null && widget.control.descripcion.toString() == '1') // control != null &&
                      widgetCargarTransaction,
                    if ( widget.control != null && widget.control.descripcion.toString() == '2' || widget.control.descripcion.toString() == '3')
                      widgetDescargarLectura,
                    widgetVerificarSqlLite,
                    widgetVerificarMySql,
                  ],
                ),
              ),
            ),
          ),isLoading: _saving,
        )
    );
  }
}

void _showToastOk(bool ok) {
  if (ok)
    Fluttertoast.showToast(
      msg: "Actividad ejecutada",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey.shade900.withOpacity(0.6),
      textColor: Colors.white,
      fontSize: 16.0
    );
  else
    Fluttertoast.showToast(
        msg: "Error, verifique la conexión a internet o al servidor...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}