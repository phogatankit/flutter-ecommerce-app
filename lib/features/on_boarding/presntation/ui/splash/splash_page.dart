import 'dart:async';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1),()async{

      String nextPage = AppRoutes.login_page;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userToken = prefs.getString(AppConstants.prefUserToken)??"";
      if(userToken.isNotEmpty ){
        nextPage= AppRoutes.dashboard_page;
      }

      Navigator.pushReplacementNamed(context, nextPage);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 200,),
            SizedBox(
              height: 11,
            ),
            Text("ShoppingBucket"),
          ],
        ),
      ),
    );
  }
}