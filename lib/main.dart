import 'package:clock_app/providers/misc-provider.dart';
import 'package:clock_app/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefsService.init();

  final container = ProviderContainer();

  container.listen<Color>(
    backgroundColorProvider,
    (_, color) => SharedPrefsService.saveColor('backgroundColor', color),
  );

  container.listen<Color?>(foregroundColorProvider, (_, color) {
    if (color != null) {
      SharedPrefsService.saveColor('foregroundColor', color);
    }
  });

  container.listen<String?>(backgroundImagePathProvider, (_, path) {
    if (path != null) {
      SharedPrefsService.saveString('backgroundImagePath', path);
    } else {
      SharedPrefsService.remove('backgroundImagePath');
    }
  });

  container.listen<double?>(backgroundImageBlurPathProvider, (_, blur) {
    if (blur != null) {
      SharedPrefsService.saveDouble('backgroundImageBlur', blur);
    } else {
      SharedPrefsService.remove('backgroundImageBlur');
    }
  });

  container.listen<String?>(timeFormatProvider, (_, format) {
    if (format != null) {
      SharedPrefsService.saveString('timeFormat', format);
    }
  });

  container.listen<String?>(dateFormatProvider, (_, format) {
    if (format != null) {
      SharedPrefsService.saveString('dateFormat', format);
    }
  });

  container.listen<String?>(timeDateTextAlignmentProvider, (_, textAlignment) {
    if (textAlignment != null) {
      SharedPrefsService.saveString('timeDateTextAlignment', textAlignment);
    }
  });

  container.listen<String?>(timeDateScreenAlignmentProvider, (
    _,
    screenAlignment,
  ) {
    if (screenAlignment != null) {
      SharedPrefsService.saveString('timeDateScreenAlignment', screenAlignment);
    }
  });

  container.listen<double?>(fontSizeProvider, (_, size) {
    if (size != null) {
      SharedPrefsService.saveDouble('fontSize', size);
    } else {
      SharedPrefsService.remove('fontSize');
    }
  });

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData neutralTheme = ThemeData.light().copyWith(
      primaryColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.grey[800],
        secondary: Colors.grey[600],
        surface: Colors.grey[100],
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      cardColor: Colors.grey[100],
      dividerColor: Colors.grey[300],
      iconTheme: IconThemeData(color: Colors.grey[700]),
    );

    return MaterialApp(
      title: '',
      theme: neutralTheme,
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
