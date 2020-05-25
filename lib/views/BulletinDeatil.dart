import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class BulletinDetailPage extends StatefulWidget {
  final int pId;
  BulletinDetailPage({Key key,this.pId}) : super(key: key);

  @override
  _BulletinDetailPageState createState() => _BulletinDetailPageState();
}

class _BulletinDetailPageState extends State<BulletinDetailPage> {
  Map<String,dynamic> data = {};

  @override
  void initState() { 
    flashDetails();
    super.initState();
  }

  flashDetails() async {
    var res = await AjaxUtil().getHttp(context, '/flashDetails',data: {
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
        title: Text("快讯详情"),
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
          Container(
            padding: EdgeInsets.fromLTRB(23, 20, 23, 0),
            child: Text(
              data["flash_content"] ?? "",
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