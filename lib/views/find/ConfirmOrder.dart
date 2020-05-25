import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ldgj/components/AliPayPage.dart';
import 'package:new_ldgj/components/ButtonNormal.dart';
import 'package:new_ldgj/components/SeeImg.dart';

class ConfirmOrder extends StatefulWidget {
  final formInfo;
  ConfirmOrder({Key key,this.formInfo}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  var memaryImage;

  @override
  void initState() { 
    if(widget.formInfo["pay_voucher"] != null) {
      _getImage();
    }
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
        default:
          return "支付宝";
      }
    }
    return str;
  }

  void _getImage() {
    String str = widget.formInfo["pay_voucher"];
    str = str.split(',')[1];
    memaryImage = Base64Decoder().convert(str);
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
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeeImagePage(
                    image: widget.formInfo["pay_voucher"],
                    type: "base64"
                  )));
                },
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Image.memory(memaryImage,fit: BoxFit.contain,),
                ),
              )
            ),
          SizedBox(height: 20,),
          ButtonNormal(
            name: "确认提交",
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainKeyboard(formInfo: widget.formInfo)));
            },
          )
        ],
      ),
    );
  }
}