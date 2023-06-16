import 'package:get/get.dart';
import 'package:staff/screen/home/controller/add_new_item_controller.dart';
import 'package:staff/screen/home/controller/add_new_party_controller.dart';
import 'package:staff/screen/home/controller/home_controller.dart';
import 'package:staff/screen/splash/controller/splash_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => SplashScreenController(), permanent: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => AddNewItemCOntroller(), fenix: true);
    Get.lazyPut(() => AddNewpartyController(), fenix: true);
  }
}
