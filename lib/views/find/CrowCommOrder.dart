import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class CrowCommOrderPage extends StatefulWidget {
  CrowCommOrderPage({Key key}) : super(key: key);

  @override
  _CrowCommOrderPageState createState() => _CrowCommOrderPageState();
}

class _CrowCommOrderPageState extends State<CrowCommOrderPage> {
  List<dynamic> listArr = [];

  @override
  void initState() { 
    crowdfundingorder();
    super.initState();
  }

  crowdfundingorder() async {
    var res = await AjaxUtil().getHttp(context, '/crowdfundingorder');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
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
        title: Text("众筹订单"),
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
      body: ListView.builder(
        itemCount: listArr.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            height: 75,
            color: Colors.white,
            padding: EdgeInsets.only(left: 10,right: 10),
            margin: EdgeInsets.fromLTRB(13, 16, 13, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("订单编号：${listArr[index]['order_number']}")),
                    Text("${listArr[index]["order_status"]}")
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("订单金额：${listArr[index]['amount']}"))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("订单时间：${listArr[index]['add_time']}"))
                  ],
                )
              ],
            ),
          );
        }
      )
    );
  }
}