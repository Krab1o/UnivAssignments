%option noyywrap nodefault yylineno
%{
#include "calc.tab.h"
#include "arena_ast.h"
%}

EXP ([Ee][-+]?[0-9]+)

%%
"+" | 
"-" |
"*" |
"/" |
"|" |
"(" |
")"  {return yytext[0]; }
[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }
\n     { return EOL; }
"//".*
[ \t]  { }
.      { printf("Mystery character %s\n", yytext); }

%%