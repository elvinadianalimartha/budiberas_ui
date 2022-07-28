class MidtransModel {
  late String orderId, paymentMethod;
  late double totalPrice;
  String? vaNumber, bankName;
  late String transactionStatus;
  late DateTime transactionTime;

  MidtransModel({
    required this.orderId,
    required this.paymentMethod,
    required this.totalPrice,
    this.vaNumber,
    this.bankName,
    required this.transactionStatus,
    required this.transactionTime
  });

  MidtransModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    totalPrice = double.parse(json['gross_amount'].toString());
    paymentMethod = json['payment_type'];
    if(paymentMethod == 'bank_transfer') {
      vaNumber = json['va_numbers'][0]['va_number'];
      bankName = json['va_numbers'][0]['bank'];
    } else {
      vaNumber = null;
      bankName = null;
    }
    transactionStatus = json['transaction_status'];
    transactionTime = DateTime.parse(json['transaction_time']);
  }
}