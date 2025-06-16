import 'dart:async';
import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clock_app/providers/misc-provider.dart';

class FontColorSetting extends ConsumerStatefulWidget {
  const FontColorSetting({super.key});

  @override
  ConsumerState<FontColorSetting> createState() => _FontColorSettingState();
}

class _FontColorSettingState extends ConsumerState<FontColorSetting>
    with PortraitModeMixin {
  late Color _currentColor;
  final TextEditingController _hexController = TextEditingController();
  Timer? _debounce;
  bool _isHexValid = true;

  @override
  void initState() {
    super.initState();
    _currentColor = ref.read(foregroundColorProvider) ?? Colors.white;
    _hexController.text = _colorToHex(_currentColor);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return color.value
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase()
        .substring(2);
  }

  Color? _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '').toUpperCase();
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }

  void _onHexChangedDebounced(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final color = _hexToColor(value);
      if (color != null) {
        setState(() {
          _currentColor = color;
          _isHexValid = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Font Color'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColorPicker(
                        pickerColor: _currentColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _currentColor = color;
                            _hexController.text = _colorToHex(color);
                            _isHexValid = true;
                          });
                        },
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        colorPickerWidth: 300,
                        labelTypes: [],
                        paletteType: PaletteType.hslWithHue,
                        pickerAreaBorderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _hexController,
                                decoration: InputDecoration(
                                  labelText: 'Hexadecimal Color',
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  prefix: const Text(
                                    '#',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  _onHexChangedDebounced(value);
                                  setState(() {
                                    _isHexValid = _hexToColor(value) != null;
                                  });
                                },
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            if (!_isHexValid)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  'Invalid hexadecimal value',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isHexValid
                                  ? () {
                                      ref
                                              .read(
                                                foregroundColorProvider
                                                    .notifier,
                                              )
                                              .state =
                                          _currentColor;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Font Color Saved!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
