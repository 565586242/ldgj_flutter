import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class RewardInfoPage extends StatefulWidget {
  RewardInfoPage({Key key}) : super(key: key);

  @override
  _RewardInfoPageState createState() => _RewardInfoPageState();
}

class _RewardInfoPageState extends State<RewardInfoPage> {
  List<dynamic> listArr = [];

  @override
  void initState() {
    super.initState();
    listArr = [];
    rewardDetails();
  }

  rewardDetails() async {
    var res = await AjaxUtil().postHttp(context, '/rewardDetails');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
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
        title: Text("收益明细"),
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
        color: Color.fromRGBO(246, 246, 246, 1),
        child: _getWidget(),
      )
    );
  }

  Widget _getWidget() {
      var list = [
        Container(
          height: 30,
          margin: EdgeInsets.fromLTRB(13, 5, 13, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    "时间",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "来源",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "金额",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
      ];
      for (var item in listArr) {
        list.add(
          Container(
            height: 40,
            margin: EdgeInsets.fromLTRB(13, 0, 13, 0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      item["add_time"]??"",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      item["instruction"]??"",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      item["amount"]??"",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
      

      return ListView(
        children: list,
      );
    }
}