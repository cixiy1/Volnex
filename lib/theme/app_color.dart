import 'package:flutter/material.dart';
// Flutter UI 核心库，提供 Color 等颜色类型定义。

/// 应用全局颜色常量集中管理。
///
/// 作用：
/// - 为 ThemeData 提供种子色和背景色默认值；
/// - 全应用颜色常量一处定义，避免散落在各 Widget 中硬编码。
/// - 未来支持用户自定义主题时，可将这些常量替换为 ThemeController 中的 Rx 变量。
class AppColor {
  AppColor._(); // 私有构造函数，防止外部实例化，确保只使用静态常量

  /// 默认主题种子色（Color(0xFF255BA3)，蓝色）。
  ///
  /// 种子色（seedColor）通过 `ColorScheme.fromSeed()` 自动生成：
  /// 主色（primary）、次色（secondary）、错误色（error）等全套配色体系，
  /// 保证所有 Material 组件（按钮、输入框、AppBar 等）色调协调一致。
  ///
  /// ⚠️ 此为静态默认值。如需运行时动态切换颜色，应使用 `ThemeController.defaultSeed`（`Rx<Color>`）。
  static const Color defaultSeed = Color(0xFF255BA3);

  /// 默认全局页面背景色（Color(0xffF6F8F7)，浅灰白色）。
  ///
  /// 应用于所有页面的 Scaffold scaffoldBackgroundColor。
  /// ⚠️ 此为静态默认值。如需运行时动态切换背景色，应使用 `ThemeController.defaultBg`（`Rx<Color>`）。
  static const Color defaultBg = Color(0xffF6F8F7);
}
