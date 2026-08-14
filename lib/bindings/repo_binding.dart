import 'package:get/get.dart';
import '../controllers/repo_controller.dart';

class RepoBinding extends Bindings {
  final String username;

  RepoBinding(this.username);

  @override
  void dependencies() {
    Get.lazyPut<RepoController>(() => RepoController(), tag: username);
  }
}
