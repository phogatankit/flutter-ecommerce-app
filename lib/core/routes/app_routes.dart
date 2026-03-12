
import 'package:flutter/material.dart';

import '../../features/dashboard/presentation/ui/dashboard/dashboard_page.dart';
import '../../features/on_boarding/presntation/ui/login/login.dart';
import '../../features/on_boarding/presntation/ui/signup/signup.dart';
import '../../features/on_boarding/presntation/ui/splash/splash_page.dart';

class AppRoutes {

  static const String splash_page = "/";
  static const String login_page = "/login";
  static const String sign_up_page = "/signUp";
  static const String dashboard_page = "/dashBoard";

  static Map<String, WidgetBuilder> mRoutes = {

    splash_page: (context) => SplashPage(),
    login_page: (context) =>  LoginPage(),
    sign_up_page : (context) =>  SignupPage(),
    dashboard_page : (context) =>  DashBoardPage(),

  };

}
