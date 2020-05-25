import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/common/util.dart';
import 'package:new_ldgj/components/SeeImg.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/find/ConfirmOrder.dart';
import 'package:new_ldgj/views/find/CrowCommOrder.dart';

class CrowCommunityPage extends StatefulWidget {
  final String pwd;
  CrowCommunityPage({Key key,this.pwd}) : super(key: key);

  @override
  _CrowCommunityPageState createState() => _CrowCommunityPageState();
}

class _CrowCommunityPageState extends State<CrowCommunityPage> {
  //初始数据
  dynamic dataInfo = {};
  dynamic walletInfo = {};
  dynamic configInfo;
  //提交的数据
  dynamic formInfo = {
    "money_type": 1,  //付款方式0扫平台的支付二维码1财富金账户2储备金账户
    "amount": "10000",  //金额
    "pay_type": 4,  //支付方式
    "pay_voucher": '',
    "pay_password": ''
  };
  var base64Img = "";
  var imgFile;
  @override
  void initState() { 
    crowdfunding();
    super.initState();
  }

  crowdfunding() async {
    var res = await AjaxUtil().getHttp(context, '/crowdfunding');
    if(res["code"] == 200){
      setState(() {
        dataInfo = res["data"]["company"];
        walletInfo = res["data"]["walletInfo"];
        configInfo = res["data"]["configInfo"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  bool isChangeSelf = false;  //是否自拟定金额
  String selfMoney = '';  //自定义金额

  TextEditingController selfMoneyController = TextEditingController();

  //选择支付方式
  choosePayType(type,val){
    if(type == "money_type"){
      //财富金或储备金支付
      setState(() {
        formInfo["money_type"] = val;
        formInfo["pay_type"] = 9;
      });
    }else{
      //支付宝/微信/银行卡/数字资产支付
      setState(() {
        formInfo["pay_type"] = val;
        formInfo["money_type"] = 0;
      });
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
        title: Text("众筹社区"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CrowCommOrderPage()));
            },
            child: Container(
              padding: EdgeInsets.only(right: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("众筹订单")
                ],
              ),
            ),
          )
        ],
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
          chooseCrowMoney(),
          chooseMoneySelf(),
          choosePay(),
          formInfo["money_type"] == 0?payImage():Container(),
          submitBtn()
        ],
      ),
    );
  }

  /* 选择众筹金额 */
  Widget chooseCrowMoney() {
    var listArr = ["10000","20000","30000","40000","50000"];

    List<Widget> list = [];

    for (var item in listArr) {
      list.add(
        Container(
          width: MediaQuery.of(context).size.width/2,
          child: RadioListTile(
            value: item, 
            activeColor: Color.fromRGBO(223, 0, 0, 1),
            groupValue: formInfo["amount"], 
            title: Text("$item"),
            onChanged: (v) {
              setState(() {
                selfMoney = '';
                selfMoneyController.text = '';
                isChangeSelf = false;
                formInfo["amount"] = v;
              });
            }
          ),
        )
      );
    }

    list.add(
      Container(
        width: MediaQuery.of(context).size.width/2,
        child: RadioListTile(
          value: "0", 
          activeColor: Color.fromRGBO(223, 0, 0, 1),
          groupValue: formInfo["amount"], 
          title: Text("自拟定金额"),
          onChanged: (v) {
            setState(() {
              selfMoney = '';
              isChangeSelf = true;
              formInfo["amount"] = v;
              selfMoneyController.text = '';
            });
          }
        ),
      )
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(13.5, 20, 0, 0),
            child: Text(
              "请选择众筹金额",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(40, 40, 40, 1)
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: list
            ),
          )
        ],
      ),
    );
  }

  /* 自拟定金额 */
  Widget chooseMoneySelf() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(13.5, 20, 0, 0),
            child: Text(
              "自拟定金额",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(40, 40, 40, 1)
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 28.5,right: 46.5),
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[500]
              )
            ),
            child: TextField(
              controller: selfMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "请输入${configInfo!=null?configInfo['crowdfunding_limit1']:'0'}~${configInfo!=null?configInfo['crowdfunding_limit2']:'0'}之间的众筹金额",
                border: InputBorder.none
              ),
              enabled: isChangeSelf,
              onChanged: (v) {
                setState(() {
                  selfMoney = v;
                  isChangeSelf = true;
                  formInfo["amount"] = "0";
                });
              },
            ),
          )
        ],
      ),
    );
  }

  /* 选择支付方式 */
  Widget choosePay() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(13.5, 20, 0, 0),
            child: Text(
              "请选择支付方式",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(40, 40, 40, 1)
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1, 
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["money_type"], 
                onChanged: (value){
                  choosePayType("money_type",value);
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("money_type",1);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("财富金"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    "余额:${walletInfo["fortune_gold"]??"0.00"}",
                    maxLines: 2,
                  )
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 2, 
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["money_type"], 
                onChanged: (value){
                  setState(() {
                    choosePayType("money_type",value);
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("money_type",2);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("储备金"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    "余额:${walletInfo["reserve_fund"]??"0.00"}",
                    maxLines: 2,
                  )
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 0, 
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["pay_type"], 
                onChanged: (value){
                  setState(() {
                    choosePayType("pay_type",value);
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("pay_type",0);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("支付宝"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SeeImagePage(
                    image: CommonModel().hostUrl + dataInfo["alipay"],
                    type: "network",
                  )));
                },
                child: Container(
                  width: 89,
                  height: 89,
                  margin: EdgeInsets.only(left: 80),
                  child: dataInfo["alipay"] == null?null:Image.network(
                    CommonModel().hostUrl + dataInfo["alipay"],
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1, 
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["pay_type"], 
                onChanged: (value){
                  setState(() {
                    choosePayType("pay_type",value);
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("pay_type",1);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("微信"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SeeImagePage(
                    image: CommonModel().hostUrl + dataInfo["wechat"],
                    type: "network",
                  )));
                },
                child: Container(
                  width: 89,
                  height: 89,
                  margin: EdgeInsets.only(left: 80),
                  child: dataInfo["wechat"] == null ? null : Image.network(
                    CommonModel().hostUrl + dataInfo["wechat"],
                    fit: BoxFit.cover,
                  ),
                )
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 2,
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["pay_type"],
                onChanged: (value){
                  setState(() {
                    choosePayType("pay_type",value);
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("pay_type",2);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("银行卡"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    "${dataInfo["bank_name"]??"暂无银行卡"}${dataInfo["bank_number"]}",
                  )
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 3, 
                activeColor: Color.fromRGBO(223, 0, 0, 1),
                groupValue: formInfo["pay_type"], 
                onChanged: (value){
                  setState(() {
                    choosePayType("pay_type",value);
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    choosePayType("pay_type",3);
                  });
                },
                child: Container(
                  width: 60,
                  child: Text("数字钱包"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 40),
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    dataInfo["virtual"]??"",
                    maxLines: 2,
                  )
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget payImage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(13.5, 20, 0, 0),
            child: Text(
              "付款凭证",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(40, 40, 40, 1)
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  child: imgFile == null?
                    Image.asset("lib/assets/img_shangchuan@2x.png",fit: BoxFit.contain,):
                    Image.file(imgFile,fit: BoxFit.contain,),
                ),
              )
            ],
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
        base64Img = "data:image/png;base64," + baseImg;
      });
    }
  }

  Widget submitBtn() {
    return Container(
      margin: EdgeInsets.only(left: 37.5,right: 37.5,top: 40, bottom: 40),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(223, 0, 0, 1),
          Color.fromRGBO(244, 49, 49, 1)
        ])
      ),
      child: GestureDetector(
        child: Text(
          "提交订单",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.9,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: () {
          if(formInfo["amount"] == "0"){
            formInfo["amount"] = selfMoney;
          }
          formInfo["pay_voucher"] = base64Img??"";
          if(formInfo["money_type"] == 0 && formInfo["pay_voucher"] == ''){
            Toast.toast(context,msg: "支付凭证未上传");
          }else if(formInfo["money_type"] == 1 && num.parse(walletInfo["fortune_gold"]) < double.parse(formInfo["amount"])){
            Toast.toast(context,msg: "财富金不足!");
          }else if(formInfo["money_type"] == 2 && num.parse(walletInfo["reserve_fund"]) < double.parse(formInfo["amount"])){
            Toast.toast(context,msg: "储备金不足!");
          }else{
            if(formInfo["money_type"] == 0){
              //支付宝/微信/银行卡/数字资产
              formInfo = {
                "money_type": 0,
                "amount": formInfo["amount"],
                "pay_type": formInfo["pay_type"],
                "pay_voucher": formInfo["pay_voucher"],
              };
            }else{
              //财富金/储备金
              formInfo = {
                "money_type": formInfo["money_type"],
                "amount": formInfo["amount"],
              };
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder(formInfo:formInfo)));
          }
        },
      )
    );
  }
}