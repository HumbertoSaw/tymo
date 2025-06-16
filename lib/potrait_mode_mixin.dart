import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin PortraitModeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _setPortrait();
  }

  Future<void> _setPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _resetOrientation();
    super.dispose();
  }

  Future<void> _resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
