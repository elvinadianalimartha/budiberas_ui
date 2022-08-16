class UserModel{
  late int id;
  String? name, email, profilePhotoUrl, token, fcmToken;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.profilePhotoUrl,
    this.token,
    this.fcmToken
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profilePhotoUrl = json['profile_photo_url'];
    token = json['token'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
      'fcm_token': fcmToken
    };
  }
}