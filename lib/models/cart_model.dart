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
    this.orderNotes,
    required this.isSelected,
  });

  CartModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
    quantity = int.parse(json['quantity'].toString());
    orderNotes = json['order_notes'];
    if(orderNotes == null) {
      noteIsNull = true;
    } else {
      noteIsNull = false;
    }
    isSelected = int.parse(json['is_selected'].toString()) == 1 ? true : false;
  }
}