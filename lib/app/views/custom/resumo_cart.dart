import 'package:baby_names/app/models/cart.dart';
import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ResumoCart extends StatelessWidget {
  final VoidCallback onBuy;
  ResumoCart(this.onBuy);
  @override
  Widget build(BuildContext context) {
    CartModel.of(context).actualizarPreco();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
          padding: EdgeInsets.all(10),
          child: ScopedModelDescendant<CartModel>(
            builder: (context, child, model) {
              double subtotal = model.getSubtotal();
              double entrega = model.getEntrega();

              double total = subtotal + entrega;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Resumo do Pedido",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text("${subtotal.toStringAsFixed(2)} KZ",
                          style: TextStyle(
                            fontSize: 16.0,
                          ))
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Entrega",
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                      Text("${entrega.toStringAsFixed(2)} KZ",
                          style: TextStyle(
                            fontSize: 16.0,
                          ))
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${total.toStringAsFixed(2)} KZ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      onTap: onBuy,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            "Finalizar ordem",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
