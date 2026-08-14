import 'package:flutter/material.dart';
import '../models/github_repo.dart';
import '../utils/app_colors.dart';
import '../utils/format_count.dart';
import '../utils/time_ago.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo repo;

  const RepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final accent = repo.language != null && repo.language!.isNotEmpty
        ? _langColor(repo.language!)
        : AppColors.grey200;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(13, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowFaint,
            blurRadius: 10,
            offset: Offset(0, 4),
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
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.grey700,
                height: 1.35,
              ),
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
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  repo.language!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              const Icon(
                Icons.star_border_rounded,
                size: 16,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 3),
              Text(
                formatCount(repo.stars),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.grey700,
                ),
              ),
              const Spacer(),
              Text(
                timeAgo(repo.updatedAt),
                style: const TextStyle(fontSize: 12, color: AppColors.grey500),
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
        return AppColors.langDart;
      case 'Kotlin':
        return AppColors.langKotlin;
      case 'Swift':
        return AppColors.langSwift;
      case 'JavaScript':
        return AppColors.langJavaScript;
      case 'TypeScript':
        return AppColors.langTypeScript;
      case 'Python':
        return AppColors.langPython;
      case 'Java':
        return AppColors.langJava;
      case 'C++':
        return AppColors.langCpp;
      case 'C':
        return AppColors.langC;
      case 'HTML':
        return AppColors.langHtml;
      case 'CSS':
        return AppColors.langCss;
      case 'Go':
        return AppColors.langGo;
      case 'Rust':
        return AppColors.langRust;
      case 'Ruby':
        return AppColors.langRuby;
      case 'PHP':
        return AppColors.langPhp;
      default:
        return AppColors.langDefault;
    }
  }
}
