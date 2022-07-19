import 'package:skripsi_budiberas_9701/models/gallery_model.dart';

class TransactionModel {
  late int id, userId;
  int? userDetailId;
  late double shippingRate, totalPrice;
  late String invoiceCode, shippingType, transactionStatus, paymentMethod;
  String? pickupCode;
  late DateTime checkoutDate;
  late String checkoutTime;
  late List<TransactionDetailModel> details;
  late int countRemainingDetails;

  TransactionModel({
    required this.id,
    required this.userId,
    this.userDetailId,
    required this.shippingRate,
    required this.totalPrice,
    required this.invoiceCode,
    required this.shippingType,
    required this.transactionStatus,
    required this.paymentMethod,
    this.pickupCode,
    required this.checkoutDate,
    required this.checkoutTime
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    userId = int.parse(json['user_id'].toString());

    if(json['user_detail_id'] != null) {
      userDetailId = int.parse(json['user_detail_id'].toString());
    } else {
      userDetailId = null;
    }

    shippingRate = double.parse(json['shipping_rate'].toString());
    totalPrice = double.parse(json['total_price'].toString());
    invoiceCode = json['invoice_code'];
    shippingType = json['shipping_type'];
    transactionStatus = json['transaction_status'];
    paymentMethod = json['payment_method'];
    pickupCode = json['pickup_code'];
    checkoutDate = DateTime.parse(json['checkout_date'].toString());
    checkoutTime = json['checkout_time'];
    details = json['transaction_details']
        .map<TransactionDetailModel>((detail) => TransactionDetailModel.fromJson(detail)).toList();
    countRemainingDetails = details.length - 1;
    //user detail (name, phone number, alamat, note alamat) -> ini kayaknya taruh di tmpat terpisah krn hanya bakal dipanggil kalo user klik card preview
    //va number, nama bank?
  }
}


class TransactionDetailModel {
  late int id, quantity;
  late double subtotal;
  String? orderNotes;
  late ProductInTransactionModel product; //1 transaction model hanya punya 1 produk (one to one)

  TransactionDetailModel({
    required this.id,
    required this.quantity,
    required this.subtotal,
    this.orderNotes,
    required this.product
  });

  TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    quantity = int.parse(json['quantity'].toString());
    subtotal = double.parse(json['subtotal'].toString());
    orderNotes = json['order_notes'];
    product = ProductInTransactionModel.fromJson(json['product']);
  }
}

class ProductInTransactionModel {
  late int id;
  late String productName;
  late List<GalleryModel> galleries;

  ProductInTransactionModel({
    required this.id,
    required this.productName,
    required this.galleries
  });

  ProductInTransactionModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    productName = json['product_name'];
    galleries = json['product_galleries']
        .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery)).toList();
  }
}