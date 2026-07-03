
class ServiceModel {
  final String iconKey;
  final String title;
  final String description;

  const ServiceModel({
    required this.iconKey,
    required this.title,
    required this.description,
  });

  factory ServiceModel.formJson(Map<String, dynamic> json) {
    return ServiceModel(
      iconKey: json['iconKey'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
