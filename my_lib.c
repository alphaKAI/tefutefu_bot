#include "my_lib.h"
//インクルード及びプロトタイプ宣言
/* make_stirng関数 sleep */
#if __unix || __linux || __FreeBSD__ || __NetBSD__
#include <unistd.h>
#define SLEEP3 sleep(3)
#endif
#if _WIN32 || _WIN64
#include <windows.h>
#define SLEEP3 sleep(3000)
#endif

/*
α改の自分向けのライブラリ
他人が使うこととか想定してない
一応ライセンスはGPLv3
copyright (C) 2012 α改 @alpha_kai_NET ALL rights reserved. http://alpha-kai-net.info
*/


/*
now_time_string関数は以下のように使う
char *num;
num=now_time_string();
これでnumに現在時刻のでーたが入る
printf("%s\n", num);
あとは↑こんなかんじとかいろいろで使える
*/
/* ReturnStrings関数
使い方
char filename[] = "ファイル名";
	char str[1000];
	取得したい行数
	int get_line;
	返り値
	int return_sum;

	printf("取得したい行数\n");
	printf(">");
	scanf("%d", &get_line);
	
return_sum = ReturnStrings(filename, get_line, str, 1000);
*/
/* make_string関数
使い方
Return_stringと基本同じだが取得行数は指定しなくていい
あとから書くかも
*/

/* キー入力待ち機構 */
int pause(void){

	int c;  
    c = getchar();  
    putchar(c);  
	return 0;
}

/* ファイルチェック機構 */
int check(const char *name){
	
	FILE *fcheck;

	int check;

	if ((fcheck = fopen(name,"r")) != NULL) {
	fclose(fcheck);
		/* ファイルが存在する */
		check=1;
	}
	else{
		/* ファイルが存在しない */
		check=0;
	}

	return check;

}

/* ファイルデリート機構 */
int del(const char *name){
	int var;
	
  if( remove( name ) == 0 ){
    printf( "%sファイルを削除しました\n", name);
	var=1;
  }
  else{
    printf( "ファイル削除に失敗しました\n");
	var=0;
  }
  return var;
}

/* 結果をリザルトを読み込む */
int result(const char *name){
    
	int num=0;
	FILE *open;
    char str[1024];
	
	open = fopen(name,"r");

    if(open==NULL){

        /* 失敗を表示し終了 */

        printf("ファイルの読み込みに失敗しました\n");
		
		num=0;
		return num;
    }

    /* fgetsの戻り値がnullになるまで続ける */

    /* strにファイルからバイト取得し格納 */

    while((fgets(str,256,open))!=NULL){

        /* 格納された文字を出力 */

        printf("%s",str);

		num=1;
		
    }
    /* ファイルを閉じる */
    fclose(open);

    return num;
}

/* ビープ音 */
int onkai(void){
	
	int i;
	i=0;
	while(i<=100){
	printf("\a");
	}

return 0;
}

/* 現在時刻表示 */
int now_time(void){
    time_t now = time(NULL);
    struct tm *pnow = localtime(&now);
    char week[][3] = {"日","月","火","水","木","金","土"};
	char buff[128]="";
	
	/* 時:分:秒の取得 */
	sprintf(buff,"%d時:%d分:%d秒 です\n",
	pnow->tm_hour,
	pnow->tm_min,
	pnow->tm_sec);
	
	printf("現在は%2d年%2d月%2d日(%s) %s",
    pnow->tm_year+1900,
	pnow->tm_mon + 1,
	pnow->tm_mday,
	week[pnow->tm_wday],
	buff);
	
	return 0;
}

