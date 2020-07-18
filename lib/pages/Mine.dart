import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/Share.dart';
import 'package:new_ldgj/views/mine/MyAssets.dart';
import 'package:new_ldgj/views/mine/MyReward.dart';
import 'package:new_ldgj/views/mine/MyTeam.dart';
import 'package:new_ldgj/views/mine/Performance.dart';
import 'package:new_ldgj/views/mine/Profile.dart';
import 'package:new_ldgj/views/mine/RewardInfo.dart';
import 'package:new_ldgj/views/mine/Studio.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  var userInfo = {};

  @override
  void initState() {  
    myInfo();
    super.initState();
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

  Widget _mineTop() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/img_my_xinxi@2x.png",
          )
        )
      ),
      child: Stack(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
              },
              child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 59,
              padding: EdgeInsets.only(
                left: 33.5,
                right: 13.5
              ),
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
                    child: Container(
                      padding: EdgeInsets.only(left: 9.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userInfo["user_phone"]??"",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 28),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/icon_huiyuan@2x.png")
                              )
                            ),
                            child: Text(
                              userInfo["false_level"]??"",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(254, 211, 157, 1)
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Icon(Icons.arrow_forward_ios,color: Colors.white)
                ],
              ),
            ),
            )
          ),
          _myMoney()
        ],
      )
    );
  }

  Widget _myMoney() {
    return Align(
      alignment: Alignment(0,2.65),
      child: Container(
        height: 110,
        margin: EdgeInsets.only(left: 13,right: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 29.5,
              padding: EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[100]
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("我的资产"),
                  GestureDetector(
                    child: Text(
                    "进入资产>",
                    style: TextStyle(
                      color: Colors.grey[500]
                    ),
                  ),
                  onTap: () {
                    Navigator
                    .push(context, MaterialPageRoute(builder: (context)=>MyAssetsPage()))
                    .then((data){
                      myInfo();
                    });
                  },
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          userInfo["fortune_gold"]??"0.00",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(40, 40, 40, 1)
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "财富账户",
                          style: TextStyle(
                            color: Colors.orangeAccent
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          userInfo["reserve_fund"]??"0.00",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(40, 40, 40, 1)
                          ),
                        ),
            SizedBox(height: 5,),
                        Text(
                          "储备账户",
                          style: TextStyle(
                            color: Colors.red
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          userInfo["digital_assets"]??"0.00",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(40, 40, 40, 1)
                          ),
                        ),
            SizedBox(height: 5,),
                        Text(
                          "数字资产",
                          style: TextStyle(
                            color: Colors.black
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
              ],
            )
            )
          ],
        ),
      ),
    );
  }

  Widget _myPromote() {
    return Container(
      margin: EdgeInsets.only(
        top: 85,
        left: 13,
        right: 13
      ),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 9.5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100]
                )
              )
            ),
            child: Row(
              children: <Widget>[
                Text("我的推广")
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRewardPage()));
                      },
                      child: Container(
                        width: 100,
                        height: 28,
                        child: Image.asset("assets/my_icon_jiangli@2x.png",fit: BoxFit.contain),
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RewardInfoPage()));
                      },
                      child: Container(
                        width: 100,
                        height: 60,
                        child: Image.asset("assets/my_icon_mingxi@2x.png",fit: BoxFit.contain),
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SharePage()));
                      },
                      child: Container(
                        width: 100,
                        height: 60,
                        child: Image.asset("assets/my_icon_fenxiang@2x.png",fit: BoxFit.contain),
                      )
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _myTeam() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 13,right: 13,top: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 9.5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100]
                )
              )
            ),
            child: Row(
              children: <Widget>[
                Text("我的合伙人")
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MyTeamPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 34,
                                height: 27,
                                margin: EdgeInsets.only(right: 9.5),
                                child: Image.asset("assets/my_icon_tuandui@2x.png",fit: BoxFit.cover,),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("我的合伙人"),
                                  Text("My players",style: TextStyle(fontSize: 9),)
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                    Container(
                      width: 0.5,
                      height: 40,
                      color: Colors.grey[500],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PerformancePage()));
                        },
                        child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 34,
                              height: 27,
                              margin: EdgeInsets.only(right: 9.5),
                              child: Image.asset("assets/my_icon_yejimingxi@2x.png",fit: BoxFit.cover,),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("众筹明细"),
                                Text("Details of performance",style: TextStyle(fontSize: 9),)
                              ],
                            )
                          ],
                        ),
                      ),
                      )
                    )
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _myPartner() {

    var listArr = [
      {
        "imgUrl": "assets/my_icon_gongzuoshi@2x.png",
        "text": "工作室",
        "type": 1
      },
      {
        "imgUrl": "assets/my_icon_yunyingzhongxin@2x.png",
        "text": "运营中心",
        "type": 2
      },
      {
        "imgUrl": "assets/my_icon_fengongsi@2x.png",
        "text": "分公司",
        "type": 3
      },
      {
        "imgUrl": "assets/my_icon_rongyudongshi@2x.png",
        "text": "荣誉董事",
        "type": 4
      },
    ];

    Widget getWidget(){
      List<Widget> list = [];

      for (var item in listArr) {
        list.add(
          GestureDetector(
            onTap: () async {
              var res = await AjaxUtil().postHttp(context, '/levelInfo',data: {
                "type": item["type"]
              });
              if(res["code"] == 200){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StudioPage(data:res["data"])));
              }else{
                Toast.toast(context,msg:res["msg"]);
              }
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 26,
                    child: Image.asset(item["imgUrl"],fit: BoxFit.contain,),
                  ),
                  SizedBox(height: 4,),
                  Text(item["text"])
                ],
              ),
            ),
          )
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: list,
          )
        ],
      );
    }

    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 13,right: 13,top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            padding: EdgeInsets.only(left: 9.5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100]
                )
              )
            ),
            child: Row(
              children: <Widget>[
                Text("合伙人")
              ],
            ),
          ),
          Expanded(
            child: getWidget()
          )
        ],
      ),
    );
  }

  Widget _banner() {
    return Container(
      height: 120,
      margin: EdgeInsets.only(left: 13,right: 13),
      child: Image.asset("assets/img_001@2x.png"),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          _mineTop(),
          _myPromote(),
          _myTeam(),
          _myPartner(),
          _banner()
        ],
      ),
    );
  }
}
