/* 搜索框 */
import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 10),
      margin: EdgeInsets.fromLTRB(14.5, 10, 14.5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search,size: 16,),
          Expanded(
            child: Text("请输入搜索内容"),
          ),
          GestureDetector(
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Color.fromRGBO(223, 122, 132, 1),
                borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
              ),
              child: Text("搜索",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  height: 1.8
                ),
              ),
            )
          )
        ],
      )
    );
  }
}