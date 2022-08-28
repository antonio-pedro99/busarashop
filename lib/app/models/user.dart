class Usuario {
  String nome;
  String email;
  String endereco;
  String contacto;
  List metodoPagamento;
  int saldo;

  Usuario();

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'endereco': endereco,
      'contacto': contacto,
      'metodo_pagamento': ["Pagamento na Entrega", "Transferência"],
      'saldo': saldo
    };
  }
}
