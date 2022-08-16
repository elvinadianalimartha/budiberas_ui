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
    required String name,
    required String email,
    required String password,
    required String regency,
    required String district,
    required String address,
    String? addressNotes,
    required double latitude,
    required double longitude,
    required String phoneNumber,
  }) async {
    try {
     if(await AuthService().register(
       name: name,
       email: email,
       password: password,
       regency: regency,
       district: district,
       address: address,
       addressNotes: addressNotes,
       latitude: latitude,
       longitude: longitude,
       phoneNumber: phoneNumber,
     )) {
       return true; //berhasil mendaftar
     } else {
       return false;
     }
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
      notifyListeners();
      return true; //berhasil login
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateFcmToken({
    required String token,
    required int userId,
    required String fcmToken,
  }) async {
    try {
      if(await AuthService().updateFcmToken(
        token: token,
        userId: userId,
        fcmToken: fcmToken,
      )) {
        return true;
      } else {
        return false;
      }
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

  Future<void> fetchDataUser(String token) async {
    try {
      UserModel user = await AuthService().fetchDataUser(
        token: token,
      );
      _user = user; //berhasil fetch data by token yg disimpan di shared pref
    }catch(e) {
      print(e);
    }
  }
}