# lab3:缺页异常和页面置换

<h1>窦楷然 2210652&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;屈华晨 2210650&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;张梓恒 2211279</h1>

做完实验二后，大家可以了解并掌握物理内存管理中页表的建立过程以及页面分配算法的具体实现。本次实验是在实验二的基础上，借助于页表机制和实验一中涉及的中断异常处理机制，学习如何在磁盘上缓存内存页，从而能够支持虚拟内存管理，提供一个比实际物理内存空间“更大”的虚拟内存空间给系统使用。

## 实验目的

- 了解虚拟内存的Page Fault异常处理实现
- 了解页替换算法在操作系统中的实现
- 学会如何使用多级页表，处理缺页异常（Page Fault），实现页面置换算法。

## 实验内容

本次实验是在实验二的基础上，借助于页表机制和实验一中涉及的中断异常处理机制，完成Page Fault异常处理和部分页面替换算法的实现，结合磁盘提供的缓存空间，从而能够支持虚存管理，提供一个比实际物理内存空间“更大”的虚拟内存空间给系统使用。这个实验与实际操作系统中的实现比较起来要简单，不过需要了解实验一和实验二的具体实现。实际操作系统系统中的虚拟内存管理设计与实现是相当复杂的，涉及到与进程管理系统、文件系统等的交叉访问。如果大家有余力，可以尝试完成扩展练习，实现LRU页替换算法。

对实验报告的要求：

- 基于markdown格式来完成，以文本方式为主
- 填写各个基本练习中要求完成的报告内容
- 列出你认为本实验中重要的知识点，以及与对应的OS原理中的知识点，并简要说明你对二者的含义，关系，差异等方面的理解（也可能出现实验中的知识点没有对应的原理知识点）
- 列出你认为OS原理中很重要，但在实验中没有对应上的知识点

## 练习0：填写已有实验

本实验依赖实验2。请把你做的实验2的代码填入本实验中代码中有“LAB2”的注释相应部分。（建议手动补充，不要直接使用merge）

## 练习1：理解基于FIFO的页面替换算法（思考题）

描述FIFO页面置换算法下，一个页面从被换入到被换出的过程中，会经过代码里哪些函数/宏的处理（或者说，需要调用哪些函数/宏），并用简单的一两句话描述每个函数在过程中做了什么？（为了方便同学们完成练习，所以实际上我们的项目代码和实验指导的还是略有不同，例如我们将FIFO页面置换算法头文件的大部分代码放在了`kern/mm/swap_fifo.c`文件中，这点请同学们注意）

- 至少正确指出10个不同的函数分别做了什么？如果少于10个将酌情给分。我们认为只要函数原型不同，就算两个不同的函数。要求指出对执行过程有实际影响,删去后会导致输出结果不同的函数（例如assert）而不是cprintf这样的函数。如果你选择的函数不能完整地体现”从换入到换出“的过程，比如10个函数都是页面换入的时候调用的，或者解释功能的时候只解释了这10个函数在页面换入时的功能，那么也会扣除一定的分数

#### **实验背景**
虚拟内存是现代操作系统的核心机制之一，允许进程使用比实际物理内存更大的地址空间。

为了高效管理虚拟内存，本实验围绕以下目标展开：

1. **补充实验2代码**：完善多级页表初始化与管理逻辑，支持虚拟地址到物理地址的映射。
2. **分析 FIFO 页面置换算法**：理解页面换入与换出的实现细节，探索其优缺点。
3. **分页机制探讨**：结合实验代码分析分页机制 `get_pte()` 函数的设计和分页模式（sv32、sv39、sv48）。
4. **缺页异常处理实现**：通过补全 `do_pgfault()` 函数，完成对未映射虚拟地址的物理页分配和访问管理。
5. **实验与原理的对比**：总结实验中的关键知识点，探讨其与操作系统理论的联系和差异。

---

#### **1. 实验依赖与填充（练习0）**

实验3构建在实验2的基础上，核心是页表的初始化和管理。
1. **页表条目（PTE）的动态分配**：
   - 在访问页表条目时，若对应页表未分配，需要动态创建。
2. **页表查找和更新**：
   - 根据虚拟地址逐级查找页表，确保映射关系的正确性。

