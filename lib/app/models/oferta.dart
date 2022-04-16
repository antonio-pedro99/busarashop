import 'package:cloud_firestore/cloud_firestore.dart';

class Oferta {
  List<dynamic> capa;
  List<dynamic> codigos;
  List<dynamic> descricao;

  Oferta();

  Oferta.fromSnapshot(DocumentSnapshot snapshot) {
    codigos = (snapshot.data() as Map<String, dynamic>)["codigo"];
    capa = (snapshot.data() as Map<String, dynamic>)["capa"];
    descricao = (snapshot.data() as Map<String, dynamic>)["descricao"];
  }
}
