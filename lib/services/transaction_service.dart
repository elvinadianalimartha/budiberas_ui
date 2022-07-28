import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';

class TransactionService {
  String baseUrl = constants.baseUrl;

  Future<List<TransactionModel>> getTransactionHistory({
    required String token,
    String? searchQuery
  }) async {
    var url = '$baseUrl/transactions';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    Map<String, dynamic> qParams = {
      'searchQuery': searchQuery?.toLowerCase(),
    };

    var response = await http.get(
      Uri.parse(url).replace(queryParameters: qParams),
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
      throw Exception('Gagal mengambil histori transaksi');
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
      throw Exception('Gagal mengambil data penerima pesanan');
    }
  }

  Future<bool> checkPickupCode({
    required int transactionId,
    required String inputCode,
  }) async {
    var url = '$baseUrl/checkPickupCode/$transactionId';
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'pickup_code': inputCode,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Kode pengambilan yang dimasukkan keliru');
    }
  }

  Future<bool> updateStatus({
    required int transactionId,
    required String newStatus,
  }) async {
    var url = '$baseUrl/updateStatus/$transactionId';

    var headers = {
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      'status': newStatus,
    });

    var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Status transaksi gagal diperbarui');
    }
  }
}