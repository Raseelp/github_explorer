import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/repo_binding.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_colors.dart';
import '../utils/view_state.dart';
import '../widgets/error_view.dart';
import '../widgets/user_profile_card.dart';
import 'repos_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = Get.find<ProfileController>();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  final _searchBarKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _updateSuggestions();
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    _updateSuggestions();
    if (_focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _updateSuggestions() {
    final query = _textController.text.trim().toLowerCase();
    if (query.isEmpty) {
      _suggestions = [];
      return;
    }
    _suggestions =
        _controller.recentSearches.where((u) => u.toLowerCase().contains(query)).toList();
  }

  void _runSearch(String username) {
    _textController.text = username;
    _focusNode.unfocus();
    _controller.search(username);
  }

  void _submit() => _runSearch(_textController.text);

  void _showOverlay() {
    _removeOverlay();
    if (_suggestions.isEmpty) return;

    final box = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final width = box.size.width;
    final height = box.size.height;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, height + 8),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(14),
              color: AppColors.surface,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.grey100),
                  itemBuilder: (context, i) {
                    final username = _suggestions[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.history, size: 18, color: AppColors.grey500),
                      title: Text(username, style: const TextStyle(fontSize: 14)),
                      onTap: () => _runSearch(username),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _focusNode.unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GitHub Explorer',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Search any GitHub profile',
                  style: TextStyle(fontSize: 14, color: AppColors.grey600),
                ),
                const SizedBox(height: 20),
                CompositedTransformTarget(
                  link: _layerLink,
                  child: _searchBar(),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GetBuilder<ProfileController>(
                    builder: (c) => _buildBody(c),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      key: _searchBarKey,
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Enter a username',
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _submit,
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.search, color: AppColors.surface),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ProfileController c) {
    if (c.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (c.state == ViewState.error) {
      return ErrorView(type: c.errorType, message: c.errorMessage);
    }

    if (c.state == ViewState.data && c.user != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            UserProfileCard(user: c.user!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.to(
                  () => RepoScreen(username: c.user!.login),
                  binding: RepoBinding(c.user!.login),
                ),
                icon: const Icon(Icons.folder_outlined),
                label: const Text('View repositories'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (c.recentSearches.isEmpty) {
      return const Center(
        child: Text(
          'Try searching for a username\nlike "octocat"',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey500, height: 1.5),
        ),
      );
    }

    return ListView(
      children: [
        const Text(
          'Recent searches',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.grey700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: c.recentSearches.map((u) {
            return ActionChip(
              avatar: const Icon(Icons.history, size: 16, color: AppColors.grey600),
              label: Text(u),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.grey200),
              onPressed: () => _runSearch(u),
            );
          }).toList(),
        ),
      ],
    );
  }
}
