import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/pages/Index.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int lastTime = 3;
  Timer _timer;


  @override
  void initState() {
    startimgage();
    startTime();
    super.initState();
  }

  String loadingImage;

  //获取启动图
  startimgage() async {
    var res = await AjaxUtil().postHttp(context, '/startimgage');
    if(res["code"] == 200) {
      setState(() {
        loadingImage = CommonModel().hostUrl + res["data"]["start_image"];
      });
    }
  }

  //开始倒计时
  startTime() {
    final call = (timer) {
      setState(() {
        if (lastTime < 1) {
          _timer.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>IndexPage()));
        } else {
          lastTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: loadingImage == null?
              Image.asset(
                "lib/assets/loading.jpg",
                fit: BoxFit.cover,
              ): 
              Image.network(
                loadingImage,
                fit: BoxFit.cover,
              ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              height: 30,
              margin: EdgeInsets.only(right: 10,top: 30),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${lastTime}s",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>IndexPage()));
                    },
                    child: Text("跳过",style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none
                    ),),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}