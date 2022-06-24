import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/models/user_model.dart';
import 'package:skripsi_budiberas_9701/services/user_detail_service.dart';


class UserDetailProvider with ChangeNotifier{
  late UserDetailModel _userDetail;
  bool loading = false;

  UserDetailModel get userDetail => _userDetail;

  set userDetail(UserDetailModel value) {
    _userDetail = value;
    notifyListeners();
  }

  late UserModel _user;

  set user(UserModel userVal) {
    _user = userVal;
    notifyListeners();
  }

  Future<void> getDefaultDetailUser() async {
    loading = true;
    try {
      UserDetailModel userDetail = await UserDetailService().getDefaultDetailUser(
        token: _user.token!,
      );
      _userDetail = userDetail;
    }catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }
}