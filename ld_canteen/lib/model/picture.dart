// 图片素材
class PictureBean {
  String mimeType;
  String key;
  String name;
  String objectId;
  String url;

  PictureBean({this.mimeType, this.key, this.name, this.objectId, this.url});

  PictureBean.fromJson(Map<String, dynamic> json) {
    mimeType = json['mime_type'] ?? '';
    key = json['key'] ?? '';
    name = json['name'] ?? '';
    objectId = json['objectId'] ??'';
    url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mime_type'] = this.mimeType;
    data['key'] = this.key;
    data['name'] = this.name;
    data['objectId'] = this.objectId;
    data['url'] = this.url;
    return data;
  }
}

class PictureResp {
  List<PictureBean> results;
  int count;

  PictureResp({this.results, this.count});

  PictureResp.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<PictureBean>();
      json['results'].forEach((v) {
        results.add(PictureBean.fromJson(v));
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