**代码实现：`get_pte()` 函数**
```c
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    // 根据线性地址 la 获取页目录项
    pde_t *pdep = &pgdir[PDX(la)];
    if (!(*pdep & PTE_P)) {  // 页目录项不存在
        if (!create) return NULL;
        struct Page *page = alloc_page();  // 分配物理页作为新的页表
        if (page == NULL) return NULL;
        *pdep = page2pa(page) | PTE_P | PTE_W | PTE_U;
        memset((void *)KADDR(PDE_ADDR(*pdep)), 0, PGSIZE);  // 初始化新页表
    }
    // 返回页表条目的地址
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
```

**填充意义**：
- 动态分配未初始化的页表，保证虚拟地址对应的页表项总是有效。
- 为多级页表机制奠定基础，支持动态扩展虚拟地址空间。

---

#### **2. FIFO 页面置换算法分析（练习1）**

页面置换算法决定了在物理内存不足时，哪些页面会被换出。FIFO（First-In-First-Out）策略是最简单的算法，依赖链表维护页面的访问顺序。在 `swap_fifo.c` 文件中，核心函数包括以下10个：

1. **`_fifo_init_mm`**
   - **作用**：初始化 FIFO 所需的数据结构，将链表 `pra_list_head` 与内存管理结构体 `mm` 绑定。
   - **代码**：
     ```c
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     ```

2. **`_fifo_map_swappable`**
   - **作用**：将新到达的页面加入链表尾部，记录页面的访问顺序。
   - **代码**：
     ```c
     list_entry_t *head = (list_entry_t *)mm->sm_priv;
     list_add(head, &(page->pra_page_link));
     ```

3. **`_fifo_swap_out_victim`**
   - **作用**：从链表头部移除最早到达的页面，并返回该页面以进行替换。
   - **代码**：
     ```c
     list_entry_t *entry = list_prev(head);
     list_del(entry);
     *ptr_page = le2page(entry, pra_page_link);
     ```

4. **`swap_map_swappable`**
   - **作用**：将页面标记为可交换，使页面可参与替换。
   - **代码**：
     ```c
     swap_manager->map_swappable(mm, addr, page, swap_in);
     ```

5. **`swap_out`**
   - **作用**：触发页面置换，根据 FIFO 策略选择替换页面。
   - **代码**：
     ```c
     swap_manager->swap_out_victim(mm, &page, 0);
     ```

6. **`swap_in`**
   - **作用**：从磁盘加载页面内容到物理内存。
   - **代码**：
     ```c
     swap_in(mm, addr, &page);
     ```

7. **`page_insert`**
   - **作用**：将物理页面映射到虚拟地址，建立页表项。
   - **代码**：
     ```c
     page_insert(pgdir, page, addr, perm);
     ```

8. **`page_remove`**
   - **作用**：删除页表中虚拟地址到物理地址的映射。
   - **代码**：
     ```c
     page_remove(pgdir, addr);
     ```

9. **`list_del`**
   - **作用**：从链表中删除指定页面节点。
   - **代码**：
     ```c
     list_del(entry);
     ```

10. **`list_prev`**
    - **作用**：获取链表中最早到达的页面节点。
    - **代码**：
      ```c
      list_entry_t *entry = list_prev(head);
      ```

**过程总结**：
FIFO 算法简单易实现，但无法适应实际访问模式中常见的局部性特点。例如，经常访问的页面也可能被换出。



## 练习2：深入理解不同分页模式的工作原理（思考题）

get_pte()函数（位于`kern/mm/pmm.c`）用于在页表中查找或创建页表项，从而实现对指定线性地址对应的物理页的访问和映射操作。这在操作系统中的分页机制下，是实现虚拟内存与物理内存之间映射关系非常重要的内容。

- get_pte()函数中有两段形式类似的代码， 结合sv32，sv39，sv48的异同，解释这两段代码为什么如此相像。
- 目前get_pte()函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？

`get_pte()` 是分页机制中的核心函数，用于根据虚拟地址查找页表项，并在必要时动态分配新的页表。其功能是建立多级页表体系的关键，支持虚拟地址到物理地址的映射。

---

#### **分页机制背景**

分页机制允许操作系统将虚拟内存地址映射到物理内存地址：

1. 地址被分解为多级索引（如 sv32 的两级索引：页目录项和页表项）。
2. 每一级索引用于在页表中找到对应的下一级地址。
3. 最终索引到物理内存中的一页。

