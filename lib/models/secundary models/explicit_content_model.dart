class ExplicitContent {
  bool? filterEnabled;
  bool? filterLocked;

  ExplicitContent({this.filterEnabled, this.filterLocked});

  ExplicitContent.fromJson(Map<String, dynamic> json) {
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
