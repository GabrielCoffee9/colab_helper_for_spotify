class FollowersModel {
  String? href;
  int? total;

  FollowersModel({this.href, this.total});

  FollowersModel.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    data['total'] = total;
    return data;
  }
}
