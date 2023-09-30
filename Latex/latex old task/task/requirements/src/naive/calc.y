%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern void yyerror();
extern int yylineno;
extern void yy_scan_string(const char* str);
%}

%union {
    double d;
}

%token <d> NUMBER
%token EOL

%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <d> exp

%%

calclist: 
    | calclist exp EOL { printf("= %f\n", $2); 
    }
    | calclist EOL { }
;

exp:  exp '+' exp {$$ = $1 + $3; }
    | exp '-' exp {$$ = $1 + $3; }
    | exp '*' exp {$$ = $1 * $3; }
    | exp '/' exp {$$ = $1 / $3; }
    | '|' exp {$$ = $2 >= 0? $2 : - $2; }
    | '(' exp ')' {$$ = $2; }
    | '-' exp %prec UMINUS { $$ = -$2; }
    | NUMBER {$$ = $1; }
;   

%%


char* terminateString(char* str) {
    char* src = malloc((strlen(str) + 1) * sizeof(char));
    strcpy(src, str);
    src[strlen(str)] = '\n';
    return src;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        fprintf(stderr, "Bad arguments");
        return -1; 
    }
    char* testString = terminateString(argv[1]);
    int repeats = atoi(argv[2]);
    for (int i = 0; i < repeats; ++i) {

        yy_scan_string(testString);
        yyparse();
    }
    return 0;
}

void yyerror(char* s) {
    fprintf(stderr, "%d: error: ", yylineno);
    fprintf(stderr, "\n");
}