import 'dart:async';
import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clock_app/providers/misc-provider.dart';

class TimeFormatSetting extends ConsumerStatefulWidget {
  const TimeFormatSetting({super.key});

  @override
  ConsumerState<TimeFormatSetting> createState() => _TimeFormatSettingState();
}

class _TimeFormatSettingState extends ConsumerState<TimeFormatSetting>
    with PortraitModeMixin {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String? _selectedFormat;

  @override
  void initState() {
    super.initState();
    _selectedFormat = ref.read(timeFormatProvider);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        return time.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormats = [
      {'name': '12-hour', 'format': '12h'},
      {'name': '12-hour + seconds', 'format': '12h_seconds'},
      {'name': '24-hour', 'format': '24h'},
      {'name': '24-hour + seconds', 'format': '24h_seconds'},
      {'name': 'Epoch', 'format': 'unix'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Time Format'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: timeFormats.map((format) {
                  final isSelected = _selectedFormat == format['format'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFormat = format['format'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.2)
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.blue.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(_currentTime, format['format']!),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.blue[200],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            format['name']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedFormat == null
                      ? null
                      : () {
                          ref.read(timeFormatProvider.notifier).state =
                              _selectedFormat!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Time Format Saved!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context, _selectedFormat);
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
