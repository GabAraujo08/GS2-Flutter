import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/check_in.dart';

Color statusColor(CheckInStatus status) {
  switch (status) {
    case CheckInStatus.ok:
      return AppColors.success;
    case CheckInStatus.later:
      return AppColors.warning;
    case CheckInStatus.help:
      return AppColors.danger;
  }
}

IconData statusIcon(CheckInStatus status) {
  switch (status) {
    case CheckInStatus.ok:
      return Icons.check_circle;
    case CheckInStatus.later:
      return Icons.schedule;
    case CheckInStatus.help:
      return Icons.emergency;
  }
}
