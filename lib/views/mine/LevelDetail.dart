import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';

class LevelDetailPage extends StatefulWidget {
  LevelDetailPage({Key key}) : super(key: key);

  @override
  _LevelDetailPageState createState() => _LevelDetailPageState();
}

class _LevelDetailPageState extends State<LevelDetailPage> {

  String message;

  @override
  void initState() {
    levelIntro();
    super.initState();
  }

  levelIntro() async {
    var res = await AjaxUtil().getHttp(context, '/levelIntro');
    setState(() {
      message = res["msg"];
    });
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
        title: Text("等级说明"),
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
            padding: EdgeInsets.all(8),
            child: Text(message??""),
          )
        ],
      )
    );
  }
}