import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:transaccion/data/shared_pref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:transaccion/utils/globals.dart' as globals;
import 'package:transaccion/pages/login_page.dart';
import 'package:transaccion/pages/transaction_page.dart';

class SplashPage extends StatefulWidget {
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool logueado = false;
  @override
  void initState() {
    super.initState();
    validateLogin();
  }

  validateLogin() async {
    globals.continuar = await getUser();

    if (kIsWeb) {
      getLoginToken().then((token) => this
          .setState(() => token!.isEmpty ? logueado = false : logueado = true));
    } else {
      logueado = true;
    }

    print('--------------------------------->  ${globals.instance}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: logueado == false
          ? LoginPage('Autenticación')
          : TransactionPage(title: 'Transacciones'),
      //EjecutarHorizontalPage(title: 'Ejecutars'), // EjecutarHorizontalPage
//      navigateAfterSeconds: LoginPage('Autenticación'), //EjecutarHorizontalPage(title: 'Ejecutars'), // EjecutarHorizontalPage
//      navigateAfterSeconds: TransactionPage(title: 'Transacciones'), //EjecutarHorizontalPage(title: 'Ejecutars'), // EjecutarHorizontalPage
      title: Text(
        'OcoboSoft ',
        textScaleFactor: 2,
      ),
      image: Image.asset('assets/images/icon.png'),
      loadingText: Text("Cargando..."),
      photoSize: 70.0,
//      loaderColor: Colors.teal,
    );
  }

  Future<int> getUser() async {
    return globals.continuar;
  }
}
