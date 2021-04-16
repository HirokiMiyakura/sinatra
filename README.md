### 注意

本アプリケーションはsinatraおよびpostgresqlを利用して作成しております。
dbのインストールおよびデータベースへの接続方法については、
公式ページをご確認ください。

http://sinatrarb.com/

https://www.postgresql.org/

# ご利用前に以下のコマンドを実行してください

### 1. データベースの作成

`CREATE DATABASE memoapp;`

### 2. テーブルの作成

```
CREATE table memo (
  id serial not null,
  title varchar(255) not null,
  body text not null,
);
```
