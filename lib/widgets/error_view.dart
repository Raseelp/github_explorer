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

  Color get _iconColor {
    switch (type) {
      case ErrorType.notFound:
        return AppColors.errorNotFoundIcon;
      case ErrorType.network:
        return AppColors.errorNetworkIcon;
      case ErrorType.timeout:
        return AppColors.errorTimeoutIcon;
      case ErrorType.unknown:
        return AppColors.errorUnknownIcon;
    }
  }

  Color get _tint {
    switch (type) {
      case ErrorType.notFound:
        return AppColors.errorNotFoundTint;
      case ErrorType.network:
        return AppColors.errorNetworkTint;
      case ErrorType.timeout:
        return AppColors.errorTimeoutTint;
      case ErrorType.unknown:
        return AppColors.errorUnknownTint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
            child: Icon(_icon, size: 34, color: _iconColor),
          ),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.grey600)),
        ],
      ),
    );
  }
}
