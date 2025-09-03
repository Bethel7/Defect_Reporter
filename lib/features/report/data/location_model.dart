class LocationModel {
  final int locationID;
  final String locationName;

  LocationModel({required this.locationID, required this.locationName});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // Support both lower and upper case keys for robustness
    final id =
        json['LocationID'] ??
        json['locationID'] ??
        json['locationId'] ??
        json['id'];
    final name = json['LocationName'] ?? json['locationName'] ?? json['name'];
    return LocationModel(
      locationID: id is int ? id : int.tryParse(id.toString()) ?? 0,
      locationName: name?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'LocationID': locationID,
    'LocationName': locationName,
  };
}
