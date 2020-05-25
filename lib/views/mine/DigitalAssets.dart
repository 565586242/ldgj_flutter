import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class DigitalAsetsPage extends StatefulWidget {
  DigitalAsetsPage({Key key}) : super(key: key);

  @override
  _DigitalAsetsPageState createState() => _DigitalAsetsPageState();
}

class _DigitalAsetsPageState extends State<DigitalAsetsPage> {
  Map<dynamic, dynamic> data = {};

  @override
  void initState() { 
    digitalAssetsDetails();
    super.initState();
  }

  digitalAssetsDetails() async {
    var res = await AjaxUtil().getHttp(context, '/digitalAssetsDetails');
    if(res["code"] == 200){
      setState(() {
        data = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
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
      child: Text(money)
    );
  }

  Widget getTabList() {
    List<Widget> list = [];
    var listArr = data["digitalDetails"] == null?[]:data["digitalDetails"];
    for (var item in listArr) {
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
              Expanded(child: Text(item["type"] == 4?"数字资产":"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text(item["amount"] == null?"0":"${item["amount"]}",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text(item["log_note"]??"",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
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
                child: Text("时间",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
              ),
              Expanded(child: Text("类型",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("金额",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("状态",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 350,
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
                            "数字资产",
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              moneyNumber(data["totalMoney"] == null?"0":"${data["totalMoney"]}"),
                              moneyTiTle("累计获得(元)")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              moneyNumber(data["coldMoney"] == null?"0":"${data["coldMoney"]}"),
                              moneyTiTle("冻结余额(元)")
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
          SizedBox(height: 16.5,),
          Container(
            margin: EdgeInsets.only(left: 13,right: 13),
            child: getTabList()
          ),
        ],
      )
    );
  }
}