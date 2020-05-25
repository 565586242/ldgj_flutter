import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:video_player/video_player.dart';

class ServiceDetailPage extends StatefulWidget {
  final int pId;
  final String url;
  final int type;
  ServiceDetailPage({Key key, this.pId, this.url, this.type}) : super(key: key);

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  Map data;
  VideoPlayerController _controller;

  @override
  void initState() { 
    data = {};
    super.initState();
    serviceinfo();
    if(widget.type != 1){
      _controller = VideoPlayerController.network(widget.url)
        ..initialize()
        .then((_){
          setState(() {});
        });
    }
  }

  serviceinfo() async {
    var res = await AjaxUtil().getHttp(context, '/serviceinfo',data: {
      "id": widget.pId
    });
    if(res["code"] == 200){
      setState(() {
         data = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  @override 
  void dispose() { 
    super.dispose();
    _controller.dispose(); 
  }

  Widget _topImg() {
    return GestureDetector(
      onTap: () {
        if(_controller.value.isPlaying){
          _controller.pause();
        }else{
          _controller.play();
        }
      },
      child: Container(
        height: 240,
        margin: EdgeInsets.fromLTRB(13, 11, 13, 0),
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            widget.type == 1 ? Image.network(
              widget.url,
            ): (
              _controller.value.initialized?
              Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio, 
                  child: VideoPlayer(_controller),
                ),
              ): 
              Container()
            )
          ],
        ),
      )
    );
  }

  Widget _serviceDetail() {
    return Container(
      padding: EdgeInsets.fromLTRB(13, 10, 13, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data["service_title"] ?? "",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: Text(
              data["service_content"] ?? "",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(40, 40, 40, 1),
                height: 1.6
              ),
            ),
          ),
          Text(
            "联系方式",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(13, 10, 13, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "电话：${data["telphone"]??""}"
                ),
                Text(
                  "手机：${data["mobile_phone"]??""}"
                ),
                Text(
                  "微信：${data["wechat"]??""}"
                )
              ],
            ),
          )
        ],
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
        title: Text("文化详情"),
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
          _topImg(),
          _serviceDetail()
        ],
      ),
    );
  }
}