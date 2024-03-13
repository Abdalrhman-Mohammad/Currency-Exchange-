import 'package:currency_exchange/utils/routing/app_routes.dart';
import 'package:currency_exchange/views/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.mainPage:
        return MaterialPageRoute(
          builder: (context) {
            return const MainPage();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("nothing"),
              ),
            );
          },
        );
    }
  }
}
