import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final currentIndex;
  final bottomClick;
  BottomNavBar({Key key,this.currentIndex,this.bottomClick}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      selectedItemColor: Color.fromRGBO(223, 0, 0, 1),
      onTap: (currentIndex) {
        widget.bottomClick(currentIndex);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("首页")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_grocery_store),
          title: Text("商圈")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text("发现")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("我的")
        )
      ]
    );
  }
}