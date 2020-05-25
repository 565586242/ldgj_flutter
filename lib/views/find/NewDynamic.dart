import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/find/NewDynamicDetail.dart';

class NewDynamicPage extends StatefulWidget {
  NewDynamicPage({Key key}) : super(key: key);

  @override
  _NewDynamicPageState createState() => _NewDynamicPageState();
}

class _NewDynamicPageState extends State<NewDynamicPage> {
  List listArr = [];

  @override
  void initState() { 
    homenews();
    super.initState();
  }

  homenews() async {
    var res = await AjaxUtil().getHttp(context, '/homenews');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _newsWidget() {
  
    List<Widget> list = [];
    Widget content;
    for (var item in listArr) {
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDynamicDetailPage(parmId:item["id"])));
          },
        child: Container(
        padding: EdgeInsets.fromLTRB(13, 10, 13, 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: Color.fromRGBO(248, 248, 248, 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "${item['new_title']}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                  )),
                  Text(
                    "${item['add_time']}",
                    style: TextStyle(
                        color: Color.fromRGBO(40, 40, 40, 1), fontSize: 10),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    "lib/assets/icon_xiayiye03@2x.png",
                    width: 5.8,
                    height: 9.8,
                  )
                ],
              ),
            ),
            Container(
              height: 70.0,
              padding: EdgeInsets.fromLTRB(10, 7.5, 10, 0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "${item['new_subtitle']}",
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
                    offstage: item['new_cover'] == '' ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: item['new_cover'] == null?null:
                      Image.network(
                        CommonModel().hostUrl + item['new_cover'],
                        width: 100.0,
                        height: 55.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
        )
      );
    }
    content = Column(
      children: list,
    );
    return content;
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
        title: Text("最新动态"),
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
      body: ListView(
        children: <Widget>[
          _newsWidget()
        ],
      ),
    );
  }
}