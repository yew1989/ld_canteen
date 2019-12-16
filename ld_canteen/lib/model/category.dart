// 菜品分类
class Category {
  // id
  String objectId;
  // 菜品名称
  String name;

  Category({this.name,this.objectId});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    objectId = json['objectId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name ?? '';
    data['objectId'] = this.objectId ?? '';
    return data;
  }
}

// 菜品分类列表 responese
class CategoryListResp {

  List<Category> results;

  CategoryListResp({this.results});

  CategoryListResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<Category>();
      json['results'].forEach((v) {
        results.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

