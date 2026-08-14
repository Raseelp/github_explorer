import 'package:flutter/material.dart';
import '../models/github_repo.dart';
import '../utils/time_ago.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo repo;

  const RepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repo.name,
            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
          ),
          if (repo.description != null && repo.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              repo.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700, height: 1.35),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (repo.language != null && repo.language!.isNotEmpty) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _langColor(repo.language!),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  repo.language!,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
              ],
              Icon(Icons.star_border_rounded, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 3),
              Text(
                '${repo.stars}',
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
              ),
              const Spacer(),
              Text(
                timeAgo(repo.updatedAt),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _langColor(String language) {
    switch (language) {
      case 'Dart':
        return const Color(0xFF00B4AB);
      case 'Kotlin':
        return const Color(0xFFA97BFF);
      case 'Swift':
        return const Color(0xFFF05138);
      case 'JavaScript':
        return const Color(0xFFF1E05A);
      case 'TypeScript':
        return const Color(0xFF3178C6);
      case 'Python':
        return const Color(0xFF3572A5);
      case 'Java':
        return const Color(0xFFB07219);
      case 'C++':
        return const Color(0xFFF34B7D);
      case 'C':
        return const Color(0xFF555555);
      case 'HTML':
        return const Color(0xFFE34C26);
      case 'CSS':
        return const Color(0xFF563D7C);
      case 'Go':
        return const Color(0xFF00ADD8);
      case 'Rust':
        return const Color(0xFFDEA584);
      case 'Ruby':
        return const Color(0xFF701516);
      case 'PHP':
        return const Color(0xFF4F5D95);
      default:
        return Colors.grey.shade400;
    }
  }
}
