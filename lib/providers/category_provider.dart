import 'package:flutter/cupertino.dart';
import 'package:skripsi_budiberas_9701/services/category_service.dart';

import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier{
  bool loading = false;
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  set categories(List<CategoryModel> listCategory) {
    _categories = listCategory;
    notifyListeners();
  }

  Future<void> getCategories() async{
    loading = true;
    try {
      _categories = await CategoryService().getCategories();
    } catch (e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }
}