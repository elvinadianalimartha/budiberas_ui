class ShopInfoModel{
  late String shopAddress, phoneNumber, openStatus;
  String? addressNotes;
  late double latitude, longitude;

  ShopInfoModel({
    required this.shopAddress,
    this.addressNotes,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.openStatus,
  });

  ShopInfoModel.fromJson(Map<String, dynamic> json) {
    shopAddress = json['shop_address'];
    addressNotes = json['address_notes'];
    phoneNumber = json['phone_number'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openStatus = json['open_status'];
  }
}