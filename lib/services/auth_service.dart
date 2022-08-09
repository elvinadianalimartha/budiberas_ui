import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

class AuthService{
  String baseUrl = constants.baseUrl + '/user';

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String fcmToken,
    required String regency,
    required String district,
    required String address,
    String? addressNotes,
    required double latitude,
    required double longitude,
    required String phoneNumber,
  }) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
      'regency': regency,
      'district': district,
      'address': address,
      'address_notes': addressNotes,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber
    }); //utk kirim data harus di-encode dulu
    
    var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200){
      return true;
    } else {
      throw Exception('Gagal registrasi!');
    }
  }

  Future<UserModel> login({
    String? email,
    String? password
  }) async {

    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    }); //utk kirim data harus di-encode dulu

    var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('Gagal login!');
    }
  }

  Future<bool> logout(String token) async {
    var url = '$baseUrl/logout';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal logout!');
    }
  }

  Future<UserModel> fetchDataUser({
    required String token,
  }) async {

    var url = '$baseUrl/fetchData';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      user.token = token;

      return user;
    } else {
      throw Exception('Gagal ambil data user!');
    }
  }
}