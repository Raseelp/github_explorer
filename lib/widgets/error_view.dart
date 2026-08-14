import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/error_type.dart';

class ErrorView extends StatelessWidget {
  final ErrorType type;
  final String message;

  const ErrorView({super.key, required this.type, required this.message});

  IconData get _icon {
    switch (type) {
      case ErrorType.notFound:
        return Icons.person_search_outlined;
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.timeout:
        return Icons.hourglass_empty_rounded;
      case ErrorType.unknown:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 46, color: AppColors.grey400),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.grey600)),
        ],
      ),
    );
  }
}
