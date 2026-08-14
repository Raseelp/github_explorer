import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/repo_controller.dart';
import '../utils/app_colors.dart';
import '../utils/view_state.dart';
import '../widgets/error_view.dart';
import '../widgets/repo_tile.dart';

class RepoScreen extends StatefulWidget {
  final String username;

  const RepoScreen({super.key, required this.username});

  @override
  State<RepoScreen> createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  late final RepoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<RepoController>(tag: widget.username);
    _controller.loadRepos(widget.username);
  }

  @override
  void dispose() {
    Get.delete<RepoController>(tag: widget.username);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: GetBuilder<RepoController>(
        tag: widget.username,
        builder: (c) => _buildBody(c),
      ),
    );
  }

  Widget _buildBody(RepoController c) {
    if (c.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (c.state == ViewState.error) {
      return ErrorView(type: c.errorType, message: c.errorMessage);
    }

    if (c.repos.isEmpty) {
      return const Center(
        child: Text('No repositories found', style: TextStyle(color: AppColors.grey600)),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              Text(
                '${c.repos.length} repositories',
                style: const TextStyle(color: AppColors.grey600, fontSize: 13),
              ),
              const Spacer(),
              _sortToggle(c),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: c.repos.length,
            itemBuilder: (context, i) => RepoTile(repo: c.repos[i]),
          ),
        ),
      ],
    );
  }

  Widget _sortToggle(RepoController c) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _sortButton(c, 'Stars', RepoSort.stars),
          _sortButton(c, 'Recent', RepoSort.updated),
        ],
      ),
    );
  }

  Widget _sortButton(RepoController c, String label, RepoSort value) {
    final selected = c.sort == value;
    return GestureDetector(
      onTap: () => c.toggleSort(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected ? const [BoxShadow(color: AppColors.shadowToggle, blurRadius: 4)] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.textDark : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}
