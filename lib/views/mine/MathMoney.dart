import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class MathMoneyPage extends StatefulWidget {
  MathMoneyPage({Key key}) : super(key: key);

  @override
  _MathMoneyPageState createState() => _MathMoneyPageState();
}

class _MathMoneyPageState extends State<MathMoneyPage> {
  String digitalWalletAddress;

  @override
  void initState() { 
    super.initState();
    payInfo();
  }

  payInfo() async {
    var res = await AjaxUtil().getHttp(context, '/payInfo');
    if(res["code"] == 200){
      setState(() {
        digitalWalletAddress = res["data"]["digital_wallet_address"];
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
        title: Text("数字资产",style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: <Widget>[
          cardList()
        ],
      )
    );
  }

  Widget cardList() {
    return Container(
      height: 90,
      margin: EdgeInsets.all(13),
      padding: EdgeInsets.only(left: 15,right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/img_yinhangkabg@2x.png")
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 45,
            height: 45,
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.account_balance_wallet,size: 42,color: Colors.white,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("数字资产:",style: TextStyle(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${digitalWalletAddress??''}",style: TextStyle(fontSize: 13,color: Colors.white)),
                    GestureDetector(
                      onTap: (){
                        copyC(digitalWalletAddress);
                      },
                      child: Text("复制",style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  copyC(text) async {
    Clipboard.setData(ClipboardData(text: text));
    var clipboardData = await Clipboard.getData('text/plain');
    if(clipboardData.text != null && clipboardData.text != ''){
      Toast.toast(context,msg: "复制成功");
    }else{
      Toast.toast(context,msg: "暂无内容");
    }
  }
}