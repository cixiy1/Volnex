import 'app/app.dart';

// 程序入口函数 main，声明为 async 以支持异步初始化。
// 所有同步/异步初始化流程（存储、SDK、全局服务）均在 app() 中完成，
// 完成后启动 Flutter 应用。
void main() async {
  await app();
}
