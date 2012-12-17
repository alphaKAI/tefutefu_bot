/* ORIGINAL */
/* Last Modified: July 5, 2012. by Plemling138 */
/* ctwt.c  ---   Tweet sample on C
   Copyright (C) 2012 Plemling138

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
*/
/*
  Usage: 
  ./tweet [status]
  -Enable Multi-byte text
  -NOT package character count
  (Perhaps overflow buffer)
  
  -If Status-update success:
  return HTTP/1.0 200 and XML data
  -If any:
  return HTTP Error code
*/ 

/*
α改 @alpha_kai_NET
勝手に改造させていただいています版・・・
最初のORIGINALはかってに書き込みました
人の書いたライブラリを使うのは初めてなのでよくわからないので残しておきました
もともと書いてあったぶぶんはこめんとアウトにして有ります
↓かいていいのかわかりませんが一応・・・
copyright (C) 2012 α改 @alpha_kai_NET All rights reserved.
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "twilib.h"
#include "my_lib.h"

void RemoveReturn(char *str, int size)
{
  int i=0;
  while(str[i] != 0 && i != size) {
    if(str[i] == '\r' || str[i] == '\n') str[i] = 0;
    i++;
  }
}

//int main(int argc, char *argv[])
int main(void)
{
  int errcode = 0;
  char pin[20] = {0};
  char *errcode_c = 0;
  FILE *access_token;
  //α改の勝手に追加
  FILE *fp;
  char num[260];
  char post_string[100];
  char filename[]="data.txt";
  //ファイルチェックの返り値
  int sum;
  //ファイル読み込みとかの返り値
  int kum;
  //ファイルチェックの時の返り値によって処理をキメる的な
  int dum;
  //行数チェック
  int zum;
  //乱数の返り値
  int var;
  //ロガー呼び出しのとこ
  char logger[] = "./tefutefu_log";
  //updateに渡すポインタ
  char *str;
  //ここまで
    
  char usr[20] = {0}, id[20] = {0}, token[150] = {0}, secret[150] = {0};
  
  /*
  if(argc != 2) {
    printf("Usage: ./tweet [Tweet text]\n");
    exit(0);
  }
  */
  

  struct Twitter_consumer_token *c;
  struct Twitter_request_token *r;
  struct Twitter_access_token *a;

  c = (struct Twitter_consumer_token *) calloc(1, sizeof(struct Twitter_consumer_token));
  r = (struct Twitter_request_token *) calloc(1, sizeof(struct Twitter_request_token));
  a = (struct Twitter_access_token *) calloc(1, sizeof(struct Twitter_access_token));

  //取得したコンシューマキーとコンシューマシークレットをセットする
  /* char consumer_key[] = "[Consumer Key]"; */
  /* char consumer_secret[] = "[Consumer Secret]"; */
  /*てふてふ(C言語のbot)CK*/
  char consumer_key[] = "9qjaaynB6iZ5jjbj77vQg";
  /*てふｔ(ry CS*/
  char consumer_secret[] = "btaHirIHyJG9496n5nYlaaO4b3WyirxVo0Up3CsQ";
 
  c->consumer_key = consumer_key;
  c->consumer_secret = consumer_secret;

  //アクセストークンを保存する
  access_token = fopen("access_token.txt", "r");
  
  if(access_token == NULL) {
    //リクエストトークン取得
    printf("リクエストトークンの取得を行います。\n");

    printf("接続中です...");
    if(errcode = Twitter_GetRequestToken(c, r), errcode < 0){
      printf("\nリクエストトークンの取得でエラーが発生しました\n");
      if(errcode < -8) printf("エラーコード:%d（通信エラー）\n", errcode);
      else  printf("エラーコード:%d（内部処理エラー）\n", errcode);
      exit(0);
    }
    
	//α改が勝手に追加したカレントディレクトリにPINコード取得用のURLを吐き出させるTXTを生成させるもの
	fp=fopen("Access.txt", "w");
	sprintf(num, "%s%s", "https://api.twitter.com/oauth/authorize?oauth_token=", r->request_token);
	fprintf(fp, "%s\n", num);
	fclose(fp);
	//ここまで
	
	
    printf("OK.\n%s%s にアクセスしてPINコードを取得してください。\nPIN:", "https://api.twitter.com/oauth/authorize?oauth_token=", r->request_token);
    if(scanf("%19s%*[^\n]", pin) == -1) {
      printf("入力エラーです。\n");
      exit(EXIT_FAILURE);
    }
    a->pin = pin;

    printf("アクセストークンを取得しています...");
    if(errcode = Twitter_GetAccessToken(c, r, a), errcode < 0) {
      printf("\nアクセストークンの取得でエラーが発生しました。\n");
      if(errcode < -8) printf("エラーコード:%d（通信エラー）\n", errcode);
      else  printf("エラーコード:%d（内部処理エラー）\n", errcode);
      exit(0);
    }
    
	sum=check(filename);
	if(sum==1){
	access_token = fopen("access_token.txt", "ab");	
	}
	else{
	access_token = fopen("access_token.txt", "wt");
	}
    if(access_token == NULL) {
      printf("Error\n");
      exit(0);
    }
    fprintf(access_token, "%s\n%s\n%s\n%s\n%s\n", a->screen_name, a->user_id, a->access_token, a->access_secret, a->pin);
    fclose(access_token);
  }

  else {
    //ファイルから必要な情報を取り出す
    if(errcode_c = fgets(usr, 20, access_token), errcode_c == NULL) return -1;
    if(errcode_c = fgets(id, 20, access_token), errcode_c == NULL) return -1;
    if(errcode_c = fgets(token, 150, access_token), errcode_c == NULL) return -1;
    if(errcode_c = fgets(secret, 150, access_token), errcode_c == NULL) return -1;
    if(errcode_c = fgets(pin, 20, access_token), errcode_c == NULL) return -1;
    
    RemoveReturn(usr, 20);
    RemoveReturn(id, 20);
    RemoveReturn(token, 150);
    RemoveReturn(secret, 150);
    RemoveReturn(pin, 20);
  
    a->user_id = usr;
    a->access_token = token;
    a->access_secret = secret;
    a->pin = pin;
    fclose(access_token);
  }
  
  printf("OK.\nログイン完了 現在は右のユーザーでログインしています %s(ID:%s)\n", a->screen_name, a->user_id);
	
	//α改が書きましたｧ ==BOTの機関部==
	//ろがーの実行
	system(logger);
	//ファイルチェック
	sum=check(filename);
	if(sum==1){
	dum=1;
	}
	else{
	dum=0;
	printf("ファイルを読み込めませんでした\n");
	system("./tefutefu_log 2 エラー:ファイルを読み込めませんでした");
	onkai();
	return 0;
	}
	
	if(dum==1){
	//ファイル読み込み
	//ファイルのパス, 取得する行数, 返す変数(?)(自分で書き換えたけどよくわかってない), 読み込む最大文字数140字分
	zum = how_line(filename);
	var = GetRandom(zum);
	//kum = ReturnStrings(filename, var, post_string, 140);
	ReturnStrings(filename, var, post_string, 1000);
	
	//str = &post_string;

	}
	else{
	printf("学習ファイル(現在は学習の昨日は未実装のため語句ふぁいるです)が見つかりませんでした\n");
	printf("終了します\n");
	return 0;
	}
	if(kum==0){
	printf("正常に学習ファイルを読み込みました\n");
	}
	else if(kum==-1){
	printf("ファイルオープンに失敗しました");
	}
	else if(kum==-2){
	printf("データの取得に失敗しました");
	}
	else{
	printf("不明なエラーが発生しました\n");
	}	
	//ここまで
	
	
	
  printf("ツイートしています...");
  /* if(errcode = Twitter_UpdateStatus(c, a, argv[1]), errcode < 0) */
  if(errcode = Twitter_UpdateStatus(c, a, post_string), errcode < 0) {
    printf("\nツイートでエラーが発生しています\n");
    if(errcode < -8){
	system("./tefutefu_log 2 エラーが発生しました\n通信エラーが発生しました\n");
	printf("エラーコード:%d（通信エラー）\n", errcode);
	}
    else{
	printf("エラーコード:%d（内部処理エラー）\n", errcode);
	system("./tefutefu_log 2 エラーが発生しました\n内部エラーが発生しました\n");
	}
    exit(0);
  }
  else{
  system("./tefutefu_log 1 \n");
  printf("OK.\nツイートに成功しました。\n");
  }

	printf("post:%s\n", post_string);
	
  return 0;
}
