import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/Bulletin.dart';
import 'package:new_ldgj/views/Cooperation.dart';
import 'package:new_ldgj/views/Message.dart';
import 'package:new_ldgj/views/Service.dart';
import 'package:new_ldgj/views/Share.dart';
import 'package:new_ldgj/views/Synopsis.dart';
import 'package:new_ldgj/views/Welfare.dart';
import 'package:new_ldgj/views/find/NewDynamicDetail.dart';
import 'package:new_ldgj/views/home/Help.dart';
import 'package:marquee_flutter/marquee_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> bannerList = [];//轮播图
  List<dynamic> newsList = []; //动态列表
  var messageList; //消息

  @override
  void initState() {
    homeindex();
    super.initState();
  }

  homeindex() async {
    var res = await AjaxUtil().getHttp(context, '/homeindex');
    print(res);
    if(res["code"] == 200){
      setState(() {
        bannerList = res["data"]["banner_list"];
        newsList = res["data"]["news_list"];
        messageList = res["data"]["message_list"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }
  /* 头部搜索 */
  Widget homeTop() {
    return Container(
      padding: EdgeInsets.fromLTRB(18, 0, 23, 0),
      child: Row(
        children: <Widget>[
          Image.asset(
            "lib/assets/home_logo@2x.png",
            width: 28,
          ),
          SizedBox(width: 15),
          Expanded(
              child: Container(
            width: 290.0,
            height: 30.0,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(232, 235, 241, 1),
                borderRadius: BorderRadius.circular(3.0)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "请输入搜索内容",
                  style: TextStyle(
                      color: Color.fromRGBO(40, 40, 40, 1), fontSize: 14),
                )),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Image.asset(
                    "lib/assets/home_sousuo_fenge@2x.png",
                    width: 1.0,
                    height: 18.0,
                  ),
                ),
                Image.asset(
                  "lib/assets/home_sousuo@2x.png",
                  width: 18.5,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget bannerWidget() {
    /* 轮播图 */
    return Container(
      height: 150,
      margin: EdgeInsets.fromLTRB(13, 0, 13, 0),
      child: bannerList.length != 0 ? Swiper(
        autoplay: true,
        loop: true,
        itemCount: bannerList.length,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return AspectRatio(
            aspectRatio: 698 / 300,
            child: Image.network(
              CommonModel().hostUrl + bannerList[index]["img_path"],
              fit: BoxFit.cover,
            ),
          );
        },
      ):Container(),
    );
  }

  Widget gridWidget() {
    /* 九宫格 */
    var gridList = [
      {
        "imgUrl": "lib/assets/home_icon_gonggao@2x.png",
        "title": "公 告",
        "routerUrl": MesagePage()
      },
      {
        "imgUrl": "lib/assets/home_icon_jiejian@2x.png",
        "title": "简 介",
        "routerUrl": SynopsisPage()
      },
      {
        "imgUrl": "lib/assets/home_icon_kuaixun@2x.png",
        "title": "快 讯",
        "routerUrl": BulletinPage()
      },
      {
        "imgUrl": "lib/assets/home_icon_fuli@2x.png",
        "title": "福 利",
        "routerUrl": WelfarePage()
      },
      {
        "imgUrl": "lib/assets/home_icon_fuwu@2x.png",
        "title": "文 化",
        "routerUrl": ServicePage()
      },
      {
        "imgUrl": "lib/assets/home_icon_hezuo@2x.png",
        "title": "合 作",
        "routerUrl": CooperationPage()
      },
      {
        "imgUrl": "lib/assets/home_icon_fenxiang@2x.png",
        "title": "分 享",
        "routerUrl": SharePage()
      },
      {
        "imgUrl": "lib/assets/home_icon_bangzhu@2x.png",
        "title": "帮 助",
        "routerUrl": HelpPage()
      }
    ];
    return Container(
        height: 150,
        padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.3
            ),
            itemCount: gridList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    if(gridList[index]['routerUrl'] != '') {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>gridList[index]['routerUrl']));
                    }else{
                      Toast.toast(context,msg: "暂未开通");
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: Image.asset(
                          gridList[index]["imgUrl"],
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(gridList[index]["title"])
                    ],
                  ),
                ),
              );
            }));
  }

  Widget messageWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MesagePage()));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(13, 6, 13, 0),
        child: Row(
          children: <Widget>[
            Image.asset(
              "lib/assets/home_icon_xiaoxi@2x.png",
              width: 38,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                height: 50,
                child: MarqueeWidget(
                  text: messageList == null?"":messageList["roll_content"],
                  textStyle: new TextStyle(fontSize: 13.0),
                  scrollAxis: Axis.horizontal,
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget newsWidget() {
    List<Widget> list = [];
    Widget content;
    for (var item in newsList) {
      list.add(
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDynamicDetailPage(parmId: item["id"])));
          },
          child: Container(
        padding: EdgeInsets.fromLTRB(13, 10, 13, 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                    )
                  ),
                  SizedBox(width: 50),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        item["new_subtitle"]??"",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ),
                  Offstage(
                    offstage: item['new_cover'] == '' ? true : false,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: Image.network(
                        item['new_cover'] != null ? CommonModel().hostUrl + item['new_cover']: null,
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
      body: ListView(
        children: <Widget>[
          homeTop(),
          SizedBox(height: 6,),
          bannerWidget(),
          messageWidget(),
          SizedBox(height: 6,),
          gridWidget(),
          newsWidget()
        ],
      ),
    );
  }
}
