// 菜品
class Dish {
  
  // id
  String objectId;
  // 菜名
  String name;
  // 菜价
  String price;

  Dish({this.name,this.objectId,this.price});

  Dish.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'] ?? '';
    name = json['name'] ?? '';
    price = json['price'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['objectId'] = this.objectId ?? '';
    data['name'] = this.name ?? '';
    data['price'] = this.price ?? '';
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