分页模式的差异体现在页表层级的数量上：

- **sv32（两级）**：
  - 页目录（Page Directory）：4KB。
  - 页表（Page Table）：每项 4 字节，每表最多容纳 1024 项。
- **sv39（三级）**：
  - 页目录指针表 → 页目录 → 页表。
  - 每一级可表示更大的地址空间。
- **sv48（四级）**：
  - 更进一步扩展地址范围，适合更高端的内存需求。

---

#### **`get_pte()` 的逻辑分析**

以下是 `get_pte()` 的核心代码：

```c
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    // 通过虚拟地址 la 获取顶层页目录项
    pde_t *pdep = &pgdir[PDX(la)];
    if (!(*pdep & PTE_P)) {  // 页目录项不存在
        if (!create) return NULL; // 如果 create 标志未设置，返回 NULL
        struct Page *page = alloc_page();  // 分配一个物理页作为新的页表
        if (page == NULL) return NULL; // 分配失败
        *pdep = page2pa(page) | PTE_P | PTE_W | PTE_U; // 设置页目录项指向新页表
        memset((void *)KADDR(PDE_ADDR(*pdep)), 0, PGSIZE);  // 初始化新页表
    }
    // 返回目标页表中的页表项指针
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
```

---

#### **逐步解析 `get_pte()` 的每个部分**

1. **输入参数**：

   - `pgdir`：顶层页表指针。
   - `la`：虚拟地址。
   - `create`：指示是否在页表不存在时创建新页表。

2. **页目录项查找**：

   ```c
   pde_t *pdep = &pgdir[PDX(la)];
   ```

   - 使用宏 `PDX(la)` 提取虚拟地址的页目录索引。
   - 通过 `pgdir` 定位到页目录中的相应项 `pdep`。

3. **页目录项存在性检查**：

   ```c
   if (!(*pdep & PTE_P)) {
       if (!create) return NULL;
   }
   ```

   - 检查页目录项的存在性（`PTE_P` 标志位是否设置）。
   - 若未设置，且 `create` 参数为假，直接返回 `NULL`。

4. **动态创建页表**：

   ```c
   struct Page *page = alloc_page();
   *pdep = page2pa(page) | PTE_P | PTE_W | PTE_U;
   memset((void *)KADDR(PDE_ADDR(*pdep)), 0, PGSIZE);
   ```

   - 调用 `alloc_page()` 分配物理内存用于存储页表。
   - 更新页目录项，使其指向新分配的页表。
   - 初始化页表，将所有条目清零。

5. **页表项指针返回**：

   ```c
   return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
   ```

   - 使用宏 `PTX(la)` 提取虚拟地址的页表索引。
   - 返回页表中对应虚拟地址的页表项指针。

---

#### **函数意义**

- **动态分配**：未分配的页表在访问时动态分配，避免预先分配所有页表，节约内存。
- **支持多级分页**：通过递归调用，在多级页表中逐级查找或分配条目。
- **抽象分页机制**：屏蔽了具体分页模式的实现细节（sv32、sv39、sv48）。



## 练习3：给未被映射的地址映射上物理页（需要编程）

补充完成do_pgfault（mm/vmm.c）函数，给未被映射的地址映射上物理页。设置访问权限 的时候需要参考页面所在 VMA 的权限，同时需要注意映射物理页时需要操作内存控制 结构所指定的页表，而不是内核的页表。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处。
- 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
  - 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？



`do_pgfault()` 是处理缺页异常的核心函数。它的主要任务是：
1. 检查缺页地址是否在合法的虚拟内存区域（VMA）内。
2. 分配新的物理页面或从磁盘加载页面。
3. 设置页面访问权限并建立虚拟地址到物理地址的映射。
4. 若页面可交换，则更新页面置换链表。

以下是 `do_pgfault()` 的完整实现和逐步解析：
```c
int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
    struct vma_struct *vma = find_vma(mm, addr);
    if (vma == NULL || addr < vma->vm_start) return -E_INVAL;

    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) perm |= PTE_W;

    addr = ROUNDDOWN(addr, PGSIZE);
    pte_t *ptep = get_pte(mm->pgdir, addr, 1);
    if (*ptep == 0) {
        struct Page *page = alloc_page();
        if (page == NULL) return -E_NO_MEM;
        page_insert(mm->pgdir, page, addr, perm);
    } else if (swap_init_ok) {
        struct Page *page = NULL;
        swap_in(mm, addr, &page);
        page_insert(mm->pgdir, page, addr, perm);
        swap_map_swappable(mm, addr, page, 1);
    }
    return 0;
}
```

