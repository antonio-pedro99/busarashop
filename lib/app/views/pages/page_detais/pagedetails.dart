import 'package:baby_names/app/models/cart.dart';
import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/models/scopedmodels/cart_model.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
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
  Future<void> addToCart() async {
    setState(() {
      List<CartProduto> car = CartModel.of(context).cartProdutos;

      if (UserModel.of(context).estaLogado()) {
        CartProduto cartProduto = CartProduto();
        cartProduto.peso = widget.produto.peso;
        cartProduto.pid = widget.produto.id;
        cartProduto.categoria = widget.produto.categoria;
        cartProduto.produto = widget.produto;
        cartProduto.eLiquido = widget.produto.eLiquido;

        if (!car.contains(cartProduto)) {
          CartModel.of(context).addCartItem(context, cartProduto);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CarrinhoPage();
          }));
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                      "Este Produto já encontra-se no carrinho, incremente somente a quantidade!"),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PageLogin();
                          }));
                          Navigator.of(context).pop();
                        },
                        child: Text("Iniciar Sessão"))
                  ],
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Deves iniciar sessão primeiro!"),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PageLogin();
                        }));
                      },
                      child: Text("Iniciar Sessão"))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double preco = widget.produto.preco;
    bool tipo = widget.produto.eLiquido;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.produto.nome),
          elevation: 0,
        ),
        body: Column(children: [
          Container(
            height: 260,
            alignment: Alignment.topCenter,
            child: Center(
                child: Carousel(
              boxFit: BoxFit.fitWidth,
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
          Expanded(
              child: Card(
            margin: EdgeInsets.zero,
            elevation: 3,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.produto.nome,
                    style: TextStyle(
                        color: Colors.black54,
                        letterSpacing: 0.2,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
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
                  SizedBox(
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
            ),
          ))
        ]),
        extendBody: true,
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                addToCart();
              },
              child: CurvedButton(
                label: "Add no carrinho",
                largura: 100,
                altura: 56,
                colorBg: Theme.of(context).primaryColor,
                colorBorder: Colors.white,
                colorFg: Colors.white,
              ),
            )));
  }
}
