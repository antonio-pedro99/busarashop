import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:baby_names/app/views/pages/cadastrar_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formkey = GlobalKey<FormState>();
  final senhaController = TextEditingController();
  final emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void onSucess() {
    Navigator.of(context).pop();
  }

  void onFail() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Erro ao entrar"),
        duration: Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.estaCarregando) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(children: [
            Container(
              height: 660,
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 140, child: Image.asset('assets/logo.jpg')),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Form(
                      key: _formkey,
                      child: Container(
                          height: 240,
                          child: ListView(
                            children: [
                              TextFormField(
                                controller: emailController,
                                validator: (str) {
                                  if (str.isEmpty || !str.contains("@")) {
                                    return "This cannot be an empty field.";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(55))),
                                    filled: true,
                                    fillColor: Colors.grey[400],
                                    hintText: "Escreva aqui seu email"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: senhaController,
                                obscureText: true,
                                validator: (text) {
                                  if (text.isEmpty || text.length < 6) {
                                    return "Senha inválida";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(55))),
                                    filled: true,
                                    fillColor: Colors.grey[400],
                                    hintText: "Senha"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formkey.currentState.validate()) {
                                    // model.verificar();
                                    model.fazerLogin(
                                        senha: senhaController.text,
                                        email: emailController.text,
                                        onSucess: onSucess,
                                        onFail: onFail);
                                  }
                                },
                                child: CurvedButton(
                                  label: "Entrar",
                                  largura: 100,
                                  altura: 55,
                                  colorBg: Theme.of(context).primaryColor,
                                  colorBorder: Colors.white,
                                  colorFg: Colors.white,
                                ),
                              ),
                            ],
                          ))),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return SigInPage();
                        }));
                      },
                      child: Text("Não tens uma conta? Cadastra-se")),
                  Container(
                    width: 300,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/login.jpg',
                    ),
                  )
                ],
              ),
            ),
          ]);
        }));
  }
}