---

#### **逐步解析 `do_pgfault()`**

1. **检查地址合法性**：
   ```c
   struct vma_struct *vma = find_vma(mm, addr);
   if (vma == NULL || addr < vma->vm_start) return -E_INVAL;
   ```
   - 调用 `find_vma()` 查找地址所在的 VMA。
   - 如果地址不在任何合法的虚拟内存区域中，返回错误。

2. **设置访问权限**：
   ```c
   uint32_t perm = PTE_U;
   if (vma->vm_flags & VM_WRITE) perm |= PTE_W;
   ```
   - 检查 VMA 的访问权限（如读、写权限）。
   - 根据 VMA 标志位，设置页表项的权限。

3. **对齐地址**：
   ```c
   addr = ROUNDDOWN(addr, PGSIZE);
   ```
   - 将地址对齐到页面边界，因为页表操作以页面为单位。

4. **获取页表项指针**：
   ```c
   pte_t *ptep = get_pte(mm->pgdir, addr, 1);
   ```
   - 调用 `get_pte()` 获取页表项。
   - 如果页表不存在，创建新页表。

5. **页面分配与映射**：
   - **分配新页面**：
     ```c
     if (*ptep == 0) {
         struct Page *page = alloc_page();
         if (page == NULL) return -E_NO_MEM;
         page_insert(mm->pgdir, page, addr, perm);
     }
     ```
     - 分配新的物理页面。
     - 调用 `page_insert()`，建立物理页面与虚拟地址的映射。

   - **从磁盘加载页面**：
     ```c
     else if (swap_init_ok) {
         struct Page *page = NULL;
         swap_in(mm, addr, &page);
         page_insert(mm->pgdir, page, addr, perm);
         swap_map_swappable(mm, addr, page, 1);
     }
     ```
     - 如果页面在磁盘中，调用 `swap_in()` 加载页面内容。
     - 建立映射关系并将页面标记为可交换。

6. **返回成功**：
   
   ```c
   return 0;
   ```

---

#### **核心逻辑总结**

1. **多级检查**：
   - 从 VMA 范围检查到页表项分配，逐步验证地址的合法性。
2. **动态分配与加载**：
   - 在内存中未分配时分配物理页面。
   - 在页面被换出时，从磁盘加载页面。
3. **与页面置换的联动**：
   - 若页面从磁盘加载，调用页面置换相关

函数（如 `swap_map_swappable`）。

通过 `do_pgfault()`，实现了完整的缺页异常处理，确保虚拟内存访问的连续性和正确性。



## 练习4：补充完成Clock页替换算法（需要编程）

#### 算法介绍

时钟页面替换算法是一种改进的页面替换算法，旨在减少经典FIFO算法的缺点，提供更优的性能。其基本思想是用一个类似于时钟的循环链表来追踪页面，链表中的每个页面节点都有一个访问标志（通常称为“访问位”）。在页面加载到内存时，访问位被设置为1，当需要进行页面替换时，时钟指针开始顺时针扫描页面链表。如果遇到访问位为1的页面，表示页面近期被访问过，访问位被重置为0，指针继续移动；如果遇到访问位为0的页面，则选择该页面进行替换。

这样，当一个页面被多次访问时，算法会将其保留，减少频繁换入换出导致的性能下降。这种策略可以有效避免Belady现象，提高页面的命中率，同时保留FIFO算法实现简单的特点，兼顾了性能与开销的平衡。

#### 算法流程

下面我们来解释每个函数的实现细节：

### 1. `_clock_init_mm` 函数
```c
static int _clock_init_mm(struct mm_struct *mm) {
    list_init(&pra_list_head);
    curr_ptr = &pra_list_head;
    mm->sm_priv =  &pra_list_head;
    cprintf(" mm->sm_priv %x in fifo_init_mm\n", mm->sm_priv);
    return 0;
}
```
- **功能**：初始化页面替换算法的基础数据结构。
- **细节**：
  - `list_init(&pra_list_head)`：初始化 `pra_list_head`，将其设为空链表。
  - `curr_ptr = &pra_list_head`：设置当前指针 `curr_ptr` 指向链表头，表示当前页面替换位置为链表头。
  - `mm->sm_priv = &pra_list_head`：将 `mm` 结构中的私有成员 `sm_priv` 指向 `pra_list_head`，这样后续页面管理操作可以通过 `mm` 访问链表。

