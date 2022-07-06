import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBarStyle extends StatelessWidget {
  AppBarStyle({Key? key, required this.titulo}) : super(key: key);
  String titulo;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xff6A9438),
      iconTheme: IconThemeData(color: Colors.white),
      title: Text("  ${titulo}"),
    );
  }
}
