import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaccion/data/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:transaccion/pages/transaction_page.dart';
import 'package:transaccion/utils/globals.dart' as globals;
import 'package:transaccion/services/database_action.dart';
import 'package:transaccion/config/local_storage.dart';

import '../services/database_handler_transaction.dart';
import '../styles/style_appbar.dart';

late bool _saving = false;

//late Registro control;

/*
late Registro control = {
  'registro': 2,
  'descripcionregistro' : '---------',
  'tabla' : 700
} as Registro;
*/

class LoginPage extends StatefulWidget {
  LoginPage(this.titulo);
  final String titulo;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late bool _iconPassword;
  late bool _colorPassword;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late Icon _iconEmail;

  List<String> _dbs = ['Local', 'Web'];
  late String _db = kIsWeb ? 'Web' : 'Local';

  static const Color primaryColor = Color(0xff689225);

  @override
  initState() {
    _cargar();
    _saving = false;
    super.initState();
    setState(() {});
  }

  _cargar() async {
    _colorPassword = false;
    _iconPassword = true;

//
    DatabaseHandlerTransaction handlerTransaction; // definir variable
    handlerTransaction = DatabaseHandlerTransaction(); // instanciar la variable
    var connection = await handlerTransaction.initializeDBMySql(); // Ya

    print('vbvbbbbbbbbbbbbbbbbbbbbbb');

    print(connection);
    print('vbvbbbbbbbbbbbbbbbbbbbbbb');
    _dbs = await listPropertiesDB();
    // print('login_page _dbs - ${_dbs}');
  }

  bool loanding = false;
  @override
  Widget build(BuildContext context) {
    Future<void> _refrescar(bool cual) async {
      await _cargar();
      setState(() {
        _saving = cual;
      });
    }

    Widget decoracion = Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Container(
                child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Container(child: Image.asset('assets/images/icon.png')),
              radius: 70.0,
            )),
          ),
        ),
/*
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: Text(
                  'Agregar empresa',
                  style: TextStyle(
                      fontSize: 12,),
//                      color: OcoboColors.primaryColor,
//                      fontFamily: "PoppinsBold"),
                ),
/*
                onTap: () async {
                  final result = await Navigator.pushNamed(
                      context, routes.AddBussinesRoute);
                  if (result != null) {
                    _companies = result;
                  }
                },
  */
              ),
              Icon(
                Icons.chevron_right,
//                color: OcoboColors.primaryColor,
                size: 35,
              )
            ],
          ),
        )

 */
      ],
    );

    Widget dropdownButtonBD = DropdownButtonFormField(
      value: _db,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down),
      borderRadius: new BorderRadius.circular(10.0),
      elevation: 2,
      focusColor: Colors.white,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onChanged: (String? newValue) {
        setState(() {
          _db = newValue!;
        });
      },
      items: _dbs.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    Widget textUser = TextFormField(
      controller: _email,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Usuario',
        hintText: 'Ingrese el usuario',
//        border: new OutlineInputBorder( borderSide: new BorderSide( color: primaryColor, ), ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            _iconEmail = Icon(
              Icons.warning,
              color: Colors.yellow,
            );
          });
          return 'Ingrese el Usuario';
        }
        _iconEmail = Icon(
          Icons.warning,
          color: Colors.white,
        );
        setState(() {});
        return null;
      },
    );

    Widget textPassword = TextFormField(
      controller: _password,
      obscureText: _iconPassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Ingrese la contraseña',
//        border: new OutlineInputBorder( borderSide: new BorderSide( color: primaryColor, ), ),
        suffixIcon: IconButton(
          icon: _iconPassword
              ? Icon(Icons.visibility_off_outlined)
              : Icon(Icons.visibility_outlined),
          color: _colorPassword ? Colors.red : Colors.black,
          onPressed: () {
            setState(() {
              if (_iconPassword)
                _iconPassword = false;
              else
                _iconPassword = true;
            });
//            _loginCubit.changeIconPassword(show: !_iconPassword);
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            _colorPassword = false;
          });
          return 'Ingrese la contraseña';
        }
        setState(() {
          _colorPassword = true;
        });
        return null;
      },
    );

    Widget olvido = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          child: Text(
            'Olvidó su contraseña',
            style: TextStyle(
              fontSize: 12,
              color: primaryColor, // fontFamily: "PoppinsBold"
            ),
          ),
          onTap: () {
//            Navigator.pushNamed(context, routes.ForgetPasswordPageRoute);
          },
        ),
      ],
    );

    Widget butonVerificar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 48,
        width: 300, // specific value
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.login_outlined,
            color: Colors.white,
            size: 30.0,
          ),
          label: Text('Iniciar sesión',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                loanding = true;
              });

              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  loanding = false;
                });
              });
              var arr = [];

              if (kIsWeb == false) {
                String contrasenas =
                    await streamPropertiesDB(kIsWeb ? "Web" : _db);
                arr = contrasenas.toString().toString().split('|');

                globals.host = arr[1];
                globals.port = int.parse(arr[2]);
                globals.userDB = arr[3];
                globals.passwordDB = arr[4];
                globals.dataBase = arr[5];

                globals.instance = _db;

                print('login_page - globals.instance - ${globals.instance}');
              }

              if (_email.text.toString().trim().length == 0)
                globals.user = 'Ocobo';
              else
                globals.user = _email.text.toString().trim();

              print('login_page arr - ${arr}.toString()');

