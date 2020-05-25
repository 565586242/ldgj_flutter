import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/SeeImg.dart';
import 'package:new_ldgj/components/Toast.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  var dataInfo = {};

  @override
  void initState() {
    getcustomer();
    super.initState();
  }

  getcustomer() async {
    var res = await AjaxUtil().getHttp(context, '/gethelp');
    setState(() {
      dataInfo = res["data"];
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
        title: Text("帮 助"),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(245, 246, 247, 1),
        child: ListView(
          children: <Widget>[
            Image.asset(
              "lib/assets/login_logo@2x.png",
              height: 87,
            ),
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  Text("APP下载二维码",style: TextStyle(fontSize: 16),)
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SeeImagePage(
                        image: CommonModel().hostUrl + dataInfo["APP_img"],
                        type: "network",
                      )));
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      child: dataInfo["APP_img"] != null?Image.network(
                        CommonModel().hostUrl + dataInfo["APP_img"]
                      ):Container(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: <Widget>[
                  Text("客服助手",style: TextStyle(fontSize: 16),)
                ],
              ),
            ),
            Container(
              child: ListTile(
                leading: Container(width: 60,child: Text("微信号①"),),
                title: Text(dataInfo["customer_wachat1"]??""),
                trailing: FlatButton(
                  onPressed: () {
                    copyC(dataInfo["customer_wachat1"]);
                  },
                  child: Text("复制"),
                ),
              ),
              color: Colors.white,
            ),
            Container(
              child: ListTile(
                leading: Container(width: 60,child: Text("微信号②"),),
                title: Text(dataInfo["customer_wachat2"]??""),
                trailing: FlatButton(
                  onPressed: () {
                    copyC(dataInfo["customer_wachat2"]);
                  },
                  child: Text("复制"),
                ),
              ),
              color: Colors.white,
            ),
            Container(
              child: ListTile(
                leading: Container(width: 60,child: Text("电    话"),),
                title: Text(dataInfo["customer_phone"]??""),
                trailing: FlatButton(
                  onPressed: () {
                    copyC(dataInfo["customer_phone"]);
                  },
                  child: Text("复制"),
                ),
              ),
              color: Colors.white,
            ),
            Container(
              child: ListTile(
                leading: Container(width: 60,child: Text("邮    箱"),),
                title: Text(dataInfo["customer_email"]??""),
                trailing: FlatButton(
                  onPressed: () {
                    copyC(dataInfo["customer_email"]);
                  },
                  child: Text("复制"),
                ),
              ),
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.all(13),
              child: Image.asset(
                "lib/assets/img_001@2x.png",
                fit: BoxFit.cover,
              )
            )
          ],
        ),
      )
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