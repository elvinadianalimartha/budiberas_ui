import 'package:skripsi_budiberas_9701/models/product_model.dart';

class CartModel{
  late int id;
  late ProductModel product;
  late int quantity;
  String? orderNotes;
  late bool noteIsNull;

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.orderNotes,
  });

  CartModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
    quantity = json['quantity'];
    orderNotes = json['order_notes'];
    if(orderNotes == null) {
      noteIsNull = true;
    } else {
      noteIsNull = false;
    }
  }
}