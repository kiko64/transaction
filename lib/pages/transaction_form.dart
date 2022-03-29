import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transaccion/data/record.dart';
import 'package:transaccion/services/database_action.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:transaccion/data/transactiox.dart';
import 'package:transaccion/pages/record_page.dart';
import 'package:transaccion/services/database_handler_transaction.dart';

int _current = 0;
List<String> imgList = [];

class TransactionWidget extends StatefulWidget {
  TransactionWidget(this.actual, this.titulo);
  final Transactiox actual;
  final String titulo;

  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  late DatabaseHandlerTransaction handler;
  final NumberFormat formato = new NumberFormat("#,##0", "es_US");

  late List<Transactiox> snapshot;

  String _parAgenda0 = '';
  String _parAgenda1 = '';
  String _parAgenda2 = '';
  String _parAgenda3 = '';

  int _agenda = 0;
  var _desAgenda = TextEditingController();
  final FocusNode _desAgendaFocus = FocusNode();

  int _mascara = 0;
  var _desMascara = TextEditingController();
  final FocusNode _mascaraFocus = FocusNode();

  int _documento = 0;
  var _desDocumento = TextEditingController();
  final FocusNode _documentoFocus = FocusNode();

  var _valor = TextEditingController();
  final FocusNode _valorFocus = FocusNode();

  int _cuenta = 0;
  var _desCuenta = TextEditingController();
  final FocusNode _cuentaFocus = FocusNode();

  var _observacion = TextEditingController();
  final FocusNode _observacionFocus = FocusNode();

  var _fecha = TextEditingController();
  final FocusNode _fechaFocus = FocusNode();

  int _seguimiento = 0;
  var _desSeguimiento = TextEditingController();
  final FocusNode _seguimientoFocus = FocusNode();

  bool _cambio = false;
  late File? _image = null;
  var _isVisible = true;

//  _TransactionWidgetState();

  _formatearValor() {
    if (_valor.text.length > 0) {
      String cadena = _valor.text;
      cadena = cadena.replaceAll(",", "");
      if (formato.format(int.parse(cadena)) != _valor.text) {
        _valor.text = formato.format(int.parse(cadena));
        _valor.selection = TextSelection.collapsed(offset: _valor.text.length);
      }
    }
  }

  @override
  void initState() {
    this.handler = DatabaseHandlerTransaction();
    _cambio = false;
    _valor.addListener(_formatearValor);

//    _lecturaActual.addListener(_actualizacion);
//    _descripcionNovedad.addListener(_actualizacion);
//    _observacion.addListener(_actualizacion);

    super.initState();
    _refrescar();
  }

