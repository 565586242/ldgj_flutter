import 'package:flutter/material.dart';

class ButtonNormal extends StatefulWidget {
  final name;
  final onTap;
  ButtonNormal({Key key,this.name,this.onTap}) : super(key: key);

  @override
  _ButtonNormalState createState() => _ButtonNormalState();
}

class _ButtonNormalState extends State<ButtonNormal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 37.5,right: 37.5),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(226, 48, 48, 1),
          Color.fromRGBO(206, 0, 10, 1)
        ])
      ),
      child: GestureDetector(
        child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.9,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: widget.onTap
      )
    );
  }
}