#ifndef _NODE_H_
#define _NODE_H_

typedef struct node {
    int nodetype;
    unsigned int l;
    unsigned int r;
} node;

typedef struct value {
    int nodetype;
    double number;
} value;


#endif