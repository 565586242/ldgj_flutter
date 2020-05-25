import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/InputList.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/pubComponents/gesture_password.dart';

class ChangeHeadPage extends StatefulWidget {
  ChangeHeadPage({Key key}) : super(key: key);

  @override
  _ChangeHeadPageState createState() => _ChangeHeadPageState();
}

class _ChangeHeadPageState extends State<ChangeHeadPage> {
  var formData = {
    "user_phone": '',
    "code": '',
    "gestures_password": ''
  };
  var sendCodeTime = 0; //发送验证码时间
  Timer _timer;  //定时器
  String firstPassword;  //第一次密码

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
  void initState() {
    firstPassword = null;
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
  
  gesturesPassword() async {
    var res = await AjaxUtil().postHttp(context, '/gesturesPassword',data: formData);
    if(res["code"] != 200){
      Toast.toast(context,msg: res["msg"]);
      firstPassword = null;
    }else{
      Toast.toast(context,msg: res["msg"]);
      Navigator.pop(context);
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
        title: Text("设置手势密码"),
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
      body: Column(
        children: <Widget>[
          inputField(),
          headWidget(),
          SizedBox(height: 40,),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }


  Widget inputField() {
    return Column(
      children: <Widget>[
        InputList(
          title:"手  机  号",
          hintText: "请输入手机号码",
          keyboardType: TextInputType.number,
          onChanged: (val) {
            formData["user_phone"] = val;
          },
        ),
        InputList(
          title:"验  证  码",
          hintText: "请输入验证码",
          keyboardType: TextInputType.number,
          onChanged: (val) {
            formData["code"] = val;
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
                          "phone": formData["user_phone"],
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
        )
      ],
    );
  }

  Widget headWidget() {
    return GesturePassword(
      showLineTimer: .5,
      attribute: ItemAttribute(
        smallCircleR: 20.0,
        bigCircleR: 40.0,
        selectedColor: Colors.redAccent,
        normalColor: Colors.grey[500],
        lineStrokeWidth: 15.0,
        circleStrokeWidth: 6.0,
      ),
      successCallback: (pwd) {
        if(firstPassword == null) {
          firstPassword = pwd;
          Toast.toast(context,msg: "请再次输入手势密码");
        }else{
          if(firstPassword == pwd) {
            formData["gestures_password"] = pwd;
            gesturesPassword();
          }else{
            Toast.toast(context,msg: "两次密码不一致");
            firstPassword = null;
          }
        }
      },
      failCallback: () {
        Toast.toast(context,msg: "手势密码最少设置4个点");
      },
    );
  }
}