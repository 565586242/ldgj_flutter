import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class PerformancePage extends StatefulWidget {
  PerformancePage({Key key}) : super(key: key);

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  List<dynamic> listArr = [];

  @override
  void initState() {
    resultsDetail();
    super.initState();
  }

  resultsDetail() async {
    var res = await AjaxUtil().getHttp(context, '/resultsDetail');
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
                    "业绩来源",
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
              Expanded(
                child: Container(
                  child: Text(
                    "奖励比例",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
      ];
      Widget content;

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
                      item["type"]??"",
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
                Expanded(
                  child: Container(
                    child: Text(
                      item["rate"]??"",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
      content = ListView(
        children: list,
      );
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("众筹明细"),
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
      body: _getWidget()
    );
  }
}
