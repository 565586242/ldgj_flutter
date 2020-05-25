import 'package:flutter/material.dart';

class InputPayBtn extends StatefulWidget {
  final String text;
  final callback;
  InputPayBtn({Key key, this.text, this.callback}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => ButtonState();
}

class ButtonState extends State<InputPayBtn> {
  ///回调函数执行体
  var backMethod;

  void back() {
    widget.callback('$backMethod');
  }

  @override
  Widget build(BuildContext context) {

 /// 获取当前屏幕的总宽度，从而得出单个按钮的宽度
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    return new Container(
        height:50.0,
        width: _screenWidth / 3,
        child: new OutlineButton(
          // 直角
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(0.0)),
          // 边框颜色
          borderSide: new BorderSide(color: Color(0x10333333)),
          child: new Text(
            widget.text,
            style: new TextStyle(color: Color(0xff333333), fontSize: 20.0),
          ),
         // 按钮点击事件
          onPressed: back,
        ));
  }
}