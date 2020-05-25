import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ldgj/components/Toast.dart';
import '../components/BottomNavBar.dart';

import 'Find.dart';
import 'Home.dart';
import 'Mine.dart';
import 'Shop.dart';

class IndexPage extends StatefulWidget {
  final int pageIndex;
  IndexPage({Key key,this.pageIndex}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex;
  DateTime lastPopTime;

  @override
  void initState() {
    currentIndex = widget.pageIndex == null?0:widget.pageIndex;
    super.initState();
  }

  var listArr = [
    HomePage(),
    ShopPage(),
    FindPage(),
    MinePage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: listArr[currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          bottomClick: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ), 
      onWillPop: () async {
        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
          lastPopTime = DateTime.now();
          Toast.toast(context,msg: '再按一次退出');
        }else{
          lastPopTime = DateTime.now();
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      }
    );
  }
}