import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:http/http.dart' as http;

class UserDetailService {
  String baseUrl = constants.baseUrl;

  Future<UserDetailModel> getDefaultDetailUser({
    required String token,
  }) async {
    var url = '$baseUrl/detailUserDefault';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'][0];
      UserDetailModel userDetail = UserDetailModel.fromJson(data);
      return userDetail;
    } else {
      throw Exception('Gagal ambil default detail user!');
    }
  }

  Future<List<UserDetailModel>> getAllDetailUser({
    required String token,
  }) async {
    var url = '$baseUrl/allDetailUser';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      List<UserDetailModel> details = [];

      for(var item in data) {
        details.add(UserDetailModel.fromJson(item));
      }
      return details;
    } else {
      throw Exception('Gagal ambil list detail user!');
    }
  }
}