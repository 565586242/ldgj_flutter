import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/CustomJPassword.dart';
import 'package:new_ldgj/components/MyKeyboard.dart';
import 'package:new_ldgj/components/Toast.dart';

/// 支付密码  +  自定义键盘
class MainKeyboard extends StatefulWidget {

  final Map formInfo;

  MainKeyboard({Key key,this.formInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainKeyboardState();
}

class MainKeyboardState extends State<MainKeyboard> {
  /// 用户输入的密码
  String pwdData = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // VoidCallback：没有参数并且不返回数据的回调
  VoidCallback _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    return new Container(
      width: double.maxFinite,
      height: 300.0,
      color: Color(0xffffffff),
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: new Text(
              '请在此输入新支付密码',
              style: new TextStyle(fontSize: 18.0, color: Color(0xff333333)),
            ),
          ),
          ///密码框
          new Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildPwd(pwdData),
          ),
        ],
      ),
    );
  }

  submitorder() async {
    widget.formInfo["pay_password"] = pwdData;
    var res = await AjaxUtil().postHttp(context, '/submitorder',data: widget.formInfo);
    if(res["code"] == 200){
      Toast.toast(context,msg:res["msg"]);
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
      Toast.toast(context,msg:res["msg"]);
    }
  }

  /// 密码键盘 确认按钮 事件
  void onAffirmButton() async {
    submitorder();
  }

  void _onKeyDown(KeyEvent data) {
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    }else {
      if ((pwdData.length + 1) < 6) {
        pwdData += data.key;
      }else{
        pwdData += data.key;
        submitorder();
      }
      setState(() {});
    }
  }

  void _showBottomSheet() {
    if(_showBottomSheetCallback != null){
      setState(() {
        _showBottomSheetCallback = null;
      });
    }

    /*
      currentState：获取具有此全局键的树中的控件状态
      showBottomSheet：显示持久性的质感设计底部面板
      解释：联系上文，_scaffoldKey是Scaffold框架状态的唯一键，因此代码大意为，
           在Scaffold框架中显示持久性的质感设计底部面板
     */
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          /// 将自定义的密码键盘作为其child   这里将回调函数传入
          return new MyKeyboard(_onKeyDown);
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button  // 重新启用按钮
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  /// 构建 密码输入框  定义了其宽度和高度
  Widget _buildPwd(var pwd) {
    return new GestureDetector(
      child: new Container(
        width: 300.0,
        height: 40.0,
        child: new CustomJPasswordField(pwd),
      ),
      onTap: () {
        _showBottomSheetCallback();
      },
    );
  }
}
