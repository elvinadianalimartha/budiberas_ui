class AddressSuggestionModel {
  late String displayName;
  late double lat;
  late double lon;

  AddressSuggestionModel({
    required this.displayName,
    required this.lat,
    required this.lon
  });

  AddressSuggestionModel.fromJson(Map<String, dynamic> json){
    displayName = json['display_name'];
    lat = double.parse(json['lat']);
    lon = double.parse(json['lon']);
  }
}