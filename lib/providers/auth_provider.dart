import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier{
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register({
    String? name,
    String? email,
    String? password
  }) async {
    try {
      UserModel user = await AuthService().register(
        name: name,
        email: email,
        password: password,
      );
      _user = user;
      return true; //berhasil mendaftar
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    String? email,
    String? password
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );
      _user = user;
      return true; //berhasil login
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout(String token) async {
    try {
      if(await AuthService().logout(token)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}