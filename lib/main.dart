import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';
import 'package:transaccion/styles/theme.dart';

import 'package:transaccion/pages/transaction_page.dart';

// Buscar/remplazar en todo el proyecto: Ctrl+Mays+R

Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await di.init();
//  Bloc.observer = SimpleBlocObserver();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
//      onGenerateRoute: router.generateRoute,
//      initialRoute: routes.SplashRoute,
      home: SplashPage(),
    ),
  );
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: TransactionPage(title: 'Transacciones'), //EjecutarHorizontalPage(title: 'Ejecutars'), // EjecutarHorizontalPage
      title: Text('OcoboSoft ',textScaleFactor: 2,),
      image: Image.asset('assets/images/icon.png'),
      loadingText: Text("Cargando..."),
      photoSize: 76.0,
//      loaderColor: Colors.teal,
    );
  }
}
