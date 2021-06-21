%{
	#include<stdio.h>
	#include "y.tab.h"
	#include<stdlib.h>
	extern int yylineno;
	extern int yyerror(const char *s);
%}

letter		[A-Z]
digit			[0-9]
whitespace		[ \t\r]+
keyword		#START|#END|DECLARE|ASSIGN|ANSWER|RESULT
id			{letter}{digit}
operation		ADD|SUB|MUL|DIV
word			{letter}+
number		{digit}+(\.{digit}+)?
eol			[\.?]?{whitespace}?[\n]+
comment		"**"[^\n]*

%%

{keyword}	{  
			if(!strcmp(yytext, "#START")){
				return START;
			}else if(!strcmp(yytext, "#END")){
				return END;
			}else if(!strcmp(yytext, "DECLARE")){
				return DECLARE;
			}else if(!strcmp(yytext, "ASSIGN")){
				return ASSIGN;
			}else if(!strcmp(yytext, "ANSWER")){
				return ANSWER;
			}else if(!strcmp(yytext, "RESULT")){
				return RESULT;
			}
		}
{operation}	{ 
			if(!strcmp(yytext, "ADD")){
				return ADD;
			}else if(!strcmp(yytext, "SUB")){
				return SUB;
			}else if(!strcmp(yytext, "MUL")){
				return MUL;
			}else if(!strcmp(yytext, "DIV")){
				return DIV;
			}
		}
{id}		{ 
			strcpy(yylval.id, yytext); 
			return ID; 
		}
{word}	{ 
			strcpy(yylval.word, yytext); 
			return WORD; 
		}
{number}	{ 
			yylval.number=atof(yytext); 
			return NUMBER; 
		}
{eol}		{ 
			if(yytext[0]=='.'){
			return DOT;
			}else if(yytext[0]=='?'){
				return QMARK;
			} 
		}
{comment}	{ }
{whitespace}	{ }
.		{ 
			char msg[256];
			sprintf(msg, "Lexical Error : <Invalid symbol : \'%c\'>", yytext[0]);
			yyerror(msg);
		}
%%

int yywrap(void){
	return 1;
}
