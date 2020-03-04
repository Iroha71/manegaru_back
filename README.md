# README

## ngrokを使うときに変更する場所

### front
* `.env`
    - `BASE_URL` = バックngrokのurl
        - ajaxのベースurlで使用

### back
* `.env`
    - `CLIENT_URL` = フロントのurl
        - メール認証後のリダイレクト先・LINE送信するurl
    - `NGROK_URL` = バックのurl
        - ngrokのforbidden対策
### LINE DEV
* `LIFF`
    - エンドポイントurl (フロントのngrok url)
* `BOT`
    - コールバックurl (バックのngrok url)
