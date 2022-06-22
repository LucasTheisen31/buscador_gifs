//pagina para exibir os gifs quando clicados lembrando que todas as telas em Flutter sao widget
//como está pagina nao sera modificavel, nao vamos poder interagir e servira somente para mostrar o gif (ela nao precisa ser stateFULL, pode ser stateLESS)

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {//StatelessWidget nao vamos poder interagir

  final Map _dadosGif;

  GifPage(this._dadosGif);//construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(//Scaffold é uma classe de flutter que fornece muitos widgets ou podemos dizer APIs como Drawer, SnackBar, BottomNavigationBar, FloatingActionButton, AppBar etc
      appBar: AppBar(
        title: Text(_dadosGif["title"]),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_dadosGif["images"]["fixed_height"]["url"]);
            })],
      ),
      backgroundColor: Colors.black,//cor de fundo do widget
      body: Center(
        child: Image.network(_dadosGif["images"]["fixed_height"]["url"]),
      ),
    );
  }
}


