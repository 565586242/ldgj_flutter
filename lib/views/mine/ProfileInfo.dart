import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/common/util.dart';
import 'package:new_ldgj/components/ButtonNormal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ldgj/components/Toast.dart';

class ProfileInfoPage extends StatefulWidget {
  ProfileInfoPage({Key key}) : super(key: key);

  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController userphoneController = new TextEditingController();
  TextEditingController usertruenameController = new TextEditingController();
  TextEditingController alipayController = TextEditingController();
  Map<dynamic, dynamic> userInfo = {};
  String imgPath;  //base64图像
  dynamic imgFile;  //图片文件
  dynamic wechatImgFile;
  String wechatImgPath;

  @override
  void initState() {
    imgPath = null;
    imgFile = null;
    super.initState();
    myInfo();
  }

  myInfo() async {
    var res = await AjaxUtil().postHttp(context, '/myInfo');
    if(res["code"] == 200){
      setState(() {
        usernameController.text = res["data"]["user_name"];
        userphoneController.text = res["data"]["user_phone"];
        usertruenameController.text = res["data"]["user_truename"];
        alipayController.text = res["data"]["alipay"];
        userInfo = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
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
        title: Text("个人信息"),
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
          myImage(),
          SizedBox(height: 10,),
          myInfoWidget(),
          SizedBox(height: 40,),
          ButtonNormal(name: "保存修改",onTap: () async {
            var res = await AjaxUtil().postHttp(context, '/perInfo',data: {
              "user_head": imgPath,
              "user_truename": userInfo["user_truename"],
              "wechat_code": wechatImgPath,
              "alipay": userInfo["alipay"]
            });
            if(res["code"] == 200){
              Toast.toast(context,msg:res["msg"]);
              Navigator.pop(context);
            }else{
              Toast.toast(context,msg:res["msg"]);
            }
          },),
          SizedBox(height: 40,)
        ]
      )
    );
  }

  Widget myImage() {
    return Container(
      height: 140,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              width: 59,
              height: 59,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(29.5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imgFile != null ? 
                    (
                      FileImage(imgFile)
                    ):
                    (
                      userInfo["user_head"] != null && userInfo["user_head"] != ""?
                      NetworkImage(CommonModel().hostUrl + userInfo["user_head"]):
                      AssetImage("lib/assets/img_touxiang@2x.png")
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 13,),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Text(
              "点击修改头像",
              style: TextStyle(
                color: Color.fromRGBO(223, 0, 0, 1)
              ),
            )
          )
        ],
      ),
    );
  }
  
  Widget myInfoWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 100,
              child: Text("用户名",textAlign: TextAlign.justify,style: TextStyle(fontSize: 15),),
            ),
            title: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              enabled: false,
            ),
          ),
          ListTile(
            leading: Container(
              width: 100,
              child: Text("手机号",textAlign: TextAlign.justify,style: TextStyle(fontSize: 15),),
            ),
            title: TextField(
              controller: userphoneController,
              decoration: InputDecoration(
                hintText: "请输入手机号",
                border: InputBorder.none,
              ),
              enabled: false,
              onChanged: (val){
                userInfo["user_phone"] = val;
              },
            ),
          ),
          ListTile(
            leading: Container(
              width: 100,
              child: Text("姓名",textAlign: TextAlign.justify,style: TextStyle(fontSize: 15),),
            ),
            title: TextField(
              controller: usertruenameController,
              decoration: InputDecoration(
                hintText: "请输入姓名",
                border: InputBorder.none,
              ),
              onChanged: (val){
                userInfo["user_truename"] = val;
              },
            ),
          ),
          ListTile(
            leading: Container(
              width: 100,
              child: Text("支付宝",textAlign: TextAlign.justify,style: TextStyle(fontSize: 15),),
            ),
            title: TextField(
              controller: alipayController,
              decoration: InputDecoration(
                hintText: "请输入支付宝账号",
                border: InputBorder.none,
              ),
              onChanged: (val){
                userInfo["alipay"] = val;
              },
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(left: 16.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text("微信",textAlign: TextAlign.justify,style: TextStyle(fontSize: 15),),
                ),
                GestureDetector(
                  onTap: () {
                    getWechatImage();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: wechatImgFile != null ? 
                          (
                            FileImage(wechatImgFile)
                          ):
                          (
                            userInfo["wechat_code"] != null?
                            NetworkImage(CommonModel().hostUrl + userInfo["wechat_code"]):
                            AssetImage("lib/assets/img_shangchuan@2x.png")
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var baseImg = await EncodeUtil.imageFile2Base64(image);
      setState(() {
        imgFile = image;
        imgPath = "data:image/png;base64," + baseImg;
      });
    } 
  }

  getWechatImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var baseImg = await EncodeUtil.imageFile2Base64(image);
      setState(() {
        wechatImgFile = image;
        wechatImgPath = "data:image/png;base64," + baseImg;
      });
    }
    
  }
}