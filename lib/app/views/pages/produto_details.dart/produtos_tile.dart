import 'package:baby_names/app/models/produtos.dart';
import 'package:baby_names/app/views/pages/page_detais/pagedetails.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProdutoTile extends StatelessWidget {
  ProdutoTile(this.produto);
  final Produto produto;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PageDetails(produto: produto);
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: FadeInImage.memoryNetwork(
                fadeInCurve: Curves.easeOut,
                fadeInDuration: Duration(seconds: 2),
                placeholder: kTransparentImage,
                image: produto.images[0],
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              margin: EdgeInsets.only(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text(
                      produto.preco.toDouble().toStringAsFixed(2) +
                          " Kz"
                              "${produto.eLiquido ? "" : " /Kg"}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
