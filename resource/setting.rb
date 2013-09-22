#encoding: utf-8

#バージョン
VERSION="0.7.1α_Rb"
# コンシュマーキーとアクセストークン
CONSUMER_KEY        = ""
CONSUMER_SECRET     = ""
ACCESS_TOKEN        = ""
ACCESS_TOKEN_SECRET = ""

BOT_DEBUG=true

#admins
#管理者のID 配列化してあるので、複数ユーザーを設定可能
ADMINS=[""]

#commands
COMMANDS=["reboot","stop","再起動","停止","開眼","気分","天気","ふぁぼれよ","バージョン","ver"]

#botの設定
#botのID(@を含める)
BOTNAME_ID=""
#botのIDから、@を外したもの
BOTNAME_ID_NOAT=BOTNAME_ID.delete("@").to_s
#botの表示名 Ex:てふてふ
BOTNAME_HN="