/*
              var newData = { // Viene del properties
//                "host": '200.118.224.78',
//                "port": 3306,
//                "userdb": 'root',
//                "passworddb": 'Juan2008',
//                "db": 'prueba',

                "host": globals.host,
                "port": globals.port,
                "userdb": globals.userDB,
                "passworddb": globals.passwordDB,
                "db": globals.dataBase,

                "user": globals.user,
                "password": _password.text.toString().trim()
              };
*/
              if (await verificarUserMySql(_password.text.toString().trim()) ==
                  1) {
                _showToast(1, 'Conexión realizada a ${_db}');
                setLoginToken(_password.text.toString());

                globals.continuar = 1;
                _showToast(1, 'Conexión realizada a ${_db}');
                if (kIsWeb) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionPage(title: 'Transacciones'),
                      ),
                      ModalRoute.withName('/'));
                } else {
                  Navigator.pop(context);
                }
              } else {
                _showToast(
                    2, 'Error, verifique los datos o la conexión a internet');
              }
            } else {}
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Color(0xff6A9438),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
        ),
      ),
    );

    Widget widgetBody = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        decoracion,
        SizedBox(height: 16.0),
        kIsWeb ? Container() : dropdownButtonBD,
        kIsWeb
            ? Container(
                width: MediaQuery.of(context).size.width / 3, child: textUser)
            : textUser,
        kIsWeb
            ? Container(
                width: MediaQuery.of(context).size.width / 3,
                child: textPassword)
            : textPassword,
        SizedBox(height: 8.0),
        Container(width: MediaQuery.of(context).size.width / 3, child: olvido),
        SizedBox(height: 12.0),
        butonVerificar,
        SizedBox(height: 80.0),
      ],
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff6A9438),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("  ${widget.titulo}"),
        ),
        body: Form(
          key: _formKey,
          child: LoadingOverlay(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: widgetBody,
                    ),
                  ),
                ),
                loanding
                    ? Center(
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              height: 150,
                              width: 150,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Color(0xff6A9438),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            isLoading: _saving,
          ),
        ));
  }
}

void _showToast(int presentacion, String mensaje) {
  switch (presentacion) {
    case 1:
      Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black.withOpacity(0.48),
          textColor: Colors.white,
          fontSize: 16.0);
      break;
    case 2:
      Fluttertoast.showToast(
          msg: mensaje,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red.withOpacity(0.68),
          textColor: Colors.white,
          fontSize: 16.0);
      break;
    default:
      print("Since we don't know your favorite flavor, here's a random one");
  }
}
