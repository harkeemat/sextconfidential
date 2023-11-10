import 'package:flutter/material.dart';

import 'calling_page.dart';

class AppRoute {
  static const callingPage = '/calling_page';

  static Route<Object>? generateRoute(RouteSettings settings) {
    print("SETTING");
    switch (settings.name) {
      case callingPage:
        return MaterialPageRoute(
          builder: (_) => const CallingPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