  void _refrescar() async {
    setState(() {
      imgList.clear();

      _agenda = widget.actual.agenda!;
      _desAgenda.text = widget.actual.desAgenda.toString();
      _parAgenda0 = widget.actual.parAgenda0;
      _parAgenda1 = widget.actual.parAgenda1;
      _parAgenda2 = widget.actual.parAgenda2;
      _parAgenda3 = widget.actual.parAgenda3;

      _mascara = widget.actual.mascara;
      _desMascara.text = widget.actual.desMascara.toString();

      _documento = widget.actual.documento!;
      _desDocumento.text = widget.actual.desDocumento.toString();

      _valor.text = widget.actual.valor.toString().replaceAll(".", ",");

      _cuenta = widget.actual.cuenta;
      _desCuenta.text = widget.actual.desCuenta.toString();

      _observacion.text = widget.actual.observacion.toString();

      _seguimiento = widget.actual.seguimiento!;
      _desSeguimiento.text = widget.actual.desSeguimiento.toString();

      _isVisible = true;
      if (widget.actual.ejecutar == 0) {
        print('I N S E R T ...');
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(now);
        _fecha.text = formatted;
//        imgList.add('https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80');
      } else {
        if (_seguimiento != 12601) {
          // Solo en peparación se puede cambiar
          print('U P D A T E ...' + widget.actual.seguimiento.toString());
          _isVisible = false;
        }
        _fecha.text = widget.actual.fecha.toString();
//        imgList.add('https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80');
//        imgList.add('https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80');
//        imgList.add('https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80');

        if (widget.actual.archivo0.toString().trim().length > 0)
          imgList.add(widget.actual.archivo0.toString());
        if (widget.actual.archivo1.toString().trim().length > 0)
          imgList.add(widget.actual.archivo1.toString());
        if (widget.actual.archivo2.toString().trim().length > 0)
          imgList.add(widget.actual.archivo2.toString());
        if (widget.actual.archivo3.toString().trim().length > 0)
          imgList.add(widget.actual.archivo3.toString());
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
//    _lecturaActual.dispose();
//    _descripcionNovedad.dispose();
//    _observacion.dispose();
    super.dispose();
  }

  void _actualizacion() {
    _cambio = true;
    print('****************** Cambio **************************');
  }

  Widget _setImageView() {
    if (_image != null) {
      return Image.file(_image!, width: 200, height: 200);
    } else {
      return Text("Please select an image");
    }
  }

  Future getImageCamera() async {
    try {
      var image = (await ImagePicker().pickImage(source: ImageSource.camera));
      if (image != null) {
        setState(() {
          _image = File(image.path);
          print('Nombre archivo $_image.path.toString()');
          imgList.add(_image!.path.toString());
          _cambio = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImageGallery() async {
    try {
      var image = (await ImagePicker().pickImage(source: ImageSource.gallery));
      if (image != null) {
        setState(() {
          print('Nombre archivo' + image.path);
          _image = File(image.path);
          imgList.add(_image!.path.toString());
          _cambio = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Desea eliminar el soporte actual?',
            style: TextStyle(color: Colors.black87, fontSize: 15),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(' '),
                Text(
                  'Borrar este soporte',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ELIMINAR',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              onPressed: () {
                _showToastOk(
                    1, 'Soporte No. ${(_current + 1).toString()} eliminado');
                imgList.removeAt(_current);
                _cambio = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    //SCR: ejecutamos dentro del widget build para que esta lista se refresque y pueda validar si tiene o no contenido
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
//      width: 48.0,
                height: 80.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  child: GestureDetector(
//            Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    child: Image.file(File(item.toString()),
                        fit: BoxFit.cover, width: 1000.0),
                    onDoubleTap: () {
                      _showToastOk(
                          1, 'onDoubleTap No. ${(_current + 1).toString()}');
//            imgList.removeAt(_current);
//            _showMyDialog();
                    },
                    onLongPress: () {
                      _showToastOk(
                          1, 'onLongPress No. ${(_current + 1).toString()}');
//            imgList.removeAt(_current);
//            _showMyDialog();
                    },
                  ),
                ),
              ),
            ))
        .toList();
    imgList.length == 0 ? imageSliders.clear() : imageSliders;

    void _grabar() async {
      print('Cambio' + _cambio.toString());
      if (_cambio) {
        String archivo0 = '';
        String archivo1 = '';
        String archivo2 = '';
        String archivo3 = '';

        if (imgList.length > 0) archivo0 = imgList[0].toString();
        if (imgList.length > 1) archivo1 = imgList[1].toString();
        if (imgList.length > 2) archivo2 = imgList[2].toString();
        if (imgList.length > 3) archivo3 = imgList[3].toString();

        if (widget.actual.ejecutar == 0) if (_agenda > 0) {
          print(
              '==================================================== INSERT...');

          var newData = {
            "fecha": _fecha.text,
            "usuario": 'Ocobo',
            "seguimiento": _seguimiento,
            "agenda": _agenda,
            "documento": _documento,
            "cuenta": _cuenta,
            "valor": int.parse(_valor.text.replaceAll(",", "")),
            "observacion": _observacion.text,
            "registro": '0',
            "mascara": _mascara,
            "archivo0": archivo0,
            "archivo1": archivo1,
            "archivo2": archivo2,
            "archivo3": archivo3
          };

          print(newData);

          await this.handler.insertUsingHelper(newData); // MySql
//            await this.handler.insertUsingHelperMySql(newData);  // MySql
          Vibration.vibrate(duration: 200);
          _cambio = false;
          _showToastOk(1, 'Transacción adicionada');
        } else {
          _showToastOk(2, 'Error, completar los campos...');
        }
        else {
          print(
              '==================================================== UPDATE...');
          // Actualizando

          var newData = {
            "ejecutar": widget.actual.ejecutar,
            "fecha": _fecha.text,
            "seguimiento": _seguimiento,
            "agenda": _agenda,
            "documento": _documento,
            "cuenta": _cuenta,
            "valor": int.parse(_valor.text.replaceAll(",", "")),
            "observacion": _observacion.text,
            "registro": '0',
            "mascara": _mascara,
            "archivo0": archivo0,
            "archivo1": archivo1,
            "archivo2": archivo2,
            "archivo3": archivo3
          };

          print(newData);

          await this.handler.updateUsingHelper(newData); // MySql
//          await this.handler.updateUsingHelperMySql(newData);  // MySql
          Vibration.vibrate(duration: 200);
          _cambio = false;
          _showToastOk(1, 'Transacción actualizada');
        }
      } else {
        _showToastOk(2, 'Error, no ha realizado ningun cambio...');
      }
    }

    Widget widgetTitulo = Container(
      margin: EdgeInsets.fromLTRB(0, 4, 0, 0), // L, U, R, D
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('    ' + widget.actual.agenda.toString(),
                style: Theme.of(context).textTheme.overline),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('    ' + widget.actual.agenda.toString(),
                style: Theme.of(context).textTheme.overline),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('    ' + widget.actual.agenda.toString(),
                style: Theme.of(context).textTheme.overline),
          ), // caption

          SizedBox(height: 10.0),

          Align(
            alignment: Alignment.bottomLeft,
            child: Text('  Medidor Nro.: ' + widget.actual.valor.toString(),
                style: Theme.of(context).textTheme.headline6),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
                '  Lectura anterior: ' +
                    widget.actual.valor.toString().replaceAll(".", ","),
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      ),
    );

    Widget widgetActividad = Container(
      width: MediaQuery.of(context).size.width,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(2.0),
//      ),
//      padding: EdgeInsets.symmetric(
//        vertical: 0.0,
//        horizontal: 6.0,
//      ),
      child: TextFormField(
        controller: _desAgenda,
        readOnly: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.content_paste_rounded),
//          suffixIcon: IconButton(
//            onPressed: _listen,
//            color: Colors.black,
//            icon: Icon(_isListening ? Icons.mic_sharp : Icons.mic_none),
//          ),
          labelText: 'Actividad',
          hintText: 'Selecionar actividad',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        focusNode: _desAgendaFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_descripcionActividad) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
//          _adicionalFocus.unfocus();
          FocusScope.of(context).requestFocus(_valorFocus);
        },
        onTap: () async {
          var data = Data(
              titulo: 'Actividad',
              llave: _agenda,
              condicion: 'tabla = 10301',
              descripcion: _desAgenda.text
                  .toString(), // Es usado para el retornar la descripción
              parData0: '',
              parData1: '',
              parData2: '',
              parData3: '');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPage(
                      dataRegistro: data,
                    )),
          ) as Data;
          setState(() {
            print('agenda: ${result.llave}');
            print('tipoAgenda: ${result.parData0.toString()}');
            print('tipoTercero: ${result.parData1.toString()}');
            print('Cuenta: ${result.parData2.toString()}');
            print('Valor: ${result.parData3.toString()}');

            _cambio = true;
            _agenda = result.llave;
            _desAgenda.text = result.descripcion.toString();
            _parAgenda0 = result.parData0.toString(); // tipoAgenda
            _parAgenda1 = result.parData1.toString(); // tipoAuxiliar
            _parAgenda2 = result.parData2.toString(); // cuenta
            _parAgenda3 = result.parData3.toString(); // valor
            _cuenta = int.parse(result.parData2.toString());
            if (result.parData3.indexOf('.') > 0)
              _valor.text = result.parData3
                  .toString()
                  .substring(0, result.parData3.indexOf('.'));
            else
              _valor.text = '0';
          });

          late Record
              control; // Averigua descripcion de cuenta (10343), primer presupuesto (10327) OJO puede que no Exista y auxiliar (10320), además cuando es actividad hereda 0,0,0
          control = await retrieveBusqueda('registro, descripcion',
              'tabla = 10343 and registro = ' + _cuenta.toString()) as Record;
          setState(() {
            if (control.registro != null) {
              _desCuenta.text = control.descripcion;
            } else {
              _desCuenta.text = 'n/a';
            }
          });

          control = await retrieveBusqueda(
              'min(registro) AS registro, descripcion',
              'tabla = 10327 and parametro0 = ' + _agenda.toString()) as Record;
          setState(() {
            if (control.registro != null) {
              _mascara = control.registro!;
              _desMascara.text = control.descripcion;
            } else {
              _mascara = 0;
              _desMascara.text = 'n/a';
            }
          });

          control = await retrieveBusqueda(
                  'min(registro) AS registro, descripcion',
                  'tabla = 10320 and parametro0 = ' + _parAgenda1.toString())
              as Record;
          setState(() {
            if (control.registro != null) {
              _documento = control.registro!;
              _desDocumento.text = control.descripcion;
            } else {
              _documento = 0;
              _desDocumento.text = 'n/a';
            }
          });
        },
      ),
    );

    Widget widgetMascara = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _desMascara,
        readOnly: true,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.monetization_on_outlined),
          labelText: 'Presupuesto',
          hintText: 'Ingrese presupuesto',
        ),
        focusNode: _mascaraFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_mascaraActual) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_documentoFocus);
        },
        onTap: () async {
          var data = Data(
              titulo: 'Presupuesto',
              llave: _mascara,
              condicion: "(tabla = 10327 and parametro0 = '" +
                  _agenda.toString() +
                  "') or (tabla = 10327 and registro = 0)", // De la tabla de presupuesto de agenda actual
              descripcion: _desMascara.text.toString(),
              parData0: '',
              parData1: '',
              parData2: '',
              parData3: '');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPage(
                      dataRegistro: data,
                    )),
          ) as Data;
          setState(() {
            _cambio = true;
            _mascara = result.llave;
            _desMascara.text = result.descripcion.toString();
          });
        },
      ),
    );

    Widget widgetDocumento = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        readOnly: true,
        controller: _desDocumento,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.account_circle_outlined),
          labelText: 'Auxiliar',
          hintText: 'Ingrese el auxiliar',
        ),
        focusNode: _documentoFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_documentoActual) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_valorFocus);
        },
        onTap: () async {
          var data = Data(
            titulo: 'Auxiliar',
            llave: _documento,
            condicion: "(tabla = 10320 and parametro0 ='" +
                _parAgenda1.toString() +
                "') or (tabla = 10320 and registro = 0)", // and parametro0 ='" + _parametro1 + "'",
            descripcion: _desDocumento.text.toString(),
            parData0: '',
            parData1: '',
            parData2: '',
            parData3: '',
          );
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPage(
                      dataRegistro: data,
                    )),
          ) as Data;
          setState(() {
            _cambio = true;
            _documento = result.llave;
            _desDocumento.text = result.descripcion.toString();
          });
        },
      ),
    );

    Widget widgetValor = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _valor,
        focusNode: _valorFocus,
        onChanged: (_valor) {
          _cambio = true;
        },
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (term) {
          _valorFocus.unfocus();
          FocusScope.of(context).requestFocus(_cuentaFocus);
        },
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.attach_money),
          labelText: 'Valor',
          hintText: 'Ingrese valor',
        ),
      ),
    );

    Widget widgetCuenta = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        readOnly: true,
        controller: _desCuenta,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.account_balance_outlined),
          labelText: 'Cuenta',
          hintText: 'Ingrese cuenta',
        ),
        focusNode: _cuentaFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_cuenta) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_observacionFocus);
        },
        onTap: () async {
          var data = Data(
              titulo: 'Cuenta',
              llave: _cuenta,
              condicion: 'tabla = 10343',
              descripcion: _desCuenta.text.toString(),
              parData0: '',
              parData1: '',
              parData2: '',
              parData3: '');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPage(
                      dataRegistro: data,
                    )),
          ) as Data;
          setState(() {
            _cambio = true;
            _cuenta = result.llave;
            _desCuenta.text = result.descripcion.toString();
          });
        },
      ),
    );

    Widget widgetObservacion = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _observacion,
