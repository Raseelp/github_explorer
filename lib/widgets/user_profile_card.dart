import 'package:flutter/material.dart';
import '../models/github_user.dart';
import '../utils/app_colors.dart';

class UserProfileCard extends StatelessWidget {
  final GithubUser user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.grey200,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            onBackgroundImageError: user.avatarUrl != null ? (_, __) {} : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 40, color: AppColors.grey400)
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            user.name != null && user.name!.isNotEmpty ? user.name! : user.login,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            '@${user.login}',
            style: const TextStyle(fontSize: 14, color: AppColors.grey600),
          ),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.grey700, height: 1.4),
            ),
          ],
          if (user.location != null && user.location!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place_outlined, size: 15, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(
                  user.location!,
                  style: const TextStyle(fontSize: 13, color: AppColors.grey600),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat('Repos', user.publicRepos),
              _divider(),
              _stat('Followers', user.followers),
              _divider(),
              _stat('Following', user.following),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value) {
    return Column(
      children: [
        Text(
          _format(value),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 28, width: 1, color: AppColors.grey200);
  }

  String _format(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }
}
