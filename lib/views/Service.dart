import 'package:flutter/material.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/views/ServiceDetail.dart';

class ServicePage extends StatefulWidget {
  ServicePage({Key key}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List servicelist = [];

  @override
  void initState() {
    super.initState();
    homeservice();
  }

  homeservice() async {
    var res = await AjaxUtil().getHttp(context, '/homeservice');
    if(res["code"] == 200){
      setState(() {
        servicelist = res["data"];
      });
    }else{
      Toast.toast(context,msg: res["msg"]);
    }
  }

  Widget _servicePage() {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 170/210,
        ),
        itemCount: servicelist.length,
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceDetailPage(
                pId: servicelist[index]["id"],
                url: CommonModel().hostUrl + servicelist[index]['service_cover'],
                type: servicelist[index]["type"]
              )));
            },
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: AspectRatio(
                      aspectRatio: 698 / 380,
                      child: servicelist[index]["type"] == 1?Image.network(
                        CommonModel().hostUrl + servicelist[index]['service_cover'],
                        fit: BoxFit.cover,
                      ): Stack(
                        children: <Widget>[
                          Align(
                            child: servicelist[index]['video_cover'] == null?Container():Image.network(
                              CommonModel().hostUrl + servicelist[index]['video_cover'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 48,
                              height: 48,
                              child: Image.asset("assets/icon_zanting@2x.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 8.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          servicelist[index]["service_title"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(40, 40, 40, 1)),
                        ),
                        Container(
                          height: 40,
                          child: Text(
                            servicelist[index]["service_content"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            child: Row(
                          children: <Widget>[
                            Expanded(child: Text("查看详情")),
                            Image.asset(
                              "assets/icon_xiayiye03@2x.png",
                              width: 10,
                            )
                          ],
                        ))
                      ],
                    )
                  )
                ],
              ),
            ),
          );
        }
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
        title: Text("文 化"),
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
      body: _servicePage(),
    );
  }
}
