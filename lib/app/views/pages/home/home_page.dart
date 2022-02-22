import 'package:baby_names/app/models/oferta.dart';
import 'package:baby_names/app/models/produto_dest.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/models/record.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/pages/produto_details.dart/produtos_tile.dart';
import 'package:baby_names/app/views/pages/produto_screen/produto_screen.dart';
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
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                stretch: true,
                elevation: 0,
                toolbarHeight: 85,
                backgroundColor: Colors.white,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Receber em:",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                        Text(
                            model.estaLogado() && endereco != null
                                ? endereco
                                : "Precisas fazer login",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                SafeArea(
                    child: Container(
                  padding: EdgeInsets.only(left: 2, right: 2),
                  height: size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      //build category list
                      Expanded(
                        child: Container(
                            height: size.height / 4,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: _buildBody(context, size)),
                      )
                    ],
                  ),
                ))
              ]))
            ],
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
                  Expanded(
                      child: Container(
                    child: ListView(
                      children: [
                        ProdutoTile(Produto())
                      ],
                    ),
                  ))
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
