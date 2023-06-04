import 'dart:async';

import 'package:get/get.dart';

import '../../home/home.dart';

class SplashScreenController extends GetxController {
  startThisTimer() {
    Timer(const Duration(seconds: 4), () {
      Get.off(() => const HomePage());
    });
  }
}
