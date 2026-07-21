import 'package:get/get.dart';
// 第三方存储包
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/university_service.dart';
import '../theme/theme_controller.dart';

class AppInitService {
  // 全局单例，全项目统一调用
  static final AppInitService instance = AppInitService._create();

  AppInitService._create();

  /// main函数统一调用的初始化入口
  Future<void> initGlobalConfig() async {
    // 1. 初始化本地持久化存储（第三方包 shared_preferences）
    await _initLocalStorage();

    // 2. 预加载高校数据到注册表，供路由在 build 之前解析 URL 参数
    await _initUniversityData();

    // 3. 注册全局常驻业务服务
    _registerGlobalService();
  }

  /// 预加载高校数据
  ///
  /// 在 AppInitService 初始化阶段调用，确保 GoRouter 解析 URL 时
  /// UniversityRegistry 已有数据可用，避免直接访问 URL 时注册表为空的竞速问题。
  Future<void> _initUniversityData() async {
    await fetchUniversities();
  }

  // 初始化本地缓存
  Future<void> _initLocalStorage() async {
    final storage = await SharedPreferences.getInstance();
    // 存入Get全局，任意页面可直接获取
    Get.put<SharedPreferences>(storage);
  }

  // 注册全局长期存在的业务服务/控制器
  void _registerGlobalService() {
    // 示例：Get.put(UserService());
    // 注册主题控制器单例
    final ThemeController themeCtrl = Get.put(ThemeController());
    // 初始化时读取本地保存的颜色
    final SharedPreferences sp = Get.find();
    themeCtrl.loadTheme(sp);
  }
}