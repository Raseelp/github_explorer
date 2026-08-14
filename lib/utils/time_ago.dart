String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  }
  if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  }
  if (diff.inDays >= 1) {
    return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
  }
  if (diff.inHours >= 1) {
    return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
  }
  if (diff.inMinutes >= 1) {
    return diff.inMinutes == 1 ? '1 minute ago' : '${diff.inMinutes} minutes ago';
  }
  return 'just now';
}
