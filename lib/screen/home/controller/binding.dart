import 'package:get/get.dart';
import 'package:staff/screen/home/controller/home_controller.dart';
import 'package:staff/screen/splash/controller/splash_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => SplashScreenController(), fenix: true);
  }
}
