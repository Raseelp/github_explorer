import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import '../models/github_user.dart';
import '../services/github_api.dart';
import '../services/recent_searches_service.dart';
import '../utils/error_type.dart';
import '../utils/view_state.dart';

class ProfileController extends GetxController {
  final _api = GithubApi();
  final _recentService = RecentSearchesService();

  ViewState state = ViewState.idle;
  GithubUser? user;
  String errorMessage = '';
  ErrorType errorType = ErrorType.unknown;
  List<String> recentSearches = [];
  int _requestId = 0;

  @override
  void onInit() {
    super.onInit();
    loadRecent();
  }

  Future<void> loadRecent() async {
    recentSearches = await _recentService.getAll();
    update();
  }

  void reset() {
    ++_requestId;
    state = ViewState.idle;
    user = null;
    update();
  }

  Future<void> search(String username) async {
    username = username.trim();
    if (username.isEmpty) return;

    final requestId = ++_requestId;
    state = ViewState.loading;
    update();

    try {
      final result = await _api.getUser(username);
      if (requestId != _requestId) return;
      user = result;
      state = ViewState.data;
      update();
      await _recentService.add(result.login);
      await loadRecent();
    } on UserNotFoundException {
      if (requestId != _requestId) return;
      state = ViewState.error;
      errorType = ErrorType.notFound;
      errorMessage = 'No user found with that username';
      update();
    } on SocketException {
      if (requestId != _requestId) return;
      state = ViewState.error;
      errorType = ErrorType.network;
      errorMessage = 'Network error, check your connection';
      update();
    } on TimeoutException {
      if (requestId != _requestId) return;
      state = ViewState.error;
      errorType = ErrorType.timeout;
      errorMessage = 'Request timed out, try again';
      update();
    } catch (e) {
      if (requestId != _requestId) return;
      state = ViewState.error;
      errorType = ErrorType.unknown;
      errorMessage = 'Something went wrong, try again';
      update();
    }
  }
}
