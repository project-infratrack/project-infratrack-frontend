class ReportModel {
  final String id;
  final String userId;
  final String reportType;
  final String description;
  final String location;
  final String image;
  final double latitude;
  final double longitude;
  final int thumbsUp;
  final int thumbsDown;

  ReportModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.thumbsUp,
    required this.thumbsDown,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      reportType: json["reportType"] ?? "",
      description: json["description"] ?? "",
      location: json["location"] ?? "",
      image: json["image"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      thumbsUp: json["thumbsUp"] ?? 0,
      thumbsDown: json["thumbsDown"] ?? 0,
    );
  }
}
