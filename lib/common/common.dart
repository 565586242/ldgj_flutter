import 'package:scoped_model/scoped_model.dart';

class CommonModel extends Model{
  String _hostUrl = "http://ldgj.gfcvip168.com/";
  /* String _hostUrl = "http://www.ldgj1699.com/"; */
  Map<String,dynamic> _userInfo;  //userInfo

  String get hostUrl => _hostUrl;
  Map<String,dynamic> get userInfo => _userInfo;

  void setUserInfo(data) {
    _userInfo = data;

    notifyListeners();
  }
}