import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clock_app/providers/misc-provider.dart';

class DateFormatSetting extends ConsumerStatefulWidget {
  const DateFormatSetting({super.key});

  @override
  ConsumerState<DateFormatSetting> createState() => _DateFormatSettingState();
}

class _DateFormatSettingState extends ConsumerState<DateFormatSetting>
    with PortraitModeMixin {
  late String? _selectedFormat;
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedFormat = ref.read(dateFormatProvider);
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
        return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormats = [
      {'name': 'Day/Month/Year', 'format': 'dd/MM/yyyy'},
      {'name': 'Month/Day/Year', 'format': 'MM/dd/yyyy'},
      {'name': 'Year-Month-Day', 'format': 'yyyy-MM-dd'},
      {'name': 'Day Month Year', 'format': 'dd MMM yyyy'},
      {'name': 'Month Day, Year', 'format': 'MMM dd, yyyy'},
      {'name': 'Weekday, Month Day', 'format': 'EEEE, MMM dd, yyyy'},
      {'name': 'Day/Month/Year (Short)', 'format': 'dd/MM/yy'},
      {'name': 'Month/Day/Year (Short)', 'format': 'MM/dd/yy'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Date Format'),
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
                children: dateFormats.map((format) {
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
                            _formatDate(_currentDate, format['format']!),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.blue[200],
                              fontSize: 18,
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
                            textAlign: TextAlign.center,
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
                          ref.read(dateFormatProvider.notifier).state =
                              _selectedFormat!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Date Format Saved!'),
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
