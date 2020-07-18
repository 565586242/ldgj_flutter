import 'package:flutter/material.dart';
import 'package:new_ldgj/common/common.dart';

class StudioPage extends StatefulWidget {
  final data;
  StudioPage({Key key, this.data}) : super(key: key);

  @override
  _StudioPageState createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  @override
  void initState() {
    print(widget.data);
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
        title: Text("${widget.data["userInfo"]["false_level"]}" ?? ""),
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
      body: ListView(
        children: <Widget>[
          mineTop(),
          personConfig(),
          performance(),
          SizedBox(height: 20),
          container(),
        ],
      ),
    );
  }

  Widget mineTop() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(33.5, 20.5, 33.5, 20.5),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 59,
                  height: 59,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(29.5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.data["userInfo"]["user_head"] != null &&
                                widget.data["userInfo"]["user_head"] != ""
                            ? NetworkImage(CommonModel().hostUrl +
                                widget.data["userInfo"]["user_head"])
                            : AssetImage("assets/img_touxiang@2x.png")),
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.data["userInfo"]["user_name"],
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      widget.data["userInfo"]["user_phone"],
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* 级别介绍 */
  Widget container() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Text("${widget.data["levelIntro"]}"),
    );
  }

  /* 人员配置 */
  Widget personConfig() {
    return Container(
      child: Column(
        children: <Widget>[
          pageTitle("人员配置"),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(13),
            child: Text("${widget.data["myDirectInfo"]}",)
          )
        ],
      ),
    );
  }

  /* 业绩 */
  Widget performance() {
    return Container(
      child: Column(
        children: <Widget>[
          pageTitle("业绩"),
          Container(
            height: 50,
            color: Colors.white,
            padding: EdgeInsets.only(left: 13, right: 14.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "个人业绩",
                  style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                ),
                Text(
                  "${widget.data["myResult"]}",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          Container(
            height: 50,
            color: Colors.white,
            padding: EdgeInsets.only(left: 13, right: 14.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "总业绩",
                  style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                ),
                Text(
                  "${widget.data["teamResult"]}",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /* 分支机构 */
  /* Widget branches() {
    List<Widget> list = [];
    for (var item in widget.data["directInfo"]) {
      list.add(Container(
        height: 50,
        color: Colors.white,
        padding: EdgeInsets.only(left: 13),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${item["user_name"]}",
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
            ),
            Expanded(
              child: Text("${item["user_level"]}"),
            )
          ],
        ),
      ));
    }

    return Container(
      child: Column(
        children: <Widget>[
          pageTitle("分支机构"),
          Column(
            children: list,
          )
        ],
      ),
    );
  } */

  /* 标题 */
  Widget pageTitle(String title) {
    return Container(
      height: 38.5,
      padding: EdgeInsets.only(left: 13.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
