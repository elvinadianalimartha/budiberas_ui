import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:skripsi_budiberas_9701/models/regency_district_model.dart';

import '../models/address_suggestion_model.dart';

class RegencyService {
  String baseUrl = constants.baseUrl;

  Future<List<RegencyModel>> getLocalRegencies() async {
    var url = '$baseUrl/localRegencies';

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    List result = jsonDecode(response.body);

    List<RegencyModel> regencies = [];
    for(var item in result) {
      regencies.add(RegencyModel.fromJson(item));
    }

    return regencies;
  }
}

class DistrictService {
  String baseUrl = constants.baseUrl;

  Future<List<DistrictModel>> getDistrictsByRegency(String regencyName) async {
    var url = '$baseUrl/localDistricts';

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    Map<String, dynamic> qParams = {
      'regency_name': regencyName
    };

    var response = await http.get(
        Uri.parse(url).replace(queryParameters: qParams),
        headers: headers
    );

    print(response.body);

    List result = jsonDecode(response.body);

    List<DistrictModel> districts = [];
    for(var item in result) {
      districts.add(DistrictModel.fromJson(item));
    }

    return districts;
  }
}

//get address data from Nominatim API
class PlaceApi{
  Future<List<AddressSuggestionModel>> fetchSuggestions(String input) async {
    var request = constants.mapUrl + '/search?format=json&state=daerah%istimewa%yogyakarta&city=$input&street=jalan';

    var response = await http.get(
      Uri.parse(request),
    );

    print(response.body);

    List data = jsonDecode(response.body);

    List<AddressSuggestionModel> listAddress = [];
    for(var item in data) {
      listAddress.add(AddressSuggestionModel.fromJson(item));
    }

    return listAddress;
  }

  Future<AddressSuggestionModel> reverseGeocode(double lat, double lon) async {
    var request = constants.mapUrl + '/reverse?lat=$lat&lon=$lon&format=json';

    var response = await http.get(
      Uri.parse(request),
    );

    print(response.body);

    var data = jsonDecode(response.body);
    AddressSuggestionModel address = AddressSuggestionModel.fromJson(data);

    return address;
  }
}