import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:clock_app/providers/misc-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeAndDateOrientationSetting extends ConsumerStatefulWidget {
  const TimeAndDateOrientationSetting({super.key});

  @override
  ConsumerState<TimeAndDateOrientationSetting> createState() =>
      _TimeAndDateOrientationSettingState();
}

class _TimeAndDateOrientationSettingState
    extends ConsumerState<TimeAndDateOrientationSetting>
    with PortraitModeMixin {
  late String? _selectedAlignment;
  late String? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedAlignment = ref.read(timeDateTextAlignmentProvider);
    _selectedPosition = ref.read(timeDateScreenAlignmentProvider);
  }

  final Map<String, Map<String, dynamic>> textAlingmentOptions = {
    'left': {
      'icon': Icons.format_align_left,
      'label': 'Left',
      'alignment': Alignment.centerLeft,
      'textAlign': TextAlign.left,
    },
    'center': {
      'icon': Icons.format_align_center,
      'label': 'Center',
      'alignment': Alignment.center,
      'textAlign': TextAlign.center,
    },
    'right': {
      'icon': Icons.format_align_right,
      'label': 'Right',
      'alignment': Alignment.centerRight,
      'textAlign': TextAlign.right,
    },
  };

  final Map<String, Alignment> positionOptions = {
    'topLeft': Alignment.topLeft,
    'topCenter': Alignment.topCenter,
    'topRight': Alignment.topRight,
    'centerLeft': Alignment.centerLeft,
    'center': Alignment.center,
    'centerRight': Alignment.centerRight,
    'bottomLeft': Alignment.bottomLeft,
    'bottomCenter': Alignment.bottomCenter,
    'bottomRight': Alignment.bottomRight,
  };

  final Map<String, String> positionLabels = {
    'topLeft': 'Top Left',
    'topCenter': 'Top Center',
    'topRight': 'Top Right',
    'centerLeft': 'Center Left',
    'center': 'Center',
    'centerRight': 'Center Right',
    'bottomLeft': 'Bottom Left',
    'bottomCenter': 'Bottom Center',
    'bottomRight': 'Bottom Right',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Time & Date Orientation'),
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
            Row(
              children: textAlingmentOptions.entries.map((entry) {
                final key = entry.key;
                final value = entry.value;
                final isSelected = _selectedAlignment == key;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAlignment = key;
                        });
                      },
                      child: Container(
                        alignment: value['alignment'],
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
                            Icon(
                              value['icon'],
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.blue[200],
                              size: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              value['label'],
                              textAlign: value['textAlign'],
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
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 214, 214, 214),
                    thickness: 1,
                    endIndent: 10,
                  ),
                ),
                Text(
                  'and',
                  style: TextStyle(
                    color: Color.fromARGB(255, 167, 167, 167),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 214, 214, 214),
                    thickness: 1,
                    indent: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: positionOptions.entries.map((entry) {
                final key = entry.key;
                final isSelected = _selectedPosition == key;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPosition = key;
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
                    child: Center(
                      child: Text(
                        positionLabels[key] ?? key,
                        textAlign: TextAlign.center,
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
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_selectedAlignment == null || _selectedPosition == null)
                      ? null
                      : () {
                          ref
                                  .read(timeDateTextAlignmentProvider.notifier)
                                  .state =
                              _selectedAlignment!;
                          ref
                                  .read(
                                    timeDateScreenAlignmentProvider.notifier,
                                  )
                                  .state =
                              _selectedPosition!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Orientation saved successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
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
                  child: Text(
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
