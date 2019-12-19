import 'package:ld_canteen/model/banner.dart';
import 'package:ld_canteen/model/category.dart';

class Menu {
  // id
  String objectId;
  // 关联到菜谱
  Category category;
  // 关联到展示位
  Banner banner;
  // 类型
  String type;
  // 排序
  int sort;
  
  Menu({this.category, this.type, this.sort, this.objectId, this.banner});

  Menu.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
    type = json['type'] ?? '';
    sort = json['sort'] ?? 0;
    objectId = json['objectId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }
    data['type'] = this.type;
    data['sort'] = this.sort;
    data['objectId'] = this.objectId;
    return data;
  }
}

class MenuResp {
  List<Menu> results;
  int count;

  MenuResp({this.results, this.count});

  MenuResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<Menu>();
      json['results'].forEach((v) {
        results.add(Menu.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}



