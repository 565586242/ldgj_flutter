import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/util.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/mine/Agree.dart';

class VerifiedPage extends StatefulWidget {
  VerifiedPage({Key key}) : super(key: key);

  @override
  _VerifiedPageState createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
  var realName,
  idCard,
  cardNumber,
  cardAddress,
  reservedPhone,
  digitalWallet,
  frontCard,
  frontCardFile,
  reverseCard,
  reverseCardFile;
  bool isAgree = false;  //是否同意保密协议

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
        title: Text("实名认证"),
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
          cardType(),
          SizedBox(height: 20,),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  value: isAgree,
                  activeColor: Colors.red,
                  onChanged: (val) {
                    setState(() {
                      isAgree = !isAgree;
                    });
                  },
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "同意"),
                      TextSpan(
                        text: "保密协议",
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AgreePage()));
                        },
                        style: TextStyle(
                          color: Colors.red
                        )
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          submitBtn()
        ],
      ),
    );
  }

  Widget cardType() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text("真实姓名",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请填写您本人的真实姓名",
                border: InputBorder.none
              ),
              onChanged: (val) {
                realName = val;
              },
            )
          ),
          ListTile(
            leading: Text("身份证号",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请输入您的身份证号码",
                border: InputBorder.none
              ),
              onChanged: (val) {
                idCard = val;
              },
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 53,
            padding: EdgeInsets.only(left: 15),
            color: Colors.grey[100],
            child: Text(
              "真实姓名必须和身份证号，银行卡号保持一致",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                height: 3
              ),
            ),
          ),
          ListTile(
            leading: Text("银行卡号",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请输入您的银行卡号",
                border: InputBorder.none
              ),
              onChanged: (val) {
                cardNumber = val;
              },
            )
          ),
          ListTile(
            leading: Text("预留手机号",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请输入您在该银行预留的手机号",
                border: InputBorder.none
              ),
              onChanged: (val) {
                reservedPhone = val;
              },
            )
          ),
          ListTile(
            leading: Text("开户行地址",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请输入银行卡的开户行地址",
                border: InputBorder.none
              ),
              onChanged: (val) {
                cardAddress = val;
              },
            )
          ),
          Container(height: 10,color: Colors.grey[100],),
          ListTile(
            leading: Text("数字钱包地址",style: TextStyle(fontSize: 15),),
            title: TextField(
              decoration: InputDecoration(
                hintText: "请输入您的数字钱包地址",
                border: InputBorder.none
              ),
              onChanged: (val) {
                digitalWallet = val;
              },
            ),
            trailing: GestureDetector(
              onTap: () async {
                Clipboard.setData(ClipboardData(text: digitalWallet));
                var clipboardData = await Clipboard.getData('text/plain');
                if(clipboardData.text != null && clipboardData.text != ''){
                  Toast.toast(context,msg: "复制成功");
                }else{
                  Toast.toast(context,msg: "暂无内容");
                }
              },
              child: Text("复制"),
            ),
          ),
          Container(height: 10,color: Colors.grey[100],),
          Container(
            height: 150,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text("身份证正面",style: TextStyle(fontSize: 15),),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          getImage(1);
                        },
                        child: Container(
                          width: 126,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: frontCard != null?
                            Image.file(frontCardFile,fit: BoxFit.cover,):
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset("lib/assets/img_shangchuan@2x.png",fit: BoxFit.cover,),
                                ),
                                Text("点击上传正面")
                              ],
                            )
                        ),
                      ),
                      Text("实例:"),
                      Container(
                        width: 126,
                        height: 80,
                        child: Image.asset("lib/assets/img_shilie_zheng@2x.png",fit: BoxFit.cover,),
                      )
                    ],
                  )
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
          Container(height: 10,color: Colors.grey[100],),
          Container(
            height: 150,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text("身份证反面",style: TextStyle(fontSize: 15),),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          getImage(2);
                        },
                        child: Container(
                          width: 126,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: reverseCard != null?
                            Image.file(reverseCardFile,fit: BoxFit.cover,):
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset("lib/assets/img_shangchuan@2x.png",fit: BoxFit.cover,),
                                ),
                                Text("点击上传反面")
                              ],
                            )
                        ),
                      ),
                      Text("实例:"),
                      Container(
                        width: 126,
                        height: 80,
                        child: Image.asset("lib/assets/img_shilie_fan@2x.png",fit: BoxFit.cover,),
                      )
                    ],
                  )
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget submitBtn() {
    return Container(
      margin: EdgeInsets.only(left: 37.5,right: 37.5,bottom: 20),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(226, 48, 48, 1),
          Color.fromRGBO(206, 0, 10, 1)
        ])
      ),
      child: GestureDetector(
        child: Text(
          "确认提交",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.9,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: () async {
          if(isAgree == false){
            Toast.toast(context,msg:"请先阅读保密协议");
          }else{
            var res = await AjaxUtil().postHttp(context, '/realAuth',data: {
              "real_name": realName,
              "id_card": idCard,
              "card_number": cardNumber,
              "card_address": cardAddress,
              "reserved_phone": reservedPhone,
              "digital_wallet": digitalWallet,
              "front_card": frontCard,
              "reverse_card": reverseCard
            });
            if(res["code"] == 200){
              Toast.toast(context,msg: res["msg"]);
              Navigator.pop(context);
            }else{
              Toast.toast(context,msg: res["msg"]);
            }
          }
        },
      )
    );
  }


  //1正面  2反面
  getImage(int index) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var base64Image = await EncodeUtil.imageFile2Base64(image);
      setState(() {
        if(index == 1){
          frontCard = "data:image/png;base64," + base64Image;
          frontCardFile = image;
        }else{
          reverseCard = "data:image/png;base64," + base64Image;
          reverseCardFile = image;
        }
      });
    }
  }
}