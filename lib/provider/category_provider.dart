import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';

import 'package:flutter_grocery/data/repository/category_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';

import '../data/model/response/home_product_model.dart';
import '../data/model/response/home_sub_sub_cate.dart';
import '../data/model/response/sub_sub_category.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  int _categorySelectedIndex = 0;
  int _filterIndex = -1;

  int get categorySelectedIndex => _categorySelectedIndex;

  int get filterIndex => _filterIndex;
  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList = [];

  List<Product> _categoryProductList = [];
  List<Product> _categoryAllProductList = [];
  List<SubSubCate> _subSubCate = [];

  CategoryModel _categoryModel;
  List<SubCategoryModel> _subCategoryData = [];
  List<SubSubCategoryHome> _ssHomecate = [] ;
  List<SubSubCate> _ssHomeProd  = [];

  List<SubSubCate> get ssHomeProd => _ssHomeProd ;
  List<CategoryModel> get categoryList => _categoryList;

  List<CategoryModel> get subCategoryList => _subCategoryList;

  List<Product> get categoryProductList => _categoryProductList;

  CategoryModel get categoryModel => _categoryModel;

  List<SubCategoryModel> get subCategoryData => _subCategoryData;

  List<SubSubCate> get subsubcategoryList => _subSubCate;

  List<SubSubCategoryHome> get ssHomecate => _ssHomecate ;

  Future<void> getCategoryList(
      BuildContext context, String languageCode, bool reload,
      {int id}) async {
    ApiResponse apiResponse = await categoryRepo.getCategoryList(languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _categoryList = [];
      apiResponse.response.data.forEach(
          (category) => _categoryList.add(CategoryModel.fromJson(category)));
      _categorySelectedIndex = 0;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getSubCategory(
      BuildContext context, String languageCode, bool reload) async {
    ApiResponse apiResponse = await categoryRepo.getSubCategory(languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _subCategoryData = [];
      apiResponse.response.data.forEach((category) =>
          _subCategoryData.add(SubCategoryModel.fromJson(category)));


      _categorySelectedIndex = 0;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
  Future<void> getSubSubCategory(
      BuildContext context, String languageCode, bool reload) async {
    ApiResponse apiResponse = await categoryRepo.getSubSubCategory(languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _ssHomecate = [];
      apiResponse.response.data.forEach((category) =>
          _ssHomecate.add(SubSubCategoryHome.fromJson(category)));
      _ssHomeProd = [] ;
      _ssHomeProd.addAll(SubSubCategoryHome.fromJson(apiResponse.response.data).subSubList);
      _categorySelectedIndex = 0;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void getCategory(int id, BuildContext context) async {
    if (_categoryList == null) {
      await getCategoryList(context, '', true);
      _categoryModel =
          _categoryList.firstWhere((category) => category.id == id);
      notifyListeners();
    } else {
      _categoryModel =
          _categoryList.firstWhere((category) => category.id == id);
    }
  }

  void getSubCategoryList(
      BuildContext context, String categoryID, String languageCode) async {
    _subCategoryList = null;

    ApiResponse apiResponse =
        await categoryRepo.getSubCategoryList(categoryID, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _subCategoryList = [];
      _subSubCate = [];
      apiResponse.response.data.forEach(
          (category) => _subCategoryList.add(CategoryModel.fromJson(category)));
      apiResponse.response.data.forEach(
              (category) => _subSubCate.add(SubSubCate.fromJson(category)));
      getCategoryProductList(context, categoryID, languageCode);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void getCategoryProductList(
      BuildContext context, String categoryID, String languageCode) async {
    _categoryProductList = [];

    ApiResponse apiResponse =
        await categoryRepo.getCategoryProductList(categoryID, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response.data.forEach(
          (category) => _categoryProductList.add(Product.fromJson(category)));
      _categoryAllProductList.addAll(_categoryProductList);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  int _selectCategory = -1;

  int get selectCategory => _selectCategory;

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex, {bool notify = true}) {
    _categorySelectedIndex = selectedIndex;
    if (notify) {
      notifyListeners();
    }
  }

  void setFilterIndex(int selectedIndex) {
    _filterIndex = selectedIndex;
  }
}
