import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/ButtonNormal.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/mine/ChangeHead.dart';
import 'package:new_ldgj/views/mine/ChangePay.dart';
import 'package:new_ldgj/views/mine/ChangePhone.dart';
import 'package:new_ldgj/views/mine/ChangePwd.dart';
import 'package:new_ldgj/views/mine/LevelDetail.dart';
import 'package:new_ldgj/views/mine/ProfileInfo.dart';
import 'package:new_ldgj/views/mine/Verified.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userInfo = {};

  @override
  void initState() {
    super.initState();
    myInfo();
  }

  myInfo() async {
    var res = await AjaxUtil().postHttp(context, '/myInfo');
    if(res["code"] == 200){
      setState(() {
        userInfo = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget mineTop() {
    return Container(
      height: 120,
      padding: EdgeInsets.fromLTRB(33.5, 30.5, 33.5, 30.5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 59,
            height: 59,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(29.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: userInfo["user_head"] != null && userInfo["user_head"] != ""?
                  NetworkImage(
                    CommonModel().hostUrl + userInfo["user_head"]
                  ):
                  AssetImage(
                    "assets/img_touxiang@2x.png"
                  )
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  userInfo["user_phone"]??"",
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: getStarLevel(),
                )
              ],
            )
          )
        ],
      ),
    );
  }

  List<Widget> getStarLevel() {
    List<Widget> list = [];
    for(int i = 0; i < 6;i++){
      if( userInfo["star_level"] != null && i < userInfo["star_level"]){
        list.add(
          Icon(Icons.star,color: Colors.orange,)
        );
      }else{
        list.add(
          Icon(Icons.star,color: Colors.grey,)
        );
      }
      
    }
    return list;
  }

  Widget configList() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("会员等级"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LevelDetailPage()));
            },
            trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    userInfo["false_level"]??"",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )
          ),
          ListTile(
            title: Text("个人信息"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator
              .push(context, MaterialPageRoute(builder: (context)=>ProfileInfoPage()))
              .then((data){
                myInfo();
              });
            },
          ),
          ListTile(
            title: Text("实名认证"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifiedPage()));
            },
            trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    userInfo["is_real_auth"]??"",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            )
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePwdPage()));
            },
            title: Text("修改登录密码"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePayPage()));
            },
            title: Text("设置支付密码"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeHeadPage()));
            },
            title: Text("设置手势密码"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator
              .push(context, MaterialPageRoute(builder: (context)=>ChangePhonePage()))
              .then((data){
                myInfo();
              });
            },
            title: Text("修改手机"),
            trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    userInfo["user_phone"]??"",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            )
          ),
          ListTile(
            title: Text("邀请码"),
            trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    userInfo["invitation_code"]??"",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId"); //删除指定键
    prefs.remove("token"); //删除指定键
    prefs.clear();//清空键值对
    Toast.toast(context,msg: "退出登录成功");
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
        title: Text("个人中心"),
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
          mineTop(),
          SizedBox(height: 10,),
          configList(),
          SizedBox(height: 20,),
          ButtonNormal(name: "退出登录",onTap: () {
            signOut();
          },),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}