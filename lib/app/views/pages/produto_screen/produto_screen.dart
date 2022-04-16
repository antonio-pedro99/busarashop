import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/views/pages/produto_details.dart/produtos_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutoScreen extends StatelessWidget {
  ProdutoScreen({this.snapshot});
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text((snapshot.data() as Map<String, dynamic>)['titulo']),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('produtos')
              .doc(snapshot.id)
              .collection('items')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(4.0),
                child: GridView.builder(
                    itemCount: snapshot.data.size,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                        childAspectRatio: 0.65),
                    itemBuilder: (context, index) {
                      Produto data =
                          Produto.fromsnapshot(snapshot.data.docs[index]);
                      data.categoria = this.snapshot.id;

                      return ProdutoTile((data));
                    }),
              );
            }
          },
        ));
  }
}
