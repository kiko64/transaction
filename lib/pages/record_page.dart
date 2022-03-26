import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:transaccion/pages/transaction_form.dart';

import 'package:transaccion/services/database_handler_record.dart'; // cambio
import 'package:transaccion/data/record.dart';

class RecordPage extends StatefulWidget {

  @override
  final Data dataRegistro;
  RecordPage({required this.dataRegistro});

  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  late DatabaseHandlerRecord handler; // cambio

  String _queryText = '';

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text(widget.dataRegistro.titulo),
        centerTitle: true,
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    _refrescar(value.toString());
    ///*
    setState(() {
      var context = _scaffoldKey.currentContext;
      if (context == null) {
        return;
      }
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(new SnackBar(content: new Text('You wrote "$value"!')));
    });
//*/
  }

  _RecordPageState() {
    searchBar = new SearchBar(
      hintText: 'Buscar...',
      inBar: true,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
//      onSubmitted: onSubmitted, // Este sirve para cuando termina de escribir
      onChanged: onSubmitted,
//        onCleared: () {print("************************* Search bar has been cleared");},
//        onClosed: () {print("************************* Search bar has been closed");}
    );
  }

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandlerRecord(); // cambio
  }

  void _refrescar(String query) {
    _queryText = query;
    setState(() {
      this.handler = DatabaseHandlerRecord(); // cambio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: FutureBuilder(
        future: this.handler.retrieveRegistros( widget.dataRegistro.condicion, _queryText ), // cambio
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) { // cambio
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10 ),
              itemCount: snapshot.data?.length, // snapshot.data?.length = soccerPlayers.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    elevation: 2.0,
                    child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),  // L, U, R, D
                        title: Text(snapshot.data![index].descripcion.toString()), // cambio
                        subtitle: Text(snapshot.data![index].registro.toString() ), // + ' ' + snapshot.data![index].parametro0.toString() ), // cambio
                        trailing: Icon(
                          snapshot.data![index].registro != widget.dataRegistro.llave
                              ? null // Icons.cancel_outlined Icons.panorama_fish_eye
                              : Icons.check_circle,
                          color: snapshot.data![index].registro != widget.dataRegistro.llave
                              ? null
                              : Colors.teal,
                        ),
                        onTap: () {
                          setState(() {
//                            widget.dataRegistro.llave = snapshot.data![index].registro!;
                            print('widget.data.actual *******************************************: '
                                'llave: ${snapshot.data![index].registro!}'
                                ' valor: ${snapshot.data![index].parametro3.toString()}'
                            );
                            Navigator.pop(context, Data(
                                titulo:     '',
                                condicion:  '',
                                llave:      snapshot.data![index].registro!,
                                descripcion:snapshot.data![index].descripcion.toString(),
                                parData0:   snapshot.data![index].parametro0.toString(),
                                parData1:   snapshot.data![index].parametro1.toString(),
                                parData2:   snapshot.data![index].parametro2.toString(),
                                parData3:   snapshot.data![index].parametro3.toString(),
                            )
                            ); // Devolverme a la forma de transacción
                          });
                        }
                    )
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
