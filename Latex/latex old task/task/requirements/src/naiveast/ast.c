#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "ast.h"

struct node* newast(int nodetype, struct node* l, struct node* r) {
    struct node* a = malloc(sizeof(struct node));

    if (!a) {
        yyerror(NULL, "Not enough memory");
        exit(0);
    }

    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    
    return a;
}

struct node* newnum(double d) {
    struct value* a = malloc(sizeof(struct value));
    if(!a) {
        yyerror(NULL, "out of space");
        exit(0); 
    }
    a->nodetype = 'K';
    a->number = d;
    return (struct node*) a;
}

double eval(struct node* a) {
    double v;
    switch (a->nodetype) {
    case 'K': {
        value* val = (value*) a;
        v = val->number;
        break;
    }   
    case '+':
        v = eval(a->l) + eval(a->r);
        break;
    case '-':
        v = eval(a->l) - eval(a->r);
        break;
    case '*':
        v = eval(a->l) * eval(a->r);
        break;
    case '/':
        v = eval(a->l) / eval(a->r);
        break;
    case '|':
        v = fabs(eval(a->l));
        break;
    case 'M':
        v = -eval(a->l);
        break;
    default:
        printf("internal error: bad node %c\n", a->nodetype);
        break;
    }
    return v;
}

void treefree(struct node* a) {
    switch(a->nodetype) {
        case 
    }
    if (a->nodetype == '+' || a->nodetype == '-' || a->nodetype == '*' || a->nodetype == '/') {
        treefree(a->r);
        treefree(a->l);
        free(a);
    }
    else
    if (a->nodetype == '|' || a->nodetype == 'M') {
        treefree(a->l);
        free(a);
    }
    else
    if (a->nodetype == 'K') {
        free(a);
    }
    else {
        printf("internal error: free bad node %c\n", a->nodetype);
    } 
}