/* 現在時刻を文字列として返す */
char *now_time_string(void){
    time_t now = time(NULL);
    struct tm *pnow = localtime(&now);
    char week[][3] = {"日","月","火","水","木","金","土"};
	char buff[128]="";
	char *num;
	char num2[260];
	num = malloc(260);
	
	
	//時:分:秒の取得
	sprintf(buff,"%d時:%d分:%d秒",
	pnow->tm_hour,
	pnow->tm_min,
	pnow->tm_sec);
	
	sprintf(num2, "%2d年%2d月%2d日(%s) %s",
    pnow->tm_year+1900,
	pnow->tm_mon + 1,
	pnow->tm_mday,
	week[pnow->tm_wday],
	buff);
	
	strcpy(num,num2);
	return num;
}

/* 任意のファイルの行数を返す */
int how_line(const char *name){
	
	FILE *fi;
	char ch;
	int inc=1;
	int line=0;
	int ncr=0;

	fi = fopen(name,"r");
	
while((ch = fgetc(fi)) != EOF){

	line += inc; inc = 0;
		
		if(ch=='\n'){
		inc = 1;
		ncr++;
		}
}
	/* printf("行数 = %d\n", line); */
	/* printf("改行 = %d\n", ncr);  */
	
	fclose(fi);
	return line;
}

/* GetRandom関数 引数には最大値を渡す */
int GetRandom(int const max){
	
	int num, i;
	int k=0;
	int sum[10];
	int result;
	srand((unsigned)time(NULL));
	
while(k!=1){
	for(i=1; i<9; i++){
	sum[i] = rand() %max+1;
	}
	num = rand() % 9 + 1;

	result=sum[num];
	
	if(max < result){
		printf("Error\n");
		printf("理由:\n生成された乱数の返り値の変数resultの値が\n乱数生成の最大値の引数 max変数より大きかったため値が異常です\n", num);
		printf("参考用:%d\n", result);
		printf("再試行します\n\n");
		result = 0;
		num = 0;
		for(i=1; i<9; i++){
		sum[i] = 0;
		}
		
	}
	else{
		printf("乱数は正常に生成されました\n");
		k = 1;
	}
}
	printf("Result:%d\n",result);
	return result;

}

/* ReturnStrings関数 */
int ReturnStrings(const char* path, const int num, char* buf, const int size){
    int cnt = 0;
    FILE* file = NULL;

    if ((file = fopen(path, "r")) == NULL)
        return -1;
		//ファイルチェック失敗
    while (fgets(buf, size, file) != NULL && num > ++cnt);
    fclose(file);

    if (num != cnt)
    {
        for (cnt = 0; cnt < size; ++cnt)
            buf[cnt] = 0;
        return -2;
		//データ取得失敗
    }

    return 0;
}

/* make_string関数 */
int make_string(const char *filename, char *buf, const int size){

	int i;
	int sum;
	int dum;
	int ck;
	char str[1000];
	int get_line;
	int return_sum;
	int count;
	count=1;
	i=0;
	
	/* ファイルチェック */
	ck=check(filename);
	if(ck==0){
	printf("ERROR:\n");
	printf("読み込み対象のファイルが存在しません\n");
	return 1;
	}
	else if(ck==1){
		/* 引数のファイル名の行数取得 */
		sum = how_line(filename);
		/* 文字列のメモリサイズの上限(?) */
		dum=GetRandom(size);
		while(i!=1){
		printf("%d==============\n", count);
			get_line=GetRandom(sum);
			return_sum = ReturnStrings(filename, get_line, str, 1000);
		if(return_sum==-1){
			printf("ERROR:\n");
			printf("Return_Strings関数でファイルオープンに失敗しました\n");
		return -1;
		}
		else if(return_sum==-2){
			printf("ERROR:\n");
			printf("Return_Strings関数でデータ取得に失敗しました\n");
		return -2;
		}
	
		/* 文字列連結 */
		strcat(buf,str);
		/* 最大上限より大きいのでi=1で終了 */
		if(sizeof(buf)>=dum){
			break;
		}
			SLEEP3;
			count++;
			/* 改行削除 */	
			strtok(buf,"\n\0");
		}
	}
	else{
	printf("ERROR:\n");
	printf("check関数からの返り値が異状です\n");
	return 2;
	}
	
	return 0;
}
