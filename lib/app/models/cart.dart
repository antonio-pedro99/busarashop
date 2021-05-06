import 'package:baby_names/app/models/produtos.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduto {
  String cid;
  String pid;
  double peso;
  String categoria;
  Produto produto;
  String nome;
  bool eLiquido;
  CartProduto();

  CartProduto.fromDocument(DocumentSnapshot snapshot) {
    pid = snapshot.id.toString();
    categoria = snapshot.data()["categoria"];
    peso = snapshot.data()["peso"];
  }

  Map<String, dynamic> toMap() {
    return {
      "pid": pid,
      "categoria": categoria,
      "peso": peso,
      "produto": produto.toResumeMap()
    };
  }
}
