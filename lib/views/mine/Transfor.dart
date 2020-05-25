import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import '../../components/ButtonNormal.dart';

class TransforPage extends StatefulWidget {
  final money;
  final int type;  //1财富金转账  2储备金转账
  TransforPage({Key key, this.money,this.type}) : super(key: key);

  @override
  _TransforPageState createState() => _TransforPageState();
}

class _TransforPageState extends State<TransforPage> {
  var formData = {
    "type": 1,
    "collectionUser": "",
    "collectionPhone": '',
    "amount": '',
    "code": ''
  };
  var sendCodeTime = 0;  //验证码时间
  Timer _timer;  //定时器

  transfer() async {
    formData["type"] = widget.type;
    var res = await AjaxUtil().postHttp(context, '/transfer',data: formData);
    if(res["code"] == 200){
      Toast.toast(context,msg:res["msg"]);
      Navigator.pop(context);
    }else{
      Toast.toast(context,msg:res["msg"]);
    }
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

  Widget _tranforInfo() {
    return Container(
      padding: EdgeInsets.only(left: 13,top: 20,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("收款人姓名",style: TextStyle(fontSize: 15)),
          Container(
            width: 300,
            height: 40,
            margin: EdgeInsets.only(left: 10,top: 10),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[500]
              )
            ),
            child: TextField(
              style: TextStyle(
                height: 1.2
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入收款人真实姓名"
              ),
              onChanged: (v) {
                formData["collectionUser"] = v;
              },
            ),
          ),
          SizedBox(height: 20,),
          Text("收款人手机号",style: TextStyle(fontSize: 15)),
          Container(
            width: 300,
            height: 40,
            margin: EdgeInsets.only(left: 10,top: 10),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[500]
              )
            ),
            child: TextField(
              style: TextStyle(
                height: 1.2
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入收款人手机号码"
              ),
              onChanged: (v) {
                formData["collectionPhone"] = v;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _transforMoney() {
    return Container(
      padding: EdgeInsets.only(left: 13,top: 20,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("转账金额",style: TextStyle(fontSize: 15)),
          Container(
            width: 300,
            height: 40,
            margin: EdgeInsets.only(left: 10,top: 10),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[500]
              )
            ),
            child: TextField(
              style: TextStyle(
                height: 1.2
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入转账金额",
                icon: Text("￥"),
              ),
              onChanged: (v) {
                formData["amount"] = v;
              },
            ),
          ),
          Container(padding: EdgeInsets.only(left: 10),child: Text("可用余额${widget.money}元"),)
        ],
      ),
    );
  }

  Widget _validataCode() {
    return Container(
      padding: EdgeInsets.only(left: 13,top: 20,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("短信验证码",style: TextStyle(fontSize: 15)),
          Container(
            width: 300,
            height: 40,
            margin: EdgeInsets.only(left: 10,top: 10),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[500]
              )
            ),
            child: TextField(
              style: TextStyle(
                height: 1.2
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入短信验证码",
                suffixIcon: Container(
                  width: 90,
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if(sendCodeTime == 0){
                            var res = await AjaxUtil().getHttp(context, '/forwardPhoneCode');
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
              onChanged: (v){
                formData["code"] = v;
              },
            ),
          ),
        ],
      ),
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
        title: Text("转 账"),
        /* actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WithdrawPage(
                money: widget.money,
                type: widget.type,
              )));
            },
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("提现")
                ],
              ),
            ),
          )
        ], */
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
          _tranforInfo(),
          _transforMoney(),
          _validataCode(),
          SizedBox(height: 65,),
          ButtonNormal(name: "确认转账",onTap: (){
            transfer();
          },)
        ],
      ),
    );
  }
}