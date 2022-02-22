import 'dart:collection';

import 'package:baby_names/app/views/custom/status_leading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidosTile extends StatelessWidget {
  final String uid;
  PedidosTile({this.uid});

  String _buildPedidoDesc(DocumentSnapshot snapshot) {
    String texto = "Breve Descrição\n";
    double total = (snapshot.data() as Map<String, dynamic>)["total"];
    double entrega = (snapshot.data() as Map<String, dynamic>)["entrega"];
    for (LinkedHashMap p in (snapshot.data() as Map<String, dynamic>)['produtos']) {
      var tipo = p["produto"]["eLiquido"];
      String unidade = p["produto"]["eLiquido"] == true ? "UN" : "Kg";
      print(tipo);
      texto +=
          "Produto : ${p["peso"].toStringAsFixed(2)} $unidade de ${p["produto"]["nome"]}\n";
    }
    texto += "Entrega : ${entrega.toStringAsFixed(2)} KZ\n";
    texto += "Total : ${total.toStringAsFixed(2)} KZ";

    return texto;
  }

  Widget _buildCircle(String titulo, IconData icon, int status, int thisStatus,
      BuildContext context) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.green[200];
      child = Icon(
        icon,
        color: Colors.white,
      );
    } else if (status == thisStatus) {
      backColor = Colors.green[600];
      child = Stack(
        children: [
          Center(
            child: Icon(icon),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          child: Center(
            child: child,
          ),
        ),
        StatusLeanding(
          leading: titulo,
          color: backColor,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(10),
          title: Text(
            "Código do Pedido : ".toUpperCase() + uid.toString().toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pedidos')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return DefaultTextStyle(
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.normal,
                          fontSize: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Data: " + (snapshot.data.data() as Map<String, dynamic>)['data'],
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(_buildPedidoDesc(snapshot.data)),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(height: 5),
                          Text("Status",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCircle("Preparação", Icons.access_time,
                                  (snapshot.data.data() as Map<String, dynamic>)["status"], 1, context),
                              Container(
                                height: 20,
                                width: 1.0,
                                color: Colors.grey[200],
                              ),
                              _buildCircle("Pedido Aceite", Icons.access_time,
                                  (snapshot.data.data() as Map<String, dynamic>)["status"], 2, context),
                              Container(
                                height: 20,
                                width: 1.0,
                                color: Colors.grey[200],
                              ),
                              _buildCircle("Transporte", Icons.time_to_leave,
                                  (snapshot.data.data() as Map<String, dynamic>)["status"], 3, context),
                              Container(
                                height: 20,
                                width: 1.0,
                                color: Colors.grey[200],
                              ),
                              _buildCircle("Entrega", Icons.assessment,
                                  (snapshot.data.data() as Map<String, dynamic>)["status"], 4, context),
                            ],
                          )
                        ],
                      ));
                }
              },
            ),
          ],
        ));
  }
}
