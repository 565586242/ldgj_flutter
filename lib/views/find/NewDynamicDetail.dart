import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:new_ldgj/components/Toast.dart';

class NewDynamicDetailPage extends StatefulWidget {
  final parmId;
  NewDynamicDetailPage({Key key,this.parmId}) : super(key: key);

  @override
  _NewDynamicDetailPageState createState() => _NewDynamicDetailPageState();
}

class _NewDynamicDetailPageState extends State<NewDynamicDetailPage> {
  var data = {};

  @override
  void initState() { 
    newsinfo();
    super.initState();
  }

  newsinfo() async {
    var res = await AjaxUtil().getHttp(context, '/newsinfo',data: {
      "id": widget.parmId
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
        title: Text("最新动态"),
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
        padding: EdgeInsets.fromLTRB(13.5, 13, 13.5, 20),
        children: <Widget>[
          Text(
            data["new_title"]??"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 15,),
          Text(
            data["new_subtitle"]??"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          SizedBox(height: 5,),
          Container(
            child: Html(
              data: data["new_content"]??""
            )
          )
        ],
      ),
    );
  }
}