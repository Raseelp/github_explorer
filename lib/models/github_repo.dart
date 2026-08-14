class GithubRepo {
  final String name;
  final String? description;
  final int stars;
  final String? language;
  final DateTime updatedAt;

  GithubRepo({
    required this.name,
    this.description,
    required this.stars,
    this.language,
    required this.updatedAt,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: json['name'] ?? '',
      description: json['description'],
      stars: json['stargazers_count'] ?? 0,
      language: json['language'],
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
