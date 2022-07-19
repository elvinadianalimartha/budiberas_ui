import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';

class TransactionService {
  String baseUrl = constants.baseUrl;

  Future<List<TransactionModel>> getTransactionHistory({
    required String token,
  }) async {
    var url = '$baseUrl/transactions';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<TransactionModel> transactions = [];

      for(var item in data) {
        transactions.add(TransactionModel.fromJson(item));
      }

      return transactions;
    } else {
      throw Exception('Gagal checkout');
    }
  }

  Future<UserDetailModel> getOrderReceiver({
    required String token,
    required int userDetailId,
  }) async {
    var url = '$baseUrl/receiver/$userDetailId';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserDetailModel orderReceiver = UserDetailModel.fromJson(data);
      return orderReceiver;
    } else {
      throw Exception('Gagal mengambhil data penerima pesanan');
    }
  }
}