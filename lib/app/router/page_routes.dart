import 'package:flutter/material.dart';

// 路由占位页面：便于路由立即可用，后续替换为 lib/pages 下的完整页面。

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('高校库')),
        body: const Center(child: Text('高校库页面（占位）')),
      );
}

// DataHubPage 已迁移至 lib/pages/app/data_hub_page.dart，路由配置也已同步更新。
// 此文件仅保留 LibraryPage 占位，后续替换。
