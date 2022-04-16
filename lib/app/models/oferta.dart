import 'package:cloud_firestore/cloud_firestore.dart';

class Oferta {
  List<dynamic> capa;
  List<dynamic> codigos;
  List<dynamic> descricao;

  Oferta();

  Oferta.fromSnapshot(DocumentSnapshot snapshot) {
    codigos = (snapshot.data())["codigo"];
    capa = (snapshot.data())["capa"];
    descricao = (snapshot.data())["descricao"];
  }
}
