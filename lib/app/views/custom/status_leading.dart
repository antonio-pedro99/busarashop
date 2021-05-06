import 'package:flutter/material.dart';

class StatusLeanding extends StatelessWidget {
  final String leading;
  final Color color;
  StatusLeanding({this.leading, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: 250,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: color),
        child: Center(
          child: Text(
            leading,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
