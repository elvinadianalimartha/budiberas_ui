import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

import '../models/product_model.dart';

class ProductService{
  String baseUrl = constants.baseUrl;

  Future<List<ProductModel>> getProducts() async{
    var url = '$baseUrl/products';
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<ProductModel> products = [];

      for(var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Data produk gagal diambil!');
    }
  }
}