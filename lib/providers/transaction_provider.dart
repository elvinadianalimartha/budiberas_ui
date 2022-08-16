import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/services/transaction_service.dart';

import '../models/user_model.dart';

class TransactionProvider with ChangeNotifier{
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  set transactions(List<TransactionModel> value) {
    _transactions = value;
    notifyListeners();
  }

  bool loadingGetData = false;

  set carts(List<TransactionModel> value) {
    _transactions = value;
    notifyListeners();
  }

  UserModel? _user;

  set user(UserModel? userVal) {
    _user = userVal;
    notifyListeners();
  }

  Future<void> getTransactionHistory({
    String? searchQuery
  }) async{
    loadingGetData = true;
    try {
      List<TransactionModel> transactions = await TransactionService().getTransactionHistory(token: _user!.token!, searchQuery: searchQuery);
      _transactions = transactions;
    } catch (e) {
      print(e);
      _transactions = [];
    }
    loadingGetData = false;
    notifyListeners();
  }

  UserDetailModel? _orderReceiver;

  UserDetailModel? get orderReceiver => _orderReceiver;

  set orderReceiver(UserDetailModel? value) {
    _orderReceiver = value;
    notifyListeners();
  }

  Future<void> pusherTransactionHistory() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('transaction-status');

    pusher.onConnectionStateChange((state) {
      print('previousState: ${state!.previousState}, currentState: ${state.currentState}');
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    channel.bind('App\\Events\\TransStatusUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      //update data status sesuai dgn id yg dituju
      _transactions.where((e) => e.id == int.parse(data['transId'].toString())).first.transactionStatus = data['status'];
      notifyListeners();
    });
  }

  bool loadingReceiver = false;

  Future<void> getOrderReceiver(int userDetailId) async{
    loadingReceiver = true;
    try {
      UserDetailModel receiver = await TransactionService().getOrderReceiver(token: _user!.token!, userDetailId: userDetailId);
      _orderReceiver = receiver;
    } catch (e) {
      print(e);
    }
    loadingReceiver = false;
    notifyListeners();
  }

  Future<bool> checkPickupCode({
    required int transactionId,
    required String inputCode,
  }) async {
    try {
      if(await TransactionService().checkPickupCode(token: _user!.token!, transactionId: transactionId, inputCode: inputCode)){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateStatusTransaction({
    required int id,
    required String newStatus,
  }) async {
    try {
      if(await TransactionService().updateStatus(token: _user!.token!, transactionId: id, newStatus: newStatus)) {
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