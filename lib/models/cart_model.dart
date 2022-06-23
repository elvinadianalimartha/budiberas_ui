import 'package:skripsi_budiberas_9701/models/product_model.dart';

class CartModel{
  late int id;
  late ProductModel product;
  late int quantity;
  String? orderNotes;
  late bool noteIsNull;
  late bool isSelected;

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.orderNotes,
    required this.isSelected,
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
    isSelected = json['is_selected'] == 1 ? true : false;
  }
}