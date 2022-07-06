import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:transaccion/styles/theme.dart';
import 'package:transaccion/pages/splash_page.dart';

import 'package:transaccion/pages/transaction_page.dart';

// Buscar/remplazar en todo el proyecto: Ctrl+Mays+R
@override
void initState() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

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
