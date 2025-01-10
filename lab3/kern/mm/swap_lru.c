#include <defs.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_lru.h>
#include <list.h>

static list_entry_t pra_list_head;

// 相同的初始化函数
static int
_lru_init_mm(struct mm_struct *mm)
{     
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
    return 0;
}

static int
_lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    // 每次一个页被访问，如果它原本就存在于链表中，将其删除并重新加入头部，victim为尾部的项
    list_entry_t *head = (list_entry_t*) mm->sm_priv;
    list_entry_t *entry = &(page->pra_page_link);

    assert(entry != NULL && head != NULL);

    // 遍历链表以检查页面是否已经存在，如果存在要删除
    list_entry_t *tmp = list_next(head);
    while (tmp != head) {
        if (tmp == entry) {
            list_del(entry);
            break;
        }
        tmp = list_next(tmp);
    }

    // 将页面插入到链表头部
    list_add_after(head, entry);

    return 0;
}

static int
_lru_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick)
{
    list_entry_t *head = (list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick == 0);

    // 找到链表尾
    list_entry_t *entry = list_prev(head);
    if (entry == head) return -1; // 链表为空
    
    // 移除链表尾，返回被替换走页面的指针
    list_del(entry);
    *ptr_page = le2page(entry, pra_page_link);
    return 0;
}

static void
print_mm_list() {
    cprintf("print mm: \n");
    list_entry_t *head = &pra_list_head, *le = head;
    while ((le = list_next(le)) != head)
    {
        struct Page* page = le2page(le, pra_page_link);
        cprintf("vaddr: 0x%x\n", page->pra_vaddr);
    }
}

static int
_lru_check_swap(void) {
    cprintf("write Virt Page c in lru_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num == 4);
    cprintf("write Virt Page a in lru_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num == 4);
    cprintf("write Virt Page d in lru_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num == 4);
    cprintf("write Virt Page b in lru_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num == 4);
    
    // 新页，多一次page fault，page a被挤出去
    cprintf("write Virt Page e in lru_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    print_mm_list();
    assert(pgfault_num == 5);
    cprintf("write Virt Page b in lru_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    print_mm_list();
    assert(pgfault_num == 5);
    cprintf("write Virt Page a in lru_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    print_mm_list();
    assert(pgfault_num == 5);
    cprintf("write Virt Page b in lru_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    print_mm_list();
    assert(pgfault_num == 5);
    cprintf("write Virt Page c in lru_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num == 5);
    cprintf("write Virt Page d in lru_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num == 5);
    cprintf("write Virt Page e in lru_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num == 5);
    cprintf("write Virt Page a in lru_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    print_mm_list();
    assert(pgfault_num == 6);
    return 0;
}

static int
_lru_init(void)
{
    return 0;
}

static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_lru_tick_event(struct mm_struct *mm)
{
    return 0;
}

struct swap_manager swap_manager_lru = 
{
    .name            = "lru swap manager",
    .init            = &_lru_init,
    .init_mm         = &_lru_init_mm,
    .tick_event      = &_lru_tick_event,
    .map_swappable   = &_lru_map_swappable,
    .set_unswappable = &_lru_set_unswappable,
    .swap_out_victim = &_lru_swap_out_victim,
    .check_swap      = &_lru_check_swap,
};