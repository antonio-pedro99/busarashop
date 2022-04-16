import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:baby_names/app/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MinhaContaPage extends StatefulWidget {
  @override
  _MinhaContaPageState createState() => _MinhaContaPageState();
}

class _MinhaContaPageState extends State<MinhaContaPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        double saldo = model.userData["saldo"];
        List metodo_pagemento = model.userData["metodo_pagamento"];
        int _currentMetodo = 0;

        void _pegarCurrentValue(int value) {
          setState(() {
            _currentMetodo = value;

            switch (_currentMetodo) {
              case 0:
                break;
              case 1:
                break;

              default:
            }
          });
        }

        if (model.estaLogado()) {
          return ListView(
            children: [
              SizedBox(
                height: size.height / 5,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          height: size.height / 3,
                          decoration: BoxDecoration(color: Colors.green),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Meu Perfil",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        setState(() {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Desejas Terminar Sessão?"),
                                                  actions: [
                                                    OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Não")),
                                                    OutlinedButton(
                                                        onPressed: () {
                                                          UserModel.of(context)
                                                              .fazerLogout();
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                            return PageLogin();
                                                          }));
                                                        },
                                                        child: Text("Sim"))
                                                  ],
                                                );
                                              });
                                        });
                                      });
                                    },
                                    child: Container(
                                        height: 25,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sair",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16),
                                          ),
                                        )),
                                  )
                                ],
                              )),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(10, 55, 10, 0),
                          elevation: 1,
                          borderOnForeground: true,
                          shape: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide.none),
                          child: Container(
                            height: 120,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: DefaultTextStyle(
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                model.userData["nome"]
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  model.userData["email"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Card(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 30),
                  elevation: 1,
                  borderOnForeground: true,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none),
                  child: Container(
                    height: 270,
                    child: Container(
                        height: 150,
                        padding: EdgeInsets.only(top: 15),
                        child: ListView(
                          padding: EdgeInsets.all(2),
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Alterar Método de Pagamento"),
                                            content: Container(
                                              height: 100,
                                              child: ListView(
                                                padding: EdgeInsets.all(2),
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 0,
                                                        groupValue:
                                                            _currentMetodo,
                                                        onChanged:
                                                            _pegarCurrentValue,
                                                      ),
                                                      Text(metodo_pagemento[0]
                                                          .toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Confirmar")),
                                            ],
                                          );
                                        });
                                  });
                                });
                              },
                              child: ListTile(
                                leading: Icon(Icons.card_giftcard),
                                title: Text(
                                  "Método de pagamento",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                subtitle: Text(
                                    model.userData["metodo_pagamento"]
                                        [_currentMetodo]),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.monetization_on),
                              title: Text(
                                "Carregar carteira de pagamento",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                              subtitle: Text(
                                  "Transferir quantia em AKZ para sua carteira"),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text(
                                "Relatório de Gastos",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                              subtitle: Text(
                                  "Ver seu histórico de compras e poupanças"),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )),
                  )),
            ],
          );
        } else {
          return ListView(
            children: [
              SizedBox(
                height: 240,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 150,
                          decoration: BoxDecoration(color: Colors.green),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Meu Perfil",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) {
                                        return PageLogin();
                                      }));
                                    },
                                    child: Container(
                                        height: 25,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Entrar",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          ),
                                        )),
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 80, 10, 30),
                height: 250,
                child: Container(
                    height: 150,
                    padding: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Conteúdo indisponível, inicie uma sessão!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PageLogin();
                              }));
                            },
                            child: CurvedButton(
                              label: "fazer login",
                              colorBg: Theme.of(context).primaryColor,
                              colorBorder: Colors.green,
                              colorFg: Colors.white,
                              largura: 200,
                              altura: 45,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          );
        }
      },
    );
  }
}
