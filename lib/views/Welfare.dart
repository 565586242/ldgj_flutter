import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/Welfareinfo.dart';

class WelfarePage extends StatefulWidget {
  WelfarePage({Key key}) : super(key: key);

  @override
  _WelfarePageState createState() => _WelfarePageState();
}

class _WelfarePageState extends State<WelfarePage> {
  List listArr = [];

  @override
  void initState() { 
    listArr = [];
    homewelfare();
    super.initState();
  }

  homewelfare() async {
    var res = await AjaxUtil().getHttp(context, '/homewelfare');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _content(item) {
    return Container(
      margin: EdgeInsets.fromLTRB(13, 15, 13, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item["type"] == 1?"众筹福利":"其他福利",
                    style: TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                  )
                ),
                Text(
                  item["add_time"],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500]
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    "assets/icon_xiayiye03@2x.png",
                    width: 6,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item["welfare_title"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  item["welfare_content"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getContentWidget() {
    List<Widget> list = [];
    for (var item in listArr) {
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WelfareInfoPage(pId: item["id"])));
          },
          child: _content(item),
        )
      );
    }

    return ListView(
      children: list,
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
        title: Text("福 利"),
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
      body: getContentWidget()
    );
  }
}