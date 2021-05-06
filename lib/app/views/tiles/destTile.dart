import 'package:baby_names/app/models/produto_dest.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DestTile extends StatelessWidget {
  final DestProduto destProduto;

  DestTile(this.destProduto);
  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          padding: EdgeInsets.all(8),
          child: Image.network(
            destProduto.produto.images[0],
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destProduto.produto.nome,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                destProduto.produto.preco.toStringAsFixed(2) + " KZ",
                style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Container(
                        height: 35,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Text("Adicionar ao carrinho")),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: destProduto.produto == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('produtos')
                  .doc(destProduto.categoria)
                  .collection('items')
                  .doc(destProduto.pid)
                  .get(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  destProduto.produto = Produto.fromsnapshot(snapshot.data);
                  return _buildContent(context);
                } else {
                  return Container(
                    height: 70.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            )
          : _buildContent(context),
    );
  }
}
