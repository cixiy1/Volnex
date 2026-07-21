import 'package:flutter/material.dart';
import 'dart:ui' show PlatformDispatcher; // 补上这个导入

class ErrorUtil {
  static void initCatchError() {
    // 捕获UI渲染报错
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint("UI渲染异常：${details.exception}");
    };

    // 全局异步异常捕获
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      debugPrint("全局异步崩溃：$error\n$stackTrace");
      return true;
    };
  }
}