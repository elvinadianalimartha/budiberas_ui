

import 'package:skripsi_budiberas_9701/models/product_model.dart';

class MessageModel {
  late String id;

  //pesan dan pengirimnya
  late String message;
  late int userId;
  late String userName;
  String? userImage;

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
    required this.userId,
    required this.userName,
    this.userImage,
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
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userImage'];
    isFromUser = json['isFromUser'];

    product = json['product'].isEmpty
        ? UninitializedProductModel() 
        : ProductModel.fromJsonFirebase(json['product']);
    imageUrl = json['imageUrl'];

    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'isFromUser': isFromUser,
      'product': product is UninitializedProductModel ? {} : product!.toJson(),
      'imageUrl': imageUrl,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'isRead': isRead,
    };
  }

}