class UserDetailModel{
  late int id, userId;
  late String addressOwner, address, phoneNumber;
  String? addressNotes;
  late double latitude, longitude;
  late int defaultAddress;

  UserDetailModel({
    required this.id,
    required this.userId,
    required this.addressOwner,
    required this.address,
    this.addressNotes,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.defaultAddress
  });

  UserDetailModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = int.parse(json['user_id'].toString());
    addressOwner = json['address_owner'];
    address = json['address'];
    addressNotes = json['address_notes'];
    latitude = double.parse(json['latitude'].toString());
    longitude = double.parse(json['longitude'].toString());
    phoneNumber = json['phone_number'];
    defaultAddress = int.parse(json['default_address'].toString());
  }
}