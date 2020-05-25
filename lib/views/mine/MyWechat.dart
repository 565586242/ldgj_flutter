import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';

class MyWechatPage extends StatefulWidget {
  MyWechatPage({Key key}) : super(key: key);

  @override
  _MyWechatPageState createState() => _MyWechatPageState();
}

class _MyWechatPageState extends State<MyWechatPage> {
  String wechat;

  @override
  void initState() { 
    super.initState();
    payInfo();
  }

  payInfo() async {
    var res = await AjaxUtil().getHttp(context, '/payInfo');
    if(res["code"] == 200){
      setState(() {
        wechat = res["data"]["wechat_code"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("我的微信",style: TextStyle(color: Colors.black),),
      ),
      body: cardList(),
    );
  }

  Widget cardList() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: wechat == null?
          Container():
          Image.network(
            CommonModel().hostUrl + wechat,
            fit: BoxFit.cover,
          )
      ),
    );
  }
}