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
    nome = (snapshot.data() as Map<String, dynamic>)['nome'];
    preco = (snapshot.data() as Map<String, dynamic>)['preco'] + 0.0;
    peso = (snapshot.data() as Map<String, dynamic>)['peso'] + 0.0;
    images = (snapshot.data() as Map<String, dynamic>)['images'];
    descricao = (snapshot.data() as Map<String, dynamic>)['descricao'];
    categoria = (snapshot.data() as Map<String, dynamic>)['categoria'];
    eLiquido = (snapshot.data() as Map<String, dynamic>)['eLiquido'];
  }

  Map<String, dynamic> toResumeMap() {
    return {"nome": nome, "preco": preco, "peso": peso};
  }

  @override
  String toString() =>
      "Produto<$nome:$preco:$peso:$images:$descricao:$categoria: $eLiquido>";
}
