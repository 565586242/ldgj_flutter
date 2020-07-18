import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/views/mine/Withdraw.dart';

class WealthAccountPage extends StatefulWidget {
  WealthAccountPage({Key key}) : super(key: key);

  @override
  _WealthAccountPageState createState() => _WealthAccountPageState();
}

class _WealthAccountPageState extends State<WealthAccountPage> {
  List<dynamic> fortuneLog = [];
  Map<String,dynamic> fortuneGoldData = {};
  int currentIndex = 0;
  
  @override
  void initState() { 
    super.initState();
    fortuneGold();
  }

  fortuneGold() async {
    dynamic res = await AjaxUtil().getHttp(context, '/fortuneGold');
    setState(() {
      fortuneLog = res["data"]["fortuneLog"];
      fortuneGoldData["usableMoney"] = res["data"]["usableMoney"];
      fortuneGoldData["totalMoney"] = res["data"]["totalMoney"];
      fortuneGoldData["totalWithdraw"] = res["data"]["totalWithdraw"];
    });
  }

  Widget moneyTiTle(title) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 12,color: Colors.grey[500],decoration: TextDecoration.none), 
      child: Text(title)
    );
  }

  Widget moneyNumber(String money) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 15,color: Colors.black,decoration: TextDecoration.none), 
      child: Text(money??"0")
    );
  }

  Widget getTabWidget() {
    var tabArr = [
      {
        "title": "全部",
        "index": 0
      },
      {
        "title": "收益",
        "index": 1
      },
      {
        "title": "提现",
        "index": 2
      }
    ];
    List<Widget> list = [];
    for (var item in tabArr) {
      list.add(
        GestureDetector(
          onTap: () {
            setState(() {
              currentIndex = item["index"];
            });
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: item["index"] == currentIndex?Color.fromRGBO(181, 20, 29, 1):Colors.grey[500],
                  style: item["index"] == currentIndex?BorderStyle.solid:BorderStyle.none,
                  width: 1.5
                )
              )
            ),
            child: Text(
              item["title"],
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: item["index"] == currentIndex?Color.fromRGBO(181, 20, 29, 1):Colors.grey[500],
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
    List<Widget> list = [];
    String type;
    for (var item in fortuneLog) {
      if(item["where_id_info"] == "0") {
        if(item["type"] == 1 || item["type"] == 8) {
          type = "收益";
        }else if(item["type"] == 9 || item["type"] == 10 ){
          type = "提现";
        }else if( item["type"] == 7){
          type = "转账消耗";
        }
      }else{
        type = item["where_id_info"];
      }
      
      if(currentIndex == 0){
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
                  child: Text(item["add_time"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
                ),
                Expanded(child: Text(type,textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text("${item["amount"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text(item["log_note"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              ],
            ),
          ),
        );
      }else if(currentIndex == 1 &&  (item["type"] == 1 || item["type"] == 8)){
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
                  child: Text(item["add_time"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
                ),
                Expanded(child: Text("收益",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text("${item["amount"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text(item["log_note"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              ],
            ),
          ),
        );
      }else if(currentIndex == 2 &&  (item["type"] == 9 || item["type"] == 10)){
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
                  child: Text(item["add_time"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
                ),
                Expanded(child: Text("提现",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text("${item["amount"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
                Expanded(child: Text(item["log_note"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              ],
            ),
          ),
        );
      }
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
                child: Text("时间",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
              ),
              Expanded(child: Text("类型",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("金额",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("状态",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      child: Column(
        children: <Widget>[
          Container(
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
                        image: AssetImage("assets/img_my_xinxi@2x.png")
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
                            "财富账户",
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
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.only(bottom: 30),
                    margin: EdgeInsets.only(left: 13,right: 13,top: 75),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(fortuneGoldData["usableMoney"] == null?'0':"${fortuneGoldData["usableMoney"]}",style: TextStyle(fontSize: 24,color: Colors.black,decoration: TextDecoration.none),),
                                Text("可用余额(元)",style: TextStyle(fontSize: 13,color: Colors.grey[500],decoration: TextDecoration.none))
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  moneyNumber(fortuneGoldData["totalMoney"] == null?'0':"${fortuneGoldData["totalMoney"]}"),
                                  moneyTiTle("累计获得(元)")
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  moneyNumber(fortuneGoldData["totalWithdraw"] == null?"0":"${fortuneGoldData["totalWithdraw"]}"),
                                  moneyTiTle("累计提现(元)")
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator
                      .push(context, MaterialPageRoute(builder: (context)=>WithdrawPage(
                        money: fortuneGoldData["usableMoney"],
                        type: 1
                      )))
                      .then((data){
                        fortuneGold();
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 25,
                      margin: EdgeInsets.only(right: 13, top: 90),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(225, 49, 53, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.5),
                              bottomLeft: Radius.circular(12.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 13,
                            height: 13,
                            margin: EdgeInsets.only(right: 3),
                            child: Image.asset("assets/icon_tixian@2x.png",fit: BoxFit.cover,),
                          ),
                          Text(
                            "立即提现",
                            style: TextStyle(inherit: false,fontSize: 10, color: Colors.white),
                          )
                        ],
                      )
                    ),
                  )
                )
              ],
            ),
          ),
          Container(
            height: 56,
            child: getTabWidget()
          ),
          Container(
            margin: EdgeInsets.only(left: 13,right: 13),
            child: getTabList()
          ),
        ],
      )
    );
  }
}