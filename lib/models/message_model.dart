import 'package:skripsi_budiberas_9701/models/product_model.dart';

class MessageModel {
  late String id;

  late String message;

  //utk mengetahui chat berasal dr pelanggan atau pemilik
  late bool isFromUser;

  //utk menautkan produk yg ingin ditanyakan
  ProductModel? product;

  //utk menautkan gambar
  String? imageUrl;

  late DateTime createdAt;
  DateTime? updatedAt;
  late bool isRead;

  MessageModel({
    required this.id,
    required this.message,
    required this.isFromUser,
    this.product,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    required this.isRead,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    isFromUser = json['isFromUser'];

    product = json['product'].isEmpty
        ? UninitializedProductModel() 
        : ProductModel.fromJsonFirebase(json['product']);
    imageUrl = json['imageUrl'];

    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    isRead = json['isRead'];
  }
}