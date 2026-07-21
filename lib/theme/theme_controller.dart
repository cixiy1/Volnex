import 'package:flutter/material.dart';
// Flutter UI 核心库，提供 Color、ThemeData 等 UI 相关类型。

import 'package:get/get.dart';
// GetX 状态管理包，提供 GetxController（响应式控制器基类）、
// Rx<T>（响应式变量）、Obx（响应式 UI 刷新）能力。

import 'package:shared_preferences/shared_preferences.dart';
// SharedPreferences：本地键值对持久化存储，用于保存用户主题偏好，
// App 重启后可恢复上次选择。

class ThemeController extends GetxController {
  // GetxController 的子类：在 update() 被调用时通知所有 Obx 监听者重建 UI。
  // 由于本类使用 Rx<T> 响应式变量（而非普通成员变量），Obx 会自动监听，无需手动 update()。

  /// 全局 App 标题（响应式）。
  final RxString globalAppTitle = 'Volnex 高考志愿助手'.obs;

  /// 主题种子色（响应式）。
  /// 种子色通过 ColorScheme.fromSeed(seedColor) 生成完整配色方案，
  final Rx<Color> defaultSeed = const Color(0xff156B5B).obs;

  /// 全局页面背景色（响应式）。
  /// 应用于 ThemeData.scaffoldBackgroundColor，控制所有页面背景色。
  final Rx<Color> defaultBg = const Color(0xffF6F8F7).obs;

  /// 将当前配色（种子色 + 背景色）保存到本地持久化存储。调用时机：用户在设置页修改主题后，保存偏好。
  /// SharedPreferences 的键名："seed_color" 和 "bg_color"，存储值为 Color.value（即 ARGB 整数）。
  Future<void> saveTheme() async {
    // 从 GetX 容器获取 SharedPreferences 实例（AppInitService._initLocalStorage 已注册）
    final sp = Get.find<SharedPreferences>();

    // setInt 将 Color.value（即 ARGB 32位整数）转为字符串存入本地文件。
    // Color.value 是 Color 类提供的 getter，返回 a*2^24 + r*2^16 + g*2^8 + b。
    await sp.setInt("seed_color", defaultSeed.value as int);
    await sp.setInt("bg_color", defaultBg.value as int);
  }

  /// 从本地持久化存储加载已保存的配色到响应式变量。调用时机：AppInitService._registerGlobalService() 初始化阶段。
  /// 如果 SharedPreferences 中有已保存的颜色值，则覆盖当前的默认值；如果没有（首次安装），则保持初始值不变。
  /// 参数 sp：由调用方（AppInitService）传入已初始化的 SharedPreferences 实例。
  void loadTheme(SharedPreferences sp) {
    // getInt 返回值类型为 int?（可空），需要判断 null 再赋值。
    // 如果 SharedPreferences 中不存在 "seed_color" 键，getInt 返回 null。
    final int? seedVal = sp.getInt("seed_color");
    if (seedVal != null) {
      // 用从存储读取的 ARGB 整数重建 Color 对象，赋值给 Rx<Color>.
      // Rx<Color>.value 的 setter 会通知所有 Obx 监听者。
      defaultSeed.value = Color(seedVal);
    }

    // 同上，加载已保存的背景色（如果存在）
    final int? bgVal = sp.getInt("bg_color");
    if (bgVal != null) {
      defaultBg.value = Color(bgVal);
    }
  }
}
