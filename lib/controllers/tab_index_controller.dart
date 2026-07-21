// Tab 索引控制器：管理当前选中 Tab 索引，供 Shell 与 Tab 组件共享
//
// 说明：
// - 该控制器使用 GetX 框架提供的响应式编程能力，维护一个全局的 tab 索引状态（RxInt）；
// - 当索引改变时，所有使用 Obx 包装的 UI 会自动重建并反映新状态，无需手动调用 setState；
// - 推荐在 main.dart 或应用初始化时通过 Get.put(TabIndexController()) 注册到依赖容器。
import 'package:get/get.dart';

/// TabIndexController
///
/// 中文说明：GetX 响应式状态管理控制器，负责全局 tab 索引切换。
class TabIndexController extends GetxController {
  /// 当前选中 tab 的索引（响应式变量）
  /// 
  /// `.obs` 后缀使该变量变为可观测的（Observable），任何对其 `.value` 的改变都会通知监听器。
  final RxInt currentIndex = 0.obs;

  /// 切换到指定索引
  ///
  /// 调用该方法时，所有用 Obx 包装并依赖 currentIndex 的 UI 会自动重建。
  void select(int index) => currentIndex.value = index;
}
