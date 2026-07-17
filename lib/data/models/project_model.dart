
enum GalleryImageSize { small, tall, large }

class GalleryImage {
  final String path;
  final GalleryImageSize size;
  const GalleryImage({required this.path, required this.size});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      path: json['path'] as String,
      size: GalleryImageSize.values.firstWhere(
        (element) => element.name == (json['size'] as String),
        orElse: () => GalleryImageSize.small,
      ),
    );
  }
}

class ProjectMetrics {
  final String label;
  final String value;
  const ProjectMetrics({required this.label, required this.value});

  factory ProjectMetrics.fromJson(Map<String, dynamic> json) {
    return ProjectMetrics(
      label: json['label'] as String,
      value: json['value'] as String,
    );
  }
}

class ProjectModel {
  final String slug;
  final String title;
  final String category;
  final String shortDescription;
  final String tagline;
  final List<String> platforms;
  final String coverImage;
  final String challenge;
  final String solution;
  final List<String> techStack;
  final List<ProjectMetrics> metrics;
  final List<GalleryImage> gallery;
  final String? nextProjectSlug;
  final String githubUrl; 

  const ProjectModel({
    required this.slug,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.tagline,
    required this.platforms,
    required this.coverImage,
    required this.challenge,
    required this.solution,
    required this.techStack,
    required this.metrics,
    required this.gallery,
    this.nextProjectSlug, required this.githubUrl,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      slug: json['slug'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      shortDescription: json['shortDescription'] as String,
      tagline: json['tagline'] as String,
      platforms: List<String>.from(json['platforms'] as List),
      coverImage: json['coverImage'] as String,
      challenge: json['challenge'] as String,
      solution: json['solution'] as String,
      techStack: List<String>.from(json['techStack'] as List),
      metrics: (json['metrics'] as List)
          .map((e) => ProjectMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      gallery: (json['gallery'] as List)
          .map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextProjectSlug: json['githubUrl'] as String?, githubUrl: '',
    );
  }
}
