import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_ldgj/login/LoginPwd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/common.dart';


class AjaxUtil {
  static BaseOptions options = BaseOptions(
    connectTimeout: 10000,
    receiveTimeout: 5000,
    baseUrl: CommonModel().hostUrl,
    contentType: "application/x-www-form-urlencoded",
  );

  static Dio dio = Dio(options);

  /* get请求 */
  getHttp(context, url, {data}) async {
    BotToast.showLoading();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print(token);
    var res;
    try {
      res =  await dio.get(
        url, 
        queryParameters: data, 
        options: Options(
          headers: {
            "token": token
          }
        ),
      );
      BotToast.closeAllLoading();
    } on DioError catch (e) {
      print(e);
      BotToast.closeAllLoading();
    }
    if(res.data["code"] == 1){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("userId"); //删除指定键
      prefs.remove("token"); //删除指定键
      prefs.clear();//清空键值对
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPwdPage()));
    }
    return res.data;
    
  }

  postHttp(context, url,{data}) async {
    BotToast.showLoading();
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var res;
    try {
      res = await dio.post(
        url, 
        data: data,
        options: Options(
          headers: {
            "token": token
          }
        )
      );
      BotToast.closeAllLoading();
    } on DioError catch (e) {
      BotToast.closeAllLoading();
      print("$e");
    }
    BotToast.closeAllLoading();
    if(res.data["code"] == 1){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("userId"); //删除指定键
      prefs.remove("token"); //删除指定键
      prefs.clear();//清空键值对
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPwdPage()));
    }
    return res.data;
  }
}