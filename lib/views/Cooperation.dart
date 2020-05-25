import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class CooperationPage extends StatefulWidget {
  CooperationPage({Key key}) : super(key: key);

  @override
  _CooperationPageState createState() => _CooperationPageState();
}

class _CooperationPageState extends State<CooperationPage> {
  String _cooperationTitle = '';
  String _cooperationContent = '';

  @override
  void initState() { 
    _cooperationTitle = '';
    _cooperationContent = '';
    homecooperation();
    super.initState();
  }

  homecooperation() async {
    var res = await AjaxUtil().getHttp(context, '/homecooperation');
    if(res["code"] == 200){
      setState(() {
        _cooperationTitle = res["data"]["cooperation_title"];
        _cooperationContent = res["data"]["cooperation_content"];
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
        title: Text("招商合作"),
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
            child: Text(
              _cooperationTitle,
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
              _cooperationContent,
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