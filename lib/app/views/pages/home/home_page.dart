import 'package:baby_names/app/models/oferta.dart';
import 'package:baby_names/app/models/produto_dest.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/models/record.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/pages/produto_screen/produto_screen.dart';
import 'package:baby_names/app/views/tiles/destTile.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.titulo}) : super(key: key);
  final String titulo;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DocumentSnapshot snapshot;
  bool iniciado = false;
  bool temErro = false;

  void iniciarFireBase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        iniciado = true;
      });
    } catch (e) {
      setState(() {
        temErro = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    iniciarFireBase();
  }

  @override
  Widget build(BuildContext context) {
    var visorOrintacao = MediaQuery.of(context).orientation;

    var size = MediaQuery.of(context).size;

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      String endereco = model.userData["endereco"];
      if (model.estaCarregando) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: visorOrintacao == Orientation.portrait
              ? Padding(
                  padding: EdgeInsets.all(size.aspectRatio * 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: size.height / 8,
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Receber em:",
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 18),
                                ),
                                SizedBox(
                                    width: size.width - 80,
                                    child: Text(
                                        model.estaLogado() && endereco != null
                                            ? endereco
                                            : "Seu Endereço vai aparecer aqui após o login",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)))
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: size.height / 4,
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("ofertas")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: size.height / 4 - 10,
                                    child: _buildListOferta(
                                        snapshot.data.docs, context, size),
                                  ),
                                  Row(
                                    children: [],
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                            height: size.height / 4,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: _buildBody(context, size)),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    height: size.height,
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          height: size.height / 8,
                          padding: EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Receber em:",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 18),
                                  ),
                                  SizedBox(
                                      width: size.width - 100,
                                      child: Text(
                                          model.estaLogado() && endereco != null
                                              ? endereco
                                              : "Seu Endereço vai aparecer aqui após o login",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)))
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("ofertas")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: size.height - 40,
                                      child: _buildListOferta(
                                          snapshot.data.docs, context, size),
                                    ),
                                    Row(
                                      children: [],
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                              height: size.height,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: _buildBody(context, size)),
                        )
                      ],
                    ),
                  ),
                ),
        );
      }
    });
  }
}

//Metodo usado para construir o corpo do programa.
Widget _buildBody(BuildContext context, Size size) {
  var or = MediaQuery.of(context).orientation;
  return Container(
    padding: EdgeInsets.zero,
    height: or == Orientation.portrait ? size.height : 500,
    width: size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('produtos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());

            return Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Categorias",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Container(
                    height: 110,
                    child: _buildListCategory(context, snapshot.data.docs),
                  ),
                  Text("Para si",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  // Expanded(
                  //      child: FutureBuilder<QuerySnapshot>(
                  //    future: FirebaseFirestore.instance.collection('produtos').doc('frutas').collection()
                  //    builder: (context, snapshot) {
                  //      if (!snapshot.hasData) {
                  //        return Center(
                  //          child: Center(child: CircularProgressIndicator()),
                  //        );
                  //      }
                  //      return _builListVerticalOferta(snapshot.data.docs, context, size);
                  //    },
                  //  ))
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

// Widget _buildListDestaque(
//     List<DocumentSnapshot> snapshot, BuildContext context) {
//   DocumentSnapshot data;
//   DestProduto destProduto = DestProduto.fromDocument(data);
//   return ListView(
//     children: snapshot.map((data) {
//       return DestTile(destProduto);
//     }).toList(),
//   );
// }

Widget _builListVerticalOferta(
    List<DocumentSnapshot> snapshot, BuildContext context, Size size) {
  return ListView(
      children: snapshot
          .map((e) => _builListVerticalItem(e, context, size))
          .toList());
}

Widget _builListVerticalItem(
    DocumentSnapshot snapshot, BuildContext context, Size size) {
  Produto produto = Produto.fromsnapshot(snapshot);
  return Card(
    child: Row(
      children: [
        Container(
          color: Colors.green,
          height: 200,
          width: size.width,
          padding: EdgeInsets.all(8),
          child: Image.network(
            produto.images[0],
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produto.nome,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

//metodo criado e chamado para construir a lista de ofertas
Widget _buildListOferta(
    List<DocumentSnapshot> snapshot, BuildContext context, Size size) {
  return ListView(
    scrollDirection: Axis.horizontal,
    children: snapshot.map((data) {
      return _buildListOfertaItem(context, data, size);
    }).toList(),
  );
}

//metodo criado e chamado para construir cada item da lista de ofertas
Widget _buildListOfertaItem(
    BuildContext context, DocumentSnapshot data, Size size) {
  final Oferta oferta = Oferta.fromSnapshot(data);
  var or = MediaQuery.of(context).orientation;
  return Container(
    height: or == Orientation.portrait ? 150 : size.height - 20,
    width: size.width - 20,
    decoration: BoxDecoration(
        // image: DecorationImage(
        //     image: NetworkImage(oferta.capa[0]), fit: BoxFit.cover),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(15))),
    padding: EdgeInsets.zero,
    child: Carousel(
      dotSize: 5,
      borderRadius: true,
      dotPosition: DotPosition.bottomCenter,
      dotBgColor: Colors.transparent,
      dotSpacing: 15.0,
      dotVerticalPadding: 2,
      autoplayDuration: Duration(seconds: 15),
      dotColor: Theme.of(context).primaryColor,
      autoplay: true,
      animationCurve: Curves.easeOutCubic,
      images: oferta.capa.map((e) => NetworkImage(e)).toList(),
    ),
  );
}

//metodo criado para construir a lista de categorias
Widget _buildListCategory(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
      scrollDirection: Axis.horizontal,
      children: snapshot.map((data) {
        return _buildListItem(context, data);
      }).toList());
}

//metodo criado para criar e chamar cada item da lista de categoriaas
Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final Categoria record = Categoria.fromSnapshot(data);
  return Column(
      key: ValueKey(record.titulo),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProdutoScreen(snapshot: data);
              }));
            },
            child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.rectangle),
                child: Image.network(
                  record.icon,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            record.titulo,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ]);
}
