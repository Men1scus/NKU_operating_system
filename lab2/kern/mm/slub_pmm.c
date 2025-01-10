#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <assert.h>
#include <slub_pmm.h>
#include <pmm.h>
#include <stdio.h>

struct slob_block
{
    int units;               // 块的大小
    struct slob_block *next; // 下一个slot块
};
typedef struct slob_block slob_t;

#define SLOB_UNIT sizeof(slob_t)
#define SLOB_UNITS(size) (((size) + SLOB_UNIT - 1) / SLOB_UNIT)

struct bigblock
{
    int order;
    void *pages;
    struct bigblock *next;
};
typedef struct bigblock bigblock_t;

static slob_t arena = {.next = &arena, .units = 1};
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size)
{
    assert(size < PGSIZE);

    slob_t *prev, *cur;
    int units = SLOB_UNITS(size);

    prev = slobfree;
    for (cur = prev->next;; prev = cur, cur = cur->next)
    {
        if (cur->units >= units)
        {

            if (cur->units == units)
                prev->next = cur->next;
            else
            {
                prev->next = cur + units;
                prev->next->units = cur->units - units;
                prev->next->next = cur->next;
                cur->units = units;
            }
            slobfree = prev;
            return cur;
        }
        if (cur == slobfree)
        {
            if (size == PGSIZE)
                return 0;
            cur = (slob_t *)alloc_pages(1);
            if (!cur)
                return 0;
            slob_free(cur, PGSIZE);
            cur = slobfree;
        }
    }
}

static void slob_free(void *block, int size)
{
    slob_t *cur, *b = (slob_t *)block;
    if (!block)
        return;
    if (size)
        b->units = SLOB_UNITS(size);

    // Find the correct position to insert the block back into the free list
    for (cur = slobfree; !(cur->next == slobfree || (b > cur && b < cur->next)); cur = cur->next)
    {
        // Handle wrap-around case where cur is the last block in the list
        if (cur >= cur->next && (b > cur || b < cur->next))
        {
            break;
        }
    }

    // Merge with the next block if possible
    if ((char *)b + b->units * SLOB_UNIT == (char *)cur->next)
    {
        b->units += cur->next->units;
        b->next = cur->next->next;
    }
    else
    {
        b->next = cur->next;
    }

    // Merge with the previous block if possible
    if ((char *)cur + cur->units * SLOB_UNIT == (char *)b)
    {
        cur->units += b->units;
        cur->next = b->next;
    }
    else
    {
        cur->next = b;
    }

    // Update slobfree to point to the newly freed block if it is earlier in memory
    if (b < slobfree)
    {
        slobfree = b;
    }
}

void slub_init(void)
{
    cprintf("slub_init() succeeded!\n");
}

void *slub_alloc(size_t size)
{
    slob_t *m;
    bigblock_t *bb;

    if (size < PGSIZE)
    {
        m = slob_alloc(size + SLOB_UNIT);
        return m ? (void *)(m + 1) : 0;
    }

    bb = slob_alloc(sizeof(bigblock_t));
    if (!bb)
        return 0;

    bb->order = ((size - 1) >> PGSHIFT) + 1;
    bb->pages = (void *)alloc_pages(bb->order);

    if (bb->pages)
    {
        bb->next = bigblocks;
        bigblocks = bb;
        return bb->pages;
    }

    slob_free(bb, sizeof(bigblock_t));
    return 0;
}

void slub_free(void *block)
{
    bigblock_t *bb, **last = &bigblocks;

    if (!block)
        return;

    if (!((unsigned long)block & (PGSIZE - 1)))
    {
        for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
        {
            if (bb->pages == block)
            {
                *last = bb->next;
                free_pages((struct Page *)block, bb->order);
                slob_free(bb, sizeof(bigblock_t));
                return;
            }
        }
    }

    slob_free((slob_t *)block - 1, 0);
    return;
}

unsigned int slub_size(const void *block)
{
    bigblock_t *bb;

    if (!block)
        return 0;

    // Check if the block is page-aligned, indicating it is a bigblock
    if (!((unsigned long)block % PGSIZE))
    {
        for (bb = bigblocks; bb; bb = bb->next)
        {
            if (bb->pages == block)
            {
                return bb->order << PGSHIFT;
            }
        }
    }

    // Otherwise, treat it as a slob block and calculate its size
    slob_t *b = (slob_t *)block - 1;
    if (b->units > 0)
    {
        return b->units * SLOB_UNIT;
    }
    else
    {
        return 0;
    }
}

int slobfree_len()
{
    int len = 0;
    for (slob_t *curr = slobfree->next; curr != slobfree; curr = curr->next)
        len++;
    return len;
}

void slub_check()
{
    cprintf("SLUB check begins\n");

    // Initial state: check length of slobfree list
    int initial_len = slobfree_len();

    // Allocate memory of size smaller than one page
    void *p1 = slub_alloc(64); // Allocate 64 bytes
    assert(p1 != NULL);


    // Allocate another small block
    void *p2 = slub_alloc(128); // Allocate 128 bytes
    assert(p2 != NULL);

    // Free the first small block
    slub_free(p1);

    // Allocate a very small block to test splitting
    void *p3 = slub_alloc(32); // Allocate 32 bytes
    assert(p3 != NULL);


    // Free the remaining small blocks
    slub_free(p2);
    slub_free(p3);


    cprintf("SLUB check passed\n");
}
