import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class ForgetPwdPage extends StatefulWidget {
  ForgetPwdPage({Key key}) : super(key: key);

  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  Timer _timer;
  var sendCodeTime = 0;
  var _data = {
    "name": '',
    "phone": '',
    "code": '',
    "password": '',
    "repassword": ''
  };

  @override
  void initState() { 
    _data["name"] = "";
    _data["phone"] = "";
    _data["code"] = "";
    _data["password"] = "";
    _data["repassword"] = "";
    sendCodeTime = 0;
    super.initState();
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

  Widget _formView() {
    return Container(
      padding: EdgeInsets.fromLTRB(38.5, 0, 36.5, 0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "用户名",
                hintText: "请输入用户名"
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) {_data["name"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                labelText: "手机号",
                hintText: "请输入手机号"
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {_data["phone"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.verified_user),
                labelText: "验证码",
                hintText: "请输入验证码",
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
                                "phone": _data["phone"],
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
              keyboardType: TextInputType.number,
              onChanged: (value) {_data["code"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: "登录密码",
                hintText: "请输入登录密码"
              ),
              obscureText: true,
              keyboardType: TextInputType.url,
              onChanged: (value) {_data["password"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: "登录密码",
                hintText: "请确认登录密码",
              ),
              obscureText: true,
              keyboardType: TextInputType.url,
              onChanged: (value) {_data["repassword"] = value;},
            ),
          ],
        ),
      )
    );
  }

  Widget _loginBtn() {
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
          "确认修改",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.9,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: () async {
          var res = await AjaxUtil().postHttp(context, 
            '/homeresetpass',
            data: _data
          );
          if(res["code"] == 200){
            Toast.toast(context,msg:res["msg"]);
            Navigator.pop(context);
          }else{
            Toast.toast(context,msg:res["msg"]);
          }
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("忘记密码"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(226,48,54, 1),
                Color.fromRGBO(208,0,8, 1)
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          _formView(),
          SizedBox(height: 40),
          _loginBtn(),
        ],
      ),
    );
  }
}