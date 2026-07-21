// 考生档案弹窗（底部表单）：允许用户输入省份、位次等信息
//
// 说明：
// - 本工具类封装了一个静态方法 `show`，用于在任意页面弹出底部表单，采集用户的省份与全省位次；
// - 返回值为 Tuple2(String province, int rank) 的可空值；当用户取消时返回 null，确认保存时返回新值。
// - 注意：使用该方法时，调用者应根据返回值判断是否需要更新全局控制器（例如 HomeController）。
import 'package:flutter/material.dart';

class ProfileSheet {
  /// 显示档案弹窗，返回用户保存后的 (省份, 位次)
  ///
  /// 参数说明：
  /// - [context]：当前 BuildContext，用于 showModalBottomSheet 的显示与导航上下文；
  /// - [initialProvince] 与 [initialRank]：作为表单的初始值，便于用户在已有档案的情况下快速调整。
  ///
  /// 返回：用户点击保存时返回 `(province, candidateRank)`，点击取消返回 null。
  static Future<(String, int)?> show(
    BuildContext context, {
    required String initialProvince,
    required int initialRank,
  }) {
    String province = initialProvince;
    int candidateRank = initialRank;

    return showModalBottomSheet<(String, int)?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                const Text('完善考生档案', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: province,
                  decoration: const InputDecoration(labelText: '高考省份', border: OutlineInputBorder()),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: '浙江', child: Text('浙江')),
                    DropdownMenuItem(value: '江苏', child: Text('江苏')),
                    DropdownMenuItem(value: '山东', child: Text('山东')),
                    DropdownMenuItem(value: '广东', child: Text('广东')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setSheetState(() => province = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  initialValue: '$candidateRank',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '全省位次',
                    helperText: '推荐以位次为主要依据',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    candidateRank = int.tryParse(value) ?? candidateRank;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, (province, candidateRank)),
                    child: const Text('保存并更新推荐'),
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
