%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include <string.h>
int yylex();
int yyparse(struct node** root);
extern void yy_scan_string(const char* str);

%}

%union {
    struct node* a;
    double d;
}

%token <d> NUMBER
%token EOL

%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS
%param {struct node** root}

%type <a> exp

%%

calclist: 
    | calclist exp EOL { *root = $2; }
    | calclist EOL { }
;

exp: exp '+' exp {$$ = newast('+', $1, $3); }
    | exp '-' exp {$$ = newast('-', $1, $3); }
    | exp '*' exp {$$ = newast('*', $1, $3); }
    | exp '/' exp {$$ = newast('/', $1, $3); }
    | '|' exp {$$ = newast('|', $2, NULL); }
    | '(' exp ')' {$$ = $2; }
    | '-' exp %prec UMINUS { $$ = newast('M', $2, NULL); }
    | NUMBER {$$ = newnum($1); }
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
    const char* testString = terminateString(argv[1]);
    int repeats = atoi(argv[2]);
    node* result;
    yy_scan_string(testString);
    yyparse(&result);
    
    for (int i = 0; i < repeats; ++i) {
        printf("%f\n" , eval(result));  
    }
    treefree(result);
    return 0;
}

void yyerror(struct node** root, char* s) {
    fprintf(stderr, "%d: error: ", yylineno);
}