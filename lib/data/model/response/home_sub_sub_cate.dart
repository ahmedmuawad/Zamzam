import 'package:flutter_grocery/data/model/response/sub_sub_category.dart';

class SubSubCategoryHome {
  String _subCateName;

  List<SubSubCate> _subSubList;

  SubSubCategoryHome({String subCateName, List<SubSubCate> subSubList}) {
    this._subCateName = subCateName;
    this._subSubList = subSubList;
  }

  String get name => _subCateName;

  List<SubSubCate> get subSubList => _subSubList;

  SubSubCategoryHome.fromJson(Map<String, dynamic> json) {
    _subCateName = json['sub_category'];
    if (json['sub_sub_category'] != null) {
      _subSubList = [];
      json['sub_sub_category'].forEach((v) {
        _subSubList.add(new SubSubCate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_category'] = this._subCateName;

    if (this._subSubList != null) {
      data['sub_sub_category'] =
          this._subSubList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
