import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/models/address_suggestion_model.dart';
import 'package:skripsi_budiberas_9701/models/regency_district_model.dart';
import 'package:skripsi_budiberas_9701/services/places_service.dart';

class PlacesProvider with ChangeNotifier {
  List<RegencyModel> _regencies = [];

  List<RegencyModel> get regencies => _regencies;

  set regencies(List<RegencyModel> value) {
    _regencies = value;
    notifyListeners();
  }

  bool loadingRegencies = false;

  Future<void> getLocalRegencies() async{
    loadingRegencies = true;
    try {
      List<RegencyModel> regencies = await RegencyService().getLocalRegencies();
      _regencies = regencies;
    } catch (e) {
      print(e);
    }
    loadingRegencies = false;
    notifyListeners();
  }

  //============================================================================

  List<DistrictModel> _districts = [];

  List<DistrictModel> get districts => _districts;

  set districts(List<DistrictModel> value) {
    _districts = value;
    notifyListeners();
  }
  bool loadingDistricts = false;

  Future<void> getDistrictsByRegency(String regencyName) async{
    loadingDistricts = true;
    try {
      List<DistrictModel> districts = await DistrictService().getDistrictsByRegency(regencyName);
      _districts = districts;
    } catch (e) {
      print(e);
    }
    loadingDistricts = false;
    notifyListeners();
  }

  //============================================================================
  List<AddressSuggestionModel> _addressSuggestions = [];

  List<AddressSuggestionModel> get addressSuggestions => _addressSuggestions;

  set addressSuggestions(List<AddressSuggestionModel> value) {
    _addressSuggestions = value;
    notifyListeners();
  }

  bool loadSuggestions = false;

  Future<void> getAddressSuggestions(String inputDistrict) async {
    loadSuggestions = true;
    try {
      List<AddressSuggestionModel> suggestions = await PlaceApi().fetchSuggestions(inputDistrict);
      _addressSuggestions = suggestions;
    } catch (e) {
      print(e);
    }
    loadSuggestions = false;
    notifyListeners();
  }

  //=================== DISPOSE ================================================
  disposeInputAddress() {
    _districts = [];
    _addressSuggestions = [];
  }
}