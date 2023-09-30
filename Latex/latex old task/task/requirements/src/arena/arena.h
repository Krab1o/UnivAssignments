#ifndef _ARENA_H_
#define _ARENA_H_

#include <stdlib.h>
#include "arena_ast.h"
#include "node.h"

#define DEFAULT_ARENA_SIZE 16
#define MULTIPLY_FACTOR 2

typedef struct arena {
    struct node* arena;
    unsigned int size;
    unsigned int allocated;
} arena;

extern int arena_construct(arena* arena); // 0 - ok, !0 - failure
extern void arena_free(arena* arena); 
extern int arena_allocate(arena* arena, unsigned int count); // -1 - failure, index in arena otherwise
extern void arena_clear(arena* arena);

#endif /* _ARENA_H_ */