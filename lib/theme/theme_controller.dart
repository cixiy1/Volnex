import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 全局主题控制器，存放可动态修改的颜色变量
class ThemeController extends GetxController {
  // 全局标题，全局唯一源头，一处修改全应用同步
  final RxString globalAppTitle = 'Volnex 高考志愿助手'.obs;

  // 响应式种子色
  final Rx<Color> defaultSeed = const Color(0xff156B5B).obs;
  // 响应式页面背景
  final Rx<Color> defaultBg = const Color(0xffF6F8F7).obs;

  // 把当前配色保存到本地存储
  Future<void> saveTheme() async {
    final sp = Get.find<SharedPreferences>();
    // 存储ARGB数值
    await sp.setInt("seed_color", defaultSeed.value as int);
    await sp.setInt("bg_color", defaultBg.value as int);
  }

  // 从本地读取配色
  void loadTheme(SharedPreferences sp) {
    final int? seedVal = sp.getInt("seed_color");
    final int? bgVal = sp.getInt("bg_color");
    if (seedVal != null) defaultSeed.value = Color(seedVal);
    if (bgVal != null) defaultBg.value = Color(bgVal);
  }
}