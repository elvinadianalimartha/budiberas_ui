import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/address_management_service.dart';

import '../models/user_model.dart';

class AddressManagementProvider with ChangeNotifier{
  //untuk set token user di change notifier proxy provider
  late UserModel _user;

  set user(UserModel userVal) {
    _user = userVal;
    notifyListeners();
  }

  bool loadingAdd = false;

  int selectedValue = 0;
  void changeDefaultVal(int value) {
    if(value == 0) {
      selectedValue = 0;
    } else {
      selectedValue = 1;
    }
    notifyListeners();
  }

  Future<bool> createNewAddress({
    required String addressOwner,
    required String regency,
    required String district,
    required String address,
    String? addressNotes,
    required double latitude,
    required double longitude,
    required String phoneNumber,
    required int defaultAddress,
  }) async{
    loadingAdd = true;
    try {
      if(await AddressManagementService().createNewAddress(
          token: _user.token!,
          addressOwner: addressOwner,
          regency: regency,
          district: district,
          address: address,
          addressNotes: addressNotes,
          latitude: latitude,
          longitude: longitude,
          phoneNumber: phoneNumber,
          defaultAddress: defaultAddress)
      ) {
        loadingAdd = false;
        notifyListeners();
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