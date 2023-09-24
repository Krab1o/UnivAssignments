%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include "arena_ast.h"

int yylex();
int yyparse(arena*, node**);
extern void yy_scan_string(const char* str);

%}

%union {
    unsigned int a;
    double d;
}

%token <d> NUMBER
%token EOL

%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS
%param { arena* arena } {node** root}

%type <a> exp

%code requires {
    #include "arena.h"
}

%%

calclist: 
    | calclist exp EOL { *root = arena->arena + $2; }
    | calclist EOL { }
;

exp: exp '+' exp {$$ = newast(arena, '+', $1, $3); }
    | exp '-' exp {$$ = newast(arena, '-', $1, $3); }
    | exp '*' exp {$$ = newast(arena, '*', $1, $3); }
    | exp '/' exp {$$ = newast(arena, '/', $1, $3); }
    | '|' exp {$$ = newast(arena, '|', $2, -1); } 
    | '(' exp ')' {$$ = $2; }
    | '-' exp %prec UMINUS {$$ = newast(arena, 'M', $2, -1); }
    | NUMBER {$$ = newnum(arena, $1); }
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

    arena* arena = malloc(sizeof(arena));
    arena_construct(arena);

    const char* testString = terminateString(argv[1]);
    int repeats = atoi(argv[2]);

    node* result;
    yy_scan_string(testString);
    yyparse(arena, &result);
    
    for (int i = 0; i < repeats; ++i) {
        printf("%f\n" , eval(arena, result));
        
    }
    arena_free(arena);
    return 0;
}


void yyerror (arena* arg, node** root, char* s) {
    fprintf(stderr, "%d: error: ", yylineno);
    fprintf(stderr, "\n");
}