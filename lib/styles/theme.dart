import 'package:flutter/material.dart';
import 'package:transaccion/styles/colors.dart';

final ThemeData kDefaultTheme = ThemeData(

  primaryColor: Colors.grey, // Encabezado
  primarySwatch: Colors.teal, // Color botones y circulo
  accentColor: Colors.teal[800], // Color sombra
  primaryColorBrightness: Brightness.light,

  appBarTheme: AppBarTheme(
    
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    color: Colors.white70,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
);

final ThemeData kIOSTheme = new ThemeData(

  primaryColor: Colors.white, // Encabezado
  primarySwatch: Colors.teal, // Color botones y circulo
  accentColor: Colors.teal[800], // Color de sombra
  primaryColorBrightness: Brightness.dark,

  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    color: OcoboSoftColors.primaryColor,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 28.0,
      ),
    ),
  ),
);

class ButtonNavigation extends StatelessWidget {
  String text;
  VoidCallback navigator;
  ButtonNavigation({
    required this.text,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            ),
            elevation: 4.0,
            color: Colors.white,
            textColor: Colors.black,
            child: Text(
              text,
              style: TextStyle(fontSize: 17, ),   // fontWeight: FontWeight.bold
            ),
            onPressed: navigator),
      ],
    );
  }
}

class ButtonNavigationO extends StatelessWidget {
  String text;
  VoidCallback navigator;
  ButtonNavigationO({
    required this.text,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(6.0),
            ),
            elevation: 4.0,
            color: OcoboSoftColors.primaryColor,
            textColor: Colors.white,
            child: Text(
              text,
              style: TextStyle(fontSize: 17, ),   // fontWeight: FontWeight.bold
            ),
            onPressed: navigator),
      ],
    );
  }
}

