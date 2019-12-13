class UpdateResp {
  String objectId;
  String createdAt;

  UpdateResp({this.objectId, this.createdAt});

  UpdateResp.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'] ?? '';
    createdAt = json['createdAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = this.objectId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}