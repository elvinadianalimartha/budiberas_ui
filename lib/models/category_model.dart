class CategoryModel{
  late int id;
  late String categoryName;

  CategoryModel({required this.id, required this.categoryName});

  CategoryModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'category_name': categoryName,
    };
  }
}