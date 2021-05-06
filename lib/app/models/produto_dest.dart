import 'package:baby_names/app/models/produtos.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DestProduto {
  String cid;
  String pid;
  double preco;
  String categoria;
  Produto produto;
  String nome;
  bool eLiquido;

  DestProduto();

  DestProduto.fromDocument(DocumentSnapshot snapshot) {
    pid = snapshot.id.toString();
    nome = snapshot.data()["nome"];
    categoria = snapshot.data()["categoria"];
    preco = snapshot.data()["preco"];
  }

  Map<String, dynamic> toMap() {
    return {
      "pid": pid,
      "categoria": categoria,
      "preco": preco,
      "produto": produto.toResumeMap()
    };
  }
}
