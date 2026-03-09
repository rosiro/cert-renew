# 主な機能

引数で複数ドメイン指定可能  
nginx / Apache を自動検出して再読み込み  
/var/log/certbot-renew.log にログ出力  

```
/usr/local/bin/cert-renew.sh www.example.com
```

```
スクリプトを /usr/local/bin/ に配置して実行権限付与
sudo crontab -e で毎日AM3:00実行に設定
certbot renew --dry-run でドライラン確認
```

