#!/bin/bash
# GitHub 发布优化脚本
# 使用方法: ./publish.sh "提交信息"

set -e

# 检查参数
if [ -z "$1" ]; then
    COMMIT_MSG="update: 同步页面内容"
else
    COMMIT_MSG="$1"
fi

echo "📦 开始发布流程..."

# 1. 确保 index.html 是最新版本
echo "1️⃣ 同步 index.html..."
if [ -f "PRD_铺设目标柜机清单.html" ]; then
    cp "PRD_铺设目标柜机清单.html" index.html
    echo "   ✅ index.html 已更新"
else
    echo "   ⚠️ 未找到 PRD_铺设目标柜机清单.html"
    exit 1
fi

# 2. 检查 GitHub CLI 认证状态
echo "2️⃣ 检查 GitHub 认证..."
if ! /opt/homebrew/bin/gh auth status &>/dev/null; then
    echo "   ⚠️ GitHub 未登录，正在启动登录..."
    /opt/homebrew/bin/gh auth login
fi
echo "   ✅ GitHub 已认证"

# 3. 添加所有更改
echo "3️⃣ 添加文件到暂存区..."
git add -A
echo "   ✅ 文件已添加"

# 4. 检查是否有更改
if git diff --staged --quiet; then
    echo "   ℹ️ 没有需要提交的更改"
else
    # 5. 提交更改
    echo "4️⃣ 提交更改..."
    git commit -m "$COMMIT_MSG"
    echo "   ✅ 提交成功"

    # 6. 推送到 GitHub
    echo "5️⃣ 推送到 GitHub..."
    if git push origin main; then
        echo "   ✅ 推送成功！"
        echo ""
        echo "🎉 发布完成！请等待 1-2 分钟后访问:"
        echo "   https://taylochang.github.io/prd-alipay-P-N6D-V2.1/"
    else
        echo "   ❌ 推送失败，请检查网络后重试"
        echo "   重试命令: git push origin main"
        exit 1
    fi
fi

echo ""
echo "📋 提示: 如果推送失败，可以单独执行:"
echo "   git push origin main"
