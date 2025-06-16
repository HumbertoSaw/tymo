import 'package:clock_app/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgroundColorProvider = StateProvider<Color>((ref) {
  final savedColor = SharedPrefsService.getColor('backgroundColor');
  return savedColor ?? Colors.white;
});

final foregroundColorProvider = StateProvider<Color?>((ref) {
  return SharedPrefsService.getColor('foregroundColor');
});

final backgroundImagePathProvider = StateProvider<String?>((ref) {
  return SharedPrefsService.getString('backgroundImagePath');
});

final backgroundImageBlurPathProvider = StateProvider<double>((ref) {
  return SharedPrefsService.getDouble('backgroundImageBlur') ?? 0.0;
});

final timeFormatProvider = StateProvider<String?>((ref) {
  return SharedPrefsService.getString('timeFormat');
});

final dateFormatProvider = StateProvider<String?>((ref) {
  return SharedPrefsService.getString('dateFormat');
});

final timeDateTextAlignmentProvider = StateProvider<String>((ref) {
  return SharedPrefsService.getString('timeDateTextAlignment') ?? 'center';
});

final timeDateScreenAlignmentProvider = StateProvider<String>((ref) {
  return SharedPrefsService.getString('timeDateScreenAlignment') ?? 'center';
});

final fontSizeProvider = StateProvider<double>((ref) {
  return SharedPrefsService.getDouble('fontSize') ?? 50.0;
});
