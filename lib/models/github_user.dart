class GithubUser {
  final String login;
  final String? name;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final int followers;
  final int following;
  final int publicRepos;

  GithubUser({
    required this.login,
    this.name,
    this.avatarUrl,
    this.bio,
    this.location,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      login: json['login'] ?? '',
      name: json['name'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      location: json['location'],
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      publicRepos: json['public_repos'] ?? 0,
    );
  }
}
