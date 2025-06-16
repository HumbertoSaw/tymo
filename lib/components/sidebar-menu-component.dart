import 'package:clock_app/settings/settings.dart' show SettingsView;
import 'package:flutter/material.dart';

class SidebarMenuComponent extends StatelessWidget {
  const SidebarMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF121212),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsetsDirectional.only(top: 65, bottom: 20),
              decoration: BoxDecoration(color: Colors.black),
              child: Icon(Icons.menu, color: Colors.white, size: 24),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SettingsView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.white, height: 1, thickness: 0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
