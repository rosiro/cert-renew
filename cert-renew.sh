#!/bin/bash
# SSL証明書自動更新スクリプト
# 使い方: ./renew_ssl.sh example.com [example2.com ...]

set -euo pipefail

LOG_FILE="/var/log/certbot-renew.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使い方: $0 <ドメイン名> [ドメイン名2 ...]"
    echo "例: $0 example.com www.example.com"
    exit 1
fi

log() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

log "===== SSL証明書更新開始 ====="

for DOMAIN in "$@"; do
    log "ドメイン: ${DOMAIN} の証明書を更新中..."

    if certbot renew --cert-name "$DOMAIN" --quiet --no-self-upgrade 2>>"$LOG_FILE"; then
        log "${DOMAIN}: 更新成功（または更新不要）"
    else
        log "${DOMAIN}: 更新失敗（終了コード: $?）"
    fi
done

# Webサーバー再読み込み（該当するものだけ実行）
if systemctl is-active --quiet nginx 2>/dev/null; then
    log "nginxを再読み込み中..."
    systemctl reload nginx
    log "nginx再読み込み完了"
elif systemctl is-active --quiet httpd 2>/dev/null; then
    log "Apacheを再読み込み中..."
    systemctl reload httpd
    log "Apache再読み込み完了"
elif systemctl is-active --quiet apache2 2>/dev/null; then
    log "Apacheを再読み込み中..."
    systemctl reload apache2
    log "Apache再読み込み完了"
fi

log "===== SSL証明書更新完了 ====="
