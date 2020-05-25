import 'package:flutter/material.dart';
import 'package:new_ldgj/loading.dart';
import 'package:new_ldgj/login/ForgetPwd.dart';
import 'package:new_ldgj/login/LoginCode.dart';
import 'package:new_ldgj/login/LoginHead.dart';
import 'package:new_ldgj/login/Registered.dart';
import 'package:new_ldgj/pages/Index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../ajax/request.dart';
import '../components/Toast.dart';
import '../common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPwdPage extends StatefulWidget {
  LoginPwdPage({Key key}) : super(key: key);

  @override
  _LoginPwdPageState createState() => _LoginPwdPageState();
}

class _LoginPwdPageState extends State<LoginPwdPage> {

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId");
    String token = prefs.getString("token");
    if(userId != null && token != null){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>IndexPage()));
    }
  }

  @override
  void initState() {
    
    checkToken();

    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);

    username = '';
    password = '';

    //监听用户名框的输入改变
    _userNameController.addListener((){
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }
    });
    super.initState();
  }
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var password = '';//用户名
  var username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮

  // 监听焦点
  Future _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  @override
  void dispose() { 
    username = '';
    password = '';
    super.dispose();
  }

  Widget _logoImageArea(){
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        "lib/assets/login_logo@2x.png",
        width: 100,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _inputTextArea() {
    return Container(
      margin: EdgeInsets.only(left: 38.5,right: 36.5),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "用户名/手机号",
                hintText: "请输入用户名或手机号",
                prefixIcon: Icon(Icons.person),
                suffixIcon:(_isShowClear) ?
                  IconButton(icon: Icon(Icons.clear),onPressed: (){_userNameController.clear();},)
                  : null ,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return '用户名不能为空';
                }
                return null;
              },
              onChanged: (String value){
                username = value;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              focusNode: _focusNodePassWord,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.https),
                suffixIcon: Container(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isShowPwd = !_isShowPwd;
                          });
                        },
                        child: Image.asset(_isShowPwd?"lib/assets/login_icon_xianshi@2x.png":"lib/assets/login_icon_yincang@2x.png"),
                      )),
                      Container(
                        width: 0.5,
                        height: 12.0,
                        margin: EdgeInsets.only(
                          left: 5,
                          right: 5
                        ),
                        color: Color.fromRGBO(40, 40, 40, 1),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPwdPage()));
                        },
                        child: Text("忘记密码"),
                      )
                    ],
                  ),
                )
              ),
              obscureText: !_isShowPwd,
              validator: (value) {
                if (value.isEmpty) {
                  return '密码不能为空';
                }
                return null;
              },
              //保存数据
              onSaved: (String value){
                password = value;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
      margin: EdgeInsets.only(left: 37.5,right: 37.5),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(226, 48, 48, 1),
          Color.fromRGBO(206, 0, 10, 1)
        ])
      ),
      child: ScopedModelDescendant<CommonModel>(
        builder: (BuildContext context, Widget child, CommonModel model){
          return GestureDetector(
            child: Text(
              "登录",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.9,
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            onTap: () async {
              //点击登录按钮，解除焦点，回收键盘
              _focusNodePassWord.unfocus();
              _focusNodeUserName.unfocus();
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                var res = await AjaxUtil().postHttp(context, 
                  '/homelogin',
                  data: {
                    "type": 1,
                    "name": username.trim(),
                    "password": password.trim()
                  }
                );
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
              }
            },
          );
        }
      )
    );
  }

  Widget _loginType() {
    return Container(
      padding: EdgeInsets.only(
        left: 38.5,
        right: 37
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginCodePage()));
            },
            child: Text("短信验证码登录"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginHead()));
            },
            child: Text("手势登录"),
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: ListView(
          children: <Widget>[
            SizedBox(height: 60),
            _logoImageArea(),
            SizedBox(height: 60),
            _inputTextArea(),
            SizedBox(height: 50),
            _loginBtn(),
            SizedBox(height: 30),
            _loginType(),
          ],
        ),
      )
    );
  }
}