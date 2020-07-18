import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:new_ldgj/common/common.dart';
import 'package:new_ldgj/login/LoginPwd.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp(
  model: CommonModel(),
));

class MyApp extends StatelessWidget {
  final CommonModel model;
 
  const MyApp({Key key,@required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: ScopedModel(
        model: model, 
        child: MaterialApp(
          title: "汉威资本",
          navigatorObservers: [BotToastNavigatorObserver()],
          home: LoginPwdPage(),
        )
      )
    );
  }
}
