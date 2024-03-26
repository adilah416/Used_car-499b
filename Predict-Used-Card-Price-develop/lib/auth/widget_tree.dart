import 'package:firebase_auth/firebase_auth.dart';
import 'package:predict_used_car_price/auth/auth.dart';
import 'package:predict_used_car_price/home/home_screen.dart';
import 'package:predict_used_car_price/predict_price/predict_price_screen.dart';
import 'package:predict_used_car_price/auth/login_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return const LoginPage();
          }
        });
  }
}
