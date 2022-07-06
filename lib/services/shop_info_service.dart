import 'dart:convert';

import 'package:skripsi_budiberas_9701/constants.dart' as constants;
import 'package:skripsi_budiberas_9701/models/shipping_rates_model.dart';
import 'package:skripsi_budiberas_9701/models/shop_info_model.dart';
import 'package:http/http.dart' as http;

class ShopInfoService {
  String baseUrl = constants.baseUrl;

  Future<ShopInfoModel> getShopInfo() async {
    var url = '$baseUrl/shopInfoForCustomer';
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'][0];
      ShopInfoModel shopInfo = ShopInfoModel.fromJson(data);
      return shopInfo;
    } else {
      throw Exception('Gagal mengambil data toko');
    }
  }

  Future<List<ShippingRatesModel>> getShippingRates() async {
    var url = '$baseUrl/shippingRates';
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      List<ShippingRatesModel> shippingRates = [];

      for(var item in data) {
        shippingRates.add(ShippingRatesModel.fromJson(item));
      }

      return shippingRates;
    } else {
      throw Exception('Gagal mengambil data biaya pengiriman');
    }
  }
}