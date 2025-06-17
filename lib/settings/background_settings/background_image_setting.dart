import 'dart:ui';

import 'package:clock_app/potrait_mode_mixin.dart';
import 'package:clock_app/providers/misc-provider.dart';
import 'package:clock_app/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageBackgroudSetting extends ConsumerStatefulWidget {
  const ImageBackgroudSetting({super.key});

  @override
  ConsumerState<ImageBackgroudSetting> createState() =>
      _ImageBackgroudSettingState();
}

class _ImageBackgroudSettingState extends ConsumerState<ImageBackgroudSetting>
    with PortraitModeMixin {
  File? _selectedImage;
  double _blurAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadInitialValues();
  }

  Future<void> _loadInitialValues() async {
    final backgroundPath = ref.read(backgroundImagePathProvider);
    final blurAmount = ref.read(backgroundImageBlurPathProvider);

    if (backgroundPath != null) {
      setState(() {
        _selectedImage = File(backgroundPath);
        _blurAmount = blurAmount;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _blurAmount = 0.0;
    });

    ref.read(backgroundImagePathProvider.notifier).state = null;
    ref.read(backgroundImageBlurPathProvider.notifier).state = 0.0;

    SharedPrefsService.remove('backgroundImagePath');
    SharedPrefsService.remove('backgroundImageBlur');
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image Removed!')));
      Navigator.pop(context);
      return;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'background_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await _selectedImage!.copy('${appDir.path}/$fileName');

      ref.read(backgroundImagePathProvider.notifier).state = savedImage.path;
      ref.read(backgroundImageBlurPathProvider.notifier).state = _blurAmount;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Image Saved!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error has ocurred...: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Background Image'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: _blurAmount,
                            sigmaY: _blurAmount,
                          ),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Search Image'),
                  ),
                  ElevatedButton(
                    onPressed: _removeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Remove Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blur Amount',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Slider(
                    value: _blurAmount,
                    min: 0.0,
                    max: 10.0,
                    divisions: 20,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.white,
                    label: _blurAmount.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _blurAmount = value;
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
                    onPressed: _saveImage,
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
