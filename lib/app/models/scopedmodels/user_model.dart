import 'package:baby_names/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as user;
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:device_info/device_info.dart';

class UserModel extends Model {
  bool estaCarregando = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User meu_user;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  Map<String, dynamic> userData = Map();

  Map<String, dynamic> log = Map();

  @override
  void addListener(listener) {
    super.addListener(listener);
    _carregarUsuario();
  }

  void criarConta(
      {Map<String, dynamic> userData,
      String pass,
      VoidCallback onSucess,
      VoidCallback onFail}) {
    estaCarregando = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((user) async {
      meu_user = user.user;
      await _salvarDadosUsuario(userData);
      _salvaLogin();
      onSucess();
      estaCarregando = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      estaCarregando = false;
      notifyListeners();
    });
  }

  void recuperarSenha(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  void fazerLogin(
      {String senha,
      String email,
      VoidCallback onSucess,
      VoidCallback onFail}) async {
    estaCarregando = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((user) async {
      meu_user = user.user;

      if (user != null) {
        _salvaLogin();
      }
      await _carregarUsuario();

      onSucess();
      estaCarregando = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      estaCarregando = false;
      notifyListeners();
    });
  }

  void fazerLogout() async {
    await _auth.signOut();
    userData = Map();
    meu_user = null;
    notifyListeners();
  }

  void verificar() {
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print("Usuário n está logado!");
      } else {
        print("logado com sucesso");
      }
    });
  }

  bool estaLogado() {
    return meu_user != null;
  }

  Future<Null> _salvaLogin() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

    log = {
      "data": Timestamp.now().toDate(),
      "device": androidDeviceInfo.model + " " + androidDeviceInfo.brand
    };
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_auth.currentUser.uid)
        .collection('logins')
        .add(log);
  }

  Future<Null> _salvarDadosUsuario(Map<String, dynamic> data) async {
    this.userData = data;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_auth.currentUser.uid)
        .set(data);
  }

//Add metodo de pagemento
  String getMetodoPagamento() {
    return userData["metodoPagamento"].toString();
  }

  Future<Null> addMetodoPagamento(Usuario usuario, String newMetodo) async {
    usuario.metodoPagamento.add(newMetodo);
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_auth.currentUser.uid)
        .update(usuario.toMap());

    notifyListeners();
  }

  Future<Null> _carregarUsuario() async {
    if (meu_user == null) meu_user = await _auth.currentUser;
    if (meu_user != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(meu_user.uid)
            .get();
        userData = snapshot.data();
      }
    }
    notifyListeners();
  }
}
