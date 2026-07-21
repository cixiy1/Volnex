// Flutter 错误处理工具
//
// 说明：
// - ErrorUtil 负责注册全局错误处理器，捕获 UI 渲染异常与 Dart 异步异常；
// - 调用一次 initCatchError() 即可将处理器注册到 Flutter 框架，进程生命周期内持续生效；
// - 真实生产环境建议将错误上报到 Sentry、Bugly 等监控服务。
import 'package:flutter/material.dart';
import 'dart:ui' show PlatformDispatcher;

/// ErrorUtil
///
/// 中文说明：Flutter 全局错误处理器注册工具。
class ErrorUtil {
  /// 初始化全局错误捕获
  ///
  /// 该方法应在 main() 中调用一次，以注册 UI 层和异步层的异常处理器。
  static void initCatchError() {
    // 捕获 Flutter UI 渲染层的报错（如 build() 方法中的异常）
    // 当 Widget 树构建过程中抛出异常时，Flutter 会调用 presentError 展示红色错误页
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint("UI渲染异常：${details.exception}");
    };

    // 捕获未被任何 try/catch 捕获的异步异常（Future / isolate 等）
    // 返回 true 表示已处理（不向上传播），返回 false 表示未处理
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      debugPrint("全局异步崩溃：$error\n$stackTrace");
      return true;
    };
  }
}
