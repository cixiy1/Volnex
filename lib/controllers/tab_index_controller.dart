// Tab 索引控制器：管理当前选中 Tab 索引，供 Shell 与 Tab 组件共享
import 'package:get/get.dart';

class TabIndexController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void select(int index) => currentIndex.value = index;
}
