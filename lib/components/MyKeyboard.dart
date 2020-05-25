import 'package:flutter/material.dart';
import 'package:new_ldgj/components/InputPayBtn.dart';

/// 自定义密码 键盘
class MyKeyboard extends StatefulWidget {
  final callback;

  MyKeyboard(this.callback);

  @override
  State<StatefulWidget> createState() {
    return new MyKeyboardStat();
  }
}

class MyKeyboardStat extends State<MyKeyboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 定义 确定 按钮 接口  暴露给调用方
  ///回调函数执行体
  var backMethod;

  void onCommitChange() {
    widget.callback(new KeyEvent("commit"));
  }

  void onKeyChange(BuildContext context, int key) {
    widget.callback(new KeyEvent("$key"));
  }

  /// 点击删除
  void onDeleteChange() {
    widget.callback(new KeyEvent("del"));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: 250.0,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            height:30.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: new Text(
              '下滑隐藏',
              style: new TextStyle(fontSize: 12.0, color: Color(0xff999999)),
            ),
          ),

          ///  键盘主体
          new Column(
            children: <Widget>[
              ///  第一行
              new Row(
                children: <Widget>[
                  InputPayBtn(
                      text: '1', callback: (val) => onKeyChange(context,1)),
                  InputPayBtn(
                      text: '2', callback: (val) => onKeyChange(context,2)),
                  InputPayBtn(
                      text: '3', callback: (val) => onKeyChange(context,3)),
                ],
              ),

              ///  第二行
              new Row(
                children: <Widget>[
                  InputPayBtn(
                      text: '4', callback: (val) => onKeyChange(context,4)),
                  InputPayBtn(
                      text: '5', callback: (val) => onKeyChange(context,5)),
                  InputPayBtn(
                      text: '6', callback: (val) => onKeyChange(context,6)),
                ],
              ),

              ///  第三行
              new Row(
                children: <Widget>[
                  InputPayBtn(
                      text: '7', callback: (val) => onKeyChange(context,7)),
                  InputPayBtn(
                      text: '8', callback: (val) => onKeyChange(context,8)),
                  InputPayBtn(
                      text: '9', callback: (val) => onKeyChange(context,9)),
                ],
              ),

              ///  第四行
              new Row(
                children: <Widget>[
                  InputPayBtn(text: ''),
                  InputPayBtn(
                      text: '0', callback: (val) => onKeyChange(context,0)),
                  InputPayBtn(text: '删除', callback: (val) => onDeleteChange()),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

///  支符密码  用于 密码输入框和键盘之间进行通信
class KeyEvent {
 ///  当前点击的按钮所代表的值
  String key;
  KeyEvent(this.key);

  bool isDelete() => this.key == "del";
  bool isCommit() => this.key == "commit";
}