class UserDetailModel{
  late int id, userId;
  late String addressOwner, address, phoneNumber;
  String? addressNotes;
  late double latitude, longitude;
  late bool defaultAddress;

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
    userId = json['user_id'];
    addressOwner = json['address_owner'];
    address = json['address'];
    addressNotes = json['address_notes'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phoneNumber = json['phone_number'];
    defaultAddress = json['default_address'] == 1 ? true : false;
  }
}