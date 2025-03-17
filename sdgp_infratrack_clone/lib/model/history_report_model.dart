class HistoryReportModel {
  final String id;
  final String userId;
  final String reportType;
  final String description;
  final String location;
  final String image; 
  final String status;
  final double latitude;
  final double longitude;
  final String priorityLevel;
  final int thumbsUp;
  final int thumbsDown;
  final String approval;
  final List<dynamic> thumbsUpUsers;
  final List<dynamic> thumbsDownUsers;

  HistoryReportModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.description,
    required this.location,
    required this.image,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.priorityLevel,
    required this.thumbsUp,
    required this.thumbsDown,
    required this.approval,
    required this.thumbsUpUsers,
    required this.thumbsDownUsers,
  });

  factory HistoryReportModel.fromJson(Map<String, dynamic> json) {
    return HistoryReportModel(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      reportType: json["reportType"] ?? "",
      description: json["description"] ?? "",
      location: json["location"] ?? "",
      image: json["image"] ?? "",
      status: json["status"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      priorityLevel: json["priorityLevel"] ?? "",
      thumbsUp: json["thumbsUp"] ?? 0,
      thumbsDown: json["thumbsDown"] ?? 0,
      approval: json["approval"] ?? "",
      thumbsUpUsers: json["thumbsUpUsers"] ?? [],
      thumbsDownUsers: json["thumbsDownUsers"] ?? [],
    );
  }
}
