import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class MyRewardPage extends StatefulWidget {
  MyRewardPage({Key key}) : super(key: key);

  @override
  _MyRewardPageState createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  var data = {};
  var rewardList = [];

  @override
  void initState() { 
    super.initState();
    myReward();
  }

  myReward() async {
    var res = await AjaxUtil().postHttp(context, '/myReward');
    if(res["code"] == 200){
      setState(() {
        data = res["data"];
        rewardList = res["data"]["rewardList"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(246, 246, 246, 1),
        child: Column(
          children: <Widget>[
            Container(
              height: 245,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.asset("lib/assets/img_my_xinxi@2x.png",fit: BoxFit.cover,),
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
                              "我的收益",
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
                    alignment: Alignment.center,
                    child: Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("${data["yesterdayIncome"]??0}",style: TextStyle(color: Colors.white,fontSize: 18),),
                          SizedBox(height: 5,),
                          Text("昨日收益(元)",style: TextStyle(color: Colors.white,fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(26),
                      margin: EdgeInsets.only(left: 13,right: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("lib/assets/img_jiangli@2x.png")
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("${data["totalIncome"]??0}",style: TextStyle(fontSize: 18,color: Color.fromRGBO(223, 0, 10, 1)),),
                                Text("累计获得收益")
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey[200],
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("${data["totalInvitaPeople"]??0}",style: TextStyle(fontSize: 18,color: Color.fromRGBO(223, 0, 10, 1)),),
                                Text("累计邀请人数")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 13,right: 13),
              child: getTabList()
            ),
          ],
        )
      )
    );
  }

  Widget getTabList() {
    List<Widget> list = [];

    for (var item in rewardList) {
      list.add(
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
                child: Text(item["add_time"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54),),
              ),
              Expanded(child: Text(item["user_phone"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["is_cert"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["amount"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
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
              Expanded(child: Text("是否认证",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("获得奖励",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 400,
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: list
          ),
        )
      ],
    );
  }
}