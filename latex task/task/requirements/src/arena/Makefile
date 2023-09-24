calc.out: calc.l calc.y arena_ast.h
	bison -d calc.y
	flex calc.l
	cc -o $@ calc.tab.c lex.yy.c arena_ast.c arena.c
	