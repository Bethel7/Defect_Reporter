class LocationModel {
  final int locationId;
  final String locationName;

  LocationModel({required this.locationId, required this.locationName});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locationId: json['LocationId'] as int,
      locationName: json['LocationName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'LocationId': locationId,
    'LocationName': locationName,
  };
}
