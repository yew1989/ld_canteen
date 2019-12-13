// 菜品
class Dish {
  // 菜品id
  String objectId;
  // 菜名
  String name;
  // 是否展示
  bool isShow;
  // 价格
  String price;
  // 排序
  int sort;

  Dish({this.name, this.isShow, this.price, this.sort, this.objectId});

  Dish.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    isShow = json['isShow'] ?? false;
    price = json['price'] ?? '';
    sort = json['sort'] ?? 0;
    objectId = json['objectId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name ?? '';
    data['isShow'] = this.isShow ?? true;
    data['price'] = this.price ?? '';
    data['sort'] = this.sort ?? 0;
    return data;
  }
}

// 菜品列表 responese
class DishListResp {

  List<Dish> results;

  DishListResp({this.results});

  DishListResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<Dish>();
      json['results'].forEach((v) {
        results.add(Dish.fromJson(v));
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

