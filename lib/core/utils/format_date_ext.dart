import 'package:intl/intl.dart';

extension FormatDateTime on DateTime {
  String formatDate(String format) {
    return DateFormat(format).format(this);
  }

  String formatTimeAgo() {
    final Duration difference = DateTime.now().difference(this);

    if (difference.inDays > 365) {
      return DateFormat('MMM d, yyyy').format(this);
    } else if (difference.inDays > 30) {
      return DateFormat('MMM d').format(this);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day ago' : 'days ago'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago' : 'hours ago'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago' : 'minutes ago'}';
    } else {
      return 'a few seconds ago';
    }
  }
}
