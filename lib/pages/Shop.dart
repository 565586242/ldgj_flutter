import 'package:flutter/material.dart';
import 'package:new_ldgj/components/Toast.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            controller: tabController,
            labelColor: Color.fromRGBO(223, 1, 0, 1),
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            indicatorColor: Color.fromRGBO(223, 1, 0, 1),
            unselectedLabelColor: Colors.black87,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "丽东臻品汇"),
              Tab(text: "生活服务",)
            ]
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ShopView(),
          LifeView()
        ]
      ),
    );
  }
}

/* 丽东臻品汇 */
class ShopView extends StatefulWidget {
  ShopView({Key key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
      children: <Widget>[
        Container(
          height: 30,
          padding: EdgeInsets.only(left: 10),
          margin: EdgeInsets.fromLTRB(14.5, 10, 14.5, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.search,size: 16,),
              Expanded(
                child: Text("请输入搜索内容"),
              ),
              GestureDetector(
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(223, 122, 132, 1),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
                  ),
                  child: Text("搜索",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.8
                    ),
                  ),
                )
              )
            ],
          )
        ),
        Wrap(
          runSpacing: 6,
          alignment: WrapAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width - 40)/2,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 215,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      )
                    ),
                    child: Image.asset("lib/assets/img_02@2x.png",fit: BoxFit.cover,),
                  ),
                  Text(
                    "碧色Bedtder18K金铂金情 侣求婚结婚钻石戒指克拉",
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "￥",style: TextStyle(fontSize: 12,color: Colors.red)),
                            TextSpan(text: "1,680",style: TextStyle(fontSize: 16,color: Colors.red))
                          ]
                        )
                      ),
                      Text("30人付款",style: TextStyle(fontSize: 12,color: Color.fromRGBO(122, 122, 122, 1)))
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 40)/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 215,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Image.asset("lib/assets/img_02@2x.png",fit: BoxFit.cover,),
                  ),
                  Text(
                    "碧色Bedtder18K金铂金情 侣求婚结婚钻石戒指克拉",
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "￥",style: TextStyle(fontSize: 12,color: Colors.red)),
                            TextSpan(text: "1,680",style: TextStyle(fontSize: 16,color: Colors.red))
                          ]
                        )
                      ),
                      Text("30人付款",style: TextStyle(fontSize: 12,color: Color.fromRGBO(122, 122, 122, 1)))
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 172,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 215,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Image.asset("lib/assets/img_02@2x.png",fit: BoxFit.cover,),
                  ),
                  Text(
                    "碧色Bedtder18K金铂金情 侣求婚结婚钻石戒指克拉",
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "￥",style: TextStyle(fontSize: 12,color: Colors.red)),
                            TextSpan(text: "1,680",style: TextStyle(fontSize: 16,color: Colors.red))
                          ]
                        )
                      ),
                      Text("30人付款",style: TextStyle(fontSize: 12,color: Color.fromRGBO(122, 122, 122, 1)))
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

/* 生活服务 */
class LifeView extends StatefulWidget {
  LifeView({Key key}) : super(key: key);

  @override
  _LifeViewState createState() => _LifeViewState();
}
class _LifeViewState extends State<LifeView> {

  Widget _createItem(title,img) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Toast.toast(context,msg: "暂未开通");
        },
        child: Column(
          children: <Widget>[
            Container(
              height: 22,
              margin: EdgeInsets.only(bottom: 6),
              child: Image.asset(img,fit: BoxFit.contain,),
            ),
            Text(title)
          ],
        ),
      ),
    );
  }

  Widget _titleView(title) {
    return Container(
      padding: EdgeInsets.only(left: 13),
      margin: EdgeInsets.only(top: 19.5),
      child: Text(title,style: TextStyle(fontSize: 16,color: Color.fromRGBO(40, 40, 40, 1)),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleView("充值缴费"),
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _createItem("话费充值","lib/assets/icon_huafei@2x.png"),
              _createItem("缴水费","lib/assets/icon_shuifei@2x.png"),
              _createItem("缴电费","lib/assets/icon_dianfei@2x.png"),
              Expanded(
                child: Column(),
              ),
            ],
          ),
        ),
        _titleView("交通出行"),
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _createItem("滴滴出行","lib/assets/icon_didi@2x.png"),
              _createItem("火车票","lib/assets/icon_huoche@2x.png"),
              _createItem("飞机票","lib/assets/icon_feiji@2x.png"),
              Expanded(
                child: Column(),
              ),
            ],
          ),
        ),
        _titleView("更多"),
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0)
            ),
            child: Image.asset(
              "lib/assets/img_001@2x.png",
            )
          ),
        )
      ],
    );
  }
}








