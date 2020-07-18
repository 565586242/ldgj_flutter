import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/AliPayPage.dart';
import 'package:new_ldgj/components/ButtonNormal.dart';
import 'package:new_ldgj/components/SeeImg.dart';
import 'package:new_ldgj/components/Toast.dart';

class ConfirmOrder extends StatefulWidget {
  final formInfo;
  ConfirmOrder({Key key,this.formInfo}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  var memaryImage1;
  var memaryImage2;
  var memaryImage3;

  @override
  void initState() { 
    _getImage();
    super.initState();
  }

  String _getPayType() {
    String str;
    if(widget.formInfo["money_type"] == 1) {
      str = "财富金";
    }else if(widget.formInfo["money_type"] == 2){
      str = "储备金";
    }else{
      switch (widget.formInfo["pay_type"]) {
        case 0:
          return "支付宝";
          break;
        case 1:
          return "微信";
          break;
        case 2:
          return "银行卡";
          break;
        case 3:
          return "数字钱包";
          break;
        case 6:
          return "第三方支付";
          break;
        default:
          return "支付宝";
      }
    }
    return str;
  }

  void _getImage() {
    if(widget.formInfo["pay_voucher"] != null && widget.formInfo["pay_voucher"] != ""){
      String str1 = widget.formInfo["pay_voucher"];
      str1 = str1.split(',')[1];
      memaryImage1 = Base64Decoder().convert(str1);
    }
    if(widget.formInfo["pay_voucher1"] != null && widget.formInfo["pay_voucher1"] != ""){
      String str2 = widget.formInfo["pay_voucher1"];
      str2 = str2.split(',')[1];
      memaryImage2 = Base64Decoder().convert(str2);
    }
    if(widget.formInfo["pay_voucher2"] != null && widget.formInfo["pay_voucher2"] != ""){
      String str3 = widget.formInfo["pay_voucher2"];
      str3 = str3.split(',')[1];
      memaryImage3 = Base64Decoder().convert(str3);
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
        title: Text("确认订单"),
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
          ListTile(
            leading: Text("众筹金额:"),
            title: Text("${widget.formInfo["amount"]}"),
          ),
          ListTile(
            leading: Text("支付方式:"),
            title: Text(_getPayType()),
          ),
          widget.formInfo["pay_voucher"] == null?
            Container():
            ListTile(
              leading: Text("上传凭证:"),
              title: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeeImagePage(
                        image: widget.formInfo["pay_voucher"],
                        type: "base64"
                      )));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Image.memory(memaryImage1,fit: BoxFit.contain,),
                    ),
                  ),
                  widget.formInfo["pay_voucher1"] == ""?Container():GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeeImagePage(
                        image: widget.formInfo["pay_voucher1"],
                        type: "base64"
                      )));
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Image.memory(memaryImage2,fit: BoxFit.contain,),
                    ),
                  ),
                  widget.formInfo["pay_voucher2"] == ""?Container():GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeeImagePage(
                        image: widget.formInfo["pay_voucher2"],
                        type: "base64"
                      )));
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Image.memory(memaryImage3,fit: BoxFit.contain,),
                    ),
                  )
                ],
              )
            ),
          SizedBox(height: 20,),
          ButtonNormal(
            name: "确认提交",
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainKeyboard(
                formInfo: widget.formInfo,
                calback: (data) async {
                  var res = await AjaxUtil().postHttp(context, '/submitorder',data: data);
                  if(res["code"] == 200){
                    Toast.toast(context,msg:res["msg"]);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }else{
                    Toast.toast(context,msg:res["msg"]);
                  }
                },
              )));
            },
          ),
          SizedBox(height: 60)
        ],
      ),
    );
  }
}