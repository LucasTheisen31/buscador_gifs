
import 'dart:convert';
import 'dart:io';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

//Basicamente, um widget é um componente visual para definir a interface de um aplicativo.
//Cada widget é uma pequena peça e, ao final, este conjunto de peças representará uma interface completa:
//cria tela home como um widget stateful
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String ?_busca;//vai ser a string q queremos buscar
  int _offSet = 0;//quantos dados a mais vao ser buscados

  Future<Map> _getGifs() async {//metodo que retorna um mapa no futuro tem que ser assincrona -> Future<Map>() async()
    http.Response response; //A http.Response classe contém os dados recebidos de uma chamada http bem-sucedida.

    if(_busca == null || _busca!.isEmpty || _busca == ""){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=EEhrCUeJVlBmkatJbPaXJAkKHnJsVa2v&limit=20&rating=g"));
    }else{
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=EEhrCUeJVlBmkatJbPaXJAkKHnJsVa2v&q=$_busca&limit=19&offset=$_offSet&rating=g&lang=pt"));
    }

    return json.decode(response.body);//json.decode transforma os dados recebidos em um mapa, pois isso o metodo tem que retornar um Map
  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//Scaffold é uma classe de flutter que fornece muitos widgets ou podemos dizer APIs como Drawer, SnackBar, BottomNavigationBar, FloatingActionButton, AppBar etc
      backgroundColor: Colors.black,//cor de fundo do widget
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),//titulo vai ser uma imagem pega na internet
        centerTitle: true,//para centralizar o titulo
      ),
      drawer: Drawer(),
      body: Column(//corpo do widget Scaffold vai comecar com 1 coluna
        children:<Widget>[//1º filho da coluna
          Padding(//borda
             padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),//borda de 10 em todas as direçoes
              child: TextField(
                decoration: InputDecoration(//decoracao do TextField
                  labelText: "Pesquise aqui!",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  border: OutlineInputBorder(),//adiciona borda em torno do TextField
                ),
                style: TextStyle(color: Colors.white, fontSize: 20,),//estilo do texto dentro do TextFild
                textAlign: TextAlign.center,//alinha o texto digitado no centro do TextField
                onSubmitted: (texto){ //Ao inserir o texto e clicar no OK do teclado, vai chamar esta funcao anonima passando o texto
                  setState(() { //notifica a estrutura de que o estado interno deste objeto foi alterado de uma forma que pode impactar a interface(reconstroi a interface)
                    _busca = texto;
                    _offSet = 0;//zera busca adicional
                  });
                },
              )
          ),
          Expanded(//pois vai ocupar o espaco restante da coluna
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){//verifica o estado da conexao
                    case ConnectionState.waiting://caso a conexao esteja em espera
                      case ConnectionState.none://caso a conexao esteja sem carregar nada
                        return Container(//vai retornar um coontainer
                          width: 200,//largura
                          height: 200,//altura
                          alignment: Alignment.center,//alinha o conteiner no centro
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),//especifica que a cor do CircularProgressIndicator sempre parado vai ser sempre branca
                          ),
                        );
                    default:{
                      if(snapshot.hasError){//caso a conexao der erro
                        return Container();
                      }else{
                        return _tabelaDeGifs(context, snapshot);
                      }
                    }
                  }
                },
              ),
          ),
        ],
      ),
    );
  }

  int _getNumeroDeDados(List data){//funcao para retornar o numero de items da lista
    if(_busca == null){ // se a string _busca for vazia, ou seja se nao esta sendo feita uma pesquisa
      return data.length;//retorna o numero de items da lista
    }else{
      return data.length+1;//retorna o numero de items da lista +1 para podermos exibir o botao de exibir mais gif nesta posicao adicional
    }
  }

  Widget _tabelaDeGifs(BuildContext context, AsyncSnapshot snapshot){//funcao que retorna o wdget com a tabela de gifs
    return GridView.builder(//retorna uma view no formato de grade,
        padding: EdgeInsetsDirectional.all(10),//borda de 10 em todos os lados

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//mostra como os itens vao ser organizados na grade
          crossAxisCount: 2, //numero de items na horizontal
          crossAxisSpacing: 10, //espacamento entre os itens na horizontal
          mainAxisSpacing: 10 //espacamento entre os itens na vertical
        ),
        itemCount: _getNumeroDeDados(snapshot.data["data"]),// itemCount serve para determinar o numero de items no grid, e vai usar a funcao _getNumeroDeDados para contar o numero de dados da lista
        itemBuilder: (context, index){ //no itemBuilder passamos uma funcao anonima que vai retornar o widget que sera colocado em cada posição

          if(_busca == null || index < snapshot.data["data"].length){//se nao estiver sendo feita uma pesquisa gifs ou se o indice for menor que o o numero de itens da lista(ou seja se o indice nao for o ultimo item) mostramos a imagem
            return GestureDetector( //para que possa clicar na imagen ou widget
              child: FadeInImage.memoryNetwork( // imagens apareceriem gradualmente à medida que sao carregadas
                  placeholder: kTransparentImage,  //imagem que vai aparecer no widget emquanto a imagem é carregada, vai ser a propria imagem transparente
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"], //imagem
                  height: 300,  //Atribui uma altura a ser usada para o widget
                  fit: BoxFit.cover //alinha o filho dentro de sua caixa pai e descarta as partes fora de sua caixa pai
              ),
              onTap: (){//ao tocar no whidget com GestureDetector
                Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))); //Navegue para uma nova tela(Navigator.push)
              },
              onLongPress: (){//funcao anonima ao precionar e segurar um widget no caso um gif
                HapticFeedback.vibrate(); //faz vibrar
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]); //para compartilhar conteúdo
              },
            );
          }else{ //mostramos o item no final para carregar mais imagems(gif)
              return Container(
                child: GestureDetector( //para que possa clicar na imagen ou widget
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,//alinha a coluna no centro do widget
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 70,),
                      Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 22)),
                    ],
                  ),
                  onTap: (){ //ao tocar no whidget com GestureDetector
                    setState(() {//notifica a estrutura de que o estado interno deste objeto foi alterado de uma forma que pode impactar a interface(reconstroi a interface)
                      _offSet += 19;//busca adicional recebe mais 19
                    });
                  },
                )
              );
          }

        }
    );
  }
}

