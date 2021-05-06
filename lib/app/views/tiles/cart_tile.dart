import 'package:baby_names/app/models/cart.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartTile extends StatefulWidget {
  final CartProduto cartProduto;
  CartTile({this.cartProduto});

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final newPeso = TextEditingController();
  double peso;

  double getPeso() {
    peso = double.parse(newPeso.text);
    return peso;
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          padding: EdgeInsets.all(8),
          child: Image.network(
            widget.cartProduto.produto.images[0],
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cartProduto.produto.nome,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.cartProduto.produto.preco.toStringAsFixed(2) + " KZ",
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
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: widget.cartProduto.peso >
                                      widget.cartProduto.produto.peso
                                  ? () {
                                      CartModel.of(context)
                                          .decPeso(widget.cartProduto);
                                    }
                                  : null),
                          Container(
                            height: 20,
                            width: 1,
                            color: Colors.white,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  CartModel.of(context).addPeso(
                                                      widget.cartProduto,
                                                      getPeso());
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Ok"))
                                          ],
                                          content: TextFormField(
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Escreva uma quantidade"),
                                            keyboardType: TextInputType.number,
                                            controller: newPeso,
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  "${widget.cartProduto.peso.toStringAsFixed(2)} ${widget.cartProduto.eLiquido ? "UN" : "Kg"}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )),
                          Container(
                            height: 18,
                            width: 1,
                            color: Colors.white,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                CartModel.of(context)
                                    .incPeso(widget.cartProduto);
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 25,
                          ),
                          onPressed: () {
                            CartModel.of(context)
                                .removeCartItem(widget.cartProduto);
                          }),
                    )
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
      child: widget.cartProduto.produto == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('produtos')
                  .doc(widget.cartProduto.categoria)
                  .collection('items')
                  .doc(widget.cartProduto.pid)
                  .get(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  widget.cartProduto.produto =
                      Produto.fromsnapshot(snapshot.data);
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
