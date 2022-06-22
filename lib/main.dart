
import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:buscador_gifs/ui/home_page.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(MaterialApp(
    home: HomePage(), //widget que sera a HomePage
    theme: ThemeData(//adiciona tema ao aplicativo
        hintColor: Colors.white,
        primaryColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        )),
  ));
}



