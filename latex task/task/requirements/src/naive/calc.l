%{
#include "calc.tab.h"
%}

%%
"+"    { return '+'; }
"-"    { return '-'; }
"*"    { return '*'; }
"/"    { return '/'; }
"|"    { return '|'; }
"("    { return '('; }
")"    { return ')'; }
[0-9]+ { yylval.d = atoi(yytext); return NUMBER;}
\n     { return EOL; }
[ \t]  { }
.      { printf("Mystery character %s\n", yytext); }

%%