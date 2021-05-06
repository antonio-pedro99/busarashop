import 'package:flutter/material.dart';

class OrdenarPage extends StatefulWidget {
  @override
  _OrdenarPageState createState() => _OrdenarPageState();
}

class _OrdenarPageState extends State<OrdenarPage> {
  final GlobalKey<FormFieldState<String>> data = GlobalKey();
  final GlobalKey<FormFieldState<String>> metedoPagamento = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirmar Ordem"),
        ),
        body: SingleChildScrollView(child: Center()));
  }
}
