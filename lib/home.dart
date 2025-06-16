import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clock_app/components/sidebar-menu-component.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clock_app/providers/misc-provider.dart';
import 'dart:io';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeView> {
  double _appBarOpacity = 1.0;
  Timer? _inactivityTimer;
  DateTime _currentTime = DateTime.now();
  Timer? _clockTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _firstBuild = true;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _appBarOpacity = 0.0;
        });
      }
    });
  }

  void _handleUserInteraction([_]) {
    if (_appBarOpacity < 1.0) {
      setState(() {
        _appBarOpacity = 1.0;
      });
    }
    _startInactivityTimer();
  }

  String _formatTime(DateTime time, String format) {
    switch (format) {
      case '12h':
        final hour = time.hour > 12 ? time.hour - 12 : time.hour;
        final period = time.hour >= 12 ? 'PM' : 'AM';
        return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
      case '12h_seconds':
        final hour = time.hour > 12 ? time.hour - 12 : time.hour;
        final period = time.hour >= 12 ? 'PM' : 'AM';
        return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} $period';
      case '24h':
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case '24h_seconds':
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
      case 'unix':
        return '${(time.millisecondsSinceEpoch / 1000).floor()}';
      default:
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    }
  }

  String _getMonthName(int month) {
    const months = [
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
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return weekdays[weekday - 1];
  }

  String _formatDate(DateTime date, String format) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final shortYear = year.substring(2);
    final monthName = _getMonthName(date.month);
    final weekdayName = _getWeekdayName(date.weekday);

    switch (format) {
      case 'dd/MM/yyyy':
        return '$day/$month/$year';
      case 'MM/dd/yyyy':
        return '$month/$day/$year';
      case 'yyyy-MM-dd':
        return '$year-$month-$day';
      case 'dd MMM yyyy':
        return '$day $monthName $year';
      case 'MMM dd, yyyy':
        return '$monthName $day, $year';
      case 'EEEE, MMM dd, yyyy':
        return '$weekdayName, $monthName $day, $year';
      case 'dd/MM/yy':
        return '$day/$month/$shortYear';
      case 'MM/dd/yy':
        return '$month/$day/$shortYear';
      default:
        return '$day/$month/$year';
    }
  }

  TextAlign _timeDateAlignment(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
      default:
        return TextAlign.center;
    }
  }

  Alignment _timeDatePosition(String position) {
    switch (position.toLowerCase()) {
      case 'topleft':
        return Alignment.topLeft;
      case 'topcenter':
        return Alignment.topCenter;
      case 'topright':
        return Alignment.topRight;
      case 'centerleft':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'centerright':
        return Alignment.centerRight;
      case 'bottomleft':
        return Alignment.bottomLeft;
      case 'bottomcenter':
        return Alignment.bottomCenter;
      case 'bottomright':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final foregroundColor = ref.watch(foregroundColorProvider);
    final backgroundImagePath = ref.watch(backgroundImagePathProvider);
    final backgroundImageBlur = ref.watch(backgroundImageBlurPathProvider);
    final timeDateTextAlignment = ref.watch(timeDateTextAlignmentProvider);
    final timeDateScreenPosition = ref.watch(timeDateScreenAlignmentProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final timeFormat = ref.watch(timeFormatProvider) ?? '24h_seconds';
    final dateFormat = ref.watch(dateFormatProvider) ?? 'dd/MM/yyyy';
    final Color effectiveTextColor;

    if (foregroundColor != null) {
      effectiveTextColor = foregroundColor;
    } else {
      final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
      effectiveTextColor = brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    }

    if (_firstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
        _scaffoldKey.currentState?.closeDrawer();
        _firstBuild = false;
      });
    }

    return GestureDetector(
      onTap: _handleUserInteraction,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const SidebarMenuComponent(),
        appBar: null,
        body: Stack(
          children: [
            if (backgroundImagePath != null)
              ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(backgroundImagePath), fit: BoxFit.cover),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: backgroundImageBlur,
                        sigmaY: backgroundImageBlur,
                      ),
                      child: Container(color: Colors.transparent),
                    ),
                  ],
                ),
              )
            else
              Container(decoration: BoxDecoration(color: backgroundColor)),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _appBarOpacity,
                duration: const Duration(milliseconds: 400),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: effectiveTextColor),
                  automaticallyImplyLeading: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: _timeDatePosition(timeDateScreenPosition),
                      child: RichText(
                        textAlign: _timeDateAlignment(timeDateTextAlignment),
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${_formatTime(_currentTime, timeFormat)}\n',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: effectiveTextColor,
                              ),
                            ),
                            TextSpan(
                              text: _formatDate(_currentTime, dateFormat),
                              style: TextStyle(
                                fontSize: fontSize / 2,
                                color: effectiveTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
