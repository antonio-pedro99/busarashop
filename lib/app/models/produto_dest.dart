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
    nome = (snapshot.data() as Map<String, dynamic>)["nome"];
    categoria = (snapshot.data() as Map<String, dynamic>)["categoria"];
    preco = (snapshot.data() as Map<String, dynamic>)["preco"];
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
