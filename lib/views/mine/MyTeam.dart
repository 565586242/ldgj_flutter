import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';

class MyTeamPage extends StatefulWidget {
  MyTeamPage({Key key}) : super(key: key);

  @override
  _MyTeamPageState createState() => _MyTeamPageState();
}

class _MyTeamPageState extends State<MyTeamPage> {
  Map<dynamic, dynamic> user = {};
  List<dynamic> finRealAuth = [];
  List<dynamic> noRealAuth = [];
  Map<dynamic, dynamic> data = {};
  Map<dynamic, dynamic> parentInfo = {};
  int tabIndex = 0;

  @override
  void initState() { 
    super.initState();
    myPlayers();
  }

  myPlayers() async {
    var res = await AjaxUtil().postHttp(context, '/myPlayers');
    if(res["code"] == 200){
      setState(() {
        data = res["data"];
        user = res["data"]["user"];
        finRealAuth = res["data"]["finRealAuth"];
        noRealAuth = res["data"]["noRealAuth"];
        parentInfo = res["data"]["parentInfo"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      child: Column(
        children: <Widget>[
          _topInfo(),
          Container(
            height: 56,
            child: getTabWidget()
          ),
          Container(
            margin: EdgeInsets.only(left: 13,right: 13),
            child: getTabList()
          ),
        ],
      ),
    );
  }

  Widget _topInfo(){
    return Container(
      height: 275,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/assets/img_my_xinxi@2x.png")
                )
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 70,
              padding: EdgeInsets.only(left: 12,right: 12,top: MediaQuery.of(context).padding.top),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 23,
                      child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "我的合伙人",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(width: 23,)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180,
              margin: EdgeInsets.only(left: 13,right: 13),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/assets/img_duiyuan@2x.png")
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    padding: EdgeInsets.only(left: 20,top: 15,bottom: 15,right: 9.5),
                    child: Row(
                      children: <Widget>[
                          ClipOval(
                            child: user["user_head"] == null || user["user_head"] == ""?
                              Image.asset("lib/assets/img_touxiang@2x.png",width: 60,fit: BoxFit.cover,):
                              Image.network(CommonModel().hostUrl + user["user_head"],width: 60,fit: BoxFit.cover,),
                          ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${user["user_name"]}",
                                  style: TextStyle(
                                    inherit: false,
                                    fontSize: 15,
                                    color: Colors.black87
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "推荐人: ${parentInfo["user_name"]??""}, ${parentInfo["user_phone"]??""}",
                                    style: TextStyle(
                                      inherit: false,
                                      fontSize: 13,
                                      color: Colors.grey[500]
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: "团队:",style: 
                                      TextStyle(inherit: false,color: Colors.black87,fontSize: 13,decoration: TextDecoration.none)
                                    ),
                                    TextSpan(text: data["teamCount"] != null?"${data["teamCount"]}":"0",style: TextStyle(inherit: false,color: Color.fromRGBO(223, 0, 10, 1),fontSize: 13,decoration: TextDecoration.none)),
                                    TextSpan(text: "人",style: TextStyle(inherit: false,color: Colors.black87,fontSize: 13,decoration: TextDecoration.none))
                                  ]
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  topInfoMoney()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topInfoMoney() {
    return Expanded(child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data["myConsumption"] == null?"0":"${data["myConsumption"]}",style: TextStyle(inherit: false,color: Color.fromRGBO(223, 0, 10, 1),fontSize: 18),),
                SizedBox(height: 5,),
                Text("个人众筹金额(元)",style: TextStyle(inherit: false,color: Colors.black45,fontSize: 12),)
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(data["teamConsumption"] == null?"0":"${data["teamConsumption"]}",style: TextStyle(inherit: false,color: Color.fromRGBO(223, 0, 10, 1),fontSize: 18),),
                SizedBox(height: 5,),
                Text("团队众筹金额(元)",style: TextStyle(inherit: false,color: Colors.black45,fontSize: 12),)
              ],
            ),
          )
        ],
      )
    );
  }

  Widget getTabWidget() {
    var tabArr = [
      {
        "title": "已实名认证(${finRealAuth.length}人)",
        "index": 0
      },
      {
        "title": "未实名认证(${noRealAuth.length}人)",
        "index": 1
      }
    ];
    List<Widget> list = [];
    for (var item in tabArr) {
      list.add(
        GestureDetector(
          onTap: () {
            setState(() {
              tabIndex = item["index"];
            });
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: item["index"] == tabIndex?Color.fromRGBO(181, 20, 29, 1):Colors.grey[500],
                  style: item["index"] == tabIndex?BorderStyle.solid:BorderStyle.none,
                  width: 1.5
                )
              )
            ),
            child: Text(
              item["title"],
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: item["index"] == tabIndex?Color.fromRGBO(181, 20, 29, 1):Colors.grey[500],
              ),
            ),
          )
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list
    );

  }


  Widget getTabList() {
    List<Widget> realList = [];
    List<Widget> norealList = [];

    for (var item in finRealAuth) {
      realList.add(
        Container(
          height: 40,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 110,
                padding: EdgeInsets.all(0),
                child: Text("${item["add_time"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54),),
              ),
              Expanded(child: Text("${item["user_phone"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["certificat_time"] != null?"${item["certificat_time"]}":"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["true_name"] != null?"${item["true_name"]}":"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
            ],
          ),
        ),
      );
    }

    for (var item in noRealAuth) {
      norealList.add(
        Container(
          height: 40,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 110,
                padding: EdgeInsets.all(0),
                child: Text("${item["add_time"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54),),
              ),
              Expanded(child: Text("${item["user_phone"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["certificat_time"] != null?"${item["certificat_time"]}":"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["true_name"] != null?"${item["true_name"]}":"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
            ],
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 110,
                child: Text("注册时间",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
              ),
              Expanded(child: Text("手机号码",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("认证时间",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("认证姓名",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 400,
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: tabIndex == 0?realList:norealList
          ),
        )
      ],
    );
  }
}