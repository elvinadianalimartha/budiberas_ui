class ShippingRatesModel{
  late int id;
  late double shippingPrice;
  double? maxDistance, minOrderPrice;
  late String shippingName;

  ShippingRatesModel({
    required this.id,
    this.maxDistance,
    this.minOrderPrice,
    required this.shippingPrice,
    required this.shippingName,
  });

  ShippingRatesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['max_distance'] != null) {
      maxDistance = double.parse(json['max_distance'].toString());
    }
    if(json['min_order_price'] != null) {
      minOrderPrice = double.parse(json['min_order_price'].toString());
    }
    shippingPrice = double.parse(json['shipping_price'].toString());
    shippingName = json['shipping_name'];
  }
}