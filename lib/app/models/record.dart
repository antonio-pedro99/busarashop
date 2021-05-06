import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  final String titulo;
  final String icon;
  final DocumentReference reference;

  Categoria.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['titulo'] != null),
        assert(map['icon'] != null),
        titulo = map['titulo'],
        icon = map['icon'];

  Categoria.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$titulo:$icon>";
}
