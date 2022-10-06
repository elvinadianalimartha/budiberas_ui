import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skripsi_budiberas_9701/constants.dart' as constants;

import '../models/product_model.dart';

class ProductService{
  String baseUrl = constants.baseUrl;

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? search,
    List<double>? size,
    List<String>? riceChar,
    int? sortByPrice,
  }) async{
    var url = '$baseUrl/products';
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    Map<String, dynamic> qParams = {
      'categoryId': categoryId?.toString(),
      'search': search?.toLowerCase(),
      'sortByPrice': sortByPrice?.toString()
    };

    if(size != null) {
      for(int i=0; i < size.length; i++) {
        qParams.addAll({'size[$i]': size[i].toString()});
      }
    }

    if(riceChar != null) {
      for(int i=0; i < riceChar.length; i++) {
        qParams.addAll({'riceChar[$i]': riceChar[i]});
      }
    }

    var response = await http.get(
      Uri.parse(url).replace(queryParameters: qParams),
      headers: headers,
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