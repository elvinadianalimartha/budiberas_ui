import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/models/transaction_model.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/services/transaction_service.dart';

import '../models/user_model.dart';

class TransactionProvider with ChangeNotifier{
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  bool loadingGetData = false;

  set carts(List<TransactionModel> value) {
    _transactions = value;
    notifyListeners();
  }

  late UserModel _user;

  set user(UserModel userVal) {
    _user = userVal;
    notifyListeners();
  }

  Future<void> getTransactionHistory() async{
    loadingGetData = true;
    try {
      List<TransactionModel> transactions = await TransactionService().getTransactionHistory(token: _user.token!);
      _transactions = transactions;
    } catch (e) {
      print(e);
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

  bool loadingReceiver = false;

  Future<void> getOrderReceiver(int userDetailId) async{
    loadingReceiver = true;
    try {
      UserDetailModel receiver = await TransactionService().getOrderReceiver(token: _user.token!, userDetailId: userDetailId);
      _orderReceiver = receiver;
    } catch (e) {
      print(e);
    }
    loadingReceiver = false;
    notifyListeners();
  }

  disposeOrderReceiver() {
    _orderReceiver = null;
  }
}