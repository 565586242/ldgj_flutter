import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/Cooperation.dart';
import 'package:new_ldgj/views/find/CrowCommunity.dart';
import 'package:new_ldgj/views/find/NewDynamic.dart';
import 'package:new_ldgj/views/find/NewDynamicDetail.dart';

class FindPage extends StatefulWidget {
  FindPage({Key key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  dynamic dataInfo = {};

  @override
  void initState() { 
    super.initState();
    discover();
  }

  discover() async {
    var res = await AjaxUtil().getHttp(context, '/discover');
    if(res["code"] == 200){
      setState(() {
        dataInfo = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _dynamic() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDynamicDetailPage(parmId: dataInfo["id"])));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(13, 0, 13, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      dataInfo["new_title"]??"",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                  )),
                  Text(
                    dataInfo["add_time"]??"",
                    style: TextStyle(
                        color: Color.fromRGBO(40, 40, 40, 1), fontSize: 10),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 5.8,
                    height: 9.8,
                    child: Image.asset(
                      "assets/icon_xiayiye03@2x.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 75.0,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: dataInfo["new_subtitle"]??"",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(40, 40, 40, 1),
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Offstage(
                    offstage: dataInfo["new_cover"] == '' ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      width: 100,
                      height: 55,
                      child: dataInfo["new_cover"] != null?
                        Image.network(CommonModel().hostUrl + dataInfo["new_cover"],fit: BoxFit.cover,):
                        Container()
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _community() {

    var listArr = [
      {
        "title": '众筹社区',
        "imgHeight": 120,
        "imgUrl": "assets/img_zhongchou@2x.png",
        "routerUrl": CrowCommunityPage()
      },
      {
        "title": '招商合作',
        "imgHeight": 75,
        "imgUrl": "assets/img_zaoshang@2x.png",
        "routerUrl": CooperationPage()
      },
      {
        "title": '数字社区',
        "imgHeight": 75,
        "imgUrl": "assets/img_shangxueyuan@2x.png"
      },
    ];

    List<Widget> list = [];
    Widget content;

    for (var item in listArr) {
      list.add(
        GestureDetector(
          onTap: () {
            if(item["routerUrl"] != null){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>item["routerUrl"]));
            }
          },
          child: Column(
          children: <Widget>[
            Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
              color: Color.fromRGBO(248, 248, 248, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item["title"],style: TextStyle(fontSize: 16),),
                  Text("进入>",style: TextStyle(fontSize: 12,color: Colors.grey[500]),)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(13, 0, 13, 0),
              child: AspectRatio(
                aspectRatio: 349/item["imgHeight"],
                child: Image.asset(item["imgUrl"],fit: BoxFit.cover,),
              ),
            )
          ],
        ),
        )
      );
    }

    content = Container(
      width: 375,
      child: Column(
        children: list,
      ),
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发 现"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(226,48,54, 1),
                Color.fromRGBO(208,0,8, 1)
              ],
            ),
          ),
        )
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
            color: Color.fromRGBO(248, 248, 248, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("最新动态",style: TextStyle(fontSize: 16),),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDynamicPage()));
                  },
                  child: Text("更多>",style: TextStyle(fontSize: 12,color: Colors.grey[500]),),
                )
              ],
            ),
          ),
          _dynamic(),
          _community()
        ]
      )
    );
  }
}