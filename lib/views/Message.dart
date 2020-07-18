import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/MessageDetail.dart';

class MesagePage extends StatefulWidget {
  MesagePage({Key key}) : super(key: key);

  @override
  _MesagePageState createState() => _MesagePageState();
}

class _MesagePageState extends State<MesagePage> {

  var listArr = [];

  @override
  void initState() {
    listArr = [];
    homemessage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  homemessage() async {
    var res = await AjaxUtil().getHttp(context, '/homemessage');
    if(res["code"] == 200){
      setState(() {
        listArr = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  getContentWidget() {
    List<Widget> list = [];
    for (var item in listArr) {
      list.add(
        _content(item)
      );
    }
    return ListView(
      children: list
    );
  }

  Widget _content(item) {
    return GestureDetector(
      onTap: () {
        Navigator
        .push(context, MaterialPageRoute(builder: (context)=>MessageDetailPage(pId: item["id"])))
        .then((data){
          homemessage();
        });
      },
      child: Container(
      width: 698/2,
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
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item["message_type"] ?? ""
                        ),
                        item["is_read"] != '未读'?
                        TextSpan(
                          text: "[已读]",
                          style: TextStyle(
                            color: Colors.grey[500]
                          )
                        ):
                        TextSpan(
                          text: "[未读]",
                          style: TextStyle(
                            color: Color.fromRGBO(223, 0, 0, 1)
                          )
                        )
                      ]
                    )
                  )
                ),
                Text(
                  item["add_time"] ?? "",
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
            padding: EdgeInsets.fromLTRB(10, 10, 30, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item["message_title"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  item["message_content"] ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    ),
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
        title: Text("消 息"),
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