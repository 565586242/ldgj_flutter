import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Widget _logoImageArea(){
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "lib/assets/login_logo@2x.png",
        width: 100,
        fit: BoxFit.cover,
      ),
    );
  }
  var sendCodeTime = 0;
  Timer _timer;
  var _data = {
    "name": '',
    "phone": '',
    "code": '',
    "password": '',
    "repassword": '',
    "recode": ''
  };

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
  

  @override
  void initState() { 
    sendCodeTime = 0;
    super.initState();
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
              keyboardType: TextInputType.multiline,
              onChanged: (String value){_data["name"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                labelText: "手机号",
                hintText: "请输入手机号"
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value){_data["phone"] = value;},
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
              onChanged: (String value){_data["code"] = value;},
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: "登录密码",
                hintText: "请输入登录密码"
              ),
              keyboardType: TextInputType.url,
              onChanged: (String value){_data["password"] = value;},
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                labelText: "登录密码",
                hintText: "请确认登录密码"
              ),
              keyboardType: TextInputType.url,
              onChanged: (String value){_data["repassword"] = value;},
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.favorite),
                labelText: "邀请码",
                hintText: "请输入邀请码"
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value){_data["recode"] = value;},
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
          "注册",
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
            '/homeregister',
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
        title: Text("注 册"),
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
          _logoImageArea(),
          SizedBox(height: 10),
          _formView(),
          SizedBox(height: 20),
          _loginBtn(),
        ],
      ),
    );
  }
}
