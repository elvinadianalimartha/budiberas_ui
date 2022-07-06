import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/models/user_model.dart';
import 'package:skripsi_budiberas_9701/services/user_detail_service.dart';


class UserDetailProvider with ChangeNotifier{
  late UserDetailModel _defaultUserDetail;

  UserDetailModel get defaultUserDetail => _defaultUserDetail;

  set defaultUserDetail(UserDetailModel value) {
    _defaultUserDetail = value;
    notifyListeners();
  }

  //============================================================================

  List<UserDetailModel> _listUserDetail = [];

  List<UserDetailModel> get listUserDetail => _listUserDetail;

  set listUserDetail(List<UserDetailModel> value) {
    _listUserDetail = value;
    notifyListeners();
  }

  //============================================================================

  bool loading = false;
  bool loadingAll = false;

  //============================================================================

  //untuk set token user di change notifier proxy provider
  //(krn ini ambil data user detail berdasarkan token user)
  late UserModel _user;

  set user(UserModel userVal) {
    _user = userVal;
    notifyListeners();
  }

  //============================================================================
  Future<void> getDefaultDetailUser() async {
    loading = true;
    try {
      UserDetailModel userDetail = await UserDetailService().getDefaultDetailUser(
        token: _user.token!,
      );
      _defaultUserDetail = userDetail;
    }catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }

  //get all detail user for address management
  Future<void> getAllDetailUser() async {
    loadingAll = true;
    try {
      List<UserDetailModel> userDetail = await UserDetailService().getAllDetailUser(token: _user.token!,);
      _listUserDetail = userDetail;
    }catch(e) {
      print(e);
    }
    loadingAll = false;
    notifyListeners();
  }
}