import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/models/user_detail_model.dart';
import 'package:skripsi_budiberas_9701/models/user_model.dart';
import 'package:skripsi_budiberas_9701/services/user_detail_service.dart';

import '../services/address_management_service.dart';


class UserDetailProvider with ChangeNotifier{
  UserDetailModel? _defaultUserDetail;

  UserDetailModel? get defaultUserDetail => _defaultUserDetail;

  set defaultUserDetail(UserDetailModel? value) {
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
  UserModel? _user;

  set user(UserModel? userVal) {
    _user = userVal;
    notifyListeners();
  }

  //============================================================================
  Future<void> getDefaultDetailUser() async {
    loading = true;
    try {
      UserDetailModel userDetail = await UserDetailService().getDefaultDetailUser(
        token: _user!.token!,
      );
      _defaultUserDetail = userDetail;
    }catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }

  //get all detail user for address management or setting profile
  Future<void> getAllDetailUser() async {
    loadingAll = true;
    try {
      List<UserDetailModel> userDetail = await UserDetailService().getAllDetailUser(token: _user!.token!,);
      _listUserDetail = userDetail;
    }catch(e) {
      print(e);
    }
    loadingAll = false;
    notifyListeners();
  }

  //============================ ADDRESS MANAGEMENT ============================
  bool loadingAddAddress = false;

  int selectedValue = 0;
  void changeDefaultVal(int value) {
    // if(value == 0) {
    //   selectedValue = 0;
    // } else {
    //   selectedValue = 1;
    // }
    selectedValue = value;
    notifyListeners();
  }

  initDefaultValInEdit(int value) {
    selectedValue = value;
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
    loadingAddAddress = true;
    try {
      if(await AddressManagementService().createNewAddress(
          token: _user!.token!,
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
        loadingAddAddress = false;
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

  Future<bool> updateAddress({
    required int id,
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
    try {
      if(await AddressManagementService().updateAddress(
          id: id,
          token: _user!.token!,
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
        var _editedAddress = _listUserDetail.where((e) => e.id == id).first;
        _editedAddress.addressOwner = addressOwner;
        _editedAddress.regency = regency;
        _editedAddress.district = district;
        _editedAddress.address = address;
        _editedAddress.addressNotes = addressNotes;
        _editedAddress.latitude = latitude;
        _editedAddress.longitude = longitude;
        _editedAddress.phoneNumber = phoneNumber;
        _editedAddress.defaultAddress = defaultAddress;
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

  Future<bool> deleteAddress({
    required int id,
  }) async{
    try {
      if(await AddressManagementService().deleteAddress(
        id: id,
        token: _user!.token!,
      )) {
        _listUserDetail.removeWhere((e) => e.id == id);
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