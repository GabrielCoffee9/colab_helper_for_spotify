class ExplicitContentModel {
  bool? filterEnabled;
  bool? filterLocked;

  ExplicitContentModel({this.filterEnabled, this.filterLocked});

  ExplicitContentModel.fromJson(Map<String, dynamic> json) {
    filterEnabled = json['filter_enabled'];
    filterLocked = json['filter_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filter_enabled'] = filterEnabled;
    data['filter_locked'] = filterLocked;
    return data;
  }
}
