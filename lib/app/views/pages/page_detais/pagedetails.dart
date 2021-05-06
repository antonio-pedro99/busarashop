import 'package:baby_names/app/models/cart.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/pages/carrinhoPage/carrinho_page.dart';
import 'package:baby_names/app/views/pages/login_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class PageDetails extends StatefulWidget {
  PageDetails({Key key, this.produto}) : super(key: key);

  final Produto produto;
  @override
  _PageDetailsState createState() => _PageDetailsState();
}

class _PageDetailsState extends State<PageDetails> {
  @override
  Widget build(BuildContext context) {
    double preco = widget.produto.preco;
    bool tipo = widget.produto.eLiquido;

    bool eFavorito = true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.produto.nome),
        elevation: 0,
      ),
      body: Container(
          child: Stack(children: [
        Container(
          height: 260,
          alignment: Alignment.topCenter,
          child: Center(
              child: Carousel(
            dotSize: 5,
            dotPosition: DotPosition.bottomCenter,
            dotBgColor: Colors.transparent,
            dotSpacing: 15.0,
            dotColor: Theme.of(context).primaryColor,
            autoplay: false,
            animationCurve: Curves.easeOutCubic,
            images: widget.produto.images.map((url) {
              return NetworkImage(url);
            }).toList(),
          )),
        ),
        Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 240),
                height: 350,
                width: 500,
                child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.produto.nome,
                                style: TextStyle(
                                    color: Colors.black54,
                                    letterSpacing: 0.2,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            '${preco.toDouble().toStringAsFixed(2)} ' +
                                "Kz" +
                                "${tipo ? "" : " /Kg"}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(widget.produto.descricao,
                              softWrap: true,
                              maxLines: 8,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ))),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 70,
                child: SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        List<CartProduto> car =
                            CartModel.of(context).cartProdutos;

                        if (UserModel.of(context).estaLogado()) {
                          CartProduto cartProduto = CartProduto();
                          cartProduto.peso = widget.produto.peso;
                          cartProduto.pid = widget.produto.id;
                          cartProduto.categoria = widget.produto.categoria;
                          cartProduto.produto = widget.produto;
                          cartProduto.eLiquido = widget.produto.eLiquido;

                          if (!car.contains(cartProduto)) {
                            CartModel.of(context)
                                .addCartItem(context, cartProduto);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CarrinhoPage();
                            }));
                          } else {
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  content: Text(
                                      "Este Produto já encontra-se no carrinho, incremente somente a quantidade!"),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PageLogin();
                                          }));
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Iniciar Sessão"))
                                  ],
                                ));
                          }
                        } else {
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                content: Text("Deves iniciar sessão primeiro!"),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return PageLogin();
                                        }));
                                      },
                                      child: Text("Iniciar Sessão"))
                                ],
                              ));
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      height: 50,
                      width: 500,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "Add no carrinho",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
      ])),
    );
  }
}
