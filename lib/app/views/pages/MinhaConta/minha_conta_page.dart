import 'package:baby_names/app/models/scopedmodels/user_model.dart';
import 'package:baby_names/app/views/custom/btn_log.dart';
import 'package:baby_names/app/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light),
          ),
        );
      },
    );
  }
}
