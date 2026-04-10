import '../../features/workout/data/models/workout_session.dart';

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m ${seconds}s';
  } else if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  } else {
    return '${seconds}s';
  }
}

String formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][local.month - 1];

  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$month ${local.day}, ${local.year} - $hour:$minute';
}

String formatDouble(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(1);
}

String humanize(String value) {
  return value
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String setSummary(WorkoutSet set) {
  final parts = <String>[];

  if (set.reps != null) {
    parts.add('${set.reps} reps');
  }

  if (set.weightKg != null) {
    parts.add('${formatDouble(set.weightKg!)} kg');
  }

  if (set.rir != null) {
    parts.add('RIR ${set.rir}');
  }

  if (set.durationSeconds != null) {
    parts.add('${set.durationSeconds}s');
  }

  if (parts.isEmpty) {
    return set.isComplete ? 'Completed set' : 'Waiting to be logged';
  }

  return parts.join(' - ');
}
