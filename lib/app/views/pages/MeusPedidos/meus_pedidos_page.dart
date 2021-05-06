import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:baby_names/app/views/pages/login_page.dart';
import 'package:baby_names/app/views/tiles/pedidos_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MeusPedidoPage extends StatefulWidget {
  @override
  _MeusPedidoPageState createState() => _MeusPedidoPageState();
}

class _MeusPedidoPageState extends State<MeusPedidoPage> {
  @override
  Widget build(BuildContext context) {
    String orderBy = "status";

    String _ordenar(String value) {
      setState(() {
        orderBy = value;
      });

      return orderBy;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Acompanhar meus Pedidos"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.estaLogado()) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(model.meu_user.uid)
                  .collection('pedidos')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    ),
                  );
                } else {
                  return ListView(
                    children: snapshot.data.docs
                        .map((e) => PedidosTile(
                              uid: e.id,
                            ))
                        .toList(),
                  );
                }
              },
            );
          } else {
            return Container(
              margin: EdgeInsets.fromLTRB(10, 80, 10, 30),
              height: 250,
              child: Container(
                  height: 150,
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Conteúdo indisponível, inicie uma sessão!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PageLogin();
                            }));
                          },
                          child: CurvedButton(
                            label: "fazer login",
                            colorBg: Theme.of(context).primaryColor,
                            colorBorder: Colors.green,
                            colorFg: Colors.white,
                            largura: 200,
                            altura: 45,
                          ),
                        )
                      ],
                    ),
                  )),
            );
          }
        },
      ),
    );
  }
}
