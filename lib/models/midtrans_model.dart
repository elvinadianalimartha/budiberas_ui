class MidtransModel {
  late String invoiceCode, paymentMethod;
  late double totalPrice;
  String? vaNumber;
  late DateTime transactionTime;

  MidtransModel({
    required this.invoiceCode,
    required this.paymentMethod,
    required this.totalPrice,
    this.vaNumber,
    required this.transactionTime
  });

  MidtransModel.fromJson(Map<String, dynamic> json) {
    invoiceCode = json['order_id'];
    totalPrice = double.parse(json['gross_amount'].toString());
    vaNumber = json['va_numbers'][0]['va_number'];
    paymentMethod = json['payment_type'];
    transactionTime = DateTime.parse(json['transaction_time']);
  }
}