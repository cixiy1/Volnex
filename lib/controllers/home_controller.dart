import 'package:get/get.dart';

class HomeController extends GetxController {
  /// 考生档案 - 省份（默认值：广东）
  final RxString province = '广东'.obs;

  /// 考生档案 - 全省位次（默认值：18000）
  final RxInt candidateRank = 18000.obs;
}
