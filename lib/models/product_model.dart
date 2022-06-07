import 'package:intl/intl.dart';

import 'category_model.dart';
import 'gallery_model.dart';

class ProductModel{
  late int id;
  late String name;
  late double size;
  late double price;
  late String description;

  late int stock;
  late String stockStatus;
  String? stockNotes;
  late int canBeRetailed;

  late CategoryModel category;

  late String createdAt;
  late String updatedAt;
  //String? deletedAt;

  late List<GalleryModel> galleries;

  //late DateTime fixCreatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.description,
    required this.category
  });

  //ambil data Json dari backend, disimpan di variabel yg udh diinit di awal
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['product_name'];
    size = double.parse(json['size'].toString());
    price = double.parse(json['price'].toString());
    description = json['description'];

    stock = json['stock'];
    stockStatus = json['stock_status'];
    stockNotes = json['stock_notes'];
    canBeRetailed = json['can_be_retailed'];

    category = CategoryModel.fromJson(json['product_category']);

    galleries = json['product_galleries']
        .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery)).toList();

    final format = DateFormat('dd/MM/yyyy HH:mm:ss');

    DateTime parseCreated = format.parse(json['created_at']); //sesuaikan penulisan dgn backend
    DateTime parseUpdated = format.parse(json['updated_at']);
    //DateTime parseDeleted = format.parse(json['deleted_at']);

    createdAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(parseCreated);
    updatedAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(parseUpdated);
    //deletedAt = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(parseDeleted);

    //fixCreatedAt = DateTime.parse(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': name,
      'price': price,
      'description': description,
      'product_category': category.toJson(),
      'product_galleries': galleries.map((gallery) => gallery.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}

class UninitializedProductModel extends ProductModel {
  UninitializedProductModel() : super(
    id: 0,
    name: '',
    size: 0,
    price: 0,
    description: '',
    category: CategoryModel(id: 0, categoryName: '')
  );
}