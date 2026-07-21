// 首页控制器：管理跨 Tab 共享的考生档案状态 + 高校数据
import 'package:get/get.dart';
import 'package:volnex/models/university.dart';
import 'package:volnex/core/network/university_service.dart';

class HomeController extends GetxController {
  // 考生档案
  final RxString province = '广东'.obs;
  final RxInt candidateRank = 18000.obs;

  // 高校列表（从 service 异步加载）
  final RxList<University> universities = <University>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUniversities();
  }

  Future<void> loadUniversities() async {
    isLoading.value = true;
    try {
      final List<University> data = await fetchUniversities();
      universities.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfile({required String province, required int candidateRank}) {
    this.province.value = province;
    this.candidateRank.value = candidateRank;
  }
}