//        maxLines: 2,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.insert_comment_outlined),
          labelText: 'Comentario',
          hintText: 'Ingrese comentario adicional',
        ),
        onChanged: (_observacion) {
          _cambio = true;
        },
        focusNode: _observacionFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_seguimientoFocus);
        },
      ),
    );

    Widget widgetSeguimiento = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        readOnly: true,
        controller: _desSeguimiento,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.announcement_outlined),
          labelText: 'Estado',
          hintText: 'Ingrese estado',
        ),
        focusNode: _seguimientoFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_estado) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_fechaFocus);
        },
        onTap: () async {
          var data = Data(
              titulo: 'Estado',
              llave: _seguimiento,
              condicion: 'tabla = 126',
              descripcion: _desSeguimiento.text.toString(),
              parData0: '',
              parData1: '',
              parData2: '',
              parData3: '');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordPage(
                      dataRegistro: data,
                    )),
          ) as Data;
          setState(() {
            _cambio = true;
            _seguimiento = result.llave;
            _desSeguimiento.text = result.descripcion.toString();
          });
        },
      ),
    );

    Widget widgetFecha = Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        readOnly: true,
        controller: _fecha,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.calendar_today_outlined),
          labelText: 'Fecha',
          hintText: 'Ingrese fecha',
        ),
        focusNode: _fechaFocus,
        textInputAction: TextInputAction.next,
        onChanged: (_fecha) {
          _cambio = true;
        },
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_observacionFocus);
        },
        onTap: () async {
          DateTime newDateTime = await showRoundedDatePicker(
            context: context,
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
//            theme: ThemeData.dark(),  //     theme: ThemeData(primarySwatch: Colors.blue),
//            imageHeader: AssetImage("assets/images/icon.png"),
            description:
                "Diligencie un formulario por cada transacción, toda la información deberá ser completada",
            initialDate:
                DateTime.parse(_fecha.text.toString()), // String --> Date
//            initialDate: DateTime.now(),
//            firstDate: DateTime(DateTime.now().year - 1),
//            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 18,
          ) as DateTime;
          setState(() {
            _cambio = true;
            print('$newDateTime');
            _fecha.text =
                newDateTime.toString().substring(0, 10); // Date --< String
          });
        },
      ),
    );

    Widget addImageContainer(screenSize) {
      return Container(
        width: screenSize.width * 0.70,
        child: Center(
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox.fromSize(
                  size: Size(48, 48), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey.shade600, //OcoboColors.primaryColor,
                      child: InkWell(
                        splashColor: Colors.white, // splash color
                        onTap: () {
                          getImageCamera();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ), // icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(48, 48), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey
                          .shade600, //OcoboColors.primaryColor, // button color
                      child: InkWell(
                        splashColor: Colors.white, // splash color
                        onTap: () {
                          getImageGallery();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.collections_outlined,
                              color: Colors.white,
                            ), // icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget widgetCarousel = Container(
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal, // vertical
          autoPlay: false,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
    );

    Widget widgetImagen = Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_setImageView()],
      ),
    );

    Widget widgetTransaction = Card(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5), // L, U, R, D
      elevation: 8.0,
      child: Column(
        children: [
//          SizedBox(height: 4.0),
//          Text('Transacición No. ' + widget.actual.ejecutar.toString(), //  + ' - '+ widget.actual.id.toString()
//            style: TextStyle(
//              fontSize: 16,
//              fontWeight: FontWeight.bold,
//              color: Colors.teal[600],
//            ),
//          ),
//          SizedBox(height: 3.0),
//          widgetTitulo,
          widgetActividad,
          widgetMascara,
          widgetDocumento,
          widgetValor,
          widgetCuenta,
          widgetObservacion,
          widgetFecha,
//          widgetSeguimiento,
          widgetCarousel,
//          widgetImagen,
//          addImageContainer(screenSize),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(4.0),
          child: widgetTransaction,
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: _isVisible && imgList.length > 0
                ? FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      Icons.delete_outline_outlined,
                    ),
                    backgroundColor: Colors.red.withOpacity(0.65),
                    onPressed: () async {
                      _showMyDialog();
                    })
                : null,
          ),
          SizedBox(
            height: 50,
            child: _isVisible && imgList.length < 4
                ? FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      Icons.camera_alt_outlined,
                    ),
                    backgroundColor: Colors.black.withOpacity(0.4),
                    onPressed: () async {
                      getImageCamera();
                    })
                : null,
          ),
          SizedBox(
            height: 50,
            child: _isVisible && imgList.length < 4
                ? FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      Icons.collections_outlined,
                    ),
                    backgroundColor: Colors.black.withOpacity(0.5),
                    onPressed: () async {
                      getImageGallery();
                    })
                : null,
          ),
          SizedBox(
//            height:46,
            child: _isVisible
                ? FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.cached),
                    backgroundColor: Colors.teal.withOpacity(0.8),
                    onPressed: () async {
                      _grabar();
//                snapshot = await this.handler.retrieveTransaction(widget.queryText, widget.actual.ejecutar.toString(), 'P');
//                _refrescar();
                    })
                : null,
          ),
        ],
      ),
    );
  }
}

void _showToastOk(int presentacion, String mensaje) {
  switch (presentacion) {
    case 1:
      Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey.shade900.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 16.0);
      break;
    case 2:
      Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red.withOpacity(0.65),
          textColor: Colors.white,
          fontSize: 16.0);
      break;
    default:
      print("Since we don't know your favorite flavor, here's a random one");
  }
}

class Data {
  String titulo;
  String condicion;
  int llave;
  String descripcion;
  String parData0;
  String parData1;
  String parData2;
  String parData3;
  Data(
      {required this.titulo,
      required this.condicion,
      required this.llave,
      required this.descripcion,
      required this.parData0,
      required this.parData1,
      required this.parData2,
      required this.parData3});
}

class DataDescripcion {
  String tabla;
  String descripcion;
  DataDescripcion({required this.tabla, required this.descripcion});
}
