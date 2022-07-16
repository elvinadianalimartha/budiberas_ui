class GalleryModel{
  int? id;
  String? url;
  int? productId;

  GalleryModel({this.id, this.url, this.productId});

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['photo_url'];
    productId = int.parse(json['product_id'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_url': url,
      'product_id': productId,
    };
  }
}