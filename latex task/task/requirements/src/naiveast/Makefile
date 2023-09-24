calc.out: calc.l calc.y ast.h
	bison -d calc.y
	flex calc.l
	cc -o $@ calc.tab.c lex.yy.c ast.c