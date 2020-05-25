import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import '../../components/InputList.dart';
import '../../components/ButtonNormal.dart';

class ChangePhonePage extends StatefulWidget {
  ChangePhonePage({Key key}) : super(key: key);

  @override
  _ChangePhonePageState createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {

  var userPhone;
  var code;
  var newPhone;
  var newCode;
  var oldSendCodeTime = 0; //发送验证码时间
  Timer _oldTimer;  //定时器
  var newSendCodeTime = 0; //发送验证码时间
  Timer _newTimer;  //定时器

  oldStartTime() {
    oldSendCodeTime = 60;
    final call = (timer) {
      setState(() {
        if (oldSendCodeTime < 1) {
          _oldTimer.cancel();
        } else {
          oldSendCodeTime -= 1;
        }
      });
    };
    _oldTimer = Timer.periodic(Duration(seconds: 1), call);
  }

  newStartTime() {
    newSendCodeTime = 60;
    final call = (timer) {
      setState(() {
        if (newSendCodeTime < 1) {
          _newTimer.cancel();
        } else {
          newSendCodeTime -= 1;
        }
      });
    };
    _newTimer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  void dispose() {
    super.dispose();
    if (_oldTimer != null) {
      _oldTimer.cancel();
    }
    if (_newTimer != null) {
      _newTimer.cancel();
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
        title: Text("修改手机"),
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
            title:"原手机号",
            hintText: "请输入原手机号码",
            keyboardType: TextInputType.number,
            onChanged: (val) {
              userPhone = val;
            },
          ),
          InputList(
            title:"验  证  码",
            hintText: "请输入验证码",
            keyboardType: TextInputType.number,
            onChanged: (val) {
              code = val;
            },
            suffixIcon: Container(
              width: 90,
              padding: EdgeInsets.only(right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if(oldSendCodeTime == 0){
                        var res = await AjaxUtil().postHttp(context, 
                          '/getphonecode',
                          data: {
                            "phone": userPhone,
                          }
                        );
                        if(res["code"] == 200){
                          Toast.toast(context,msg:res["msg"]);
                          oldStartTime();
                        }else{
                          Toast.toast(context,msg:res["msg"]);
                        }
                      }
                    },
                    child: Text(
                      oldSendCodeTime == 0?"获取验证码":"${oldSendCodeTime}s",
                      textAlign: TextAlign.center,
                      style:
                        TextStyle(color: oldSendCodeTime == 0?Color.fromRGBO(206, 0, 10, 1):Colors.grey[500]),
                    ),
                  )
                ],
              ),
            )
          ),
          InputList(
            title:"新手机号",
            hintText: "请输入新手机号码",
            keyboardType: TextInputType.number,
            onChanged: (val) {
              newPhone = val;
            },
          ),
          InputList(
            title:"验  证  码",
            hintText: "请输入验证码",
            keyboardType: TextInputType.number,
            onChanged: (val) {
              newCode = val;
            },
            suffixIcon: Container(
              width: 90,
              padding: EdgeInsets.only(right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if(newSendCodeTime == 0){
                        var res = await AjaxUtil().postHttp(context, 
                          '/getphonecode',
                          data: {
                            "phone": newPhone,
                          }
                        );
                        if(res["code"] == 200){
                          Toast.toast(context,msg:res["msg"]);
                          newStartTime();
                        }else{
                          Toast.toast(context,msg:res["msg"]);
                        }
                      }
                    },
                    child: Text(
                      newSendCodeTime == 0?"获取验证码":"${newSendCodeTime}s",
                      textAlign: TextAlign.center,
                      style:
                        TextStyle(color: newSendCodeTime == 0?Color.fromRGBO(206, 0, 10, 1):Colors.grey[500]),
                    ),
                  )
                ],
              ),
            )
          ),
          SizedBox(height: 84),
          ButtonNormal(
            name: '保存设置',
            onTap: () async {
              var res = await AjaxUtil().postHttp(context, '/editPhone',data: {
                "user_phone": userPhone,
                "code": code,
                "new_phone": newPhone,
                "new_code": newCode
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