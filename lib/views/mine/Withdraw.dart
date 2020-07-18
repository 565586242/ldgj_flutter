import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/mine/Transfor.dart';
import '../../components/ButtonNormal.dart';

class WithdrawPage extends StatefulWidget {
  final money;
  final int type; //1财富账户  2储备账户
  WithdrawPage({Key key,this.money,this.type}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  var type = 0;  //支付方式
  var amount;   //金额
  var code;  //验证码
  var sendCodeTime = 0;  //验证码时间
  Timer _timer;  //定时器
  var canPayType = {}; //可以使用的支付方式
  
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
    ajaxGetWithDraw();
    super.initState();
  }

  /* 接口获取可以提现的方式 */
  ajaxGetWithDraw() async {
    var res = await AjaxUtil().getHttp(context, '/withDraw');
    if(res["code"] == 200){
      setState(() {
        canPayType = res["data"];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  Widget _choosePay() {

    Widget getWithDraw() {
      List<Widget> list = [];
      if(canPayType["is_wechat"] == 1){
        setState(() {
          type = 1;
        });
        list.add(
          Offstage(
            offstage: canPayType["is_wechat"] != 1,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    type = 1;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 1, 
                      groupValue: type, 
                      onChanged: (v){
                        setState(() {
                          type = 1;
                        });
                      },
                      activeColor: Color.fromRGBO(206, 0, 10, 1)
                    ),
                    Text("微信"),
                  ],
                ),
              )
            ),
          )
        );
      }
      if(canPayType["is_alipy"] == 1){
        setState(() {
          type = 0;
        });
        list.add(
          Offstage(
            offstage: canPayType["is_alipy"] != 1,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    type = 0;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 0, 
                      groupValue: type, 
                      onChanged: (v){
                        setState(() {
                          type = 0;
                        });
                      },
                      activeColor: Color.fromRGBO(206, 0, 10, 1)
                    ),
                    Text("支付宝"),
                  ],
                ),
              )
            ),
          )
        );
      }
      if(canPayType["is_bank"] == 1){
        setState(() {
          type = 2;
        });
        list.add(
          Offstage(
            offstage: canPayType["is_bank"] != 1,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    type = 2;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 2, 
                      groupValue: type, 
                      onChanged: (v){
                        setState(() {
                          type = 2;
                        });
                      },
                      activeColor: Color.fromRGBO(206, 0, 10, 1)
                    ),
                    Text("银行卡"),
                  ],
                ),
              )
            ),
          )
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 13,top: 36,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("请选择到账方式",style: TextStyle(fontSize: 15)),
          getWithDraw()
        ],
      ),
    );
  }

  Widget _withdrawMoney() {
    return Container(
      padding: EdgeInsets.only(left: 13,top: 20,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("提现金额",style: TextStyle(fontSize: 15)),
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
              onChanged: (val) {
                amount = val;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入提现额度",
                icon: Text("￥"),
              ),
            ),
          ),
          Container(padding: EdgeInsets.only(left: 10),child: Text("可用余额${widget.money??0.00}元"),)
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
              onChanged: (val) {
                code = val;
              },
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
        title: Text("提 现"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TransforPage(
                type: widget.type,
                money: widget.money,
              )));
            },
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("转账")
                ],
              ),
            )
          )
        ],
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
          _choosePay(),
          _withdrawMoney(),
          _validataCode(),
          SizedBox(height: 65,),
          ButtonNormal(name: "确认提现",onTap: () async {
            var res = await AjaxUtil().postHttp(context, '/withDraw',data: {
              "type": type,
              "amount": amount,
              "code": code
            });
            if(res["code"] == 200){
              Toast.toast(context,msg:res["msg"]);
              Navigator.pop(context);
            }else{
              Toast.toast(context,msg:res["msg"]);
            }
          },)
        ],
      ),
    );
  }
}