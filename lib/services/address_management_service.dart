import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

class AddressManagementService {
  String baseUrl = constants.baseUrl;

  Future<bool> createNewAddress({
    required String token,
    required String addressOwner,
    required String regency,
    required String district,
    required String address,
    String? addressNotes,
    required double latitude,
    required double longitude,
    required String phoneNumber,
    required int defaultAddress,
  }) async {
    var url = '$baseUrl/newAddress';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'address_owner': addressOwner,
      'regency': regency,
      'district': district,
      'address': address,
      'address_notes': addressNotes,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'default_address': defaultAddress,
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
      throw Exception('Data alamat gagal ditambahkan');
    }
  }
}