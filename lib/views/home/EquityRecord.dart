import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';

class EquityRecord extends StatefulWidget {
  EquityRecord({Key key}) : super(key: key);

  @override
  _EquityRecordState createState() => _EquityRecordState();
}

class _EquityRecordState extends State<EquityRecord> {
  var detailList = [];

  @override
  void initState() {
    getEquityDetails();
    super.initState();
  }

  getEquityDetails() async {
    var res = await AjaxUtil().getHttp(context, '/equityDetails');
    if(res["code"] == 200){
      setState(() {
        detailList = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget getTabList() {
    List<Widget> list = [];

    for (var item in detailList) {
      print(item);
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
              Expanded(child: Text(item["log_note"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
              Expanded(child: Text(item["amount"],textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.black54))),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 110,
                child: Text("转换时间",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]),),
              ),
              Expanded(child: Text("类型",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
              Expanded(child: Text("转换金额",textAlign: TextAlign.center,style: TextStyle(inherit: false,color: Colors.grey[500]))),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 200,
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
        title: Text("转换记录"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(226, 48, 54, 1),
                Color.fromRGBO(208, 0, 8, 1)
              ],
            ),
          ),
        ),
      ),
      body: getTabList()
    );
  }
}