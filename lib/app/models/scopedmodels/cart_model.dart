import 'package:baby_names/app/models/cart.dart';
import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduto> cartProdutos = [];

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  UserModel user;
  bool estaCarregando = false;

  CartModel({this.user}) {
    if (user.estaLogado()) {}
  }
  @override
  void addListener(listener) {
    // _loadCartItems();
    super.addListener(listener);
  }

  void addCartItem(BuildContext context, CartProduto cartProduto) {
    if (!cartProdutos.contains(cartProduto)) {
      cartProdutos.add(cartProduto);

      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.meu_user.uid)
          .collection('carrinho')
          .add(cartProduto.toMap())
          .then((doc) {
        cartProduto.cid = doc.id;
      });
      notifyListeners();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "Este produto já encontra-se no carrinho, incremente somente a quantidade desejada"),
            );
          });
    }
  }

  void removeCartItem(CartProduto cartProduto) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .doc(cartProduto.cid)
        .delete();

    cartProdutos.remove(cartProduto);
    notifyListeners();
  }

  double getSubtotal() {
    double preco = 0.0;
    for (CartProduto c in cartProdutos) {
      if (c.produto != null) {
        preco += c.peso * c.produto.preco;
      }
    }
    return preco.toDouble();
  }

  double getEntrega() {
    return 1000;
  }

  void actualizarPreco() {
    notifyListeners();
  }

  void incPeso(CartProduto cartProduto) {
    cartProduto.peso += 0.01;

    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .doc(cartProduto.cid)
        .update(cartProduto.toMap());

    notifyListeners();
  }

  void addPeso(CartProduto cartProduto, double newValue) {
    cartProduto.peso = newValue;
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .doc(cartProduto.cid)
        .update(cartProduto.toMap());

    notifyListeners();
  }

  void decPeso(CartProduto cartProduto) {
    cartProduto.peso -= 0.01;

    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .doc(cartProduto.cid)
        .update(cartProduto.toMap());

    notifyListeners();
  }

  Future<String> finalizarCompra() async {
    if (cartProdutos.length == 0) return null;

    estaCarregando = true;
    notifyListeners();
    initializeDateFormatting();
    double subtTotal = getSubtotal();
    double entrega = getEntrega();
    double total = subtTotal + entrega;

    DateTime now = DateTime.now();

    DocumentReference order =
        await FirebaseFirestore.instance.collection('pedidos').add({
      "data": DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, "pt_Pt")
          .format(now.toUtc())
          .toString(),
      "clienteId": user.meu_user.uid,
      "nomeCliente": user.userData["nome"],
      "subtotal": subtTotal,
      "entrega": entrega,
      "total": total,
      "produtos": cartProdutos.map((produtos) {
        return produtos.toMap();
      }).toList(),
      "status": 1
    });

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('pedidos')
        .doc(order.id)
        .set({"pedidoId": order.id});

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .get();
    for (DocumentSnapshot doc in querySnapshot.docs) {
      doc.reference.delete();
    }
    cartProdutos.clear();

    estaCarregando = false;
    notifyListeners();

    return order.id;
  }

  void _loadCartItems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.meu_user.uid)
        .collection('carrinho')
        .get();

    cartProdutos = snapshot.docs
        .map((DocumentSnapshot snapshot) => CartProduto.fromDocument(snapshot))
        .toList();
    notifyListeners();
  }
}
