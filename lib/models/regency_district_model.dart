class RegencyModel {
  late int id;
  late String name;

  RegencyModel({
    required this.id,
    required this.name,
  });

  RegencyModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
}

class DistrictModel {
  late int id;
  late String name;

  DistrictModel({
    required this.id,
    required this.name,
  });

  DistrictModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
}