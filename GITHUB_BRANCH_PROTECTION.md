# GitHub 分支保护配置（main）

> 当前仓库尚未配置远程。仓库推送到 GitHub 后，按以下步骤为 `main` 开启保护。

## 前置：推送到 GitHub

```bash
# 1. 在 GitHub 新建空仓库（不要勾选 README/.gitignore 初始化）
# 2. 本地添加远程并推送
git remote add origin <你的仓库SSH/HTTPS地址>
git push -u origin main
git push -u origin dev-temp-20260721   # 如需保留临时分支
```

## 配置路径

GitHub 仓库页面 → **Settings → Branches → Branch protection rules → Add rule**

## 规则设置（对应你的三点要求）

| 设置项 | 操作 |
|--------|------|
| **Branch name pattern** | 填 `main` |
| **Require a pull request before merging** | ✅ 勾选（禁止直接推送的核心开关） |
| **Require approvals** | ✅ 设为 `1`（必须审核；可设 2 提高门槛） |
| **Dismiss stale approvals** | ✅ 建议勾选 |
| **Require status checks to pass before merging** | ✅ 勾选，并在下方搜索添加 CI 检查（如 `build` / `analyze`） |
| **Require branches to be up to date** | ✅ 勾选（避免落后于 main 的 PR 合入） |
| **Do not allow bypassing the above settings** | ✅ 勾选（含管理员也受约束，最严格） |
| **Restrict force pushes** | ✅ 自动随规则生效 |
| **Restrict deletions** | ✅ 勾选（禁止删除 main） |

## CI 编译检查（供上面"status checks"引用）

在仓库根目录添加 `.github/workflows/ci.yml`，每次 PR 自动跑 `flutter analyze` + 构建：

```yaml
name: CI
on:
  pull_request:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.x'
          channel: stable
      - run: flutter pub get
      - run: flutter analyze        # 静态检查（对应 "必须通过CI编译检查"）
      - run: flutter build apk --debug   # 或 flutter test
```

> 添加后，在分支保护规则的 **Require status checks** 里搜索并勾选 `build`（即该 workflow 的 job 名），未通过则 PR 无法合并。

## 日常协作流程

1. 从 `main` 拉临时分支：`git checkout -b dev-temp-YYYYMMDD`
2. 开发、提交（钩子自动格式化 + 校验提交信息）
3. 推送并发 **Pull Request** 到 `main`
4. 至少 1 人 Review 通过 + CI 绿 → 合并

## 备注

- 旧 `dev` 分支与 `main` 内容一致，可保留或删除（删除：`git branch -d dev`，需先切到其它分支）。
- 钩子目录 `.githooks/` 已随提交入库；新克隆者启用：`git config core.hooksPath .githooks`。
