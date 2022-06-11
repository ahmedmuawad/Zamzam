import 'package:flutter_grocery/data/model/response/product_model.dart';

class SubCategoryModel {
  String _category;
  List<Product> _products;

  SubCategoryModel({String category, List<Product> products}) {
    this._category = category;
    this._products = products;
  }

  String get category => _category;

  List<Product> get products => _products;

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    _category = json['category'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this._category;

    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
