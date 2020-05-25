import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class MyCardPage extends StatefulWidget {
  MyCardPage({Key key}) : super(key: key);

  @override
  _MyCardPageState createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  String bankNum;
  String bankPhone;

  @override
  void initState() {
    payInfo();
    super.initState();
  }

  payInfo() async {
    var res = await AjaxUtil().getHttp(context, '/payInfo');
    setState(() {
      bankNum = res["data"]["bank_num"];
      bankPhone = res["data"]["bank_phone"];
    });
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
        title: Text("我的银行卡",style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 90,
            margin: EdgeInsets.all(13),
            padding: EdgeInsets.only(left: 15,right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("lib/assets/img_yinhangkabg@2x.png")
              )
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(Icons.credit_card,color: Colors.white,size: 40,)
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("银行卡号:${bankNum??""}",style: TextStyle(color: Colors.white)),
                      Text("预留手机号:${bankPhone??""}",style: TextStyle(fontSize: 13,color: Colors.white)),
                    ],
                  )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        copyC(bankNum);
                      },
                      child: Text("复制",style: TextStyle(color: Colors.white),),
                    ),
                    GestureDetector(
                      onTap: () {
                        copyC(bankPhone);
                      },
                      child: Text("复制",style: TextStyle(color: Colors.white),),
                    )
                  ],
                )
              ],
            ),
          );
        },
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