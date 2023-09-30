%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyparse();
void yyerror();
int yylineno;
%}

// Указываем возможные типы даннхы для семантических значений
%union {
    double d;
}

// Объявляем токен NUMBER и его тип
%token <d> NUMBER
%token EOL
// Указываем приоритетность
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

// Связываем нетерминал exp с типом double 
%type <d> exp

%%

// Указывем правила для стартового нетерминала
calclist: 
    | calclist exp EOL { printf("= %f\n", $2); 
    printf("> ");
    }
    | calclist EOL { printf("> "); }
;

// Указывем правила для создания выражений
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

int main(int argc, char** argv) {
    printf("> ");
    return yyparse();
}

void yyerror(char* s) {
    fprintf(stderr, "%d: error: ", yylineno);
    fprintf(stderr, "\n");
}