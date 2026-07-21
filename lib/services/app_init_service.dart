import 'package:get/get.dart';
// GetX 核心包：提供 Get.put() 全局注册、Get.find() 获取实例的能力，
// 以及响应式变量（Rx<T>）和 Obx 响应式刷新机制。

// 第三方本地持久化存储包
// 用于在设备本地存储键值对数据（主题配色、考生档案等），App 重启后数据不丢失。
import 'package:shared_preferences/shared_preferences.dart';

// 主题控制器：持有可动态修改的种子色、背景色、全局标题
import '../theme/theme_controller.dart';

/// 全局应用初始化服务。
/// 负责在 App 冷启动阶段（main() → app()）按顺序完成所有全局资源的初始化，确保 UI 渲染前所有依赖已就绪。
class AppInitService {
  // 全局单例：全局唯一实例，全项目通过 AppInitService.instance 访问。
  // 使用工厂构造 + 私有命名构造函数模式实现单例，确保外部只能访问 instance。
  static final AppInitService instance = AppInitService._create();

  // 私有命名构造函数：防止外部直接 new AppInitService()
  AppInitService._create();

  /// main() 函数统一调用的异步初始化入口。
  /// 按顺序执行本地存储初始化 → 预加载高校数据 → 注册全局常驻服务。
  Future<void> initGlobalConfig() async {
    // 1. 初始化本地持久化存储（SharedPreferences）。 必须在所有需要读取本地配置（如主题、考生档案）之前完成。
    await _initLocalStorage();

    // 2. 注册全局常驻业务服务/控制器（GetX 单例）。这些服务在 App 整个生命周期内持续存在，供任意页面 Get.find() 获取。
    _registerGlobalService();
  }

  /// 初始化本地持久化存储。
  ///
  /// SharedPreferences.getInstance() 是异步方法，首次调用时会在文件系统
  /// 中创建持久化存储文件。返回的 SharedPreferences 实例通过 Get.put()
  /// 注册到 GetX 容器，使任意页面均可 Get.find() 获取并读写本地键值。
  Future<void> _initLocalStorage() async {
    // await 等待 SharedPreferences 初始化完成，确保存储就绪后再继续。
    final storage = await SharedPreferences.getInstance();
    // 将 SharedPreferences 实例注册为 GetX 全局单例，标签默认（可用 T 类型获取）。
    // 注册后，ThemeController.loadTheme() 等方法可通过 Get.find<SharedPreferences>() 获取。
    Get.put<SharedPreferences>(storage);
  }

  /// 注册全局常驻业务服务/控制器。这些服务在整个 App 生命周期内存在，不需要按页面创建/销毁。
  /// Get.put() 将实例注入 GetX 容器，Get.find() 随时可取。
  void _registerGlobalService() {
    // 示例：Get.put(UserService()); // 未来如有用户服务，在此注册

    // 注册主题控制器单例：管理全局主题配色（种子色、背景色），
    // 支持用户自定义后通过 SharedPreferences 持久化保存。
    final ThemeController themeCtrl = Get.put(ThemeController());

    // 从 GetX 容器获取 SharedPreferences 实例（由 _initLocalStorage 注册），
    // 并将本地已保存的主题配色加载到 ThemeController 的 Rx 变量中，
    // 实现 App 重启后恢复用户上次选择的主题。
    final SharedPreferences sp = Get.find();
    themeCtrl.loadTheme(sp);
  }
}
