import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:clock_app/providers/misc-provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FontSizeSetting extends ConsumerStatefulWidget {
  const FontSizeSetting({super.key});

  @override
  ConsumerState<FontSizeSetting> createState() => _FontSizeSettingState();
}

class _FontSizeSettingState extends ConsumerState<FontSizeSetting>
    with PortraitModeMixin {
  double _fontSize = 0.0;

  @override
  void initState() {
    super.initState();
    _fontSize = ref.read(fontSizeProvider);
  }

  final Map<String, Map<String, dynamic>> textSizeOptions = {
    'small': {'value': 30.0, 'icon': 'Small', 'size': 30.0},
    'medium': {'value': 50.0, 'icon': 'Medium', 'size': 50.0},
    'large': {'value': 70.0, 'icon': 'Large', 'size': 70.0},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Font Size'),
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
              children: textSizeOptions.entries.map((entry) {
                final value = entry.value;
                final isSelected = _fontSize == value['value'];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _fontSize = value['value'];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(isSelected ? 0 : 1),
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
                            const SizedBox(height: 5),
                            Icon(
                              Icons.title,
                              size: value['size'],
                              color: isSelected ? Colors.blue : Colors.white,
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
                  'or',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Font Size',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Slider(
                  value: _fontSize,
                  min: 0.0,
                  max: 100.0,
                  divisions: 10,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.white,
                  label: _fontSize.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(fontSizeProvider.notifier).state = _fontSize;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Font Size saved successfully!'),
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
