import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/views/mine/DigitalAssets.dart';
import 'package:new_ldgj/views/mine/MathMoney.dart';
import 'package:new_ldgj/views/mine/MyAlPay.dart';
import 'package:new_ldgj/views/mine/MyCard.dart';
import 'package:new_ldgj/views/mine/MyWechat.dart';
import 'package:new_ldgj/views/mine/ReserveDetail.dart';
import 'package:new_ldgj/views/mine/WealthAccount.dart';

class MyAssetsPage extends StatefulWidget {
  MyAssetsPage({Key key}) : super(key: key);

  @override
  _MyAssetsPageState createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    getFortuneGold();
    getDigitalAssets();
    getReserveInfo();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  dynamic fortuneGoldData = {};
  dynamic digitalAssetsData = {};
  dynamic reserveInfoData = {};

  //财富账户
  getFortuneGold() async{
    dynamic res = await AjaxUtil().getHttp(context, '/fortuneGold');
    if(res["code"] == 200){
      setState(() {
        fortuneGoldData["usableMoney"] = res["data"]["usableMoney"];
        fortuneGoldData["totalMoney"] = res["data"]["totalMoney"];
        fortuneGoldData["totalWithdraw"] = res["data"]["totalWithdraw"];
      });
    }
  }

  //数字资产
  getDigitalAssets() async {
    var res = await AjaxUtil().getHttp(context, '/digitalAssets');
    if(res["code"] == 200){
      setState(() {
        digitalAssetsData["digital_assets"] = res["data"]["digital_assets"];
      });
    }
  }

  //储备账户信息
  getReserveInfo() async {
    dynamic res = await AjaxUtil().getHttp(context, '/reserveInfo');
    if(res["code"] == 200){
      setState(() {
        reserveInfoData["usableMoney"] = res["data"]["usableMoney"];
        reserveInfoData["totalMoney"] = res["data"]["totalMoney"];
        reserveInfoData["coldMoney"] = res["data"]["coldMoney"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "我的资产",
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
            controller: tabController,
            labelColor: Color.fromRGBO(181, 5, 24, 1),
            unselectedLabelColor: Colors.grey[500],
            indicatorColor: Color.fromRGBO(181, 5, 24, 1),
            indicatorWeight: 1.5,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 10.0),
            tabs: [
              Tab(text: '财富账户'),
              Tab(text: '储备账户'),
              Tab(text: '数字资产'),
            ]),
      ),
      body: TabBarView(controller: tabController, children: [
        financialAccount(),
        reserveAccount(),
        digitalAssets(),
      ]),
    );
  }

  Widget payType() {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardPage()));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 13, right: 17),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 22,
                    margin: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      "lib/assets/icon_yinhangka@2x.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "银行卡",
                    style: TextStyle(fontSize: 15),
                  )),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAlPayPage()));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 13, right: 17),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 22,
                    margin: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      "lib/assets/icon_zhifubao@2x.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "支付宝",
                    style: TextStyle(fontSize: 15),
                  )),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyWechatPage()));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 13, right: 17),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 22,
                    margin: EdgeInsets.only(right: 15),
                    child: Image.asset(
                      "lib/assets/icon_weixin@2x.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "微信",
                    style: TextStyle(fontSize: 15),
                  )),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MathMoneyPage()));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 13, right: 17),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 22,
                    margin: EdgeInsets.only(right: 15),
                    child: Icon(Icons.account_balance_wallet),
                  ),
                  Expanded(
                      child: Text(
                    "数字资产",
                    style: TextStyle(fontSize: 15),
                  )),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* 财务账户 */
  Widget financialAccount() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              child: Container(
                height: 175,
                padding: EdgeInsets.fromLTRB(13.5, 45.5, 13.5, 13.5),
                margin: EdgeInsets.fromLTRB(13, 5, 13, 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("lib/assets/img_qianbao@2x.png"))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            fortuneGoldData["totalMoney"] != null?"${fortuneGoldData["totalMoney"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text("累计获得(元)",
                              style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            fortuneGoldData["usableMoney"] != null?"${fortuneGoldData["usableMoney"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text("可用余额(元)",
                              style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          fortuneGoldData["totalWithdraw"] != null?"${fortuneGoldData["totalWithdraw"]}":'0.00',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text("累计提现(元)",
                            style: TextStyle(color: Colors.white, fontSize: 13))
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator
                    .push(context, MaterialPageRoute(builder: (context)=>WealthAccountPage()))
                    .then((data){
                      getFortuneGold();
                    });
                },
                child: Container(
                    width: 70,
                    height: 25,
                    padding: EdgeInsets.only(left: 15),
                    margin: EdgeInsets.only(right: 13, top: 20),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 144, 143, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.5),
                            bottomLeft: Radius.circular(12.5))),
                    child: Text(
                      "查看明细>",
                      style: TextStyle(
                          height: 2, fontSize: 10, color: Colors.white),
                    )
                  ),
              )
            )
          ],
        ),
        payType(),
        commonImage()
      ],
    );
  }

  /*  储蓄账户 */
  Widget reserveAccount() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              child: Container(
                height: 175,
                padding: EdgeInsets.fromLTRB(13.5, 45.5, 13.5, 13.5),
                margin: EdgeInsets.fromLTRB(13, 5, 13, 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("lib/assets/img_qianbao@2x.png"))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            reserveInfoData["totalMoney"] != null?"${reserveInfoData["totalMoney"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text("累计获得(元)",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            reserveInfoData["usableMoney"] != null?"${reserveInfoData["usableMoney"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text("可用储备金(元)",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          reserveInfoData["coldMoney"] != null?"${reserveInfoData["coldMoney"]}":'0.00',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text("冻结储备金(元)",
                            style: TextStyle(color: Colors.white, fontSize: 13))
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReserveDetailPage()));
                },
                child: Container(
                    width: 70,
                    height: 25,
                    padding: EdgeInsets.only(left: 15),
                    margin: EdgeInsets.only(right: 13, top: 20),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 144, 143, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.5),
                            bottomLeft: Radius.circular(12.5))),
                    child: Text(
                      "查看明细>",
                      style: TextStyle(
                          height: 2, fontSize: 10, color: Colors.white),
                    )
                  ),
              )
            )
          ],
        ),
        payType(),
        commonImage()
      ],
    );
  }

  /* 数字资产 */
  Widget digitalAssets() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              child: Container(
                height: 175,
                padding: EdgeInsets.all(13.5),
                margin: EdgeInsets.fromLTRB(13, 5, 13, 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("lib/assets/img_qianbao@2x.png"))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                          digitalAssetsData["digital_assets"] != null?"${digitalAssetsData["digital_assets"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text("资产总额(元)",
                              style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            digitalAssetsData["digital_assets"] != null?"${digitalAssetsData["digital_assets"]}":'0.00',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text("资产价值(元)",
                              style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator
                  .push(context, MaterialPageRoute(builder: (context)=>DigitalAsetsPage()))
                  .then((data){getDigitalAssets();});
                },
                child: Container(
                    width: 70,
                    height: 25,
                    padding: EdgeInsets.only(left: 15),
                    margin: EdgeInsets.only(right: 13, top: 20),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 144, 143, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.5),
                            bottomLeft: Radius.circular(12.5))),
                    child: Text(
                      "查看明细>",
                      style: TextStyle(
                          height: 2, fontSize: 10, color: Colors.white),
                    )
                  ),
              )
            )
          ],
        ),
        payType(),
        commonImage()
      ],
    );
  }

  Widget commonImage() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          "lib/assets/img_001@2x.png",
        ),
      ),
    );
  }
}
