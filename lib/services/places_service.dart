import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:skripsi_budiberas_9701/models/regency_district_model.dart';

import '../models/address_suggestion_model.dart';

class GetCoordinateGeocoding {
  late double latitude, longitude;
  getCoordinate(String input) async {
    List<Location> locations = await locationFromAddress(input);
    for (var location in locations) {
      latitude = location.latitude;
      longitude = location.longitude;
    }
    print(latitude);
    print(longitude);
    return {longitude, latitude};
  }
}

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

  Future<List<DistrictModel>> getDistrictsByRegency(int regencyId) async {
    var url = '$baseUrl/localDistricts/$regencyId';

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
    var request = 'https://nominatim.openstreetmap.org/search?format=json&state=daerah%istimewa%yogyakarta&city=$input&street=jalan';

    var response = await http.get(
      Uri.parse(request),
    );

    print(response.body);

    List result = jsonDecode(response.body);

    List<AddressSuggestionModel> address = [];
    for(var item in result) {
      address.add(AddressSuggestionModel.fromJson(item));
    }

    return address;
  }
}