class Copyright {
  String? text;
  String? type;

  Copyright({this.text, this.type});

  Copyright.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}
