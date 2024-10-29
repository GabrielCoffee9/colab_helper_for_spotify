class Devices {
  String? id;
  bool? isActive;
  bool? isPrivateSession;
  bool? isRestricted;
  String? name;
  String? type;
  int? volumePercent;
  bool? supportsVolume;

  Devices(
      {this.id,
      this.isActive,
      this.isPrivateSession,
      this.isRestricted,
      this.name,
      this.type,
      this.volumePercent,
      this.supportsVolume});

  Devices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    isPrivateSession = json['is_private_session'];
    isRestricted = json['is_restricted'];
    name = json['name'];
    type = json['type'];
    volumePercent = json['volume_percent'];
    supportsVolume = json['supports_volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_active'] = isActive;
    data['is_private_session'] = isPrivateSession;
    data['is_restricted'] = isRestricted;
    data['name'] = name;
    data['type'] = type;
    data['volume_percent'] = volumePercent;
    data['supports_volume'] = supportsVolume;
    return data;
  }
}
