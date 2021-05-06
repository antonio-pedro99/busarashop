import 'package:flutter/material.dart';

class CurvedButton extends StatelessWidget {
  CurvedButton(
      {Key key,
      this.colorBg,
      this.colorBorder,
      this.colorFg,
      this.label,
      this.altura: 60,
      this.largura: 100,
      this.onPress,
      this.eBold: true,
      this.fontSize: 20})
      : super(key: key);
  final double altura;
  final double largura;
  final Function onPress;
  final String label;
  final Color colorBg;
  final Color colorBorder;
  final Color colorFg;
  final double fontSize;
  final bool eBold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: altura,
      width: largura,
      decoration: BoxDecoration(
          color: colorBg,
          shape: BoxShape.rectangle,
          border: Border.all(color: colorBorder, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
              fontWeight: eBold ? FontWeight.bold : null,
              fontSize: fontSize,
              color: colorFg),
        ),
      ),
    );
  }
}
