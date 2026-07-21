# Git Commit 规范

## Commit Message 格式

采用 Conventional Commits 规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type 类型

- **feat**: 新功能
- **fix**: 修复 bug
- **docs**: 文档更新
- **style**: 代码格式调整（不影响功能）
- **refactor**: 重构（既不是新功能也不是修复）
- **perf**: 性能优化
- **test**: 测试相关
- **chore**: 构建过程或辅助工具的变动
- **revert**: 回滚之前的 commit

## Scope 范围

根据项目模块指定，例如：
- `router`: 路由相关
- `ui`: UI 组件
- `page`: 页面
- `controller`: 控制器
- `model`: 数据模型
- `theme`: 主题

## Subject 主题

- 使用现在时态（如 "add" 而非 "added"）
- 首字母小写
- 结尾不加句号
- 简洁描述做了什么

## Body 正文

- 详细描述本次提交的内容
- 说明为什么做这个修改
- 可以分多行

## Footer 脚注

- 关联的 Issue 编号
- 破坏性变更说明

## 示例

### 新功能
```
feat(router): 添加高校详情页路由

- 新增 /university/:id 路由
- 添加 UniversityDetailShell 布局组件
- 支持路径参数传递高校 ID

Closes #123
```

### 修复 bug
```
fix(ui): 修复 PageHeader 在无 AppBar 时显示异常

- 调整布局结构使用 ListView
- 移除嵌套的 Scaffold
- 统一 padding 规范
```

### 文档更新
```
docs: 更新路由配置说明文档

- 添加路由参数说明
- 补充使用示例
```

### 重构
```
refactor(page): 重构高校详情页信息展示

- 将信息项提取为列表方法
- 封装间距到组件内部
- 便于后续数据对接
```

## 注意事项

1. **每次提交只做一件事** - 不要在一个 commit 中混合多个不相关的修改
2. **提交信息要清晰** - 让其他人能理解你做了什么以及为什么
3. **及时提交** - 完成一个功能单元就提交，不要堆积太多修改
4. **避免提交临时文件** - 如 .DS_Store、*.log 等
5. **代码审查前自测** - 确保代码能正常运行

## 常用命令

```bash
# 查看提交历史
git log --oneline

# 查看最近一次提交
git show HEAD

# 修改最后一次提交信息
git commit --amend

# 暂存当前修改
git stash

# 恢复暂存的修改
git stash pop
```
