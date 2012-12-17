#include <stdio.h>
#include <time.h>
#include "my_lib.h"
/*Linux Unixでコンパイルする場合はmy_lib.cをコンパイルしてオプションに加えてください 
Windowsでは自動で読まれます*/
#if _WIN32 || _WIN64
#include <Windows.h>
#pragma comment (lib, "my_lib.lib")
#endif
/*
GPLv3ライセンスです
copyright (C) 2012 α改 @alpha_kai_NET All rights reserved.
*/

int main(int argc,char *argv[]){

	time_t now = time(NULL);
	int num[2];
	int sum[2];
	FILE *fp;
	struct tm *pnow = localtime(&now);
    char week[][3] = {"日","月","火","水","木","金","土"};
	char buff[128]="";
	char filename[]="log.txt";
	int dum = 0;
	int kum = 1;
	int tmp[3] = {48,0,0};
	int zum = 0;
	
	//ふぁいるの存在チェック
	num[0]=check(filename);
	if(num[0]==1){
		fp=fopen(filename, "ab");
		sum[0]=1;
	}
	else if(num[0]==0){
		fp=fopen(filename, "wt");
		sum[0]=2;
	}
		else{
		printf("error FILE Check MISSING\n");
		fp=fopen(filename, "wt");
		
		sprintf(buff,"%d時:%d分:%d秒\n",
		pnow->tm_hour,
		pnow->tm_min,
		pnow->tm_sec);
		
		fprintf(fp, "ファイルチェック失敗 : %2d年%2d月%2d日(%s) %s\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
		
		printf("ファイルチェック失敗 : %2d年%2d月%2d日(%s) %s\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
	

		fclose(fp);
		//音を鳴らす
		onkai();
		sum[0] = 3;
	}
	
	//通常の呼び出しが行なわれたので表示
	sprintf(buff,"%d時:%d分:%d秒\n",
		pnow->tm_hour,
		pnow->tm_min,
		pnow->tm_sec);
	
	fprintf(fp, "{\n通常の呼び出し(ロガー本体の実行)が行なわれました : %2d年%2d月%2d日(%s) %s\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
	fclose(fp);
	
	
	/* 引数のオプション */
	/* argcが1のとき すなわちロガーが引数なしに起動した場合 */
	if(argc==1){
	kum = 0;
	}
	
	/* argcが3では無いとき なおかつ　argcが1の時は実行しない */
	if(argc!=3 && kum == 1){
	/* エラー */
	dum = 1;
	}
	
	if(argc==3){
	tmp[1] = *argv[1] - tmp[0];
	printf("argv[1]:%d\n", *argv[1]);
	printf("tmp[1]:%d\n", tmp[1]);
	if(tmp[1]==1){
		fp=fopen(filename, "ab");
		/* strを渡す */
		fprintf(fp, "%sを投稿しました\n", argv[2]);
		fclose(fp);
		zum = 1;
		//printf("%sを投稿しました\n", argv[2]);
	}
	else if(tmp[1]==2){
		fp=fopen(filename, "ab");
		/* strを渡す */
		fprintf(fp, "%s\n", argv[2]);
		fclose(fp);
		zum=2;
		//printf("%s\n", argv[2]);
	}
	}
	
	
	num[1]=result(filename);
	if(num[1]==1){
	printf("ファイルの読み込みは正常に行なわれました\n");
	fp=fopen(filename, "ab");
	
	sprintf(buff,"%d時:%d分:%d秒\n",
		pnow->tm_hour,
		pnow->tm_min,
		pnow->tm_sec);
	
	
	fprintf(fp, "ファイルの読み込みは正常に行なわれました : %2d年%2d月%2d日(%s) %s\n}\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
	fclose(fp);
	sum[1]=1;
	}
	else if(num[1]==0){
	printf("ファイルの読み込みに失敗しました\n");
	fp=fopen(filename, "ab");
	sprintf(buff,"%d時:%d分:%d秒\n",
		pnow->tm_hour,
		pnow->tm_min,
		pnow->tm_sec);
	
	fprintf(fp, "ファイルの読み込みに失敗しました : %2d年%2d月%2d日(%s) %s\n}\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
	fclose(fp);
	sum[1]=2;
	}
	else{
	printf("不明なエラー:result関数からの戻り値が異常です");
	fp=fopen(filename, "ab");
	sprintf(buff,"%d時:%d分:%d秒\n",
		pnow->tm_hour,
		pnow->tm_min,
		pnow->tm_sec);
	
	fprintf(fp, "不明なエラー:result関数からの戻り値が異常です : %2d年%2d月%2d日(%s) %s\n}\n",
        pnow->tm_year+1900,
	    pnow->tm_mon + 1,
	    pnow->tm_mday,
	    week[pnow->tm_wday],
		buff);
	fclose(fp);
	//音を鳴らす
	sum[1]=3;
	onkai();
	}
	
	//結果の表示
	switch(sum[0]){
	
		case 0:
		printf("不明なエラー\n");
		printf("sum[0]の値いに0が代入されて帰って来ました\n");
		printf("不明なエラーです\n");
		break;
	
		case 1:
		printf("正常\n");
		printf("\"log.txt\"ファイルが存在するため追記モードで書き込まれました\n");
		break;
		
		case 2:
		printf("正常\n");
		printf("\"log.txt\"ファイルが存在しないためファイルが作成されて新規書き込みモードで書き込まれました\n");
		break;
		
		case 3:
		printf("エラー発生\n");
		printf("カレントディレクトリの\"log.txt\"のファイルの存在チェックに失敗しました\n");
		break;
		
		default:
		printf("不明なエラー\n");
		printf("ファイルチェックの時に sum[0]に想定しない値いが代入されました\n");
		printf("不明なエラーです\n");
		break;
	}
	
	switch(sum[1]){
		
		case 0:
		printf("エラー\n");
		printf("sum[1]の値いに0が代入されて帰って来ました\n");
		printf("完全なエラーではない可能性がありますがたぶん大丈夫です\n");
		break;
		
		case 1:
		printf("正常\n");
		printf("ファイルの書き込みが正常に行なわれたのかの確認の為読み込みを行い、正常に書き込み・読み込みが正常に行なわれました\n");
		break;
		
		case 2:
		printf("正常\n");
		printf("ファイルの書き込みが正常に行なわれたのかの確認の為読み込みを行い、正常に書き込み・読み込みに失敗しました\n");
		break;
		
		case 3:
		printf("不明なエラー\n");
		printf("result関数からの返り値が異常です\n");
		printf("不明なエラーが発生しました\n");
		break;
		
		default:
		printf("不明なエラー\n");
		printf("ファイルチェックの時に sum[0]に想定しない値いが代入されました");
		printf("不明なエラーが発生しました\n");
		break;
	}

	if(zum==1){
		printf("正常\n");
		printf("%sを投稿しました\n", argv[2]);
	}
	else if(zum==2){
	printf("正常\n");
	printf("文字列:\"%s\"を書き込みました\n", argv[2]);	
	}
	
	if(dum==1){
	printf("\nError:\n");
	printf("コマンドライン引数の数が間違っています\n");	
	printf("\a");
	}
	
	return 0;
}
