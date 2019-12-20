// 广告栏
class BannerBean {

  // id
  String objectId;
  // 名称
  String name;
  // 图片地址 列表
  List<String> images;

  BannerBean({this.name, this.images, this.objectId});

  BannerBean.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    images = json['images'].cast<String>();
    objectId = json['objectId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['images'] = this.images;
    data['objectId'] = this.objectId;
    return data;
  }
}

class BannerResp {

  List<BannerBean> results;
  int count;

  BannerResp({this.results, this.count});

  BannerResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<BannerBean>();
      json['results'].forEach((v) {
        results.add(BannerBean.fromJson(v));
      });
    }
    count = json['count'] ?? 0;
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

