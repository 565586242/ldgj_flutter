import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class WelfareInfoPage extends StatefulWidget {
  final int pId;
  WelfareInfoPage({Key key,this.pId}) : super(key: key);

  @override
  _WelfareInfoPageState createState() => _WelfareInfoPageState();
}

class _WelfareInfoPageState extends State<WelfareInfoPage> {
  Map<String,dynamic> data = {};

  @override
  void initState() { 
    welfareinfo();
    super.initState();
  }

  welfareinfo() async {
    var res = await AjaxUtil().getHttp(context, '/welfareinfo',data: {
      "id": widget.pId
    });
    if(res["code"] == 200){
      setState(() {
        data = res["data"];
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
        title: Text("福利详情"),
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
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Text(
              data["welfare_title"] ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(40, 40, 40, 1),
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(23, 20, 23, 0),
            child: Text(
              data["welfare_content"] ?? "",
              style: TextStyle(
                height: 1.6
              ),
            ),
          )
        ],
      )
    );
  }
}