import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import '../../components/InputList.dart';
import '../../components/ButtonNormal.dart';

class ChangePayPage extends StatefulWidget {
  ChangePayPage({Key key}) : super(key: key);

  @override
  _ChangePayPageState createState() => _ChangePayPageState();
}

class _ChangePayPageState extends State<ChangePayPage> {
  var userPhone;
  var phoneCode;
  var payPassword;
  var confirmPayPassword;
  var sendCodeTime = 0; //发送验证码时间
  Timer _timer;  //定时器
  
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
        title: Text("修改密码"),
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
          InputList(
            title:"手机号码",
            hintText: "请输入手机号码",
            onChanged: (val) {
              userPhone = val;
            }
          ),
          InputList(
            title:"验  证  码",
            keyboardType: TextInputType.number,
            hintText: "请输入验证码",
            onChanged: (val) {
              phoneCode = val;
            },
            suffixIcon: Container(
              width: 90,
              padding: EdgeInsets.only(right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if(sendCodeTime == 0){
                        var res = await AjaxUtil().postHttp(context, 
                          '/getphonecode',
                          data: {
                            "phone": userPhone,
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
          InputList(
            title:"支付密码",
            obscureText: true,
            keyboardType: TextInputType.url,
            hintText: "请输入6位数支付密码",
            onChanged: (val) {
              payPassword = val;
            },
          ),
          InputList(
            title:"确认密码",
            hintText: "请再次输入支付密码",
            obscureText: true,
            keyboardType: TextInputType.url,
            onChanged: (val) {
              confirmPayPassword = val;
            },
          ),
          SizedBox(height: 84,),
          ButtonNormal(
            name: '保存设置',
            onTap: () async {
              var res = await AjaxUtil().postHttp(context, '/setPayPassword',data: {
                "user_phone": userPhone,
                "phone_code": phoneCode,
                "pay_password": payPassword,
                "confirm_pay_password": confirmPayPassword
              });
              if(res["code"] == 200){
                Toast.toast(context,msg:res["msg"]);
                Navigator.pop(context);
              }else{
                Toast.toast(context,msg:res["msg"]);
              }
            },
          )
        ],
      ),
    );
  }
}