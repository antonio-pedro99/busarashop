import 'package:flutter/material.dart';

class BtnLess extends StatelessWidget {
  final VoidCallback onClick;
  final String label;
  final double height;

  BtnLess({this.label, this.onClick, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.all(4),
          height: 50,
          width: 100,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
