import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import '../models/github_repo.dart';
import '../services/github_api.dart';
import '../utils/error_type.dart';
import '../utils/view_state.dart';

enum RepoSort { stars, updated }

class RepoController extends GetxController {
  final _api = GithubApi();

  ViewState state = ViewState.idle;
  List<GithubRepo> repos = [];
  String errorMessage = '';
  ErrorType errorType = ErrorType.unknown;
  RepoSort sort = RepoSort.stars;

  Future<void> loadRepos(String username) async {
    state = ViewState.loading;
    update();

    try {
      final result = await _api.getRepos(username);
      repos = result;
      _applySort();
      state = ViewState.data;
      update();
    } on UserNotFoundException {
      state = ViewState.error;
      errorType = ErrorType.notFound;
      errorMessage = 'No user found with that username';
      update();
    } on SocketException {
      state = ViewState.error;
      errorType = ErrorType.network;
      errorMessage = 'Network error, check your connection';
      update();
    } on TimeoutException {
      state = ViewState.error;
      errorType = ErrorType.timeout;
      errorMessage = 'Request timed out, try again';
      update();
    } catch (e) {
      state = ViewState.error;
      errorType = ErrorType.unknown;
      errorMessage = 'Something went wrong, try again';
      update();
    }
  }

  void toggleSort(RepoSort value) {
    sort = value;
    _applySort();
    update();
  }

  void _applySort() {
    if (sort == RepoSort.stars) {
      repos.sort((a, b) => b.stars.compareTo(a.stars));
    } else {
      repos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
  }
}
