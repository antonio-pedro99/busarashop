import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String nome;
  double preco;
  double peso;
  String descricao;
  String categoria;
  List images;
  String id;
  bool eLiquido;

  DocumentReference reference;

  Produto(
      {this.nome,
      this.preco,
      this.peso,
      this.descricao,
      this.categoria,
      this.images,
      this.id,
      this.eLiquido});
      
  Produto.fromMap(Map<String, dynamic> snapshot, {this.reference})
      : assert(snapshot['id'] = !null),
        assert(snapshot['nome'] = !null),
        assert(snapshot['preco'] = !null),
        assert(snapshot['peso'] = !null),
        assert(snapshot['descricao'] = !null),
        assert(snapshot['images'] = !null),
        assert(snapshot['categoria'] != null),
        id = snapshot['id'],
        nome = snapshot['nome'],
        preco = snapshot['preco'] + 0.0,
        peso = snapshot['peso'] + 0.0,
        images = snapshot['images'],
        descricao = snapshot['descricao'],
        categoria = snapshot['categoria'],
        eLiquido = snapshot['eLiquido'];

  Produto.fromsnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    nome = (snapshot.data())['nome'];
    preco = (snapshot.data())['preco'] + 0.0;
    peso = (snapshot.data())['peso'] + 0.0;
    images = (snapshot.data())['images'];
    descricao = (snapshot.data())['descricao'];
    categoria = (snapshot.data())['categoria'];
    eLiquido = (snapshot.data())['eLiquido'];
  }

  Map<String, dynamic> toResumeMap() {
    return {"nome": nome, "preco": preco, "peso": peso};
  }

  @override
  String toString() =>
      "Produto<$nome:$preco:$peso:$images:$descricao:$categoria: $eLiquido>";
}
