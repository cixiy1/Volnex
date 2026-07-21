// 考生档案弹窗（底部表单）：允许用户输入省份、位次等信息
//
// 说明：
// - 本工具类封装了一个静态方法 `show`，用于在任意页面弹出底部表单，采集用户的省份与全省位次；
// - 返回值为 `(String province, int candidateRank)` 的可空元组；
//   当用户点击"保存"时返回新值，点击外部蒙层或返回键时返回 null。
// - 注意：调用者应根据返回值判断是否需要更新全局控制器（例如 HomeController）。
//
// 使用示例：
// ```dart
// final result = await ProfileSheet.show(
//   context,
//   initialProvince: '广东',
//   initialRank: 12345,
// );
// if (result != null) {
//   controller.updateProfile(province: result.$1, candidateRank: result.$2);
// }
// ```

// Flutter 核心 UI 库，提供 Scaffold、Text、FilledButton 等 Material 组件
import 'package:flutter/material.dart';

/// ProfileSheet
///
/// 中文说明：一个工具类（纯静态方法集合），通过 `show()` 静态方法弹出考生档案编辑底部面板。
///
/// 面板内容：
/// - 省份下拉选择（浙江/江苏/山东/广东）
/// - 全省位次数字输入框（辅助推荐算法的核心依据）
///
/// 设计说明：
/// - 使用 `showModalBottomSheet` 实现从屏幕底部滑入的弹窗效果；
/// - `isScrollControlled: true` 使面板高度随内容自适应；
/// - `StatefulBuilder` 包裹内部表单，允许省份和位次在本地状态中独立更新；
/// - `MediaQuery.viewInsetsOf(context).bottom` 确保键盘弹出时底部内边距被撑开。
class ProfileSheet {
  /// 显示档案弹窗，返回用户保存后的 (省份, 位次)
  ///
  /// 参数说明：
  /// - [context]：当前 BuildContext，用于 showModalBottomSheet 的显示与导航上下文；
  /// - [initialProvince]：作为表单省份下拉框的初始值，便于用户在已有档案的情况下快速调整；
  /// - [initialRank]：作为表单位次输入框的初始值。
  ///
  /// 返回：用户点击"保存并更新推荐"时返回 `(province, candidateRank)` 元组，点击取消返回 null。
  static Future<(String, int)?> show(
    BuildContext context, {
    required String initialProvince,
    required int initialRank,
  }) {
    // 局部可变状态：在 StatefulBuilder 中管理表单值，确保用户在面板内编辑时实时反映
    String province = initialProvince;
    int candidateRank = initialRank;

    // 调用 Flutter 原生 showModalBottomSheet 创建底部弹窗，
    // 使用泛型 <(String, int)?> 声明返回值的可空元组类型
    return showModalBottomSheet<(String, int)?>(
      context: context,
      // 允许弹窗内容超出默认高度并滚动，防止键盘遮挡表单
      isScrollControlled: true,
      // builder 返回弹窗内部的 Widget 树
      builder: (BuildContext sheetContext) {
        // StatefulBuilder 创建独立的局部状态空间，允许在面板内调用 setState 更新 province 和 candidateRank
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            // 弹窗主体容器：左右各 24px 内边距，底部 24px + 键盘高度（由 viewInsets 动态计算）
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24, // 左侧内边距
                24, // 顶部内边距
                24, // 右侧内边距
                24 +
                    MediaQuery.viewInsetsOf(
                      context,
                    ).bottom, // 底部：固定 24px + 键盘高度，防止被键盘遮挡
              ),
              // 内部 Column 垂直排列表单元素
              child: Column(
                mainAxisSize: MainAxisSize.min, // 高度自适应内容，不占用多余空间
                crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                children: <Widget>[
                  // 弹窗标题
                  const Text(
                    '完善考生档案',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20), // 标题与表单之间的间距
                  // 省份下拉选择器
                  DropdownButtonFormField<String>(
                    // 当前选中的省份值（来自本地状态 province）
                    initialValue: province,
                    // Material Design 输入框装饰：边框样式 + 标签文字
                    decoration: const InputDecoration(
                      labelText: '高考省份',
                      border: OutlineInputBorder(),
                    ),
                    // 下拉选项列表：浙江/江苏/山东/广东（可根据实际需求扩展）
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: '浙江', child: Text('浙江')),
                      DropdownMenuItem(value: '江苏', child: Text('江苏')),
                      DropdownMenuItem(value: '山东', child: Text('山东')),
                      DropdownMenuItem(value: '广东', child: Text('广东')),
                    ],
                    // 用户选择新省份后，更新本地状态 province，触发 StatefulBuilder 重建下拉框显示新值
                    onChanged: (String? value) {
                      if (value != null) {
                        setSheetState(() => province = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14), // 省份选择器与位次输入框之间的间距
                  // 全省位次数字输入框
                  TextFormField(
                    // 初始值从 candidateRank（整数）转为字符串显示
                    initialValue: '$candidateRank',
                    // 键盘类型为数字，仅显示数字键盘
                    keyboardType: TextInputType.number,
                    // 输入框装饰：标签 + 辅助说明文字 + 边框样式
                    decoration: const InputDecoration(
                      labelText: '全省位次',
                      helperText: '推荐以位次为主要依据',
                      border: OutlineInputBorder(),
                    ),
                    // 输入值变化时尝试解析为整数，若解析失败则保留原值（不更新）
                    onChanged: (String value) {
                      candidateRank = int.tryParse(value) ?? candidateRank;
                    },
                  ),
                  const SizedBox(height: 20), // 输入框与保存按钮之间的间距
                  // 保存按钮：撑满宽度，使用主题填充色
                  SizedBox(
                    width: double.infinity, // 按钮宽度撑满容器
                    child: FilledButton(
                      // 点击后关闭弹窗并携带结果 (province, candidateRank) 返回给调用方
                      onPressed: () =>
                          Navigator.pop(context, (province, candidateRank)),
                      child: const Text('保存并更新推荐'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
