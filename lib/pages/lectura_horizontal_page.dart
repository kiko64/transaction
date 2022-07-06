import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

// import 'package:transaccion/pages/lectura_form.dart';
import 'package:transaccion/pages/record_page.dart';
import 'package:transaccion/services/database_handler_lectura.dart';
import 'package:transaccion/data/lectura.dart';

class LecturaHorizontalPage extends StatefulWidget {
  @override
  LecturaHorizontalPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LecturaHorizontalPageState createState() => _LecturaHorizontalPageState();
}

class _LecturaHorizontalPageState extends State<LecturaHorizontalPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  late DatabaseHandlerLectura handler;

  var _actual = TextEditingController();
  final FocusNode _actualFocus = FocusNode();

  int _novedad = 0;
  var _descripcionNovedad = TextEditingController();
  final FocusNode _descripcionNovedadFocus = FocusNode();

  var _observacion = TextEditingController();
  final FocusNode _observacionFocus = FocusNode();

  String _queryText = '';

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff6A9438),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title),
        centerTitle: true,
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    _refrescar(value.toString());
/*
    setState(() {
      var context = _scaffoldKey.currentContext;
      if (context == null) {
        return;
      }
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(new SnackBar(content: new Text('You wrote "$value"!')));
    });
*/
  }

  _LecturaHorizontalPageState() {
    searchBar = new SearchBar(
      hintText: 'Buscar...',
      inBar: true,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
//        onCleared: () {print("************************* Search bar has been cleared");},
//        onClosed: () {print("************************* Search bar has been closed");}
    );
  }

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandlerLectura();

    this.handler.initializeDB().whenComplete(() async {
//      await this.handler.addLectura();
      setState(() {});
    });
  }

  void _refrescar(String query) {
    _queryText = query;
    setState(() {
      this.handler = DatabaseHandlerLectura();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetTitulo = Container();

    return Scaffold(
      appBar: searchBar.build(context),
      body: FutureBuilder(
        future: this.handler.retrieveLecturas(_queryText),
        builder: (BuildContext context, AsyncSnapshot<List<Lectura>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(5, 10, 5, 0), // L, U, R, D
                      elevation: 5.0,
                      child: Column(
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            'Código usuario: ' +
                                snapshot.data![index].documento.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[600],
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Container(
                            margin:
                                EdgeInsets.fromLTRB(0, 4, 0, 0), // L, U, R, D
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      '    ' + snapshot.data![index].direccion,
                                      style:
                                          Theme.of(context).textTheme.overline),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      '    ' + snapshot.data![index].adicional,
                                      style:
                                          Theme.of(context).textTheme.overline),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      '    ' + snapshot.data![index].municipio,
                                      style:
                                          Theme.of(context).textTheme.overline),
                                ), // caption

                                SizedBox(height: 10.0),

                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      '  Número medidor: ' +
                                          snapshot.data![index].medidor,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      '  Lectura anterior: ' +
                                          snapshot.data![index].anterior
                                              .toString()
                                              .replaceAll(".", ","),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _actual,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.create_outlined),
                                labelText: 'Lectura actual',
                                hintText: 'Lectura',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              focusNode: _actualFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context)
                                    .requestFocus(_descripcionNovedadFocus);
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _descripcionNovedad,
                              readOnly: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.thumbs_up_down_outlined),
                                labelText: 'Novedad',
                                hintText: 'Novedad description',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              focusNode: _descripcionNovedadFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context)
                                    .requestFocus(_observacionFocus);
                              },
                              onTap: () async {
                                // var data = DataEnLectura(
                                //     titulo: 'Novedad',
                                //     novedad: _novedad,
                                //     desAgenda:
                                //         _descripcionNovedad.text.toString());

                                // final result = await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => RecordPage(
                                //             dataRegistro: data,
                                //           )),
                                // ) as DataEnLectura;

                                // setState(() {
                                //   _novedad = result.novedad;
                                //   _descripcionNovedad.text =
                                //       result.desAgenda.toString();
                                //   print(
                                //       'widget.data.actual <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<: ${result.desAgenda.toString()}');
                                //   print(
                                //       'widget.data.actual <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<: ${result.novedad}');
                                //   print(
                                //       'widget.data.actual <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<: ${_novedad}');
                                // });
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _observacion,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.comment_outlined),
                                labelText: 'Observación',
                                hintText: 'Comentario adicional',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              focusNode: _observacionFocus,
                            ),
                          )
                        ],
                      ),

/*
                    elevation: 2.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0), // L, U, R, D
                      title: snapshot.data![index].ejecucion == 0
//                              ? Text(snapshot.data![index].documento.toString(), style: Theme.of(context).textTheme.caption )
                          ? Text(snapshot.data![index].documento.toString() + ', Actual: ' + snapshot.data![index].anterior.toString())
                          : Text(snapshot.data![index].documento.toString() + ', Tomada: ' + snapshot.data![index].actual.toString()),
                      subtitle: Text(snapshot.data![index].direccion + ', ' + snapshot.data![index].municipio),
                      trailing: Icon(
                        snapshot.data![index].ejecucion == 0
                            ? null // panorama_fish_eye, Icons.loop
                            : Icons.check_circle,
                        color: snapshot.data![index].ejecucion == 0
                            ? null
                            : Colors.teal,
                      ),
                      onTap: () async {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => LecturaWidget(snapshot.data![index]), // Llamar la forma de auxiliares
                        );
                        await Navigator.of(context).push(route);
                        _refrescar(_queryText);
                      },
                    ),
*/
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
