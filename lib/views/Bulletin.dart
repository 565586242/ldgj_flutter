import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/BulletinDeatil.dart';

class BulletinPage extends StatefulWidget {
  BulletinPage({Key key}) : super(key: key);

  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {

  List<dynamic> listArr;

  @override
  void initState() { 
    listArr = [];
    homeflash();
    super.initState();
  }

  homeflash() async {
    var res = await AjaxUtil().getHttp(context, '/homeflash');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _timeLine() {
    List<Widget> timeList = [];
    Widget content;
    for (var item in listArr) {
      timeList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> BulletinDetailPage(pId: item["id"],)));
          },
          child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 0, 0, 1),
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 98,
                      color: Color.fromRGBO(223, 0, 0, 1),
                    )
                  ],
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item['add_time'] ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(40, 40, 40, 1)
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          item['flash_content'] ?? "",
                          maxLines: 3,
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        ),
        )
      );
    }
    content = ListView(
      padding: EdgeInsets.all(12),
      children: timeList,
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
        title: Text("快 讯"),
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
      body: _timeLine(),
    );
  }
}
