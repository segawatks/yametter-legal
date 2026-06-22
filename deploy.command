#!/bin/bash
# ヤメッター利用規約・プラポ デプロイスクリプト
# Finderでこのファイルをダブルクリックすると、GitHub(Pages)へ自動デプロイします。

# このスクリプトが置かれているフォルダへ移動
cd "$(dirname "$0")" || { echo "フォルダに移動できませんでした"; read -n1 -s; exit 1; }

echo "================================================"
echo " ヤメッター Legal デプロイ"
echo " $(pwd)"
echo "================================================"

# 1) 残留ロックファイルを除去（あれば）
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock 2>/dev/null

# 2) コミット作者が未設定なら設定
[ -z "$(git config user.name)" ]  && git config user.name  "segawa takeshi"
[ -z "$(git config user.email)" ] && git config user.email "rikodesign.segawa@gmail.com"

# 3) 変更をステージ
git add -A

# 4) 変更があればコミット（なければスキップ）
if git diff --cached --quiet; then
  echo "▶ 新しい変更はありません。未プッシュのコミットがあればプッシュします。"
else
  MSG="update $(date '+%Y-%m-%d %H:%M')"
  git commit -m "$MSG" && echo "▶ コミットしました: $MSG"
fi

# 5) プッシュ（GitHub Pages が自動デプロイ）
echo "▶ プッシュ中..."
if git push origin main; then
  echo ""
  echo "✅ デプロイ完了！ 1〜2分で反映されます:"
  echo "   https://segawatks.github.io/yametter-legal/"
else
  echo ""
  echo "❌ プッシュに失敗しました。GitHubの認証（ユーザー名／トークン）が必要な場合があります。"
fi

echo ""
echo "（このウィンドウは閉じて構いません。何かキーを押すと閉じます）"
read -n1 -s
