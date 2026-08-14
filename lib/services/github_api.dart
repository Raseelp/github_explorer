import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_repo.dart';
import '../models/github_user.dart';

class UserNotFoundException implements Exception {}

class GithubApi {
  static const _base = 'https://api.github.com';

  Future<GithubUser> getUser(String username) async {
    final res = await http
        .get(Uri.parse('$_base/users/${Uri.encodeComponent(username)}'))
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (res.statusCode != 200) {
      throw Exception('Something went wrong');
    }
    return GithubUser.fromJson(jsonDecode(res.body));
  }

  Future<List<GithubRepo>> getRepos(String username) async {
    final res = await http
        .get(Uri.parse('$_base/users/${Uri.encodeComponent(username)}/repos?per_page=100'))
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 404) {
      throw UserNotFoundException();
    }
    if (res.statusCode != 200) {
      throw Exception('Something went wrong');
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => GithubRepo.fromJson(e)).toList();
  }
}
