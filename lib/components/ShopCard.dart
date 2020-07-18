/* 商品卡片 */
import 'package:flutter/material.dart';

class ShopCardWidget extends StatelessWidget {
  const ShopCardWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 40) / 2,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 215,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Image.asset(
              "assets/img_02@2x.png",
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "碧色Bedtder18K金铂金情 侣求婚结婚钻石戒指克拉",
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 13),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: "￥",
                    style: TextStyle(fontSize: 12, color: Colors.red)),
                TextSpan(
                    text: "1,680",
                    style: TextStyle(fontSize: 16, color: Colors.red))
              ])),
              Text("30人付款",
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(122, 122, 122, 1)))
            ],
          )
        ],
      ),
    );
  }
}
