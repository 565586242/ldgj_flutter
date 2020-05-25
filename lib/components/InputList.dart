import 'package:flutter/material.dart';

class InputList extends StatefulWidget {
  final String title;
  final String hintText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  InputList({Key key,this.title,this.hintText,this.suffixIcon,this.controller,this.onChanged,this.keyboardType,this.obscureText = false}) : super(key: key);

  @override
  _InputListState createState() => _InputListState();
}

class _InputListState extends State<InputList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: EdgeInsets.only(left: 14),
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Container(
            width: 80,
            child: Text(
              widget.title,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 15
              ),
            ),
          ),
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText
        ),
      ),
    );
  }
}