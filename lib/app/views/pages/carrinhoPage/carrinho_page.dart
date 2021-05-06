import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/my_app.dart';
import 'package:baby_names/app/views/custom/btn_act.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:baby_names/app/views/custom/resumo_cart.dart';
import 'package:baby_names/app/views/pages/MeusPedidos/meus_pedidos_page.dart';
import 'package:baby_names/app/views/pages/login_page.dart';
import 'package:baby_names/app/views/tiles/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoPage extends StatefulWidget {
  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  @override
  Widget build(BuildContext context) {
    double saldo = UserModel.of(context).userData["saldo"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        elevation: 1,
        actions: [
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(top: 10.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int lenght = model.cartProdutos.length;
                return Text("${lenght ?? 0} ${lenght == 1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal));
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.estaCarregando) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).estaLogado()) {
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
        } else if (model.cartProdutos.length == 0 ||
            model.cartProdutos == null) {
          return Center(
            child: Text("Nenhum produto adicionado"),
          );
        } else {
          return ListView(
            children: [
              ResumoCart(() {
                showDialog(
                  context: context,
                  builder: (context) {
                    if (model.getSubtotal() >= 8000) {
                      return AlertDialog(
                        title: Text("Fazer Checkout"),
                        content: Container(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  "Receberás sua encomenda segundo os seus dados de endereço e mét. de pagamento" +
                                      " definido por ti, se pretenderes alterar, vá até as suas definições",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              BtnLess(
                                height: 30,
                                label: "Checkout",
                                onClick: () {
                                  onBuy(model.finalizarCompra().toString());
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return AlertDialog(
                        title: Text("Aviso"),
                        content: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text(
                                  "Impossível efetuar compra abaixo de 8.000 KZ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BtnLess(
                                height: 40,
                                label: "Add mais produtos",
                                onClick: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              }),
              Column(
                  children: model.cartProdutos.map((produto) {
                return CartTile(
                  cartProduto: produto,
                );
              }).toList()),
            ],
          );
        }
      }),
    );
  }

  Future<void> onBuy(String order) async {
    String orderId = await order;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return MyHome();
                  }));
                },
                child: CurvedButton(
                  altura: 30,
                  largura: 80,
                  colorBg: Colors.white,
                  colorFg: Colors.green,
                  colorBorder: Colors.white,
                  label: "Continuar",
                  fontSize: 10,
                  eBold: false,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return MeusPedidoPage();
                  }));
                },
                child: CurvedButton(
                  altura: 30,
                  largura: 80,
                  colorBg: Colors.white,
                  colorFg: Colors.green,
                  colorBorder: Colors.white,
                  fontSize: 10,
                  eBold: false,
                  label: "Ver pedidos",
                ),
              )
            ],
            content: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "O Seu pedido encontra-se em processamento!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ],
                )),
          );
        });
  }
}
