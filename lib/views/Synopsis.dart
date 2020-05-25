import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';

class SynopsisPage extends StatefulWidget {
  SynopsisPage({Key key}) : super(key: key);

  @override
  _SynopsisPageState createState() => _SynopsisPageState();
}

class _SynopsisPageState extends State<SynopsisPage> {
  List<dynamic> bannerList;
  Map<String,dynamic> companyInfo = {};

  @override
  void initState() { 
    homecompany();
    super.initState();
  }

  homecompany() async {
    var res = await AjaxUtil().getHttp(context, '/homecompany');
    if(res["code"] == 200){
      setState(() {
        bannerList = res["data"]["company_banner"];
        companyInfo = res["data"]["company_info"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  //轮播图
  Widget bannerWidget() {
    /* 轮播图 */
    return Container(
      height: 150,
      margin: EdgeInsets.fromLTRB(13, 12, 13, 0),
      child: bannerList != null ?Swiper(
        autoplay: true,
        loop: true,
        itemCount: bannerList.length,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          return AspectRatio(
            aspectRatio: 698 / 300,
            child: Image.network(
              CommonModel().hostUrl + bannerList[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ):null,
    );
  }

  Widget _myBody() {
    return ListView(
      padding: EdgeInsets.fromLTRB(13, 11, 13, 0),
      children: <Widget>[
        bannerWidget(),
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: companyInfo["introduce"] ?? "",
                )
              ],
              style: TextStyle(
                height: 1.6
              )
            ),
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
        title: Text("简 介"),
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
      body: _myBody(),
    );
  }
}
