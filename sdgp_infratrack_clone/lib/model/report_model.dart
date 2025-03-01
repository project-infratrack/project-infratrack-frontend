class ReportModel {
  final String title;
  final String description;

  ReportModel({
    required this.title,
    required this.description,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
