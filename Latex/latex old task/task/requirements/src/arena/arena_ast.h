#ifndef _AST_H_
#define _AST_H_
#include "node.h"
#include "arena.h"

extern int yylineno;

typedef struct arena arena;
typedef struct node node;

unsigned int newast (arena* arena, int nodetype, 
    unsigned int l, unsigned int r);
unsigned int newnum (arena*, double d);

double eval (arena* arena, node* node);

void treefree (node*);

void yyerror (arena* arg, node** root, char* s);

#endif /* _AST_H_ */