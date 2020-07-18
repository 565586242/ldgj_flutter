import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_ldgj/ajax/request.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/components/Toast.dart';
import 'package:new_ldgj/loading.dart';
import 'package:new_ldgj/login/LoginCode.dart';
import 'package:new_ldgj/login/LoginPwd.dart';
import 'package:new_ldgj/login/Registered.dart';
import 'package:new_ldgj/pubComponents/gesture_password.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHead extends StatefulWidget {
  LoginHead({Key key}) : super(key: key);

  @override
  _LoginHeadState createState() => _LoginHeadState();
}

class _LoginHeadState extends State<LoginHead> {

  @override
  void initState() { 
    headPassword = '';
    //监听用户名框的输入改变
    _userPhoneController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userPhoneController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
    });
    super.initState();
  }

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userPhoneController = new TextEditingController();
  FocusNode _focusNodeUserPhone = new FocusNode();
  var userphone; //手机号
  var headPassword;  //手势密码
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  Widget _logoImageArea() {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/login_logo@2x.png",
        width: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _inputTextArea() {
    return Container(
      key: _formKey,
      padding: EdgeInsets.only(
        left: 38.5,
        right: 36.5
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userPhoneController,
              validator: (value) {
                if (value.isEmpty) {
                  return '手机号不能为空';
                }else if(value.trim().length<11){
                  return '手机号长度不正确';
                }
                return null;
              },
              focusNode: _focusNodeUserPhone,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_android),
                labelText: "手机号",
                hintText: "请输入手机号",
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _userPhoneController.clear();
                        },
                      )
                    : null,
              ),
              onChanged: (String value) {
                userphone = value;
              },
            )
          ],
        )
      ),
    );
  }

  Widget _headView() {
    return ScopedModelDescendant<CommonModel>(
      builder: (BuildContext context, Widget child, CommonModel model){
        return GesturePassword(
          showLineTimer: 0.5,
          attribute: ItemAttribute(
            smallCircleR: 20.0,
            bigCircleR: 40.0,
            selectedColor: Colors.redAccent,
            normalColor: Colors.grey[500],
            lineStrokeWidth: 15.0,
            circleStrokeWidth: 6.0,
          ),
          successCallback: (pwd) async {
            headPassword = pwd;
            var res = await AjaxUtil().postHttp(context, '/homelogin',data: {
              "type": 3,
              "phone": userphone,
              "password": headPassword
            });
            if(res["code"] == 200){
              final prefs = await SharedPreferences.getInstance();
              Toast.toast(context,msg:res["msg"]);
              final setTokenResult = await prefs.setString('token', res["data"]['token']);
              final setUserIdResult = await prefs.setInt('userId', res["data"]['user']["id"]);
              if(res["data"]["user"] != null){
                model.setUserInfo(res["data"]["user"]);
              }
              if(setTokenResult && setUserIdResult){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoadingPage()));
              }
            }else{
              Toast.toast(context,msg:res["msg"]);
            }
          },
          failCallback: () {
            Toast.toast(context,msg: "手势密码最少设置4个点");
          },
        );
      }
    );
  }

  Widget _loginType() {
    return Container(
      padding: EdgeInsets.only(left: 38.5, right: 37),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginCodePage()));
            },
            child: Text("短信验证登录"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPwdPage()));
            },
            child: Text("密码登录"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
            },
            child: Text("立即注册>"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _focusNodeUserPhone.unfocus();
        },
        child: Column(
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(60)),
            _logoImageArea(),
            SizedBox(height: ScreenUtil().setHeight(60)),
            _inputTextArea(),
            SizedBox(height: ScreenUtil().setHeight(20)),
            _headView(),
            SizedBox(height: ScreenUtil().setHeight(20)),
            _loginType()
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}