### 2. `_clock_map_swappable` 函数
```c
static int _clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in) {
    list_entry_t *entry = &(page->pra_page_link);
    assert(entry != NULL && curr_ptr != NULL);
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
    list_add_before(head, entry); // 插入到链表的末尾
    page->visited = 1; // 设置页面为已访问
    return 0;
}
```
- **功能**：将一个新页面加入到链表中。
- **细节**：
  - `list_entry_t *entry = &(page->pra_page_link)`：获取页面 `page` 中的链表节点 `pra_page_link`。
  - `list_entry_t *head = (list_entry_t *)mm->sm_priv`：获取链表头 `head`。
  - `list_add_before(head, entry)`：将新页面插入到链表末尾。由于链表是循环链表，因此插入到 `head` 之前就相当于末尾。
  - `page->visited = 1`：将页面的 `visited` 标志置为 1，表示该页面已被访问。

### 3. `_clock_swap_out_victim` 函数
```c
static int _clock_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick) {
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
    assert(head != NULL);
    assert(in_tick == 0);

    while (1) {
        curr_ptr = list_next(curr_ptr); // 先移到下一个页面
        if (curr_ptr == head) {
            curr_ptr = list_next(curr_ptr); // 跳过链表头
        }

        struct Page *page = le2page(curr_ptr, pra_page_link);

        if (page->visited == 0) {
            list_entry_t *next = list_next(curr_ptr);
            *ptr_page = page; // 将要换出的页面赋值给 ptr_page
            list_del(curr_ptr); // 从链表中删除该页面
            curr_ptr = list_prev(next); // 更新 curr_ptr，指向被删除页面的前一个节点
            break;
        } else {
            page->visited = 0; // 如果页面已被访问，将其标志置为 0
        }
    }

    return 0;
}
```
- **功能**：选择一个页面进行换出。
- **细节**：
  - `list_entry_t *head = (list_entry_t *)mm->sm_priv`：获取链表头。
  - 使用 `curr_ptr = list_next(curr_ptr)` 逐个遍历页面，直到找到一个未被访问的页面。
  - 如果当前页面 `page->visited == 0`，表示该页面可以换出：
    - `*ptr_page = page`：将要换出的页面指针赋值给 `ptr_page`。
    - `list_del(curr_ptr)`：将该页面从链表中删除。
    - `curr_ptr = list_prev(next)`：更新当前指针为下一个页面的前一个节点。
  - 如果页面已被访问（`visited == 1`），则将其标志置为 0，表示页面已被时钟指针“许可”过一次。

### 问题

#### 比较Clock页替换算法和FIFO算法的不同

**FIFO页面替换算法**是一种简单直观的页面管理策略，它按照页面进入内存的先后顺序进行替换，遵循“先入先出”的原则。当一个新页面需要被加载且内存已经满时，最早进入内存的页面会被替换出去。实现FIFO算法只需要维护一个队列，每次有新页面进入时，将其插入到队列的末尾，而在页面替换时总是选择队列头部的页面进行置换。虽然实现简单且开销较小，但FIFO没有考虑页面的使用频率，这可能导致频繁被使用的页面过早被替换，出现所谓的Belady现象，从而在某些情况下反而增加了页面错误率。

**Clock页面替换算法**是一种对FIFO算法的改进，采用循环链表和访问位来决定页面的替换次序，目的是提高替换策略的效率。每个页面都有一个访问位，用于记录该页面是否在最近被使用过。当需要替换页面时，时钟指针开始扫描页面链表：如果发现一个页面的访问位为1，则将其重置为0并跳过该页面，继续扫描下一个；当找到一个访问位为0的页面时，就将其替换出去。通过这种方式，Clock算法为最近使用过的页面提供了一次“豁免权”，以避免过早替换掉频繁被访问的页面，相比于FIFO具有更高的页面命中率和更好的性能表现，特别是在页面访问具有局部性特征时效果更加显著。



