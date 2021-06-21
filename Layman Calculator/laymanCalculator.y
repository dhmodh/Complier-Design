%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    extern int yylex();
    extern int yychar, yylineno;
    int yyerror(const char *s);
    float answer[50];
    int ans_index=0;
%}

%start program
%token <number> NUMBER
%token <word> WORD
%token <id> ID
%token START END DECLARE ASSIGN ANSWER RESULT ADD SUB MUL DIV DOT QMARK
%define parse.error verbose
%union{
    float number; 
    char word[30];
    char id[2];
}

%%

program:    
        START statements END    { 
                                    printf("#Successfully Compiled.\n"); 
                                }
    |   /* nothing */
    ;

statements: 
        statement statements
    |   /* nothing */
    ;

statement:  
        declarestmt
    |   assignstmt
    |   operationstmt
    |   operationonanswerstmt
    |   resultstmt
    ;

declarestmt:
        DECLARE ID DOT  {
                            printf("ID %s Declared.\n", $2);
                        }
    ;

assignstmt:
        ASSIGN NUMBER WORD ID DOT   {   if(strcmp($3, "TO")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $3);
                                            yyerror(msg);
                                        }
                                        printf("Value %f is assigned to ID %s.\n", $2, $4);
                                    }
    ;

operationstmt:
        ADD NUMBER WORD NUMBER DOT  {
                                        if(strcmp($3, "TO") && strcmp($3, "WITH")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $3);
                                            yyerror(msg);
                                        }
                                        answer[ans_index++] = $2 + $4;
                                        printf("%f is added in %f and answer is %f.\n", $4, $2, answer[ans_index-1]);
                                    }
    |   SUB NUMBER WORD NUMBER DOT  {
                                        if(strcmp($3, "FROM")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $3);
                                            yyerror(msg);
                                        }
                                        answer[ans_index++] = $4 - $2;
                                        printf("%f is subtracted from %f and answer is %f.\n", $2, $4, answer[ans_index-1]);
                                    }
    |   MUL NUMBER WORD NUMBER DOT  {
                                        if(strcmp($3, "TO") && strcmp($3, "WITH")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $3);
                                            yyerror(msg);
                                        }
                                        answer[ans_index++] = $2 * $4;
                                        printf("%f is multipled with %f and answer is %f.\n", $2, $4, answer[ans_index-1]);
                                    }
    |   DIV NUMBER WORD NUMBER DOT  {
                                        if(strcmp($3, "BY")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $3);
                                            yyerror(msg);
                                        }
                                        answer[ans_index++] = $2 / $4;
                                        printf("%f is divided by %f and answer is %f.\n", $2, $4, answer[ans_index-1]);
                                    }
    ;

resultstmt:
        WORD WORD RESULT QMARK  {
                                    if(strcmp($1, "WHAT")){
                                        char msg[256];
                                        sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $1);
                                        yyerror(msg);
                                    }
                                    if(strcmp($2, "IS")){
                                        char msg[256];
                                        sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $2);
                                        yyerror(msg);
                                    }
                                    printf("The final result : %f.\n", answer[ans_index]);
                                    printf("Final result displayed.\n");
                                }
    ;

operationonanswerstmt:
        WORD ADD WORD ANSWER DOT    {
                                        if(strcmp($1, "NOW")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $1);
                                            yyerror(msg);
                                        }
                                        float tmp=answer[0];
                                        for(int i=1; i<ans_index; i++)
                                            tmp += answer[i];
                                        answer[0]=tmp;
                                        ans_index=0;
                                        printf("%s answer are added\n", $3);
                                    }
    |   WORD SUB WORD ANSWER DOT    {
                                        if(strcmp($1, "NOW")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $1);
                                            yyerror(msg);
                                        }
                                        float tmp=answer[0];
                                        for(int i=1; i<ans_index; i++)
                                            tmp -= answer[i];
                                        answer[0]=tmp;
                                        ans_index=0;
                                        printf("%s answer are subtracted\n", $3);
                                    }
    |   WORD MUL WORD ANSWER DOT    {
                                        if(strcmp($1, "NOW")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $1);
                                            yyerror(msg);
                                        }
                                        float tmp=answer[0];
                                        for(int i=1; i<ans_index; i++)
                                            tmp *= answer[i];
                                        answer[0]=tmp;
                                        ans_index=0;
                                        printf("%s answer are multipled\n", $3);
                                    }
    |   WORD DIV WORD ANSWER DOT    {
                                        if(strcmp($1, "NOW")){
                                            char msg[256];
                                            sprintf(msg, "Semantic Error : <Invalid token : \'%s\'>", $1);
                                            yyerror(msg);
                                        }
                                        float tmp=answer[0];
                                        for(int i=1; i<ans_index; i++){
                                            if(answer[i]==0.0 || tmp==0.0){
                                                char msg[256];
                                                sprintf(msg, "Math error : Divide by 0 due to answer number %d.\n", i+1);
                                                yyerror(msg);
                                            }
                                            tmp /= answer[i];
                                        }
                                        answer[0]=tmp;
                                        ans_index=0;
                                        printf("%s answer are divided\n", $3);
                                    }
    ;

%%

void main(int argc, char *argv[]){
	if(argc != 2){
		printf("Enter this way please : ./a.out filename\n");
		exit(0);
	}
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	printf("\n");
}

int yyerror(const char *errormsg)
{
    fprintf(stderr, "at line %d :- %s\n", yylineno, errormsg);
    exit(1);
}
