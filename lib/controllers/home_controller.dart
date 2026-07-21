// 首页控制器：管理跨 Tab 共享的考生档案状态 + 高校数据
//
// 说明：
// - 该控制器是应用的主要业务逻辑中心，负责维护考生档案（省份、位次）与高校列表等全局状态；
// - 使用 GetX 的响应式变量（Rx*）存储状态，所有页面和组件可以通过 Get.find 访问该控制器；
// - 在 onInit 生命周期中自动加载高校数据，并提供更新档案的方法供外部调用。
import 'package:get/get.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/core/network/university_service.dart';

/// HomeController
///
/// 中文说明：主要的业务逻辑控制器，管理考生档案、高校数据与加载状态。
class HomeController extends GetxController {
  /// 考生档案 - 省份（默认值：广东）
  final RxString province = '广东'.obs;

  /// 考生档案 - 全省位次（默认值：18000）
  final RxInt candidateRank = 18000.obs;

  /// 从网络或本地存储异步加载的高校列表（初始为空）
  final RxList<University> universities = <University>[].obs;

  /// 加载状态标志（true：正在加载，false：加载完成或出错）
  final RxBool isLoading = true.obs;

  /// 生命周期钩子：控制器初始化时被调用
  ///
  /// 该方法在控制器被注册到 GetX 容器后立即执行，用于初始化数据加载等异步操作。
  @override
  void onInit() {
    super.onInit();
    // 初始化时立即加载高校列表
    loadUniversities();
  }

  /// 异步加载高校列表数据
  ///
  /// - 在加载开始和结束时更新 isLoading 状态；
  /// - 使用 try/finally 确保即使出错也会关闭加载状态；
  /// - 加载成功后，新数据通过 assignAll 替换现有列表（触发所有监听器更新）。
  Future<void> loadUniversities() async {
    isLoading.value = true;
    try {
      final List<University> data = await fetchUniversities();
      universities.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  /// 更新考生档案信息
  ///
  /// 当用户在弹窗中修改省份或位次后，调用此方法更新全局状态，
  /// 所有依赖这些值的页面会自动通过 Obx 响应式更新。
  void updateProfile({required String province, required int candidateRank}) {
    this.province.value = province;
    this.candidateRank.value = candidateRank;
  }
}
