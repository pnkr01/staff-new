import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_color.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    Get.find<SplashScreenController>().startThisTimer();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
          Text(
            'Staff Sathi',
            style: kTitleTextStyle(28, FontWeight.w800)
                .copyWith(color: purpleColor),
          )
        ],
      ),
    );
  }
}