## 扩展练习 Challenge：实现不考虑实现开销和效率的LRU页替换算法（需要编程）

### 算法介绍

我们利用哈希表和双向链表结合的数据结构来实现LRU页面替换算法，这种方法能够在常数时间内完成对页面的插入、删除和访问操作，从而极大提高效率。

具体来说，哈希表用于存储页面号与链表节点之间的映射，以便快速定位页面是否在内存中；双向链表则用于记录页面的访问顺序，链表头部始终存储最近被访问的页面，而链表尾部存储最久未被访问的页面。

当一个页面被访问时，如果页面在内存中，则将其从链表中删除并重新插入到链表头部；如果页面不在内存中，则将其加入链表头部并检查内存容量是否超限，超限时驱逐链表尾部的页面。这样设计既保持了LRU的特性，又将页面管理操作的时间复杂度降低到 O(1)，在性能和实现复杂度上实现了较好的平衡。

### 实现思想
- **哈希表**：用于快速定位某个页面是否已经在内存中。
- **双向链表**：用于记录页面的访问顺序，链表头部存储最近被访问的页面，尾部存储最久未被访问的页面。
- 当一个页面被访问时：
  - 如果页面已经存在于内存中，从链表中删除并重新插入到链表头部。
  - 如果页面不在内存中，将其加入链表头部，同时检查是否超出内存容量，如果超出则驱逐链表尾部节点。

这种实现能够很好地保持LRU的性质，同时保持时间复杂度为O(1)的插入、删除和访问操作。

### 实现代码

```c
struct Page {
    int page_number;        // 页面编号
    list_entry_t pra_page_link; // 页面链表节点
};

struct list_entry_t {
    Page* page;           // 指向页面的指针
    list_entry_t* prev;     // 指向前一个节点
    list_entry_t* next;       // 指向后一个节点
};

// 定义LRU缓存类
class LRUCache {
private:
    unordered_map<int, list_entry_t*> page_map; // 哈希表，快速定位页面是否在内存中
    list_entry_t *head, *tail;               // 链表的头尾节点
    int capacity;                    // 内存页面容量

    void remove(list_entry_t* node) {
        // 从链表中删除指定节点
        node->prev->next = node->next;
        node->next->prev = node->prev;
    }

    void add_to_head(list_entry_t* node) {
        // 将节点插入链表头部
        node->next = head->next;
        node->prev = head;
        head->next->prev = node;
        head->next = node;
    }

public:
    LRUCache(int cap) {
        capacity = cap;
        head = new list_entry_t(); // 哨兵头节点
        tail = new list_entry_t(); // 哨兵尾节点
        head->next = tail;
        tail->prev = head;
    }

    Page* access_page(int page_number) {
        if (page_map.find(page_number) != page_map.end()) {
            // 页面已存在于内存中，将其移动到链表头部
            list_entry_t* node = page_map[page_number];
            remove(node);
            add_to_head(node);
            return node->page;
        } else {
            // 页面不在内存中，需要换入内存
            Page* new_page = new Page();
            new_page->page_number = page_number;

            list_entry_t* new_node = new list_entry_t();
            new_node->page = new_page;

            page_map[page_number] = new_node;
            add_to_head(new_node);

            // 检查是否超过内存容量
            if (page_map.size() > capacity) {
                // 超过容量，移除链表尾部节点
                list_entry_t* tail_node = tail->prev;
                remove(tail_node);
                page_map.erase(tail_node->page->page_number);
                delete tail_node->page;
                delete tail_node;
            }

            return new_page;
        }
    }
};
```

### 优点
- 这种实现能够在常数时间内完成页面的插入、删除和访问操作，因为哈希表的查找、插入和删除时间复杂度为 O(1)，而链表的插入和删除也为 O(1)。
- 利用哈希表快速查找页面是否存在，结合双向链表记录页面访问顺序，可以有效实现LRU的置换策略。
- 哈希表和双向链表的组合使代码的逻辑更加清晰，便于理解和维护。

这种实现通过哈希表和双向链表的结合实现了LRU页面替换算法，能够高效地进行页面管理操作，满足最久未使用的需求。在这种结构中，链表头部始终存储最近被访问的页面，而链表尾部始终是最久未被访问的页面，当需要换出时，直接驱逐尾部节点即可。





