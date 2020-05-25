import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import '../../components/ButtonNormal.dart';
import '../../components/InputList.dart';

class ChangePwdPage extends StatefulWidget {
  ChangePwdPage({Key key}) : super(key: key);

  @override
  _ChangePwdPageState createState() => _ChangePwdPageState();
}

class _ChangePwdPageState extends State<ChangePwdPage> {
  var oldPassword;
  var newPassword;
  var confirmPassword;

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
        title: Text("修改密码"),
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
          InputList(
            title:"旧密码",
            hintText: "请输入旧密码",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (val) {
              oldPassword = val;
            },
          ),
          InputList(
            title:"新密码",
            hintText: "请输入6~20位数新密码",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (val) {
              newPassword = val;
            },
          ),
          InputList(
            title:"确认密码",
            hintText: "请再次输入新密码",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (val) {
              confirmPassword = val;
            },
          ),
          SizedBox(height: 84,),
          ButtonNormal(
            name: '保存修改',
            onTap: () async {
              var res = await AjaxUtil().postHttp(context, '/editPassword',data: {
                "old_password": oldPassword,
                "new_password": newPassword,
                "confirm_password": confirmPassword
              });
              if(res["code"] == 200){
                Toast.toast(context,msg:res["msg"]);
                Navigator.pop(context);
              }else{
                Toast.toast(context,msg:res["msg"]);
              }
            },
          )
        ],
      ),
    );
  }
}