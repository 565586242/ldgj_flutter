import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/loading.dart';
import 'package:new_ldgj/login/LoginHead.dart';
import 'package:new_ldgj/login/LoginPwd.dart';
import 'package:new_ldgj/login/Registered.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCodePage extends StatefulWidget {
  LoginCodePage({Key key}) : super(key: key);

  @override
  _LoginCodePageState createState() => _LoginCodePageState();
}

class _LoginCodePageState extends State<LoginCodePage> {
  @override
  void initState() {
    //设置焦点监听
    _focusNodePhoneNumber.addListener(_focusNodeListener);
    _focusNodePhoneCode.addListener(_focusNodeListener);

    phoneNumber = '';
    phoneCode = '';
    sendCodeTime = 0;
    //监听手机号的输入改变
    _phoneNumberController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_phoneNumberController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
    });
    super.initState();
  }

  FocusNode _focusNodePhoneNumber = new FocusNode();
  FocusNode _focusNodePhoneCode = new FocusNode();
  var phoneNumber = ''; //手机号
  var phoneCode = ''; //验证码
  var sendCodeTime = 0; //发送验证码时间
  Timer _timer;  //定时器
  var _isShowClear = false; //是否显示输入框尾部的清除按钮
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _phoneNumberController = new TextEditingController();

  // 监听焦点
  Future _focusNodeListener() async {
    if (_focusNodePhoneNumber.hasFocus) {
      _focusNodePhoneCode.unfocus();
    }
    if (_focusNodePhoneCode.hasFocus) {
      _focusNodePhoneNumber.unfocus();
    }
  }

  Widget _logoImageArea() {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/login_logo@2x.png",
        width: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  startTime() {
    sendCodeTime = 60;
    final call = (timer) {
      setState(() {
        if (sendCodeTime < 1) {
          _timer.cancel();
        } else {
          sendCodeTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  Widget _inputTextArea() {
    return Container(
      margin: EdgeInsets.only(left: 38.5, right: 36.5),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _phoneNumberController,
              focusNode: _focusNodePhoneNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "手机号",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _phoneNumberController.clear();
                        },
                      )
                    : null,
              ),
              validator: (value) {
                if(value.isEmpty){
                  return "手机号不能为空";
                }else if(value.trim().length<11){
                  return '手机号长度不正确';
                }
                return null;
              },
              onChanged: (String value) {
                phoneNumber = value;
              },
            ),
            TextFormField(
              focusNode: _focusNodePhoneCode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "验证码",
                hintText: "请输入验证码",
                prefixIcon: Icon(Icons.verified_user),
                suffixIcon: Container(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if(sendCodeTime == 0){
                            var res = await AjaxUtil().postHttp(context, 
                              '/getphonecode',
                              data: {
                                "phone": phoneNumber,
                              }
                            );
                            if(res["code"] == 200){
                              Toast.toast(context,msg:res["msg"]);
                              startTime();
                            }else{
                              Toast.toast(context,msg:res["msg"]);
                            }
                          }
                        },
                        child: Text(
                          sendCodeTime == 0?"获取验证码":"${sendCodeTime}s",
                          textAlign: TextAlign.center,
                          style:
                            TextStyle(color: sendCodeTime == 0?Color.fromRGBO(206, 0, 10, 1):Colors.grey[500]),
                        ),
                      )
                    ],
                  ),
                )
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '验证码不能为空';
                }
                return null;
              }, 
              onSaved: (String value) {
                phoneCode = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
        margin: EdgeInsets.only(left: 37.5, right: 37.5),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(226, 48, 48, 1),
              Color.fromRGBO(206, 0, 10, 1)
            ])),
        child: ScopedModelDescendant<CommonModel>(
        builder: (BuildContext context, Widget child, CommonModel model){
         return GestureDetector(
          child: Text(
            "登录",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.9,
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            //点击登录按钮，解除焦点，回收键盘
            _focusNodePhoneNumber.unfocus();
            _focusNodePhoneCode.unfocus();

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              var res = await AjaxUtil().postHttp(context, 
                '/homelogin',
                data: {
                  "type": 2,
                  "phone": phoneNumber,
                  "code": phoneCode
                }
              );
              if(res["code"] == 200){
                Toast.toast(context,msg:res["msg"]);
                final prefs = await SharedPreferences.getInstance();
                  Toast.toast(context,msg:res["msg"]);
                  final setTokenResult = await prefs.setString('token', res["data"]['token']);
                  final setUserIdResult = await prefs.setInt('userId', res["data"]['user']["id"]);
                  if(res["data"]["user"] != null){
                    model.setUserInfo(res["data"]["user"]);
                  }
                  if(setTokenResult && setUserIdResult){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoadingPage()));
                  }
              }else{
                Toast.toast(context,msg:res["msg"]);
              }
            }
          },
         );
      }
        )
      );
  }

  Widget _loginType() {
    return Container(
      padding: EdgeInsets.only(left: 38.5, right: 37),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPwdPage()));
            },
            child: Text("密码登录"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginHead()));
            },
            child: Text("手势登录"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
            },
            child: Text("立即注册>"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _focusNodePhoneNumber.unfocus();
          _focusNodePhoneCode.unfocus();
        },
        child: ListView(
          children: <Widget>[
            SizedBox(height: 60),
            _logoImageArea(),
            SizedBox(height: 60),
            _inputTextArea(),
            SizedBox(height: 50),
            _loginBtn(),
            SizedBox(height: 30),
            _loginType()
          ],
        ),
      ),
    );
  }
}
