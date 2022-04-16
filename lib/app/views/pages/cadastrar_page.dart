import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/models/user.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SigInPage extends StatefulWidget {
  @override
  _SigInPageState createState() => _SigInPageState();
}

class _SigInPageState extends State<SigInPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final enderecoController = TextEditingController();
  final contactosController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String endereco = "";



  Widget _buildBack() {
    return Image.asset('assets/bg.jpg');
  }

  void onFail() {
    setState(() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Erro ao criar"),
        duration: Duration(seconds: 2),
      ));
    });
  }

  void onSucess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Seja bem vindo!"),
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 1))
        .then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
              if (model.estaCarregando) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Form(
                  key: _formKey,
                  child: Expanded(
                      child: Container(
                          child: ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 140,
                          child: Image.asset('assets/logo.jpg')),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: nomeController,
                        keyboardType: TextInputType.text,
                        validator: (str) {
                          if (str.isEmpty || str.contains(RegExp(r'[0-9]'))) {
                            return "Nome inválido";
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText: "Seu nome"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty || !text.contains("@")) {
                            return "Email inválido!";
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText: "Escreva seu email"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (str) {
                          if (str.isEmpty) {
                            return "Campo vazio!";
                          } else if (str.length < 10) {
                            return "Escreva um endereço completo";
                          }
                        },
                        controller: enderecoController,
                        decoration: InputDecoration(
                            //suffixIcon: Icon(Icons.my_location),

                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText:
                                "Endereço (Como: Município, comuna, bairro, rua e número da casa)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: contactosController,
                        keyboardType: TextInputType.phone,
                        validator: (str) {
                          if (str.isEmpty) {
                            return "Campo obrigatório";
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText: "Contacto (Exemplo: 9XX XXX XXX)"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passController,
                        obscureText: true,
                        validator: (str) {
                          if (str.length < 6 || str.isEmpty) {
                            return "Senha inválida(A senha deve ter no mínimo 6 caracteres)";
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55))),
                            filled: true,
                            fillColor: Colors.grey[400],
                            hintText: "Criar Senha"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            Usuario userData = Usuario();
                            List pagamentos_metodo = [
                              "Check On Delivery",
                              "Transferência"
                            ];
                            userData.nome = nomeController.text;
                            userData.email = emailController.text;
                            userData.endereco = enderecoController.text;
                            userData.contacto = contactosController.text;
                            userData.metodoPagamento = pagamentos_metodo;

                            model.criarConta(
                                userData: userData.toMap(),
                                pass: passController.text,
                                onFail: onFail,
                                onSucess: onSucess);
                          }
                        },
                        child: CurvedButton(
                          label: "Cadastrar",
                          largura: 100,
                          altura: 55,
                          colorBg: Theme.of(context).primaryColor,
                          colorBorder: Colors.white,
                          colorFg: Colors.white,
                        ),
                      ),
                    ],
                  ))));
            })
          ],
        ));
  }
}
