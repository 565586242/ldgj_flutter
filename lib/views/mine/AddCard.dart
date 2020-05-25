import 'package:flutter/material.dart';
import '../../components/InputList.dart';
import '../../components/ButtonNormal.dart';

class AddCardPage extends StatefulWidget {
  AddCardPage({Key key}) : super(key: key);

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
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
        title: Text("添加银行卡"),
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
          InputList(title: "持  卡 人",hintText: "请输入持卡人姓名",),
          InputList(title: "开户银行",hintText: "请输入开户银行",),
          InputList(title: "银行卡号",hintText: "请输入您的银行卡号",),
          InputList(title: "预留手机号",hintText: "请输入您在该银行预留的手机号码",),
          SizedBox(height: 82.5,),
          ButtonNormal(name: "确认添加",onTap: () {},)
        ],
      ),
    );
  }
}