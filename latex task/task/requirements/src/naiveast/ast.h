#ifndef _AST_H_
#define _AST_H_

extern int yylineno;
extern double fabs(double);

typedef struct node {
    int nodetype;
    struct node* l;
    struct node* r;
} node;

typedef struct value {
    int nodetype;
    double number;
} value;

struct node* newast (int nodetype, struct node* l, struct node* r);
struct node* newnum (double d);

double eval (struct node*);

void treefree (struct node*);

void yyerror (node** root, char* s);


#endif /* _AST_H_ */