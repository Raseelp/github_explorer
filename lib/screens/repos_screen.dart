import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/repo_controller.dart';
import '../utils/view_state.dart';
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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 46, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(c.errorMessage, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    if (c.repos.isEmpty) {
      return Center(
        child: Text('No repositories found', style: TextStyle(color: Colors.grey.shade600)),
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
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
        color: Colors.grey.shade200,
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
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
