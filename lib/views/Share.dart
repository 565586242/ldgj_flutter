import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';

class SharePage extends StatefulWidget {
  SharePage({Key key}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {

  String qrcode;

  @override
  void initState() { 
    qrcode = '';
    homeinvite();
    super.initState();
  }

  homeinvite() async {
    var res = await AjaxUtil().getHttp(context, '/homeinvite');
    if(res["code"] == 200){
      setState(() {
        qrcode = CommonModel().hostUrl + res["data"]["invitation_img"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _shareLogo() {
    return Container(
      color: Colors.redAccent,
      child: Image.asset(
        "lib/assets/img_fenxiang@2x.png",
        width: 375,
        height: 460,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _shareCode() {
    return Container(
      height: 267/2,
      padding: EdgeInsets.fromLTRB(12.5, 0, 12, 0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "丽东国际敬请关注",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(40, 40, 40, 1),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 6,),
                      Image.asset(
                        "lib/assets/img_fenxiang_shouzhi@2x.png",
                        width: 43.5,
                        height: 22,
                        fit: BoxFit.cover,
                      )
                    ],
                  )
                ),
                Text(
                  "扫码注册，体验有礼",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[600]
                  ),
                )
              ],
            )
          ),
          qrcode == ''?Container():Image.network(
            qrcode,
            width: 104,
            height: 104,
            fit: BoxFit.cover
          ),
        ],
      ),
    );
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
        elevation: 0,
        title: Text("分 享"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(226,48,54, 1),Color.fromRGBO(208,0,8, 1)],
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _shareLogo(),
          _shareCode()
        ],
      ),
    );
  }
}
