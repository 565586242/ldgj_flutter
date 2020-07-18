import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/AliPayPage.dart';
import 'package:new_ldgj/components/ButtonNormal.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/home/EquityRecord.dart';

class EquityPage extends StatefulWidget {
  EquityPage({Key key}) : super(key: key);

  @override
  _EquityPageState createState() => _EquityPageState();
}

class _EquityPageState extends State<EquityPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
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
          title: Text("股 权"),
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
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(text: "储备金转股权"),
              Tab(text: "股权转储备金"),
            ],
          ),
        ),
        body:
            TabBarView(controller: tabController, children: [Tab1(), Tab2()]));
  }
}

class Tab1 extends StatefulWidget {
  Tab1({Key key}) : super(key: key);
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  var resData;
  var amount;

  @override
  void initState() {
    getTransferstock();
    super.initState();
  }

  getTransferstock() async {
    var res = await AjaxUtil().getHttp(context, '/transferstock', data: {"type": 1});
    setState(() {
      resData = res["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 13, top: 20, right: 30),
      children: <Widget>[
        Text("储备金金额", style: TextStyle(fontSize: 15)),
        ListTile(title: Text("${resData != null ? resData["wallet"] : ''}")),
        Text("兑换比例", style: TextStyle(fontSize: 15)),
        ListTile(title: Text("${resData != null ? resData["rate"] : ''}")),
        Text("兑换金额", style: TextStyle(fontSize: 15)),
        Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          padding: EdgeInsets.only(left: 5),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[500])),
          child: TextField(
            style: TextStyle(height: 1.2),
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: "请输入兑换金额"),
            onChanged: (v) {
              setState(() {
                amount = v;
              });
            },
          ), 
        ),
        SizedBox(
          height: 20,
        ),
        ButtonNormal(
          name: '立即转换',
          onTap: () {
            if (amount == null || amount == "") {
              Toast.toast(context, msg: "兑换金额不能为空");
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainKeyboard(
                            formInfo: {
                              "type": 1,
                              "amount": amount,
                            },
                            calback: (data) async {
                              print(data);
                              var res = await AjaxUtil().postHttp(
                                  context, '/transferstock',
                                  data: data);
                                  print(res);
                              if (res["code"] == 200) {
                                Toast.toast(context, msg: res["msg"]);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              } else {
                                Toast.toast(context, msg: res["msg"]);
                              }
                            },
                          )));
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        ButtonNormal(
          name: '转换记录',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EquityRecord()));
          },
        ),
      ],
    );
  }
}

class Tab2 extends StatefulWidget {
  Tab2({Key key}) : super(key: key);

  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  var resData;
  var amount;

  @override
  void initState() {
    getTransferstock();
    super.initState();
  }

  getTransferstock() async {
    var res =
        await AjaxUtil().getHttp(context, '/transferstock', data: {"type": 2});
    setState(() {
      resData = res["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 13, top: 20, right: 30),
      children: <Widget>[
        Text("股权金额", style: TextStyle(fontSize: 15)),
        ListTile(
          title: Text("${resData != null ? resData["wallet"] : ''}"),
        ),
        Text("兑换比例", style: TextStyle(fontSize: 15)),
        ListTile(
          title: Text("${resData != null ? resData["rate"] : ''}"),
        ),
        Text("分红比例", style: TextStyle(fontSize: 15)),
        ListTile(
          title: Text("${resData != null ? resData["equity_share_ratio"] : ''}"),
        ),
        Text("兑换金额", style: TextStyle(fontSize: 15)),
        Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          padding: EdgeInsets.only(left: 5),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[500])),
          child: TextField(
            style: TextStyle(height: 1.2),
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: "请输入兑换金额"),
            onChanged: (v) {
              amount = v;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ButtonNormal(
          name: '立即转换',
          onTap: () {
            if (amount == null || amount == "") {
              Toast.toast(context, msg: "兑换金额不能为空");
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainKeyboard(
                            formInfo: {
                              "type": 2,
                              "amount": amount,
                            },
                            calback: (data) async {
                              print(data);
                              var res = await AjaxUtil().postHttp(
                                  context, '/transferstock',
                                  data: data);
                                  print(res);
                              if (res["code"] == 200) {
                                Toast.toast(context, msg: res["msg"]);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              } else {
                                Toast.toast(context, msg: res["msg"]);
                              }
                            },
                          )));
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        ButtonNormal(
          name: '转换记录',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EquityRecord()));
          },
        ),
      ],
    );
  }
}
