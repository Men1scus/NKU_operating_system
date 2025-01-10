
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc020001c:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200020:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200024:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
void grade_backtrace(void);


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	ff650513          	addi	a0,a0,-10 # ffffffffc0206028 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	55e60613          	addi	a2,a2,1374 # ffffffffc0206598 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	78e010ef          	jal	ra,ffffffffc02017d8 <memset>
    cons_init();  // init the console
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00001517          	auipc	a0,0x1
ffffffffc0200056:	79e50513          	addi	a0,a0,1950 # ffffffffc02017f0 <etext+0x6>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>

    print_kerninfo();
ffffffffc020005e:	0e4000ef          	jal	ra,ffffffffc0200142 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	62b000ef          	jal	ra,ffffffffc0200e90 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>

    slub_init();
ffffffffc0200076:	0f8010ef          	jal	ra,ffffffffc020116e <slub_init>
    slub_check();
ffffffffc020007a:	154010ef          	jal	ra,ffffffffc02011ce <slub_check>

    /* do nothing */
    while (1)
ffffffffc020007e:	a001                	j	ffffffffc020007e <kern_init+0x4c>

ffffffffc0200080 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200080:	1141                	addi	sp,sp,-16
ffffffffc0200082:	e022                	sd	s0,0(sp)
ffffffffc0200084:	e406                	sd	ra,8(sp)
ffffffffc0200086:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200088:	3cc000ef          	jal	ra,ffffffffc0200454 <cons_putc>
    (*cnt) ++;
ffffffffc020008c:	401c                	lw	a5,0(s0)
}
ffffffffc020008e:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200090:	2785                	addiw	a5,a5,1
ffffffffc0200092:	c01c                	sw	a5,0(s0)
}
ffffffffc0200094:	6402                	ld	s0,0(sp)
ffffffffc0200096:	0141                	addi	sp,sp,16
ffffffffc0200098:	8082                	ret

ffffffffc020009a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	862a                	mv	a2,a0
ffffffffc020009e:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a0:	00000517          	auipc	a0,0x0
ffffffffc02000a4:	fe050513          	addi	a0,a0,-32 # ffffffffc0200080 <cputch>
ffffffffc02000a8:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000aa:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000ac:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ae:	254010ef          	jal	ra,ffffffffc0201302 <vprintfmt>
    return cnt;
}
ffffffffc02000b2:	60e2                	ld	ra,24(sp)
ffffffffc02000b4:	4532                	lw	a0,12(sp)
ffffffffc02000b6:	6105                	addi	sp,sp,32
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000ba:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000c0:	8e2a                	mv	t3,a0
ffffffffc02000c2:	f42e                	sd	a1,40(sp)
ffffffffc02000c4:	f832                	sd	a2,48(sp)
ffffffffc02000c6:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c8:	00000517          	auipc	a0,0x0
ffffffffc02000cc:	fb850513          	addi	a0,a0,-72 # ffffffffc0200080 <cputch>
ffffffffc02000d0:	004c                	addi	a1,sp,4
ffffffffc02000d2:	869a                	mv	a3,t1
ffffffffc02000d4:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000d6:	ec06                	sd	ra,24(sp)
ffffffffc02000d8:	e0ba                	sd	a4,64(sp)
ffffffffc02000da:	e4be                	sd	a5,72(sp)
ffffffffc02000dc:	e8c2                	sd	a6,80(sp)
ffffffffc02000de:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000e0:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000e2:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e4:	21e010ef          	jal	ra,ffffffffc0201302 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000e8:	60e2                	ld	ra,24(sp)
ffffffffc02000ea:	4512                	lw	a0,4(sp)
ffffffffc02000ec:	6125                	addi	sp,sp,96
ffffffffc02000ee:	8082                	ret

ffffffffc02000f0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000f0:	a695                	j	ffffffffc0200454 <cons_putc>

ffffffffc02000f2 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02000f2:	1101                	addi	sp,sp,-32
ffffffffc02000f4:	e822                	sd	s0,16(sp)
ffffffffc02000f6:	ec06                	sd	ra,24(sp)
ffffffffc02000f8:	e426                	sd	s1,8(sp)
ffffffffc02000fa:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02000fc:	00054503          	lbu	a0,0(a0)
ffffffffc0200100:	c51d                	beqz	a0,ffffffffc020012e <cputs+0x3c>
ffffffffc0200102:	0405                	addi	s0,s0,1
ffffffffc0200104:	4485                	li	s1,1
ffffffffc0200106:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200108:	34c000ef          	jal	ra,ffffffffc0200454 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020010c:	00044503          	lbu	a0,0(s0)
ffffffffc0200110:	008487bb          	addw	a5,s1,s0
ffffffffc0200114:	0405                	addi	s0,s0,1
ffffffffc0200116:	f96d                	bnez	a0,ffffffffc0200108 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200118:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc020011c:	4529                	li	a0,10
ffffffffc020011e:	336000ef          	jal	ra,ffffffffc0200454 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	8522                	mv	a0,s0
ffffffffc0200126:	6442                	ld	s0,16(sp)
ffffffffc0200128:	64a2                	ld	s1,8(sp)
ffffffffc020012a:	6105                	addi	sp,sp,32
ffffffffc020012c:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc020012e:	4405                	li	s0,1
ffffffffc0200130:	b7f5                	j	ffffffffc020011c <cputs+0x2a>

ffffffffc0200132 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200132:	1141                	addi	sp,sp,-16
ffffffffc0200134:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200136:	326000ef          	jal	ra,ffffffffc020045c <cons_getc>
ffffffffc020013a:	dd75                	beqz	a0,ffffffffc0200136 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020013c:	60a2                	ld	ra,8(sp)
ffffffffc020013e:	0141                	addi	sp,sp,16
ffffffffc0200140:	8082                	ret

ffffffffc0200142 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200142:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200144:	00001517          	auipc	a0,0x1
ffffffffc0200148:	6cc50513          	addi	a0,a0,1740 # ffffffffc0201810 <etext+0x26>
void print_kerninfo(void) {
ffffffffc020014c:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc0200152:	00000597          	auipc	a1,0x0
ffffffffc0200156:	ee058593          	addi	a1,a1,-288 # ffffffffc0200032 <kern_init>
ffffffffc020015a:	00001517          	auipc	a0,0x1
ffffffffc020015e:	6d650513          	addi	a0,a0,1750 # ffffffffc0201830 <etext+0x46>
ffffffffc0200162:	f59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc0200166:	00001597          	auipc	a1,0x1
ffffffffc020016a:	68458593          	addi	a1,a1,1668 # ffffffffc02017ea <etext>
ffffffffc020016e:	00001517          	auipc	a0,0x1
ffffffffc0200172:	6e250513          	addi	a0,a0,1762 # ffffffffc0201850 <etext+0x66>
ffffffffc0200176:	f45ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc020017a:	00006597          	auipc	a1,0x6
ffffffffc020017e:	eae58593          	addi	a1,a1,-338 # ffffffffc0206028 <free_area>
ffffffffc0200182:	00001517          	auipc	a0,0x1
ffffffffc0200186:	6ee50513          	addi	a0,a0,1774 # ffffffffc0201870 <etext+0x86>
ffffffffc020018a:	f31ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc020018e:	00006597          	auipc	a1,0x6
ffffffffc0200192:	40a58593          	addi	a1,a1,1034 # ffffffffc0206598 <end>
ffffffffc0200196:	00001517          	auipc	a0,0x1
ffffffffc020019a:	6fa50513          	addi	a0,a0,1786 # ffffffffc0201890 <etext+0xa6>
ffffffffc020019e:	f1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001a2:	00006597          	auipc	a1,0x6
ffffffffc02001a6:	7f558593          	addi	a1,a1,2037 # ffffffffc0206997 <end+0x3ff>
ffffffffc02001aa:	00000797          	auipc	a5,0x0
ffffffffc02001ae:	e8878793          	addi	a5,a5,-376 # ffffffffc0200032 <kern_init>
ffffffffc02001b2:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001b6:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001ba:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001bc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001c0:	95be                	add	a1,a1,a5
ffffffffc02001c2:	85a9                	srai	a1,a1,0xa
ffffffffc02001c4:	00001517          	auipc	a0,0x1
ffffffffc02001c8:	6ec50513          	addi	a0,a0,1772 # ffffffffc02018b0 <etext+0xc6>
}
ffffffffc02001cc:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ce:	b5f5                	j	ffffffffc02000ba <cprintf>

ffffffffc02001d0 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001d0:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc02001d2:	00001617          	auipc	a2,0x1
ffffffffc02001d6:	70e60613          	addi	a2,a2,1806 # ffffffffc02018e0 <etext+0xf6>
ffffffffc02001da:	04e00593          	li	a1,78
ffffffffc02001de:	00001517          	auipc	a0,0x1
ffffffffc02001e2:	71a50513          	addi	a0,a0,1818 # ffffffffc02018f8 <etext+0x10e>
void print_stackframe(void) {
ffffffffc02001e6:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02001e8:	1cc000ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02001ec <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02001ec:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02001ee:	00001617          	auipc	a2,0x1
ffffffffc02001f2:	72260613          	addi	a2,a2,1826 # ffffffffc0201910 <etext+0x126>
ffffffffc02001f6:	00001597          	auipc	a1,0x1
ffffffffc02001fa:	73a58593          	addi	a1,a1,1850 # ffffffffc0201930 <etext+0x146>
ffffffffc02001fe:	00001517          	auipc	a0,0x1
ffffffffc0200202:	73a50513          	addi	a0,a0,1850 # ffffffffc0201938 <etext+0x14e>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200206:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200208:	eb3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020020c:	00001617          	auipc	a2,0x1
ffffffffc0200210:	73c60613          	addi	a2,a2,1852 # ffffffffc0201948 <etext+0x15e>
ffffffffc0200214:	00001597          	auipc	a1,0x1
ffffffffc0200218:	75c58593          	addi	a1,a1,1884 # ffffffffc0201970 <etext+0x186>
ffffffffc020021c:	00001517          	auipc	a0,0x1
ffffffffc0200220:	71c50513          	addi	a0,a0,1820 # ffffffffc0201938 <etext+0x14e>
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00001617          	auipc	a2,0x1
ffffffffc020022c:	75860613          	addi	a2,a2,1880 # ffffffffc0201980 <etext+0x196>
ffffffffc0200230:	00001597          	auipc	a1,0x1
ffffffffc0200234:	77058593          	addi	a1,a1,1904 # ffffffffc02019a0 <etext+0x1b6>
ffffffffc0200238:	00001517          	auipc	a0,0x1
ffffffffc020023c:	70050513          	addi	a0,a0,1792 # ffffffffc0201938 <etext+0x14e>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    }
    return 0;
}
ffffffffc0200244:	60a2                	ld	ra,8(sp)
ffffffffc0200246:	4501                	li	a0,0
ffffffffc0200248:	0141                	addi	sp,sp,16
ffffffffc020024a:	8082                	ret

ffffffffc020024c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020024c:	1141                	addi	sp,sp,-16
ffffffffc020024e:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200250:	ef3ff0ef          	jal	ra,ffffffffc0200142 <print_kerninfo>
    return 0;
}
ffffffffc0200254:	60a2                	ld	ra,8(sp)
ffffffffc0200256:	4501                	li	a0,0
ffffffffc0200258:	0141                	addi	sp,sp,16
ffffffffc020025a:	8082                	ret

ffffffffc020025c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025c:	1141                	addi	sp,sp,-16
ffffffffc020025e:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200260:	f71ff0ef          	jal	ra,ffffffffc02001d0 <print_stackframe>
    return 0;
}
ffffffffc0200264:	60a2                	ld	ra,8(sp)
ffffffffc0200266:	4501                	li	a0,0
ffffffffc0200268:	0141                	addi	sp,sp,16
ffffffffc020026a:	8082                	ret

ffffffffc020026c <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020026c:	7115                	addi	sp,sp,-224
ffffffffc020026e:	ed5e                	sd	s7,152(sp)
ffffffffc0200270:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200272:	00001517          	auipc	a0,0x1
ffffffffc0200276:	73e50513          	addi	a0,a0,1854 # ffffffffc02019b0 <etext+0x1c6>
kmonitor(struct trapframe *tf) {
ffffffffc020027a:	ed86                	sd	ra,216(sp)
ffffffffc020027c:	e9a2                	sd	s0,208(sp)
ffffffffc020027e:	e5a6                	sd	s1,200(sp)
ffffffffc0200280:	e1ca                	sd	s2,192(sp)
ffffffffc0200282:	fd4e                	sd	s3,184(sp)
ffffffffc0200284:	f952                	sd	s4,176(sp)
ffffffffc0200286:	f556                	sd	s5,168(sp)
ffffffffc0200288:	f15a                	sd	s6,160(sp)
ffffffffc020028a:	e962                	sd	s8,144(sp)
ffffffffc020028c:	e566                	sd	s9,136(sp)
ffffffffc020028e:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200290:	e2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200294:	00001517          	auipc	a0,0x1
ffffffffc0200298:	74450513          	addi	a0,a0,1860 # ffffffffc02019d8 <etext+0x1ee>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002a0:	000b8563          	beqz	s7,ffffffffc02002aa <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002a4:	855e                	mv	a0,s7
ffffffffc02002a6:	3a4000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc02002aa:	00001c17          	auipc	s8,0x1
ffffffffc02002ae:	79ec0c13          	addi	s8,s8,1950 # ffffffffc0201a48 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002b2:	00001917          	auipc	s2,0x1
ffffffffc02002b6:	74e90913          	addi	s2,s2,1870 # ffffffffc0201a00 <etext+0x216>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002ba:	00001497          	auipc	s1,0x1
ffffffffc02002be:	74e48493          	addi	s1,s1,1870 # ffffffffc0201a08 <etext+0x21e>
        if (argc == MAXARGS - 1) {
ffffffffc02002c2:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002c4:	00001b17          	auipc	s6,0x1
ffffffffc02002c8:	74cb0b13          	addi	s6,s6,1868 # ffffffffc0201a10 <etext+0x226>
        argv[argc ++] = buf;
ffffffffc02002cc:	00001a17          	auipc	s4,0x1
ffffffffc02002d0:	664a0a13          	addi	s4,s4,1636 # ffffffffc0201930 <etext+0x146>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002d4:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002d6:	854a                	mv	a0,s2
ffffffffc02002d8:	3ac010ef          	jal	ra,ffffffffc0201684 <readline>
ffffffffc02002dc:	842a                	mv	s0,a0
ffffffffc02002de:	dd65                	beqz	a0,ffffffffc02002d6 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002e0:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002e4:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002e6:	e1bd                	bnez	a1,ffffffffc020034c <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02002e8:	fe0c87e3          	beqz	s9,ffffffffc02002d6 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002ec:	6582                	ld	a1,0(sp)
ffffffffc02002ee:	00001d17          	auipc	s10,0x1
ffffffffc02002f2:	75ad0d13          	addi	s10,s10,1882 # ffffffffc0201a48 <commands>
        argv[argc ++] = buf;
ffffffffc02002f6:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f8:	4401                	li	s0,0
ffffffffc02002fa:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002fc:	4a8010ef          	jal	ra,ffffffffc02017a4 <strcmp>
ffffffffc0200300:	c919                	beqz	a0,ffffffffc0200316 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200302:	2405                	addiw	s0,s0,1
ffffffffc0200304:	0b540063          	beq	s0,s5,ffffffffc02003a4 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200308:	000d3503          	ld	a0,0(s10)
ffffffffc020030c:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020030e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200310:	494010ef          	jal	ra,ffffffffc02017a4 <strcmp>
ffffffffc0200314:	f57d                	bnez	a0,ffffffffc0200302 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200316:	00141793          	slli	a5,s0,0x1
ffffffffc020031a:	97a2                	add	a5,a5,s0
ffffffffc020031c:	078e                	slli	a5,a5,0x3
ffffffffc020031e:	97e2                	add	a5,a5,s8
ffffffffc0200320:	6b9c                	ld	a5,16(a5)
ffffffffc0200322:	865e                	mv	a2,s7
ffffffffc0200324:	002c                	addi	a1,sp,8
ffffffffc0200326:	fffc851b          	addiw	a0,s9,-1
ffffffffc020032a:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020032c:	fa0555e3          	bgez	a0,ffffffffc02002d6 <kmonitor+0x6a>
}
ffffffffc0200330:	60ee                	ld	ra,216(sp)
ffffffffc0200332:	644e                	ld	s0,208(sp)
ffffffffc0200334:	64ae                	ld	s1,200(sp)
ffffffffc0200336:	690e                	ld	s2,192(sp)
ffffffffc0200338:	79ea                	ld	s3,184(sp)
ffffffffc020033a:	7a4a                	ld	s4,176(sp)
ffffffffc020033c:	7aaa                	ld	s5,168(sp)
ffffffffc020033e:	7b0a                	ld	s6,160(sp)
ffffffffc0200340:	6bea                	ld	s7,152(sp)
ffffffffc0200342:	6c4a                	ld	s8,144(sp)
ffffffffc0200344:	6caa                	ld	s9,136(sp)
ffffffffc0200346:	6d0a                	ld	s10,128(sp)
ffffffffc0200348:	612d                	addi	sp,sp,224
ffffffffc020034a:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020034c:	8526                	mv	a0,s1
ffffffffc020034e:	474010ef          	jal	ra,ffffffffc02017c2 <strchr>
ffffffffc0200352:	c901                	beqz	a0,ffffffffc0200362 <kmonitor+0xf6>
ffffffffc0200354:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200358:	00040023          	sb	zero,0(s0)
ffffffffc020035c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020035e:	d5c9                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc0200360:	b7f5                	j	ffffffffc020034c <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200362:	00044783          	lbu	a5,0(s0)
ffffffffc0200366:	d3c9                	beqz	a5,ffffffffc02002e8 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	033c8963          	beq	s9,s3,ffffffffc020039a <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020036c:	003c9793          	slli	a5,s9,0x3
ffffffffc0200370:	0118                	addi	a4,sp,128
ffffffffc0200372:	97ba                	add	a5,a5,a4
ffffffffc0200374:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200378:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020037c:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020037e:	e591                	bnez	a1,ffffffffc020038a <kmonitor+0x11e>
ffffffffc0200380:	b7b5                	j	ffffffffc02002ec <kmonitor+0x80>
ffffffffc0200382:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200386:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200388:	d1a5                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc020038a:	8526                	mv	a0,s1
ffffffffc020038c:	436010ef          	jal	ra,ffffffffc02017c2 <strchr>
ffffffffc0200390:	d96d                	beqz	a0,ffffffffc0200382 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200392:	00044583          	lbu	a1,0(s0)
ffffffffc0200396:	d9a9                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc0200398:	bf55                	j	ffffffffc020034c <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039a:	45c1                	li	a1,16
ffffffffc020039c:	855a                	mv	a0,s6
ffffffffc020039e:	d1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003a2:	b7e9                	j	ffffffffc020036c <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003a4:	6582                	ld	a1,0(sp)
ffffffffc02003a6:	00001517          	auipc	a0,0x1
ffffffffc02003aa:	68a50513          	addi	a0,a0,1674 # ffffffffc0201a30 <etext+0x246>
ffffffffc02003ae:	d0dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    return 0;
ffffffffc02003b2:	b715                	j	ffffffffc02002d6 <kmonitor+0x6a>

ffffffffc02003b4 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003b4:	00006317          	auipc	t1,0x6
ffffffffc02003b8:	19430313          	addi	t1,t1,404 # ffffffffc0206548 <is_panic>
ffffffffc02003bc:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003c0:	715d                	addi	sp,sp,-80
ffffffffc02003c2:	ec06                	sd	ra,24(sp)
ffffffffc02003c4:	e822                	sd	s0,16(sp)
ffffffffc02003c6:	f436                	sd	a3,40(sp)
ffffffffc02003c8:	f83a                	sd	a4,48(sp)
ffffffffc02003ca:	fc3e                	sd	a5,56(sp)
ffffffffc02003cc:	e0c2                	sd	a6,64(sp)
ffffffffc02003ce:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003d0:	020e1a63          	bnez	t3,ffffffffc0200404 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003d4:	4785                	li	a5,1
ffffffffc02003d6:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003da:	8432                	mv	s0,a2
ffffffffc02003dc:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003de:	862e                	mv	a2,a1
ffffffffc02003e0:	85aa                	mv	a1,a0
ffffffffc02003e2:	00001517          	auipc	a0,0x1
ffffffffc02003e6:	6ae50513          	addi	a0,a0,1710 # ffffffffc0201a90 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02003ea:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003ec:	ccfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003f0:	65a2                	ld	a1,8(sp)
ffffffffc02003f2:	8522                	mv	a0,s0
ffffffffc02003f4:	ca7ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
    cprintf("\n");
ffffffffc02003f8:	00001517          	auipc	a0,0x1
ffffffffc02003fc:	4e050513          	addi	a0,a0,1248 # ffffffffc02018d8 <etext+0xee>
ffffffffc0200400:	cbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200404:	062000ef          	jal	ra,ffffffffc0200466 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200408:	4501                	li	a0,0
ffffffffc020040a:	e63ff0ef          	jal	ra,ffffffffc020026c <kmonitor>
    while (1) {
ffffffffc020040e:	bfed                	j	ffffffffc0200408 <__panic+0x54>

ffffffffc0200410 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200410:	1141                	addi	sp,sp,-16
ffffffffc0200412:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc0200414:	02000793          	li	a5,32
ffffffffc0200418:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020041c:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200420:	67e1                	lui	a5,0x18
ffffffffc0200422:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200426:	953e                	add	a0,a0,a5
ffffffffc0200428:	32a010ef          	jal	ra,ffffffffc0201752 <sbi_set_timer>
}
ffffffffc020042c:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	1207b123          	sd	zero,290(a5) # ffffffffc0206550 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200436:	00001517          	auipc	a0,0x1
ffffffffc020043a:	67a50513          	addi	a0,a0,1658 # ffffffffc0201ab0 <commands+0x68>
}
ffffffffc020043e:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200442:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	3040106f          	j	ffffffffc0201752 <sbi_set_timer>

ffffffffc0200452 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200454:	0ff57513          	zext.b	a0,a0
ffffffffc0200458:	2e00106f          	j	ffffffffc0201738 <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc020045c:	3100106f          	j	ffffffffc020176c <sbi_console_getchar>

ffffffffc0200460 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200460:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200464:	8082                	ret

ffffffffc0200466 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200466:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020046a:	8082                	ret

ffffffffc020046c <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020046c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200470:	00000797          	auipc	a5,0x0
ffffffffc0200474:	2e478793          	addi	a5,a5,740 # ffffffffc0200754 <__alltraps>
ffffffffc0200478:	10579073          	csrw	stvec,a5
}
ffffffffc020047c:	8082                	ret

ffffffffc020047e <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020047e:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200480:	1141                	addi	sp,sp,-16
ffffffffc0200482:	e022                	sd	s0,0(sp)
ffffffffc0200484:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200486:	00001517          	auipc	a0,0x1
ffffffffc020048a:	64a50513          	addi	a0,a0,1610 # ffffffffc0201ad0 <commands+0x88>
void print_regs(struct pushregs *gpr) {
ffffffffc020048e:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00001517          	auipc	a0,0x1
ffffffffc020049a:	65250513          	addi	a0,a0,1618 # ffffffffc0201ae8 <commands+0xa0>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00001517          	auipc	a0,0x1
ffffffffc02004a8:	65c50513          	addi	a0,a0,1628 # ffffffffc0201b00 <commands+0xb8>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00001517          	auipc	a0,0x1
ffffffffc02004b6:	66650513          	addi	a0,a0,1638 # ffffffffc0201b18 <commands+0xd0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00001517          	auipc	a0,0x1
ffffffffc02004c4:	67050513          	addi	a0,a0,1648 # ffffffffc0201b30 <commands+0xe8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00001517          	auipc	a0,0x1
ffffffffc02004d2:	67a50513          	addi	a0,a0,1658 # ffffffffc0201b48 <commands+0x100>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00001517          	auipc	a0,0x1
ffffffffc02004e0:	68450513          	addi	a0,a0,1668 # ffffffffc0201b60 <commands+0x118>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00001517          	auipc	a0,0x1
ffffffffc02004ee:	68e50513          	addi	a0,a0,1678 # ffffffffc0201b78 <commands+0x130>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00001517          	auipc	a0,0x1
ffffffffc02004fc:	69850513          	addi	a0,a0,1688 # ffffffffc0201b90 <commands+0x148>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00001517          	auipc	a0,0x1
ffffffffc020050a:	6a250513          	addi	a0,a0,1698 # ffffffffc0201ba8 <commands+0x160>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00001517          	auipc	a0,0x1
ffffffffc0200518:	6ac50513          	addi	a0,a0,1708 # ffffffffc0201bc0 <commands+0x178>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00001517          	auipc	a0,0x1
ffffffffc0200526:	6b650513          	addi	a0,a0,1718 # ffffffffc0201bd8 <commands+0x190>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00001517          	auipc	a0,0x1
ffffffffc0200534:	6c050513          	addi	a0,a0,1728 # ffffffffc0201bf0 <commands+0x1a8>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00001517          	auipc	a0,0x1
ffffffffc0200542:	6ca50513          	addi	a0,a0,1738 # ffffffffc0201c08 <commands+0x1c0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00001517          	auipc	a0,0x1
ffffffffc0200550:	6d450513          	addi	a0,a0,1748 # ffffffffc0201c20 <commands+0x1d8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00001517          	auipc	a0,0x1
ffffffffc020055e:	6de50513          	addi	a0,a0,1758 # ffffffffc0201c38 <commands+0x1f0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00001517          	auipc	a0,0x1
ffffffffc020056c:	6e850513          	addi	a0,a0,1768 # ffffffffc0201c50 <commands+0x208>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00001517          	auipc	a0,0x1
ffffffffc020057a:	6f250513          	addi	a0,a0,1778 # ffffffffc0201c68 <commands+0x220>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00001517          	auipc	a0,0x1
ffffffffc0200588:	6fc50513          	addi	a0,a0,1788 # ffffffffc0201c80 <commands+0x238>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00001517          	auipc	a0,0x1
ffffffffc0200596:	70650513          	addi	a0,a0,1798 # ffffffffc0201c98 <commands+0x250>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00001517          	auipc	a0,0x1
ffffffffc02005a4:	71050513          	addi	a0,a0,1808 # ffffffffc0201cb0 <commands+0x268>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00001517          	auipc	a0,0x1
ffffffffc02005b2:	71a50513          	addi	a0,a0,1818 # ffffffffc0201cc8 <commands+0x280>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00001517          	auipc	a0,0x1
ffffffffc02005c0:	72450513          	addi	a0,a0,1828 # ffffffffc0201ce0 <commands+0x298>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00001517          	auipc	a0,0x1
ffffffffc02005ce:	72e50513          	addi	a0,a0,1838 # ffffffffc0201cf8 <commands+0x2b0>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00001517          	auipc	a0,0x1
ffffffffc02005dc:	73850513          	addi	a0,a0,1848 # ffffffffc0201d10 <commands+0x2c8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00001517          	auipc	a0,0x1
ffffffffc02005ea:	74250513          	addi	a0,a0,1858 # ffffffffc0201d28 <commands+0x2e0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00001517          	auipc	a0,0x1
ffffffffc02005f8:	74c50513          	addi	a0,a0,1868 # ffffffffc0201d40 <commands+0x2f8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00001517          	auipc	a0,0x1
ffffffffc0200606:	75650513          	addi	a0,a0,1878 # ffffffffc0201d58 <commands+0x310>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00001517          	auipc	a0,0x1
ffffffffc0200614:	76050513          	addi	a0,a0,1888 # ffffffffc0201d70 <commands+0x328>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00001517          	auipc	a0,0x1
ffffffffc0200622:	76a50513          	addi	a0,a0,1898 # ffffffffc0201d88 <commands+0x340>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00001517          	auipc	a0,0x1
ffffffffc0200630:	77450513          	addi	a0,a0,1908 # ffffffffc0201da0 <commands+0x358>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
}
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020063e:	00001517          	auipc	a0,0x1
ffffffffc0200642:	77a50513          	addi	a0,a0,1914 # ffffffffc0201db8 <commands+0x370>
}
ffffffffc0200646:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020064e:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200650:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200652:	00001517          	auipc	a0,0x1
ffffffffc0200656:	77e50513          	addi	a0,a0,1918 # ffffffffc0201dd0 <commands+0x388>
void print_trapframe(struct trapframe *tf) {
ffffffffc020065a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00001517          	auipc	a0,0x1
ffffffffc020066e:	77e50513          	addi	a0,a0,1918 # ffffffffc0201de8 <commands+0x3a0>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00001517          	auipc	a0,0x1
ffffffffc020067e:	78650513          	addi	a0,a0,1926 # ffffffffc0201e00 <commands+0x3b8>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00001517          	auipc	a0,0x1
ffffffffc020068e:	78e50513          	addi	a0,a0,1934 # ffffffffc0201e18 <commands+0x3d0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	11843583          	ld	a1,280(s0)
}
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020069e:	00001517          	auipc	a0,0x1
ffffffffc02006a2:	79250513          	addi	a0,a0,1938 # ffffffffc0201e30 <commands+0x3e8>
}
ffffffffc02006a6:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	06f76d63          	bltu	a4,a5,ffffffffc020072e <interrupt_handler+0x84>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	85870713          	addi	a4,a4,-1960 # ffffffffc0201f10 <commands+0x4c8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02006ca:	00001517          	auipc	a0,0x1
ffffffffc02006ce:	7de50513          	addi	a0,a0,2014 # ffffffffc0201ea8 <commands+0x460>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006d4:	00001517          	auipc	a0,0x1
ffffffffc02006d8:	7b450513          	addi	a0,a0,1972 # ffffffffc0201e88 <commands+0x440>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006de:	00001517          	auipc	a0,0x1
ffffffffc02006e2:	76a50513          	addi	a0,a0,1898 # ffffffffc0201e48 <commands+0x400>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e8:	00001517          	auipc	a0,0x1
ffffffffc02006ec:	7e050513          	addi	a0,a0,2016 # ffffffffc0201ec8 <commands+0x480>
ffffffffc02006f0:	b2e9                	j	ffffffffc02000ba <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02006f2:	1141                	addi	sp,sp,-16
ffffffffc02006f4:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02006f6:	d4dff0ef          	jal	ra,ffffffffc0200442 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02006fa:	00006717          	auipc	a4,0x6
ffffffffc02006fe:	e5670713          	addi	a4,a4,-426 # ffffffffc0206550 <ticks>
ffffffffc0200702:	631c                	ld	a5,0(a4)
ffffffffc0200704:	6589                	lui	a1,0x2
ffffffffc0200706:	71058593          	addi	a1,a1,1808 # 2710 <kern_entry-0xffffffffc01fd8f0>
ffffffffc020070a:	0785                	addi	a5,a5,1
ffffffffc020070c:	02b7f6b3          	remu	a3,a5,a1
ffffffffc0200710:	e31c                	sd	a5,0(a4)
ffffffffc0200712:	ce99                	beqz	a3,ffffffffc0200730 <interrupt_handler+0x86>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200714:	60a2                	ld	ra,8(sp)
ffffffffc0200716:	0141                	addi	sp,sp,16
ffffffffc0200718:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc020071a:	00001517          	auipc	a0,0x1
ffffffffc020071e:	7d650513          	addi	a0,a0,2006 # ffffffffc0201ef0 <commands+0x4a8>
ffffffffc0200722:	ba61                	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200724:	00001517          	auipc	a0,0x1
ffffffffc0200728:	74450513          	addi	a0,a0,1860 # ffffffffc0201e68 <commands+0x420>
ffffffffc020072c:	b279                	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc020072e:	bf31                	j	ffffffffc020064a <print_trapframe>
}
ffffffffc0200730:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200732:	00001517          	auipc	a0,0x1
ffffffffc0200736:	7ae50513          	addi	a0,a0,1966 # ffffffffc0201ee0 <commands+0x498>
}
ffffffffc020073a:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020073c:	babd                	j	ffffffffc02000ba <cprintf>

ffffffffc020073e <trap>:
            break;
    }
}

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc020073e:	11853783          	ld	a5,280(a0)
ffffffffc0200742:	0007c763          	bltz	a5,ffffffffc0200750 <trap+0x12>
    switch (tf->cause) {
ffffffffc0200746:	472d                	li	a4,11
ffffffffc0200748:	00f76363          	bltu	a4,a5,ffffffffc020074e <trap+0x10>
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}
ffffffffc020074c:	8082                	ret
            print_trapframe(tf);
ffffffffc020074e:	bdf5                	j	ffffffffc020064a <print_trapframe>
        interrupt_handler(tf);
ffffffffc0200750:	bfa9                	j	ffffffffc02006aa <interrupt_handler>
	...

ffffffffc0200754 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200754:	14011073          	csrw	sscratch,sp
ffffffffc0200758:	712d                	addi	sp,sp,-288
ffffffffc020075a:	e002                	sd	zero,0(sp)
ffffffffc020075c:	e406                	sd	ra,8(sp)
ffffffffc020075e:	ec0e                	sd	gp,24(sp)
ffffffffc0200760:	f012                	sd	tp,32(sp)
ffffffffc0200762:	f416                	sd	t0,40(sp)
ffffffffc0200764:	f81a                	sd	t1,48(sp)
ffffffffc0200766:	fc1e                	sd	t2,56(sp)
ffffffffc0200768:	e0a2                	sd	s0,64(sp)
ffffffffc020076a:	e4a6                	sd	s1,72(sp)
ffffffffc020076c:	e8aa                	sd	a0,80(sp)
ffffffffc020076e:	ecae                	sd	a1,88(sp)
ffffffffc0200770:	f0b2                	sd	a2,96(sp)
ffffffffc0200772:	f4b6                	sd	a3,104(sp)
ffffffffc0200774:	f8ba                	sd	a4,112(sp)
ffffffffc0200776:	fcbe                	sd	a5,120(sp)
ffffffffc0200778:	e142                	sd	a6,128(sp)
ffffffffc020077a:	e546                	sd	a7,136(sp)
ffffffffc020077c:	e94a                	sd	s2,144(sp)
ffffffffc020077e:	ed4e                	sd	s3,152(sp)
ffffffffc0200780:	f152                	sd	s4,160(sp)
ffffffffc0200782:	f556                	sd	s5,168(sp)
ffffffffc0200784:	f95a                	sd	s6,176(sp)
ffffffffc0200786:	fd5e                	sd	s7,184(sp)
ffffffffc0200788:	e1e2                	sd	s8,192(sp)
ffffffffc020078a:	e5e6                	sd	s9,200(sp)
ffffffffc020078c:	e9ea                	sd	s10,208(sp)
ffffffffc020078e:	edee                	sd	s11,216(sp)
ffffffffc0200790:	f1f2                	sd	t3,224(sp)
ffffffffc0200792:	f5f6                	sd	t4,232(sp)
ffffffffc0200794:	f9fa                	sd	t5,240(sp)
ffffffffc0200796:	fdfe                	sd	t6,248(sp)
ffffffffc0200798:	14001473          	csrrw	s0,sscratch,zero
ffffffffc020079c:	100024f3          	csrr	s1,sstatus
ffffffffc02007a0:	14102973          	csrr	s2,sepc
ffffffffc02007a4:	143029f3          	csrr	s3,stval
ffffffffc02007a8:	14202a73          	csrr	s4,scause
ffffffffc02007ac:	e822                	sd	s0,16(sp)
ffffffffc02007ae:	e226                	sd	s1,256(sp)
ffffffffc02007b0:	e64a                	sd	s2,264(sp)
ffffffffc02007b2:	ea4e                	sd	s3,272(sp)
ffffffffc02007b4:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc02007b6:	850a                	mv	a0,sp
    jal trap
ffffffffc02007b8:	f87ff0ef          	jal	ra,ffffffffc020073e <trap>

ffffffffc02007bc <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc02007bc:	6492                	ld	s1,256(sp)
ffffffffc02007be:	6932                	ld	s2,264(sp)
ffffffffc02007c0:	10049073          	csrw	sstatus,s1
ffffffffc02007c4:	14191073          	csrw	sepc,s2
ffffffffc02007c8:	60a2                	ld	ra,8(sp)
ffffffffc02007ca:	61e2                	ld	gp,24(sp)
ffffffffc02007cc:	7202                	ld	tp,32(sp)
ffffffffc02007ce:	72a2                	ld	t0,40(sp)
ffffffffc02007d0:	7342                	ld	t1,48(sp)
ffffffffc02007d2:	73e2                	ld	t2,56(sp)
ffffffffc02007d4:	6406                	ld	s0,64(sp)
ffffffffc02007d6:	64a6                	ld	s1,72(sp)
ffffffffc02007d8:	6546                	ld	a0,80(sp)
ffffffffc02007da:	65e6                	ld	a1,88(sp)
ffffffffc02007dc:	7606                	ld	a2,96(sp)
ffffffffc02007de:	76a6                	ld	a3,104(sp)
ffffffffc02007e0:	7746                	ld	a4,112(sp)
ffffffffc02007e2:	77e6                	ld	a5,120(sp)
ffffffffc02007e4:	680a                	ld	a6,128(sp)
ffffffffc02007e6:	68aa                	ld	a7,136(sp)
ffffffffc02007e8:	694a                	ld	s2,144(sp)
ffffffffc02007ea:	69ea                	ld	s3,152(sp)
ffffffffc02007ec:	7a0a                	ld	s4,160(sp)
ffffffffc02007ee:	7aaa                	ld	s5,168(sp)
ffffffffc02007f0:	7b4a                	ld	s6,176(sp)
ffffffffc02007f2:	7bea                	ld	s7,184(sp)
ffffffffc02007f4:	6c0e                	ld	s8,192(sp)
ffffffffc02007f6:	6cae                	ld	s9,200(sp)
ffffffffc02007f8:	6d4e                	ld	s10,208(sp)
ffffffffc02007fa:	6dee                	ld	s11,216(sp)
ffffffffc02007fc:	7e0e                	ld	t3,224(sp)
ffffffffc02007fe:	7eae                	ld	t4,232(sp)
ffffffffc0200800:	7f4e                	ld	t5,240(sp)
ffffffffc0200802:	7fee                	ld	t6,248(sp)
ffffffffc0200804:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200806:	10200073          	sret

ffffffffc020080a <buddy_system_init>:
#define IS_POWER_OF_2(x) (!((x) & ((x) - 1)))

static void
buddy_system_init(void)
{
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc020080a:	00006797          	auipc	a5,0x6
ffffffffc020080e:	81e78793          	addi	a5,a5,-2018 # ffffffffc0206028 <free_area>
ffffffffc0200812:	00006717          	auipc	a4,0x6
ffffffffc0200816:	93670713          	addi	a4,a4,-1738 # ffffffffc0206148 <buf>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020081a:	e79c                	sd	a5,8(a5)
ffffffffc020081c:	e39c                	sd	a5,0(a5)
    {
        list_init(&(free_area[i].free_list));
        free_area[i].nr_free = 0;
ffffffffc020081e:	0007a823          	sw	zero,16(a5)
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200822:	07e1                	addi	a5,a5,24
ffffffffc0200824:	fee79be3          	bne	a5,a4,ffffffffc020081a <buddy_system_init+0x10>
    }
}
ffffffffc0200828:	8082                	ret

ffffffffc020082a <split_page>:
        p += order_size;
    }
}

static void split_page(int order)
{
ffffffffc020082a:	7179                	addi	sp,sp,-48
ffffffffc020082c:	e84a                	sd	s2,16(sp)
ffffffffc020082e:	00151913          	slli	s2,a0,0x1
ffffffffc0200832:	e052                	sd	s4,0(sp)
ffffffffc0200834:	00a90a33          	add	s4,s2,a0
ffffffffc0200838:	e44e                	sd	s3,8(sp)
ffffffffc020083a:	0a0e                	slli	s4,s4,0x3
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
ffffffffc020083c:	00005997          	auipc	s3,0x5
ffffffffc0200840:	7ec98993          	addi	s3,s3,2028 # ffffffffc0206028 <free_area>
ffffffffc0200844:	014987b3          	add	a5,s3,s4
ffffffffc0200848:	ec26                	sd	s1,24(sp)
ffffffffc020084a:	6784                	ld	s1,8(a5)
ffffffffc020084c:	f022                	sd	s0,32(sp)
ffffffffc020084e:	f406                	sd	ra,40(sp)
ffffffffc0200850:	842a                	mv	s0,a0
    if (list_empty(&(free_list(order))))
ffffffffc0200852:	08f48063          	beq	s1,a5,ffffffffc02008d2 <split_page+0xa8>
        split_page(order + 1);
    }
    list_entry_t *le = list_next(&(free_list(order)));
    struct Page *page = le2page(le, page_link);
    list_del(&(page->page_link));
    nr_free(order) -= 1;
ffffffffc0200856:	9922                	add	s2,s2,s0
    uint32_t n = 1 << (order - 1);
ffffffffc0200858:	4705                	li	a4,1
ffffffffc020085a:	347d                	addiw	s0,s0,-1
ffffffffc020085c:	0087173b          	sllw	a4,a4,s0
    nr_free(order) -= 1;
ffffffffc0200860:	090e                	slli	s2,s2,0x3
    __list_del(listelm->prev, listelm->next);
ffffffffc0200862:	608c                	ld	a1,0(s1)
ffffffffc0200864:	6490                	ld	a2,8(s1)
ffffffffc0200866:	994e                	add	s2,s2,s3
    struct Page *p = page + n;
ffffffffc0200868:	02071513          	slli	a0,a4,0x20
    nr_free(order) -= 1;
ffffffffc020086c:	01092683          	lw	a3,16(s2)
    struct Page *p = page + n;
ffffffffc0200870:	9101                	srli	a0,a0,0x20
ffffffffc0200872:	00251793          	slli	a5,a0,0x2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200876:	e590                	sd	a2,8(a1)
ffffffffc0200878:	97aa                	add	a5,a5,a0
    next->prev = prev;
ffffffffc020087a:	e20c                	sd	a1,0(a2)
    nr_free(order) -= 1;
ffffffffc020087c:	36fd                	addiw	a3,a3,-1
    struct Page *p = page + n;
ffffffffc020087e:	078e                	slli	a5,a5,0x3
    nr_free(order) -= 1;
ffffffffc0200880:	00d92823          	sw	a3,16(s2)
    struct Page *p = page + n;
ffffffffc0200884:	17a1                	addi	a5,a5,-24
ffffffffc0200886:	97a6                	add	a5,a5,s1
    page->property = n;
ffffffffc0200888:	fee4ac23          	sw	a4,-8(s1)
    p->property = n;
ffffffffc020088c:	cb98                	sw	a4,16(a5)
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020088e:	00878693          	addi	a3,a5,8
ffffffffc0200892:	4709                	li	a4,2
ffffffffc0200894:	40e6b02f          	amoor.d	zero,a4,(a3)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200898:	00141513          	slli	a0,s0,0x1
ffffffffc020089c:	942a                	add	s0,s0,a0
ffffffffc020089e:	040e                	slli	s0,s0,0x3
ffffffffc02008a0:	944e                	add	s0,s0,s3
ffffffffc02008a2:	6414                	ld	a3,8(s0)
    SetPageProperty(p);
    list_add(&(free_list(order - 1)), &(page->page_link));
ffffffffc02008a4:	1a21                	addi	s4,s4,-24
    prev->next = next->prev = elm;
ffffffffc02008a6:	e404                	sd	s1,8(s0)
ffffffffc02008a8:	99d2                	add	s3,s3,s4
    list_add(&(page->page_link), &(p->page_link));
    nr_free(order - 1) += 2;
ffffffffc02008aa:	4818                	lw	a4,16(s0)
    elm->prev = prev;
ffffffffc02008ac:	0134b023          	sd	s3,0(s1)
    list_add(&(page->page_link), &(p->page_link));
ffffffffc02008b0:	01878613          	addi	a2,a5,24
    prev->next = next->prev = elm;
ffffffffc02008b4:	e290                	sd	a2,0(a3)
ffffffffc02008b6:	e490                	sd	a2,8(s1)
    elm->prev = prev;
ffffffffc02008b8:	ef84                	sd	s1,24(a5)
    elm->next = next;
ffffffffc02008ba:	f394                	sd	a3,32(a5)
    nr_free(order - 1) += 2;
ffffffffc02008bc:	0027079b          	addiw	a5,a4,2
    return;
}
ffffffffc02008c0:	70a2                	ld	ra,40(sp)
    nr_free(order - 1) += 2;
ffffffffc02008c2:	c81c                	sw	a5,16(s0)
}
ffffffffc02008c4:	7402                	ld	s0,32(sp)
ffffffffc02008c6:	64e2                	ld	s1,24(sp)
ffffffffc02008c8:	6942                	ld	s2,16(sp)
ffffffffc02008ca:	69a2                	ld	s3,8(sp)
ffffffffc02008cc:	6a02                	ld	s4,0(sp)
ffffffffc02008ce:	6145                	addi	sp,sp,48
ffffffffc02008d0:	8082                	ret
        split_page(order + 1);
ffffffffc02008d2:	2505                	addiw	a0,a0,1
ffffffffc02008d4:	f57ff0ef          	jal	ra,ffffffffc020082a <split_page>
    return listelm->next;
ffffffffc02008d8:	6484                	ld	s1,8(s1)
ffffffffc02008da:	bfb5                	j	ffffffffc0200856 <split_page+0x2c>

ffffffffc02008dc <add_page>:
}

// 先将块按照地址从小到大的顺序加入到指定序号的链表当中
static void add_page(uint32_t order, struct Page *base)
{
    if (list_empty(&(free_list(order))))
ffffffffc02008dc:	02051793          	slli	a5,a0,0x20
ffffffffc02008e0:	9381                	srli	a5,a5,0x20
ffffffffc02008e2:	00179693          	slli	a3,a5,0x1
ffffffffc02008e6:	96be                	add	a3,a3,a5
ffffffffc02008e8:	00369793          	slli	a5,a3,0x3
ffffffffc02008ec:	00005697          	auipc	a3,0x5
ffffffffc02008f0:	73c68693          	addi	a3,a3,1852 # ffffffffc0206028 <free_area>
ffffffffc02008f4:	96be                	add	a3,a3,a5
    return list->next == list;
ffffffffc02008f6:	669c                	ld	a5,8(a3)
        while ((le = list_next(le)) != &(free_list(order)))
        {
            struct Page *page = le2page(le, page_link);
            if (base < page)
            {
                list_add_before(le, &(base->page_link));
ffffffffc02008f8:	01858613          	addi	a2,a1,24
    if (list_empty(&(free_list(order))))
ffffffffc02008fc:	02f68c63          	beq	a3,a5,ffffffffc0200934 <add_page+0x58>
            struct Page *page = le2page(le, page_link);
ffffffffc0200900:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0200904:	00e5ea63          	bltu	a1,a4,ffffffffc0200918 <add_page+0x3c>
    return listelm->next;
ffffffffc0200908:	6798                	ld	a4,8(a5)
                break;
            }
            else if (list_next(le) == &(free_list(order)))
ffffffffc020090a:	00e68d63          	beq	a3,a4,ffffffffc0200924 <add_page+0x48>
{
ffffffffc020090e:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0200910:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0200914:	fee5fae3          	bgeu	a1,a4,ffffffffc0200908 <add_page+0x2c>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200918:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc020091a:	e390                	sd	a2,0(a5)
ffffffffc020091c:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020091e:	f19c                	sd	a5,32(a1)
    elm->prev = prev;
ffffffffc0200920:	ed98                	sd	a4,24(a1)
}
ffffffffc0200922:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200924:	e290                	sd	a2,0(a3)
ffffffffc0200926:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200928:	f194                	sd	a3,32(a1)
    return listelm->next;
ffffffffc020092a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020092c:	ed9c                	sd	a5,24(a1)
        while ((le = list_next(le)) != &(free_list(order)))
ffffffffc020092e:	fee690e3          	bne	a3,a4,ffffffffc020090e <add_page+0x32>
            {
                list_add(le, &(base->page_link));
            }
        }
    }
}
ffffffffc0200932:	8082                	ret
        list_add(&(free_list(order)), &(base->page_link));
ffffffffc0200934:	01858793          	addi	a5,a1,24
    prev->next = next->prev = elm;
ffffffffc0200938:	e29c                	sd	a5,0(a3)
ffffffffc020093a:	e69c                	sd	a5,8(a3)
    elm->next = next;
ffffffffc020093c:	f194                	sd	a3,32(a1)
    elm->prev = prev;
ffffffffc020093e:	ed94                	sd	a3,24(a1)
}
ffffffffc0200940:	8082                	ret

ffffffffc0200942 <buddy_system_nr_free_pages>:

static size_t
buddy_system_nr_free_pages(void)
{
    size_t num = 0;
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200942:	00005697          	auipc	a3,0x5
ffffffffc0200946:	6f668693          	addi	a3,a3,1782 # ffffffffc0206038 <free_area+0x10>
ffffffffc020094a:	4701                	li	a4,0
    size_t num = 0;
ffffffffc020094c:	4501                	li	a0,0
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc020094e:	4631                	li	a2,12
    {
        num += nr_free(i) << i;
ffffffffc0200950:	429c                	lw	a5,0(a3)
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200952:	06e1                	addi	a3,a3,24
        num += nr_free(i) << i;
ffffffffc0200954:	00e797bb          	sllw	a5,a5,a4
ffffffffc0200958:	1782                	slli	a5,a5,0x20
ffffffffc020095a:	9381                	srli	a5,a5,0x20
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc020095c:	2705                	addiw	a4,a4,1
        num += nr_free(i) << i;
ffffffffc020095e:	953e                	add	a0,a0,a5
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200960:	fec718e3          	bne	a4,a2,ffffffffc0200950 <buddy_system_nr_free_pages+0xe>
    }
    return num;
}
ffffffffc0200964:	8082                	ret

ffffffffc0200966 <buddy_system_free_pages>:
{
ffffffffc0200966:	7139                	addi	sp,sp,-64
ffffffffc0200968:	fc06                	sd	ra,56(sp)
ffffffffc020096a:	f822                	sd	s0,48(sp)
ffffffffc020096c:	f426                	sd	s1,40(sp)
ffffffffc020096e:	f04a                	sd	s2,32(sp)
ffffffffc0200970:	ec4e                	sd	s3,24(sp)
ffffffffc0200972:	e852                	sd	s4,16(sp)
ffffffffc0200974:	e456                	sd	s5,8(sp)
    assert(n > 0);
ffffffffc0200976:	18058c63          	beqz	a1,ffffffffc0200b0e <buddy_system_free_pages+0x1a8>
    assert(IS_POWER_OF_2(n));
ffffffffc020097a:	fff58793          	addi	a5,a1,-1
ffffffffc020097e:	8fed                	and	a5,a5,a1
ffffffffc0200980:	16079763          	bnez	a5,ffffffffc0200aee <buddy_system_free_pages+0x188>
    assert(n < (1 << (MAX_ORDER - 1)));
ffffffffc0200984:	7ff00793          	li	a5,2047
ffffffffc0200988:	1ab7e363          	bltu	a5,a1,ffffffffc0200b2e <buddy_system_free_pages+0x1c8>
    for (; p != base + n; p++)
ffffffffc020098c:	00259693          	slli	a3,a1,0x2
ffffffffc0200990:	96ae                	add	a3,a3,a1
ffffffffc0200992:	068e                	slli	a3,a3,0x3
ffffffffc0200994:	892a                	mv	s2,a0
ffffffffc0200996:	96aa                	add	a3,a3,a0
ffffffffc0200998:	87aa                	mv	a5,a0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020099a:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020099c:	8b05                	andi	a4,a4,1
ffffffffc020099e:	12071863          	bnez	a4,ffffffffc0200ace <buddy_system_free_pages+0x168>
ffffffffc02009a2:	6798                	ld	a4,8(a5)
ffffffffc02009a4:	8b09                	andi	a4,a4,2
ffffffffc02009a6:	12071463          	bnez	a4,ffffffffc0200ace <buddy_system_free_pages+0x168>
        p->flags = 0;
ffffffffc02009aa:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02009ae:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02009b2:	02878793          	addi	a5,a5,40
ffffffffc02009b6:	fed792e3          	bne	a5,a3,ffffffffc020099a <buddy_system_free_pages+0x34>
    base->property = n;
ffffffffc02009ba:	00b92823          	sw	a1,16(s2)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02009be:	4789                	li	a5,2
ffffffffc02009c0:	00890713          	addi	a4,s2,8
ffffffffc02009c4:	40f7302f          	amoor.d	zero,a5,(a4)
    while (temp != 1)
ffffffffc02009c8:	4785                	li	a5,1
ffffffffc02009ca:	0ef58c63          	beq	a1,a5,ffffffffc0200ac2 <buddy_system_free_pages+0x15c>
    uint32_t order = 0;
ffffffffc02009ce:	4481                	li	s1,0
        temp >>= 1;
ffffffffc02009d0:	8185                	srli	a1,a1,0x1
        order++;
ffffffffc02009d2:	2485                	addiw	s1,s1,1
    while (temp != 1)
ffffffffc02009d4:	fef59ee3          	bne	a1,a5,ffffffffc02009d0 <buddy_system_free_pages+0x6a>
    add_page(order, base);
ffffffffc02009d8:	85ca                	mv	a1,s2
ffffffffc02009da:	8526                	mv	a0,s1
ffffffffc02009dc:	f01ff0ef          	jal	ra,ffffffffc02008dc <add_page>
    if (order == MAX_ORDER - 1)
ffffffffc02009e0:	47ad                	li	a5,11
ffffffffc02009e2:	06f48763          	beq	s1,a5,ffffffffc0200a50 <buddy_system_free_pages+0xea>
ffffffffc02009e6:	00005a97          	auipc	s5,0x5
ffffffffc02009ea:	642a8a93          	addi	s5,s5,1602 # ffffffffc0206028 <free_area>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02009ee:	59f5                	li	s3,-3
ffffffffc02009f0:	4a2d                	li	s4,11
    if (le != &(free_list(order)))
ffffffffc02009f2:	02049793          	slli	a5,s1,0x20
ffffffffc02009f6:	9381                	srli	a5,a5,0x20
ffffffffc02009f8:	00179413          	slli	s0,a5,0x1
ffffffffc02009fc:	943e                	add	s0,s0,a5
    return listelm->prev;
ffffffffc02009fe:	01893703          	ld	a4,24(s2)
ffffffffc0200a02:	040e                	slli	s0,s0,0x3
ffffffffc0200a04:	9456                	add	s0,s0,s5
                add_page(order + 1, base);
ffffffffc0200a06:	2485                	addiw	s1,s1,1
    if (le != &(free_list(order)))
ffffffffc0200a08:	02870063          	beq	a4,s0,ffffffffc0200a28 <buddy_system_free_pages+0xc2>
        if (p + p->property == base)
ffffffffc0200a0c:	ff872603          	lw	a2,-8(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0200a10:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base)
ffffffffc0200a14:	02061693          	slli	a3,a2,0x20
ffffffffc0200a18:	9281                	srli	a3,a3,0x20
ffffffffc0200a1a:	00269793          	slli	a5,a3,0x2
ffffffffc0200a1e:	97b6                	add	a5,a5,a3
ffffffffc0200a20:	078e                	slli	a5,a5,0x3
ffffffffc0200a22:	97ae                	add	a5,a5,a1
ffffffffc0200a24:	06f90963          	beq	s2,a5,ffffffffc0200a96 <buddy_system_free_pages+0x130>
    return listelm->next;
ffffffffc0200a28:	02093703          	ld	a4,32(s2)
    if (le != &(free_list(order)))
ffffffffc0200a2c:	02e40063          	beq	s0,a4,ffffffffc0200a4c <buddy_system_free_pages+0xe6>
        if (base + base->property == p)
ffffffffc0200a30:	01092583          	lw	a1,16(s2)
        struct Page *p = le2page(le, page_link);
ffffffffc0200a34:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p)
ffffffffc0200a38:	02059613          	slli	a2,a1,0x20
ffffffffc0200a3c:	9201                	srli	a2,a2,0x20
ffffffffc0200a3e:	00261793          	slli	a5,a2,0x2
ffffffffc0200a42:	97b2                	add	a5,a5,a2
ffffffffc0200a44:	078e                	slli	a5,a5,0x3
ffffffffc0200a46:	97ca                	add	a5,a5,s2
ffffffffc0200a48:	00f68d63          	beq	a3,a5,ffffffffc0200a62 <buddy_system_free_pages+0xfc>
    if (order == MAX_ORDER - 1)
ffffffffc0200a4c:	fb4493e3          	bne	s1,s4,ffffffffc02009f2 <buddy_system_free_pages+0x8c>
}
ffffffffc0200a50:	70e2                	ld	ra,56(sp)
ffffffffc0200a52:	7442                	ld	s0,48(sp)
ffffffffc0200a54:	74a2                	ld	s1,40(sp)
ffffffffc0200a56:	7902                	ld	s2,32(sp)
ffffffffc0200a58:	69e2                	ld	s3,24(sp)
ffffffffc0200a5a:	6a42                	ld	s4,16(sp)
ffffffffc0200a5c:	6aa2                	ld	s5,8(sp)
ffffffffc0200a5e:	6121                	addi	sp,sp,64
ffffffffc0200a60:	8082                	ret
            base->property += p->property;
ffffffffc0200a62:	ff872783          	lw	a5,-8(a4)
ffffffffc0200a66:	9dbd                	addw	a1,a1,a5
ffffffffc0200a68:	00b92823          	sw	a1,16(s2)
ffffffffc0200a6c:	ff070793          	addi	a5,a4,-16
ffffffffc0200a70:	6137b02f          	amoand.d	zero,s3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a74:	671c                	ld	a5,8(a4)
ffffffffc0200a76:	6314                	ld	a3,0(a4)
                add_page(order + 1, base);
ffffffffc0200a78:	85ca                	mv	a1,s2
ffffffffc0200a7a:	8526                	mv	a0,s1
    prev->next = next;
ffffffffc0200a7c:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0200a7e:	e394                	sd	a3,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200a80:	01893703          	ld	a4,24(s2)
ffffffffc0200a84:	02093783          	ld	a5,32(s2)
    prev->next = next;
ffffffffc0200a88:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200a8a:	e398                	sd	a4,0(a5)
ffffffffc0200a8c:	e51ff0ef          	jal	ra,ffffffffc02008dc <add_page>
    if (order == MAX_ORDER - 1)
ffffffffc0200a90:	f74491e3          	bne	s1,s4,ffffffffc02009f2 <buddy_system_free_pages+0x8c>
ffffffffc0200a94:	bf75                	j	ffffffffc0200a50 <buddy_system_free_pages+0xea>
            p->property += base->property;
ffffffffc0200a96:	01092783          	lw	a5,16(s2)
ffffffffc0200a9a:	9e3d                	addw	a2,a2,a5
ffffffffc0200a9c:	fec72c23          	sw	a2,-8(a4)
ffffffffc0200aa0:	00890793          	addi	a5,s2,8
ffffffffc0200aa4:	6137b02f          	amoand.d	zero,s3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200aa8:	02093783          	ld	a5,32(s2)
                add_page(order + 1, base);
ffffffffc0200aac:	8526                	mv	a0,s1
            base = p;
ffffffffc0200aae:	892e                	mv	s2,a1
    prev->next = next;
ffffffffc0200ab0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200ab2:	e398                	sd	a4,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ab4:	6314                	ld	a3,0(a4)
ffffffffc0200ab6:	671c                	ld	a5,8(a4)
    prev->next = next;
ffffffffc0200ab8:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0200aba:	e394                	sd	a3,0(a5)
                add_page(order + 1, base);
ffffffffc0200abc:	e21ff0ef          	jal	ra,ffffffffc02008dc <add_page>
ffffffffc0200ac0:	b7a5                	j	ffffffffc0200a28 <buddy_system_free_pages+0xc2>
    add_page(order, base);
ffffffffc0200ac2:	85ca                	mv	a1,s2
ffffffffc0200ac4:	4501                	li	a0,0
ffffffffc0200ac6:	e17ff0ef          	jal	ra,ffffffffc02008dc <add_page>
    uint32_t order = 0;
ffffffffc0200aca:	4481                	li	s1,0
ffffffffc0200acc:	bf29                	j	ffffffffc02009e6 <buddy_system_free_pages+0x80>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ace:	00001697          	auipc	a3,0x1
ffffffffc0200ad2:	4ea68693          	addi	a3,a3,1258 # ffffffffc0201fb8 <commands+0x570>
ffffffffc0200ad6:	00001617          	auipc	a2,0x1
ffffffffc0200ada:	47260613          	addi	a2,a2,1138 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200ade:	0bf00593          	li	a1,191
ffffffffc0200ae2:	00001517          	auipc	a0,0x1
ffffffffc0200ae6:	47e50513          	addi	a0,a0,1150 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200aea:	8cbff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(IS_POWER_OF_2(n));
ffffffffc0200aee:	00001697          	auipc	a3,0x1
ffffffffc0200af2:	49268693          	addi	a3,a3,1170 # ffffffffc0201f80 <commands+0x538>
ffffffffc0200af6:	00001617          	auipc	a2,0x1
ffffffffc0200afa:	45260613          	addi	a2,a2,1106 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200afe:	0ba00593          	li	a1,186
ffffffffc0200b02:	00001517          	auipc	a0,0x1
ffffffffc0200b06:	45e50513          	addi	a0,a0,1118 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200b0a:	8abff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(n > 0);
ffffffffc0200b0e:	00001697          	auipc	a3,0x1
ffffffffc0200b12:	43268693          	addi	a3,a3,1074 # ffffffffc0201f40 <commands+0x4f8>
ffffffffc0200b16:	00001617          	auipc	a2,0x1
ffffffffc0200b1a:	43260613          	addi	a2,a2,1074 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200b1e:	0b900593          	li	a1,185
ffffffffc0200b22:	00001517          	auipc	a0,0x1
ffffffffc0200b26:	43e50513          	addi	a0,a0,1086 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200b2a:	88bff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(n < (1 << (MAX_ORDER - 1)));
ffffffffc0200b2e:	00001697          	auipc	a3,0x1
ffffffffc0200b32:	46a68693          	addi	a3,a3,1130 # ffffffffc0201f98 <commands+0x550>
ffffffffc0200b36:	00001617          	auipc	a2,0x1
ffffffffc0200b3a:	41260613          	addi	a2,a2,1042 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200b3e:	0bb00593          	li	a1,187
ffffffffc0200b42:	00001517          	auipc	a0,0x1
ffffffffc0200b46:	41e50513          	addi	a0,a0,1054 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200b4a:	86bff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200b4e <buddy_system_alloc_pages.part.0>:
    while (n < (1 << order))
ffffffffc0200b4e:	7ff00713          	li	a4,2047
ffffffffc0200b52:	47ad                	li	a5,11
ffffffffc0200b54:	4685                	li	a3,1
ffffffffc0200b56:	0aa76963          	bltu	a4,a0,ffffffffc0200c08 <buddy_system_alloc_pages.part.0+0xba>
        order -= 1;
ffffffffc0200b5a:	0007859b          	sext.w	a1,a5
ffffffffc0200b5e:	37fd                	addiw	a5,a5,-1
    while (n < (1 << order))
ffffffffc0200b60:	00f6973b          	sllw	a4,a3,a5
ffffffffc0200b64:	fee56be3          	bltu	a0,a4,ffffffffc0200b5a <buddy_system_alloc_pages.part.0+0xc>
    for (int i = order; i < MAX_ORDER; i++)
ffffffffc0200b68:	47ad                	li	a5,11
ffffffffc0200b6a:	0005869b          	sext.w	a3,a1
ffffffffc0200b6e:	08b7cd63          	blt	a5,a1,ffffffffc0200c08 <buddy_system_alloc_pages.part.0+0xba>
ffffffffc0200b72:	462d                	li	a2,11
ffffffffc0200b74:	9e0d                	subw	a2,a2,a1
ffffffffc0200b76:	1602                	slli	a2,a2,0x20
ffffffffc0200b78:	9201                	srli	a2,a2,0x20
ffffffffc0200b7a:	00d60733          	add	a4,a2,a3
ffffffffc0200b7e:	00171613          	slli	a2,a4,0x1
ffffffffc0200b82:	00169793          	slli	a5,a3,0x1
buddy_system_alloc_pages(size_t n)
ffffffffc0200b86:	1101                	addi	sp,sp,-32
ffffffffc0200b88:	963a                	add	a2,a2,a4
ffffffffc0200b8a:	97b6                	add	a5,a5,a3
ffffffffc0200b8c:	00005717          	auipc	a4,0x5
ffffffffc0200b90:	4b470713          	addi	a4,a4,1204 # ffffffffc0206040 <free_area+0x18>
ffffffffc0200b94:	e426                	sd	s1,8(sp)
ffffffffc0200b96:	078e                	slli	a5,a5,0x3
ffffffffc0200b98:	00005497          	auipc	s1,0x5
ffffffffc0200b9c:	49048493          	addi	s1,s1,1168 # ffffffffc0206028 <free_area>
ffffffffc0200ba0:	060e                	slli	a2,a2,0x3
ffffffffc0200ba2:	963a                	add	a2,a2,a4
ffffffffc0200ba4:	ec06                	sd	ra,24(sp)
ffffffffc0200ba6:	e822                	sd	s0,16(sp)
ffffffffc0200ba8:	97a6                	add	a5,a5,s1
    uint32_t flag = 0;
ffffffffc0200baa:	4701                	li	a4,0
        flag += nr_free(i);
ffffffffc0200bac:	4b94                	lw	a3,16(a5)
    for (int i = order; i < MAX_ORDER; i++)
ffffffffc0200bae:	07e1                	addi	a5,a5,24
        flag += nr_free(i);
ffffffffc0200bb0:	9f35                	addw	a4,a4,a3
    for (int i = order; i < MAX_ORDER; i++)
ffffffffc0200bb2:	fec79de3          	bne	a5,a2,ffffffffc0200bac <buddy_system_alloc_pages.part.0+0x5e>
    if (flag == 0)
ffffffffc0200bb6:	c339                	beqz	a4,ffffffffc0200bfc <buddy_system_alloc_pages.part.0+0xae>
    if (list_empty(&(free_list(order))))
ffffffffc0200bb8:	02059713          	slli	a4,a1,0x20
ffffffffc0200bbc:	9301                	srli	a4,a4,0x20
ffffffffc0200bbe:	00171793          	slli	a5,a4,0x1
ffffffffc0200bc2:	97ba                	add	a5,a5,a4
ffffffffc0200bc4:	078e                	slli	a5,a5,0x3
ffffffffc0200bc6:	94be                	add	s1,s1,a5
    return list->next == list;
ffffffffc0200bc8:	6480                	ld	s0,8(s1)
ffffffffc0200bca:	02848263          	beq	s1,s0,ffffffffc0200bee <buddy_system_alloc_pages.part.0+0xa0>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200bce:	6018                	ld	a4,0(s0)
ffffffffc0200bd0:	641c                	ld	a5,8(s0)
    page = le2page(le, page_link);
ffffffffc0200bd2:	fe840513          	addi	a0,s0,-24
    prev->next = next;
ffffffffc0200bd6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200bd8:	e398                	sd	a4,0(a5)
ffffffffc0200bda:	57f5                	li	a5,-3
ffffffffc0200bdc:	ff040713          	addi	a4,s0,-16
ffffffffc0200be0:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200be4:	60e2                	ld	ra,24(sp)
ffffffffc0200be6:	6442                	ld	s0,16(sp)
ffffffffc0200be8:	64a2                	ld	s1,8(sp)
ffffffffc0200bea:	6105                	addi	sp,sp,32
ffffffffc0200bec:	8082                	ret
        split_page(order + 1);
ffffffffc0200bee:	0015851b          	addiw	a0,a1,1
ffffffffc0200bf2:	c39ff0ef          	jal	ra,ffffffffc020082a <split_page>
    return list->next == list;
ffffffffc0200bf6:	6400                	ld	s0,8(s0)
    if (list_empty(&(free_list(order))))
ffffffffc0200bf8:	fc849be3          	bne	s1,s0,ffffffffc0200bce <buddy_system_alloc_pages.part.0+0x80>
}
ffffffffc0200bfc:	60e2                	ld	ra,24(sp)
ffffffffc0200bfe:	6442                	ld	s0,16(sp)
ffffffffc0200c00:	64a2                	ld	s1,8(sp)
        return NULL;
ffffffffc0200c02:	4501                	li	a0,0
}
ffffffffc0200c04:	6105                	addi	sp,sp,32
ffffffffc0200c06:	8082                	ret
        return NULL;
ffffffffc0200c08:	4501                	li	a0,0
}
ffffffffc0200c0a:	8082                	ret

ffffffffc0200c0c <buddy_system_alloc_pages>:
    assert(n > 0);
ffffffffc0200c0c:	c909                	beqz	a0,ffffffffc0200c1e <buddy_system_alloc_pages+0x12>
    if (n > (1 << (MAX_ORDER - 1)))
ffffffffc0200c0e:	6705                	lui	a4,0x1
ffffffffc0200c10:	80070713          	addi	a4,a4,-2048 # 800 <kern_entry-0xffffffffc01ff800>
ffffffffc0200c14:	00a76363          	bltu	a4,a0,ffffffffc0200c1a <buddy_system_alloc_pages+0xe>
ffffffffc0200c18:	bf1d                	j	ffffffffc0200b4e <buddy_system_alloc_pages.part.0>
}
ffffffffc0200c1a:	4501                	li	a0,0
ffffffffc0200c1c:	8082                	ret
{
ffffffffc0200c1e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200c20:	00001697          	auipc	a3,0x1
ffffffffc0200c24:	32068693          	addi	a3,a3,800 # ffffffffc0201f40 <commands+0x4f8>
ffffffffc0200c28:	00001617          	auipc	a2,0x1
ffffffffc0200c2c:	32060613          	addi	a2,a2,800 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200c30:	05000593          	li	a1,80
ffffffffc0200c34:	00001517          	auipc	a0,0x1
ffffffffc0200c38:	32c50513          	addi	a0,a0,812 # ffffffffc0201f60 <commands+0x518>
{
ffffffffc0200c3c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c3e:	f76ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200c42 <buddy_system_init_memmap>:
{
ffffffffc0200c42:	1141                	addi	sp,sp,-16
ffffffffc0200c44:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c46:	c1f9                	beqz	a1,ffffffffc0200d0c <buddy_system_init_memmap+0xca>
    for (; p != base + n; p++)
ffffffffc0200c48:	00259693          	slli	a3,a1,0x2
ffffffffc0200c4c:	96ae                	add	a3,a3,a1
ffffffffc0200c4e:	068e                	slli	a3,a3,0x3
ffffffffc0200c50:	96aa                	add	a3,a3,a0
ffffffffc0200c52:	87aa                	mv	a5,a0
ffffffffc0200c54:	00d50f63          	beq	a0,a3,ffffffffc0200c72 <buddy_system_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c58:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0200c5a:	8b05                	andi	a4,a4,1
ffffffffc0200c5c:	cb41                	beqz	a4,ffffffffc0200cec <buddy_system_init_memmap+0xaa>
        p->flags = p->property = 0;
ffffffffc0200c5e:	0007a823          	sw	zero,16(a5)
ffffffffc0200c62:	0007b423          	sd	zero,8(a5)
ffffffffc0200c66:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0200c6a:	02878793          	addi	a5,a5,40
ffffffffc0200c6e:	fed795e3          	bne	a5,a3,ffffffffc0200c58 <buddy_system_init_memmap+0x16>
    uint32_t order_size = 1 << order;   
ffffffffc0200c72:	6685                	lui	a3,0x1
    uint32_t order = MAX_ORDER - 1;
ffffffffc0200c74:	472d                	li	a4,11
    uint32_t order_size = 1 << order;   
ffffffffc0200c76:	80068693          	addi	a3,a3,-2048 # 800 <kern_entry-0xffffffffc01ff800>
ffffffffc0200c7a:	00005e17          	auipc	t3,0x5
ffffffffc0200c7e:	3aee0e13          	addi	t3,t3,942 # ffffffffc0206028 <free_area>
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200c82:	4309                	li	t1,2
        p->property = order_size; 
ffffffffc0200c84:	c914                	sw	a3,16(a0)
ffffffffc0200c86:	00850793          	addi	a5,a0,8
ffffffffc0200c8a:	4067b02f          	amoor.d	zero,t1,(a5)
        nr_free(order) += 1;
ffffffffc0200c8e:	02071613          	slli	a2,a4,0x20
ffffffffc0200c92:	9201                	srli	a2,a2,0x20
ffffffffc0200c94:	00161793          	slli	a5,a2,0x1
ffffffffc0200c98:	97b2                	add	a5,a5,a2
ffffffffc0200c9a:	078e                	slli	a5,a5,0x3
ffffffffc0200c9c:	97f2                	add	a5,a5,t3
ffffffffc0200c9e:	0107a803          	lw	a6,16(a5)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200ca2:	0007b883          	ld	a7,0(a5)
        list_add_before(&(free_list(order)), &(p->page_link));
ffffffffc0200ca6:	01850613          	addi	a2,a0,24
        nr_free(order) += 1;
ffffffffc0200caa:	2805                	addiw	a6,a6,1
ffffffffc0200cac:	0107a823          	sw	a6,16(a5)
    prev->next = next->prev = elm;
ffffffffc0200cb0:	e390                	sd	a2,0(a5)
ffffffffc0200cb2:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0200cb6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200cb8:	01153c23          	sd	a7,24(a0)
        curr_size -= order_size;
ffffffffc0200cbc:	02069793          	slli	a5,a3,0x20
ffffffffc0200cc0:	9381                	srli	a5,a5,0x20
ffffffffc0200cc2:	8d95                	sub	a1,a1,a3
        while (order > 0 && curr_size < order_size)
ffffffffc0200cc4:	cb19                	beqz	a4,ffffffffc0200cda <buddy_system_init_memmap+0x98>
ffffffffc0200cc6:	00f5fa63          	bgeu	a1,a5,ffffffffc0200cda <buddy_system_init_memmap+0x98>
            order_size >>= 1;
ffffffffc0200cca:	0016d79b          	srliw	a5,a3,0x1
ffffffffc0200cce:	0007869b          	sext.w	a3,a5
            order -= 1;// 2^order = order_size
ffffffffc0200cd2:	377d                	addiw	a4,a4,-1
        while (order > 0 && curr_size < order_size)
ffffffffc0200cd4:	1782                	slli	a5,a5,0x20
ffffffffc0200cd6:	9381                	srli	a5,a5,0x20
ffffffffc0200cd8:	f77d                	bnez	a4,ffffffffc0200cc6 <buddy_system_init_memmap+0x84>
        p += order_size;
ffffffffc0200cda:	00279613          	slli	a2,a5,0x2
ffffffffc0200cde:	97b2                	add	a5,a5,a2
ffffffffc0200ce0:	078e                	slli	a5,a5,0x3
ffffffffc0200ce2:	953e                	add	a0,a0,a5
    while (curr_size != 0)
ffffffffc0200ce4:	f1c5                	bnez	a1,ffffffffc0200c84 <buddy_system_init_memmap+0x42>
}
ffffffffc0200ce6:	60a2                	ld	ra,8(sp)
ffffffffc0200ce8:	0141                	addi	sp,sp,16
ffffffffc0200cea:	8082                	ret
        assert(PageReserved(p));
ffffffffc0200cec:	00001697          	auipc	a3,0x1
ffffffffc0200cf0:	2f468693          	addi	a3,a3,756 # ffffffffc0201fe0 <commands+0x598>
ffffffffc0200cf4:	00001617          	auipc	a2,0x1
ffffffffc0200cf8:	25460613          	addi	a2,a2,596 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200cfc:	02000593          	li	a1,32
ffffffffc0200d00:	00001517          	auipc	a0,0x1
ffffffffc0200d04:	26050513          	addi	a0,a0,608 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200d08:	eacff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(n > 0);
ffffffffc0200d0c:	00001697          	auipc	a3,0x1
ffffffffc0200d10:	23468693          	addi	a3,a3,564 # ffffffffc0201f40 <commands+0x4f8>
ffffffffc0200d14:	00001617          	auipc	a2,0x1
ffffffffc0200d18:	23460613          	addi	a2,a2,564 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200d1c:	45f1                	li	a1,28
ffffffffc0200d1e:	00001517          	auipc	a0,0x1
ffffffffc0200d22:	24250513          	addi	a0,a0,578 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200d26:	e8eff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200d2a <print_free_list_status>:
    free_page(p1);
    free_page(p2);
}

void print_free_list_status(void)
{
ffffffffc0200d2a:	715d                	addi	sp,sp,-80
    cprintf("\nMemory Status:\n");
ffffffffc0200d2c:	00001517          	auipc	a0,0x1
ffffffffc0200d30:	2c450513          	addi	a0,a0,708 # ffffffffc0201ff0 <commands+0x5a8>
{
ffffffffc0200d34:	fc26                	sd	s1,56(sp)
ffffffffc0200d36:	f44e                	sd	s3,40(sp)
ffffffffc0200d38:	f052                	sd	s4,32(sp)
ffffffffc0200d3a:	ec56                	sd	s5,24(sp)
ffffffffc0200d3c:	e85a                	sd	s6,16(sp)
ffffffffc0200d3e:	e45e                	sd	s7,8(sp)
ffffffffc0200d40:	e486                	sd	ra,72(sp)
ffffffffc0200d42:	e0a2                	sd	s0,64(sp)
ffffffffc0200d44:	f84a                	sd	s2,48(sp)
ffffffffc0200d46:	00005497          	auipc	s1,0x5
ffffffffc0200d4a:	2e248493          	addi	s1,s1,738 # ffffffffc0206028 <free_area>
    cprintf("\nMemory Status:\n");
ffffffffc0200d4e:	b6cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200d52:	4a01                	li	s4,0
    {
        cprintf("Order %d: %d free blocks\n", i, nr_free(i));
ffffffffc0200d54:	00001b17          	auipc	s6,0x1
ffffffffc0200d58:	2b4b0b13          	addi	s6,s6,692 # ffffffffc0202008 <commands+0x5c0>
        list_entry_t *le = &(free_list(i));
        while ((le = list_next(le)) != &(free_list(i)))
        {
            struct Page *page = le2page(le, page_link);
            cprintf("Block at address: %p, size: %u\n", page, (1 << i));
ffffffffc0200d5c:	4b85                	li	s7,1
ffffffffc0200d5e:	00001997          	auipc	s3,0x1
ffffffffc0200d62:	2ca98993          	addi	s3,s3,714 # ffffffffc0202028 <commands+0x5e0>
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200d66:	4ab1                	li	s5,12
        cprintf("Order %d: %d free blocks\n", i, nr_free(i));
ffffffffc0200d68:	4890                	lw	a2,16(s1)
ffffffffc0200d6a:	85d2                	mv	a1,s4
ffffffffc0200d6c:	855a                	mv	a0,s6
ffffffffc0200d6e:	b4cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    return listelm->next;
ffffffffc0200d72:	6480                	ld	s0,8(s1)
        while ((le = list_next(le)) != &(free_list(i)))
ffffffffc0200d74:	00940d63          	beq	s0,s1,ffffffffc0200d8e <print_free_list_status+0x64>
            cprintf("Block at address: %p, size: %u\n", page, (1 << i));
ffffffffc0200d78:	014b993b          	sllw	s2,s7,s4
ffffffffc0200d7c:	fe840593          	addi	a1,s0,-24
ffffffffc0200d80:	864a                	mv	a2,s2
ffffffffc0200d82:	854e                	mv	a0,s3
ffffffffc0200d84:	b36ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d88:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != &(free_list(i)))
ffffffffc0200d8a:	fe9419e3          	bne	s0,s1,ffffffffc0200d7c <print_free_list_status+0x52>
    for (int i = 0; i < MAX_ORDER; i++)
ffffffffc0200d8e:	2a05                	addiw	s4,s4,1
ffffffffc0200d90:	04e1                	addi	s1,s1,24
ffffffffc0200d92:	fd5a1be3          	bne	s4,s5,ffffffffc0200d68 <print_free_list_status+0x3e>
        }
    }
    cprintf("\n");
}
ffffffffc0200d96:	6406                	ld	s0,64(sp)
ffffffffc0200d98:	60a6                	ld	ra,72(sp)
ffffffffc0200d9a:	74e2                	ld	s1,56(sp)
ffffffffc0200d9c:	7942                	ld	s2,48(sp)
ffffffffc0200d9e:	79a2                	ld	s3,40(sp)
ffffffffc0200da0:	7a02                	ld	s4,32(sp)
ffffffffc0200da2:	6ae2                	ld	s5,24(sp)
ffffffffc0200da4:	6b42                	ld	s6,16(sp)
ffffffffc0200da6:	6ba2                	ld	s7,8(sp)
    cprintf("\n");
ffffffffc0200da8:	00001517          	auipc	a0,0x1
ffffffffc0200dac:	b3050513          	addi	a0,a0,-1232 # ffffffffc02018d8 <etext+0xee>
}
ffffffffc0200db0:	6161                	addi	sp,sp,80
    cprintf("\n");
ffffffffc0200db2:	b08ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200db6 <buddy_system_check>:

static void
buddy_system_check(void)
{
ffffffffc0200db6:	1141                	addi	sp,sp,-16

    // 初始化内存，假设有1024页
    struct Page pages[1024];
    //buddy_system_init_memmap(pages, 1024);

    cprintf("Initial memory status:\n");
ffffffffc0200db8:	00001517          	auipc	a0,0x1
ffffffffc0200dbc:	29050513          	addi	a0,a0,656 # ffffffffc0202048 <commands+0x600>
{
ffffffffc0200dc0:	e406                	sd	ra,8(sp)
    cprintf("Initial memory status:\n");
ffffffffc0200dc2:	af8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_free_list_status();
ffffffffc0200dc6:	f65ff0ef          	jal	ra,ffffffffc0200d2a <print_free_list_status>

    // 测试 1 页的分配和释放
    cprintf("Allocating 1 page...\n");
ffffffffc0200dca:	00001517          	auipc	a0,0x1
ffffffffc0200dce:	29650513          	addi	a0,a0,662 # ffffffffc0202060 <commands+0x618>
ffffffffc0200dd2:	ae8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (n > (1 << (MAX_ORDER - 1)))
ffffffffc0200dd6:	4505                	li	a0,1
ffffffffc0200dd8:	d77ff0ef          	jal	ra,ffffffffc0200b4e <buddy_system_alloc_pages.part.0>
    p0 = buddy_system_alloc_pages(1);
    assert(p0 != NULL);
ffffffffc0200ddc:	c919                	beqz	a0,ffffffffc0200df2 <buddy_system_check+0x3c>
    print_free_list_status(); // 分配后状态
ffffffffc0200dde:	f4dff0ef          	jal	ra,ffffffffc0200d2a <print_free_list_status>


    cprintf("buddy system tests passed.\n");
}
ffffffffc0200de2:	60a2                	ld	ra,8(sp)
    cprintf("buddy system tests passed.\n");
ffffffffc0200de4:	00001517          	auipc	a0,0x1
ffffffffc0200de8:	2a450513          	addi	a0,a0,676 # ffffffffc0202088 <commands+0x640>
}
ffffffffc0200dec:	0141                	addi	sp,sp,16
    cprintf("buddy system tests passed.\n");
ffffffffc0200dee:	accff06f          	j	ffffffffc02000ba <cprintf>
    assert(p0 != NULL);
ffffffffc0200df2:	00001697          	auipc	a3,0x1
ffffffffc0200df6:	28668693          	addi	a3,a3,646 # ffffffffc0202078 <commands+0x630>
ffffffffc0200dfa:	00001617          	auipc	a2,0x1
ffffffffc0200dfe:	14e60613          	addi	a2,a2,334 # ffffffffc0201f48 <commands+0x500>
ffffffffc0200e02:	13700593          	li	a1,311
ffffffffc0200e06:	00001517          	auipc	a0,0x1
ffffffffc0200e0a:	15a50513          	addi	a0,a0,346 # ffffffffc0201f60 <commands+0x518>
ffffffffc0200e0e:	da6ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200e12 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200e12:	100027f3          	csrr	a5,sstatus
ffffffffc0200e16:	8b89                	andi	a5,a5,2
ffffffffc0200e18:	e799                	bnez	a5,ffffffffc0200e26 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0200e1a:	00005797          	auipc	a5,0x5
ffffffffc0200e1e:	74e7b783          	ld	a5,1870(a5) # ffffffffc0206568 <pmm_manager>
ffffffffc0200e22:	6f9c                	ld	a5,24(a5)
ffffffffc0200e24:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0200e26:	1141                	addi	sp,sp,-16
ffffffffc0200e28:	e406                	sd	ra,8(sp)
ffffffffc0200e2a:	e022                	sd	s0,0(sp)
ffffffffc0200e2c:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0200e2e:	e38ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200e32:	00005797          	auipc	a5,0x5
ffffffffc0200e36:	7367b783          	ld	a5,1846(a5) # ffffffffc0206568 <pmm_manager>
ffffffffc0200e3a:	6f9c                	ld	a5,24(a5)
ffffffffc0200e3c:	8522                	mv	a0,s0
ffffffffc0200e3e:	9782                	jalr	a5
ffffffffc0200e40:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0200e42:	e1eff0ef          	jal	ra,ffffffffc0200460 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0200e46:	60a2                	ld	ra,8(sp)
ffffffffc0200e48:	8522                	mv	a0,s0
ffffffffc0200e4a:	6402                	ld	s0,0(sp)
ffffffffc0200e4c:	0141                	addi	sp,sp,16
ffffffffc0200e4e:	8082                	ret

ffffffffc0200e50 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200e50:	100027f3          	csrr	a5,sstatus
ffffffffc0200e54:	8b89                	andi	a5,a5,2
ffffffffc0200e56:	e799                	bnez	a5,ffffffffc0200e64 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200e58:	00005797          	auipc	a5,0x5
ffffffffc0200e5c:	7107b783          	ld	a5,1808(a5) # ffffffffc0206568 <pmm_manager>
ffffffffc0200e60:	739c                	ld	a5,32(a5)
ffffffffc0200e62:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0200e64:	1101                	addi	sp,sp,-32
ffffffffc0200e66:	ec06                	sd	ra,24(sp)
ffffffffc0200e68:	e822                	sd	s0,16(sp)
ffffffffc0200e6a:	e426                	sd	s1,8(sp)
ffffffffc0200e6c:	842a                	mv	s0,a0
ffffffffc0200e6e:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200e70:	df6ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200e74:	00005797          	auipc	a5,0x5
ffffffffc0200e78:	6f47b783          	ld	a5,1780(a5) # ffffffffc0206568 <pmm_manager>
ffffffffc0200e7c:	739c                	ld	a5,32(a5)
ffffffffc0200e7e:	85a6                	mv	a1,s1
ffffffffc0200e80:	8522                	mv	a0,s0
ffffffffc0200e82:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200e84:	6442                	ld	s0,16(sp)
ffffffffc0200e86:	60e2                	ld	ra,24(sp)
ffffffffc0200e88:	64a2                	ld	s1,8(sp)
ffffffffc0200e8a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200e8c:	dd4ff06f          	j	ffffffffc0200460 <intr_enable>

ffffffffc0200e90 <pmm_init>:
    pmm_manager = &buddy_system_pmm_manager; //////////////////buddy_system_pmm_manager
ffffffffc0200e90:	00001797          	auipc	a5,0x1
ffffffffc0200e94:	23878793          	addi	a5,a5,568 # ffffffffc02020c8 <buddy_system_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200e98:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200e9a:	1101                	addi	sp,sp,-32
ffffffffc0200e9c:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200e9e:	00001517          	auipc	a0,0x1
ffffffffc0200ea2:	26250513          	addi	a0,a0,610 # ffffffffc0202100 <buddy_system_pmm_manager+0x38>
    pmm_manager = &buddy_system_pmm_manager; //////////////////buddy_system_pmm_manager
ffffffffc0200ea6:	00005497          	auipc	s1,0x5
ffffffffc0200eaa:	6c248493          	addi	s1,s1,1730 # ffffffffc0206568 <pmm_manager>
void pmm_init(void) {
ffffffffc0200eae:	ec06                	sd	ra,24(sp)
ffffffffc0200eb0:	e822                	sd	s0,16(sp)
    pmm_manager = &buddy_system_pmm_manager; //////////////////buddy_system_pmm_manager
ffffffffc0200eb2:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200eb4:	a06ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0200eb8:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200eba:	00005417          	auipc	s0,0x5
ffffffffc0200ebe:	6c640413          	addi	s0,s0,1734 # ffffffffc0206580 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200ec2:	679c                	ld	a5,8(a5)
ffffffffc0200ec4:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200ec6:	57f5                	li	a5,-3
ffffffffc0200ec8:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0200eca:	00001517          	auipc	a0,0x1
ffffffffc0200ece:	24e50513          	addi	a0,a0,590 # ffffffffc0202118 <buddy_system_pmm_manager+0x50>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200ed2:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc0200ed4:	9e6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200ed8:	46c5                	li	a3,17
ffffffffc0200eda:	06ee                	slli	a3,a3,0x1b
ffffffffc0200edc:	40100613          	li	a2,1025
ffffffffc0200ee0:	16fd                	addi	a3,a3,-1
ffffffffc0200ee2:	07e005b7          	lui	a1,0x7e00
ffffffffc0200ee6:	0656                	slli	a2,a2,0x15
ffffffffc0200ee8:	00001517          	auipc	a0,0x1
ffffffffc0200eec:	24850513          	addi	a0,a0,584 # ffffffffc0202130 <buddy_system_pmm_manager+0x68>
ffffffffc0200ef0:	9caff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200ef4:	777d                	lui	a4,0xfffff
ffffffffc0200ef6:	00006797          	auipc	a5,0x6
ffffffffc0200efa:	6a178793          	addi	a5,a5,1697 # ffffffffc0207597 <end+0xfff>
ffffffffc0200efe:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0200f00:	00005517          	auipc	a0,0x5
ffffffffc0200f04:	65850513          	addi	a0,a0,1624 # ffffffffc0206558 <npage>
ffffffffc0200f08:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200f0c:	00005597          	auipc	a1,0x5
ffffffffc0200f10:	65458593          	addi	a1,a1,1620 # ffffffffc0206560 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0200f14:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200f16:	e19c                	sd	a5,0(a1)
ffffffffc0200f18:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200f1a:	4701                	li	a4,0
ffffffffc0200f1c:	4885                	li	a7,1
ffffffffc0200f1e:	fff80837          	lui	a6,0xfff80
ffffffffc0200f22:	a011                	j	ffffffffc0200f26 <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc0200f24:	619c                	ld	a5,0(a1)
ffffffffc0200f26:	97b6                	add	a5,a5,a3
ffffffffc0200f28:	07a1                	addi	a5,a5,8
ffffffffc0200f2a:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200f2e:	611c                	ld	a5,0(a0)
ffffffffc0200f30:	0705                	addi	a4,a4,1
ffffffffc0200f32:	02868693          	addi	a3,a3,40
ffffffffc0200f36:	01078633          	add	a2,a5,a6
ffffffffc0200f3a:	fec765e3          	bltu	a4,a2,ffffffffc0200f24 <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200f3e:	6190                	ld	a2,0(a1)
ffffffffc0200f40:	00279713          	slli	a4,a5,0x2
ffffffffc0200f44:	973e                	add	a4,a4,a5
ffffffffc0200f46:	fec006b7          	lui	a3,0xfec00
ffffffffc0200f4a:	070e                	slli	a4,a4,0x3
ffffffffc0200f4c:	96b2                	add	a3,a3,a2
ffffffffc0200f4e:	96ba                	add	a3,a3,a4
ffffffffc0200f50:	c0200737          	lui	a4,0xc0200
ffffffffc0200f54:	08e6ef63          	bltu	a3,a4,ffffffffc0200ff2 <pmm_init+0x162>
ffffffffc0200f58:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc0200f5a:	45c5                	li	a1,17
ffffffffc0200f5c:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200f5e:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200f60:	04b6e863          	bltu	a3,a1,ffffffffc0200fb0 <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200f64:	609c                	ld	a5,0(s1)
ffffffffc0200f66:	7b9c                	ld	a5,48(a5)
ffffffffc0200f68:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200f6a:	00001517          	auipc	a0,0x1
ffffffffc0200f6e:	25e50513          	addi	a0,a0,606 # ffffffffc02021c8 <buddy_system_pmm_manager+0x100>
ffffffffc0200f72:	948ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200f76:	00004597          	auipc	a1,0x4
ffffffffc0200f7a:	08a58593          	addi	a1,a1,138 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200f7e:	00005797          	auipc	a5,0x5
ffffffffc0200f82:	5eb7bd23          	sd	a1,1530(a5) # ffffffffc0206578 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200f86:	c02007b7          	lui	a5,0xc0200
ffffffffc0200f8a:	08f5e063          	bltu	a1,a5,ffffffffc020100a <pmm_init+0x17a>
ffffffffc0200f8e:	6010                	ld	a2,0(s0)
}
ffffffffc0200f90:	6442                	ld	s0,16(sp)
ffffffffc0200f92:	60e2                	ld	ra,24(sp)
ffffffffc0200f94:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200f96:	40c58633          	sub	a2,a1,a2
ffffffffc0200f9a:	00005797          	auipc	a5,0x5
ffffffffc0200f9e:	5cc7bb23          	sd	a2,1494(a5) # ffffffffc0206570 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200fa2:	00001517          	auipc	a0,0x1
ffffffffc0200fa6:	24650513          	addi	a0,a0,582 # ffffffffc02021e8 <buddy_system_pmm_manager+0x120>
}
ffffffffc0200faa:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200fac:	90eff06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200fb0:	6705                	lui	a4,0x1
ffffffffc0200fb2:	177d                	addi	a4,a4,-1
ffffffffc0200fb4:	96ba                	add	a3,a3,a4
ffffffffc0200fb6:	777d                	lui	a4,0xfffff
ffffffffc0200fb8:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200fba:	00c6d513          	srli	a0,a3,0xc
ffffffffc0200fbe:	00f57e63          	bgeu	a0,a5,ffffffffc0200fda <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc0200fc2:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200fc4:	982a                	add	a6,a6,a0
ffffffffc0200fc6:	00281513          	slli	a0,a6,0x2
ffffffffc0200fca:	9542                	add	a0,a0,a6
ffffffffc0200fcc:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200fce:	8d95                	sub	a1,a1,a3
ffffffffc0200fd0:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200fd2:	81b1                	srli	a1,a1,0xc
ffffffffc0200fd4:	9532                	add	a0,a0,a2
ffffffffc0200fd6:	9782                	jalr	a5
}
ffffffffc0200fd8:	b771                	j	ffffffffc0200f64 <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0200fda:	00001617          	auipc	a2,0x1
ffffffffc0200fde:	1be60613          	addi	a2,a2,446 # ffffffffc0202198 <buddy_system_pmm_manager+0xd0>
ffffffffc0200fe2:	06b00593          	li	a1,107
ffffffffc0200fe6:	00001517          	auipc	a0,0x1
ffffffffc0200fea:	1d250513          	addi	a0,a0,466 # ffffffffc02021b8 <buddy_system_pmm_manager+0xf0>
ffffffffc0200fee:	bc6ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200ff2:	00001617          	auipc	a2,0x1
ffffffffc0200ff6:	16e60613          	addi	a2,a2,366 # ffffffffc0202160 <buddy_system_pmm_manager+0x98>
ffffffffc0200ffa:	07000593          	li	a1,112
ffffffffc0200ffe:	00001517          	auipc	a0,0x1
ffffffffc0201002:	18a50513          	addi	a0,a0,394 # ffffffffc0202188 <buddy_system_pmm_manager+0xc0>
ffffffffc0201006:	baeff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc020100a:	86ae                	mv	a3,a1
ffffffffc020100c:	00001617          	auipc	a2,0x1
ffffffffc0201010:	15460613          	addi	a2,a2,340 # ffffffffc0202160 <buddy_system_pmm_manager+0x98>
ffffffffc0201014:	08b00593          	li	a1,139
ffffffffc0201018:	00001517          	auipc	a0,0x1
ffffffffc020101c:	17050513          	addi	a0,a0,368 # ffffffffc0202188 <buddy_system_pmm_manager+0xc0>
ffffffffc0201020:	b94ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0201024 <slob_free>:
}

static void slob_free(void *block, int size)
{
    slob_t *cur, *b = (slob_t *)block;
    if (!block)
ffffffffc0201024:	c125                	beqz	a0,ffffffffc0201084 <slob_free+0x60>
        return;
    if (size)
ffffffffc0201026:	e1a5                	bnez	a1,ffffffffc0201086 <slob_free+0x62>
            break;
        }
    }

    // Merge with the next block if possible
    if ((char *)b + b->units * SLOB_UNIT == (char *)cur->next)
ffffffffc0201028:	410c                	lw	a1,0(a0)
    for (cur = slobfree; !(cur->next == slobfree || (b > cur && b < cur->next)); cur = cur->next)
ffffffffc020102a:	00005817          	auipc	a6,0x5
ffffffffc020102e:	fe680813          	addi	a6,a6,-26 # ffffffffc0206010 <slobfree>
ffffffffc0201032:	00083603          	ld	a2,0(a6)
ffffffffc0201036:	661c                	ld	a5,8(a2)
ffffffffc0201038:	8732                	mv	a4,a2
ffffffffc020103a:	02c78363          	beq	a5,a2,ffffffffc0201060 <slob_free+0x3c>
ffffffffc020103e:	00a77d63          	bgeu	a4,a0,ffffffffc0201058 <slob_free+0x34>
ffffffffc0201042:	00f56f63          	bltu	a0,a5,ffffffffc0201060 <slob_free+0x3c>
        if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201046:	00f77d63          	bgeu	a4,a5,ffffffffc0201060 <slob_free+0x3c>
    for (cur = slobfree; !(cur->next == slobfree || (b > cur && b < cur->next)); cur = cur->next)
ffffffffc020104a:	6794                	ld	a3,8(a5)
ffffffffc020104c:	873e                	mv	a4,a5
ffffffffc020104e:	04c68063          	beq	a3,a2,ffffffffc020108e <slob_free+0x6a>
ffffffffc0201052:	87b6                	mv	a5,a3
ffffffffc0201054:	fea767e3          	bltu	a4,a0,ffffffffc0201042 <slob_free+0x1e>
        if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201058:	fef769e3          	bltu	a4,a5,ffffffffc020104a <slob_free+0x26>
ffffffffc020105c:	fef577e3          	bgeu	a0,a5,ffffffffc020104a <slob_free+0x26>
    if ((char *)b + b->units * SLOB_UNIT == (char *)cur->next)
ffffffffc0201060:	00459693          	slli	a3,a1,0x4
ffffffffc0201064:	96aa                	add	a3,a3,a0
ffffffffc0201066:	02d78a63          	beq	a5,a3,ffffffffc020109a <slob_free+0x76>
    {
        b->next = cur->next;
    }

    // Merge with the previous block if possible
    if ((char *)cur + cur->units * SLOB_UNIT == (char *)b)
ffffffffc020106a:	4314                	lw	a3,0(a4)
        b->next = cur->next;
ffffffffc020106c:	e51c                	sd	a5,8(a0)
    if ((char *)cur + cur->units * SLOB_UNIT == (char *)b)
ffffffffc020106e:	00469793          	slli	a5,a3,0x4
ffffffffc0201072:	97ba                	add	a5,a5,a4
ffffffffc0201074:	02f50e63          	beq	a0,a5,ffffffffc02010b0 <slob_free+0x8c>
        cur->units += b->units;
        cur->next = b->next;
    }
    else
    {
        cur->next = b;
ffffffffc0201078:	e708                	sd	a0,8(a4)
    }

    // Update slobfree to point to the newly freed block if it is earlier in memory
    if (b < slobfree)
ffffffffc020107a:	00c57563          	bgeu	a0,a2,ffffffffc0201084 <slob_free+0x60>
    {
        slobfree = b;
ffffffffc020107e:	00a83023          	sd	a0,0(a6)
ffffffffc0201082:	8082                	ret
    }
}
ffffffffc0201084:	8082                	ret
        b->units = SLOB_UNITS(size);
ffffffffc0201086:	25bd                	addiw	a1,a1,15
ffffffffc0201088:	8591                	srai	a1,a1,0x4
ffffffffc020108a:	c10c                	sw	a1,0(a0)
ffffffffc020108c:	bf79                	j	ffffffffc020102a <slob_free+0x6>
    if ((char *)b + b->units * SLOB_UNIT == (char *)cur->next)
ffffffffc020108e:	00459693          	slli	a3,a1,0x4
ffffffffc0201092:	87b2                	mv	a5,a2
ffffffffc0201094:	96aa                	add	a3,a3,a0
ffffffffc0201096:	fcd79ae3          	bne	a5,a3,ffffffffc020106a <slob_free+0x46>
        b->units += cur->next->units;
ffffffffc020109a:	4394                	lw	a3,0(a5)
        b->next = cur->next->next;
ffffffffc020109c:	679c                	ld	a5,8(a5)
        b->units += cur->next->units;
ffffffffc020109e:	9db5                	addw	a1,a1,a3
ffffffffc02010a0:	c10c                	sw	a1,0(a0)
    if ((char *)cur + cur->units * SLOB_UNIT == (char *)b)
ffffffffc02010a2:	4314                	lw	a3,0(a4)
        b->next = cur->next->next;
ffffffffc02010a4:	e51c                	sd	a5,8(a0)
    if ((char *)cur + cur->units * SLOB_UNIT == (char *)b)
ffffffffc02010a6:	00469793          	slli	a5,a3,0x4
ffffffffc02010aa:	97ba                	add	a5,a5,a4
ffffffffc02010ac:	fcf516e3          	bne	a0,a5,ffffffffc0201078 <slob_free+0x54>
        cur->units += b->units;
ffffffffc02010b0:	411c                	lw	a5,0(a0)
        cur->next = b->next;
ffffffffc02010b2:	650c                	ld	a1,8(a0)
        cur->units += b->units;
ffffffffc02010b4:	9ebd                	addw	a3,a3,a5
ffffffffc02010b6:	c314                	sw	a3,0(a4)
        cur->next = b->next;
ffffffffc02010b8:	e70c                	sd	a1,8(a4)
ffffffffc02010ba:	b7c1                	j	ffffffffc020107a <slob_free+0x56>

ffffffffc02010bc <slob_alloc>:
{
ffffffffc02010bc:	1101                	addi	sp,sp,-32
ffffffffc02010be:	ec06                	sd	ra,24(sp)
ffffffffc02010c0:	e822                	sd	s0,16(sp)
ffffffffc02010c2:	e426                	sd	s1,8(sp)
ffffffffc02010c4:	e04a                	sd	s2,0(sp)
    assert(size < PGSIZE);
ffffffffc02010c6:	6785                	lui	a5,0x1
ffffffffc02010c8:	08f57363          	bgeu	a0,a5,ffffffffc020114e <slob_alloc+0x92>
    prev = slobfree;
ffffffffc02010cc:	00005417          	auipc	s0,0x5
ffffffffc02010d0:	f4440413          	addi	s0,s0,-188 # ffffffffc0206010 <slobfree>
ffffffffc02010d4:	6010                	ld	a2,0(s0)
    int units = SLOB_UNITS(size);
ffffffffc02010d6:	053d                	addi	a0,a0,15
ffffffffc02010d8:	00455913          	srli	s2,a0,0x4
    for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02010dc:	6618                	ld	a4,8(a2)
    int units = SLOB_UNITS(size);
ffffffffc02010de:	0009049b          	sext.w	s1,s2
        if (cur->units >= units)
ffffffffc02010e2:	4314                	lw	a3,0(a4)
ffffffffc02010e4:	0696d263          	bge	a3,s1,ffffffffc0201148 <slob_alloc+0x8c>
        if (cur == slobfree)
ffffffffc02010e8:	00e60a63          	beq	a2,a4,ffffffffc02010fc <slob_alloc+0x40>
    for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02010ec:	671c                	ld	a5,8(a4)
        if (cur->units >= units)
ffffffffc02010ee:	4394                	lw	a3,0(a5)
ffffffffc02010f0:	0296d363          	bge	a3,s1,ffffffffc0201116 <slob_alloc+0x5a>
        if (cur == slobfree)
ffffffffc02010f4:	6010                	ld	a2,0(s0)
ffffffffc02010f6:	873e                	mv	a4,a5
ffffffffc02010f8:	fee61ae3          	bne	a2,a4,ffffffffc02010ec <slob_alloc+0x30>
            cur = (slob_t *)alloc_pages(1);
ffffffffc02010fc:	4505                	li	a0,1
ffffffffc02010fe:	d15ff0ef          	jal	ra,ffffffffc0200e12 <alloc_pages>
ffffffffc0201102:	87aa                	mv	a5,a0
            if (!cur)
ffffffffc0201104:	c51d                	beqz	a0,ffffffffc0201132 <slob_alloc+0x76>
            slob_free(cur, PGSIZE);
ffffffffc0201106:	6585                	lui	a1,0x1
ffffffffc0201108:	f1dff0ef          	jal	ra,ffffffffc0201024 <slob_free>
            cur = slobfree;
ffffffffc020110c:	6018                	ld	a4,0(s0)
    for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc020110e:	671c                	ld	a5,8(a4)
        if (cur->units >= units)
ffffffffc0201110:	4394                	lw	a3,0(a5)
ffffffffc0201112:	fe96c1e3          	blt	a3,s1,ffffffffc02010f4 <slob_alloc+0x38>
            if (cur->units == units)
ffffffffc0201116:	02d48563          	beq	s1,a3,ffffffffc0201140 <slob_alloc+0x84>
                prev->next = cur + units;
ffffffffc020111a:	0912                	slli	s2,s2,0x4
ffffffffc020111c:	993e                	add	s2,s2,a5
ffffffffc020111e:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8a70>
                prev->next->next = cur->next;
ffffffffc0201122:	6790                	ld	a2,8(a5)
                prev->next->units = cur->units - units;
ffffffffc0201124:	9e85                	subw	a3,a3,s1
ffffffffc0201126:	00d92023          	sw	a3,0(s2)
                prev->next->next = cur->next;
ffffffffc020112a:	00c93423          	sd	a2,8(s2)
                cur->units = units;
ffffffffc020112e:	c384                	sw	s1,0(a5)
            slobfree = prev;
ffffffffc0201130:	e018                	sd	a4,0(s0)
}
ffffffffc0201132:	60e2                	ld	ra,24(sp)
ffffffffc0201134:	6442                	ld	s0,16(sp)
ffffffffc0201136:	64a2                	ld	s1,8(sp)
ffffffffc0201138:	6902                	ld	s2,0(sp)
ffffffffc020113a:	853e                	mv	a0,a5
ffffffffc020113c:	6105                	addi	sp,sp,32
ffffffffc020113e:	8082                	ret
                prev->next = cur->next;
ffffffffc0201140:	6794                	ld	a3,8(a5)
            slobfree = prev;
ffffffffc0201142:	e018                	sd	a4,0(s0)
                prev->next = cur->next;
ffffffffc0201144:	e714                	sd	a3,8(a4)
            return cur;
ffffffffc0201146:	b7f5                	j	ffffffffc0201132 <slob_alloc+0x76>
        if (cur->units >= units)
ffffffffc0201148:	87ba                	mv	a5,a4
ffffffffc020114a:	8732                	mv	a4,a2
ffffffffc020114c:	b7e9                	j	ffffffffc0201116 <slob_alloc+0x5a>
    assert(size < PGSIZE);
ffffffffc020114e:	00001697          	auipc	a3,0x1
ffffffffc0201152:	0da68693          	addi	a3,a3,218 # ffffffffc0202228 <buddy_system_pmm_manager+0x160>
ffffffffc0201156:	00001617          	auipc	a2,0x1
ffffffffc020115a:	df260613          	addi	a2,a2,-526 # ffffffffc0201f48 <commands+0x500>
ffffffffc020115e:	02300593          	li	a1,35
ffffffffc0201162:	00001517          	auipc	a0,0x1
ffffffffc0201166:	0d650513          	addi	a0,a0,214 # ffffffffc0202238 <buddy_system_pmm_manager+0x170>
ffffffffc020116a:	a4aff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020116e <slub_init>:

void slub_init(void)
{
    cprintf("slub_init() succeeded!\n");
ffffffffc020116e:	00001517          	auipc	a0,0x1
ffffffffc0201172:	0e250513          	addi	a0,a0,226 # ffffffffc0202250 <buddy_system_pmm_manager+0x188>
ffffffffc0201176:	f45fe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc020117a <slub_free>:

void slub_free(void *block)
{
    bigblock_t *bb, **last = &bigblocks;

    if (!block)
ffffffffc020117a:	c531                	beqz	a0,ffffffffc02011c6 <slub_free+0x4c>
        return;

    if (!((unsigned long)block & (PGSIZE - 1)))
ffffffffc020117c:	03451793          	slli	a5,a0,0x34
ffffffffc0201180:	e7a1                	bnez	a5,ffffffffc02011c8 <slub_free+0x4e>
    {
        for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201182:	00005697          	auipc	a3,0x5
ffffffffc0201186:	40668693          	addi	a3,a3,1030 # ffffffffc0206588 <bigblocks>
ffffffffc020118a:	629c                	ld	a5,0(a3)
ffffffffc020118c:	cf95                	beqz	a5,ffffffffc02011c8 <slub_free+0x4e>
{
ffffffffc020118e:	1141                	addi	sp,sp,-16
ffffffffc0201190:	e406                	sd	ra,8(sp)
ffffffffc0201192:	e022                	sd	s0,0(sp)
ffffffffc0201194:	a021                	j	ffffffffc020119c <slub_free+0x22>
        for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201196:	01040693          	addi	a3,s0,16
ffffffffc020119a:	c385                	beqz	a5,ffffffffc02011ba <slub_free+0x40>
        {
            if (bb->pages == block)
ffffffffc020119c:	6798                	ld	a4,8(a5)
ffffffffc020119e:	843e                	mv	s0,a5
            {
                *last = bb->next;
ffffffffc02011a0:	6b9c                	ld	a5,16(a5)
            if (bb->pages == block)
ffffffffc02011a2:	fea71ae3          	bne	a4,a0,ffffffffc0201196 <slub_free+0x1c>
                free_pages((struct Page *)block, bb->order);
ffffffffc02011a6:	400c                	lw	a1,0(s0)
                *last = bb->next;
ffffffffc02011a8:	e29c                	sd	a5,0(a3)
                free_pages((struct Page *)block, bb->order);
ffffffffc02011aa:	ca7ff0ef          	jal	ra,ffffffffc0200e50 <free_pages>
                slob_free(bb, sizeof(bigblock_t));
ffffffffc02011ae:	8522                	mv	a0,s0
        }
    }

    slob_free((slob_t *)block - 1, 0);
    return;
}
ffffffffc02011b0:	6402                	ld	s0,0(sp)
ffffffffc02011b2:	60a2                	ld	ra,8(sp)
                slob_free(bb, sizeof(bigblock_t));
ffffffffc02011b4:	45e1                	li	a1,24
}
ffffffffc02011b6:	0141                	addi	sp,sp,16
    slob_free((slob_t *)block - 1, 0);
ffffffffc02011b8:	b5b5                	j	ffffffffc0201024 <slob_free>
}
ffffffffc02011ba:	6402                	ld	s0,0(sp)
ffffffffc02011bc:	60a2                	ld	ra,8(sp)
    slob_free((slob_t *)block - 1, 0);
ffffffffc02011be:	4581                	li	a1,0
ffffffffc02011c0:	1541                	addi	a0,a0,-16
}
ffffffffc02011c2:	0141                	addi	sp,sp,16
    slob_free((slob_t *)block - 1, 0);
ffffffffc02011c4:	b585                	j	ffffffffc0201024 <slob_free>
ffffffffc02011c6:	8082                	ret
ffffffffc02011c8:	4581                	li	a1,0
ffffffffc02011ca:	1541                	addi	a0,a0,-16
ffffffffc02011cc:	bda1                	j	ffffffffc0201024 <slob_free>

ffffffffc02011ce <slub_check>:
        len++;
    return len;
}

void slub_check()
{
ffffffffc02011ce:	1101                	addi	sp,sp,-32
    cprintf("SLUB check begins\n");
ffffffffc02011d0:	00001517          	auipc	a0,0x1
ffffffffc02011d4:	09850513          	addi	a0,a0,152 # ffffffffc0202268 <buddy_system_pmm_manager+0x1a0>
{
ffffffffc02011d8:	ec06                	sd	ra,24(sp)
ffffffffc02011da:	e822                	sd	s0,16(sp)
ffffffffc02011dc:	e426                	sd	s1,8(sp)
    cprintf("SLUB check begins\n");
ffffffffc02011de:	eddfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
        m = slob_alloc(size + SLOB_UNIT);
ffffffffc02011e2:	05000513          	li	a0,80
ffffffffc02011e6:	ed7ff0ef          	jal	ra,ffffffffc02010bc <slob_alloc>
        return m ? (void *)(m + 1) : 0;
ffffffffc02011ea:	c531                	beqz	a0,ffffffffc0201236 <slub_check+0x68>
ffffffffc02011ec:	87aa                	mv	a5,a0
        m = slob_alloc(size + SLOB_UNIT);
ffffffffc02011ee:	09000513          	li	a0,144
        return m ? (void *)(m + 1) : 0;
ffffffffc02011f2:	01078413          	addi	s0,a5,16 # 1010 <kern_entry-0xffffffffc01feff0>
        m = slob_alloc(size + SLOB_UNIT);
ffffffffc02011f6:	ec7ff0ef          	jal	ra,ffffffffc02010bc <slob_alloc>
ffffffffc02011fa:	87aa                	mv	a5,a0
        return m ? (void *)(m + 1) : 0;
ffffffffc02011fc:	cd2d                	beqz	a0,ffffffffc0201276 <slub_check+0xa8>
    // Allocate another small block
    void *p2 = slub_alloc(128); // Allocate 128 bytes
    assert(p2 != NULL);

    // Free the first small block
    slub_free(p1);
ffffffffc02011fe:	8522                	mv	a0,s0
        return m ? (void *)(m + 1) : 0;
ffffffffc0201200:	01078413          	addi	s0,a5,16
    slub_free(p1);
ffffffffc0201204:	f77ff0ef          	jal	ra,ffffffffc020117a <slub_free>
        m = slob_alloc(size + SLOB_UNIT);
ffffffffc0201208:	03000513          	li	a0,48
ffffffffc020120c:	eb1ff0ef          	jal	ra,ffffffffc02010bc <slob_alloc>
ffffffffc0201210:	84aa                	mv	s1,a0
        return m ? (void *)(m + 1) : 0;
ffffffffc0201212:	c131                	beqz	a0,ffffffffc0201256 <slub_check+0x88>
    void *p3 = slub_alloc(32); // Allocate 32 bytes
    assert(p3 != NULL);


    // Free the remaining small blocks
    slub_free(p2);
ffffffffc0201214:	8522                	mv	a0,s0
ffffffffc0201216:	f65ff0ef          	jal	ra,ffffffffc020117a <slub_free>
    slub_free(p3);
ffffffffc020121a:	01048513          	addi	a0,s1,16
ffffffffc020121e:	f5dff0ef          	jal	ra,ffffffffc020117a <slub_free>


    cprintf("SLUB check passed\n");
}
ffffffffc0201222:	6442                	ld	s0,16(sp)
ffffffffc0201224:	60e2                	ld	ra,24(sp)
ffffffffc0201226:	64a2                	ld	s1,8(sp)
    cprintf("SLUB check passed\n");
ffffffffc0201228:	00001517          	auipc	a0,0x1
ffffffffc020122c:	07850513          	addi	a0,a0,120 # ffffffffc02022a0 <buddy_system_pmm_manager+0x1d8>
}
ffffffffc0201230:	6105                	addi	sp,sp,32
    cprintf("SLUB check passed\n");
ffffffffc0201232:	e89fe06f          	j	ffffffffc02000ba <cprintf>
    assert(p1 != NULL);
ffffffffc0201236:	00001697          	auipc	a3,0x1
ffffffffc020123a:	04a68693          	addi	a3,a3,74 # ffffffffc0202280 <buddy_system_pmm_manager+0x1b8>
ffffffffc020123e:	00001617          	auipc	a2,0x1
ffffffffc0201242:	d0a60613          	addi	a2,a2,-758 # ffffffffc0201f48 <commands+0x500>
ffffffffc0201246:	0e100593          	li	a1,225
ffffffffc020124a:	00001517          	auipc	a0,0x1
ffffffffc020124e:	fee50513          	addi	a0,a0,-18 # ffffffffc0202238 <buddy_system_pmm_manager+0x170>
ffffffffc0201252:	962ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(p3 != NULL);
ffffffffc0201256:	00001697          	auipc	a3,0x1
ffffffffc020125a:	06268693          	addi	a3,a3,98 # ffffffffc02022b8 <buddy_system_pmm_manager+0x1f0>
ffffffffc020125e:	00001617          	auipc	a2,0x1
ffffffffc0201262:	cea60613          	addi	a2,a2,-790 # ffffffffc0201f48 <commands+0x500>
ffffffffc0201266:	0ed00593          	li	a1,237
ffffffffc020126a:	00001517          	auipc	a0,0x1
ffffffffc020126e:	fce50513          	addi	a0,a0,-50 # ffffffffc0202238 <buddy_system_pmm_manager+0x170>
ffffffffc0201272:	942ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(p2 != NULL);
ffffffffc0201276:	00001697          	auipc	a3,0x1
ffffffffc020127a:	01a68693          	addi	a3,a3,26 # ffffffffc0202290 <buddy_system_pmm_manager+0x1c8>
ffffffffc020127e:	00001617          	auipc	a2,0x1
ffffffffc0201282:	cca60613          	addi	a2,a2,-822 # ffffffffc0201f48 <commands+0x500>
ffffffffc0201286:	0e600593          	li	a1,230
ffffffffc020128a:	00001517          	auipc	a0,0x1
ffffffffc020128e:	fae50513          	addi	a0,a0,-82 # ffffffffc0202238 <buddy_system_pmm_manager+0x170>
ffffffffc0201292:	922ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0201296 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201296:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020129a:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020129c:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02012a0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02012a2:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02012a6:	f022                	sd	s0,32(sp)
ffffffffc02012a8:	ec26                	sd	s1,24(sp)
ffffffffc02012aa:	e84a                	sd	s2,16(sp)
ffffffffc02012ac:	f406                	sd	ra,40(sp)
ffffffffc02012ae:	e44e                	sd	s3,8(sp)
ffffffffc02012b0:	84aa                	mv	s1,a0
ffffffffc02012b2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02012b4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02012b8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02012ba:	03067e63          	bgeu	a2,a6,ffffffffc02012f6 <printnum+0x60>
ffffffffc02012be:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02012c0:	00805763          	blez	s0,ffffffffc02012ce <printnum+0x38>
ffffffffc02012c4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02012c6:	85ca                	mv	a1,s2
ffffffffc02012c8:	854e                	mv	a0,s3
ffffffffc02012ca:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02012cc:	fc65                	bnez	s0,ffffffffc02012c4 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012ce:	1a02                	slli	s4,s4,0x20
ffffffffc02012d0:	00001797          	auipc	a5,0x1
ffffffffc02012d4:	ff878793          	addi	a5,a5,-8 # ffffffffc02022c8 <buddy_system_pmm_manager+0x200>
ffffffffc02012d8:	020a5a13          	srli	s4,s4,0x20
ffffffffc02012dc:	9a3e                	add	s4,s4,a5
}
ffffffffc02012de:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012e0:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02012e4:	70a2                	ld	ra,40(sp)
ffffffffc02012e6:	69a2                	ld	s3,8(sp)
ffffffffc02012e8:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012ea:	85ca                	mv	a1,s2
ffffffffc02012ec:	87a6                	mv	a5,s1
}
ffffffffc02012ee:	6942                	ld	s2,16(sp)
ffffffffc02012f0:	64e2                	ld	s1,24(sp)
ffffffffc02012f2:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02012f4:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02012f6:	03065633          	divu	a2,a2,a6
ffffffffc02012fa:	8722                	mv	a4,s0
ffffffffc02012fc:	f9bff0ef          	jal	ra,ffffffffc0201296 <printnum>
ffffffffc0201300:	b7f9                	j	ffffffffc02012ce <printnum+0x38>

ffffffffc0201302 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201302:	7119                	addi	sp,sp,-128
ffffffffc0201304:	f4a6                	sd	s1,104(sp)
ffffffffc0201306:	f0ca                	sd	s2,96(sp)
ffffffffc0201308:	ecce                	sd	s3,88(sp)
ffffffffc020130a:	e8d2                	sd	s4,80(sp)
ffffffffc020130c:	e4d6                	sd	s5,72(sp)
ffffffffc020130e:	e0da                	sd	s6,64(sp)
ffffffffc0201310:	fc5e                	sd	s7,56(sp)
ffffffffc0201312:	f06a                	sd	s10,32(sp)
ffffffffc0201314:	fc86                	sd	ra,120(sp)
ffffffffc0201316:	f8a2                	sd	s0,112(sp)
ffffffffc0201318:	f862                	sd	s8,48(sp)
ffffffffc020131a:	f466                	sd	s9,40(sp)
ffffffffc020131c:	ec6e                	sd	s11,24(sp)
ffffffffc020131e:	892a                	mv	s2,a0
ffffffffc0201320:	84ae                	mv	s1,a1
ffffffffc0201322:	8d32                	mv	s10,a2
ffffffffc0201324:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201326:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020132a:	5b7d                	li	s6,-1
ffffffffc020132c:	00001a97          	auipc	s5,0x1
ffffffffc0201330:	fd0a8a93          	addi	s5,s5,-48 # ffffffffc02022fc <buddy_system_pmm_manager+0x234>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201334:	00001b97          	auipc	s7,0x1
ffffffffc0201338:	1a4b8b93          	addi	s7,s7,420 # ffffffffc02024d8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020133c:	000d4503          	lbu	a0,0(s10)
ffffffffc0201340:	001d0413          	addi	s0,s10,1
ffffffffc0201344:	01350a63          	beq	a0,s3,ffffffffc0201358 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201348:	c121                	beqz	a0,ffffffffc0201388 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020134a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020134c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020134e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201350:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201354:	ff351ae3          	bne	a0,s3,ffffffffc0201348 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201358:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020135c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201360:	4c81                	li	s9,0
ffffffffc0201362:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201364:	5c7d                	li	s8,-1
ffffffffc0201366:	5dfd                	li	s11,-1
ffffffffc0201368:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020136c:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020136e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201372:	0ff5f593          	zext.b	a1,a1
ffffffffc0201376:	00140d13          	addi	s10,s0,1
ffffffffc020137a:	04b56263          	bltu	a0,a1,ffffffffc02013be <vprintfmt+0xbc>
ffffffffc020137e:	058a                	slli	a1,a1,0x2
ffffffffc0201380:	95d6                	add	a1,a1,s5
ffffffffc0201382:	4194                	lw	a3,0(a1)
ffffffffc0201384:	96d6                	add	a3,a3,s5
ffffffffc0201386:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201388:	70e6                	ld	ra,120(sp)
ffffffffc020138a:	7446                	ld	s0,112(sp)
ffffffffc020138c:	74a6                	ld	s1,104(sp)
ffffffffc020138e:	7906                	ld	s2,96(sp)
ffffffffc0201390:	69e6                	ld	s3,88(sp)
ffffffffc0201392:	6a46                	ld	s4,80(sp)
ffffffffc0201394:	6aa6                	ld	s5,72(sp)
ffffffffc0201396:	6b06                	ld	s6,64(sp)
ffffffffc0201398:	7be2                	ld	s7,56(sp)
ffffffffc020139a:	7c42                	ld	s8,48(sp)
ffffffffc020139c:	7ca2                	ld	s9,40(sp)
ffffffffc020139e:	7d02                	ld	s10,32(sp)
ffffffffc02013a0:	6de2                	ld	s11,24(sp)
ffffffffc02013a2:	6109                	addi	sp,sp,128
ffffffffc02013a4:	8082                	ret
            padc = '0';
ffffffffc02013a6:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02013a8:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013ac:	846a                	mv	s0,s10
ffffffffc02013ae:	00140d13          	addi	s10,s0,1
ffffffffc02013b2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02013b6:	0ff5f593          	zext.b	a1,a1
ffffffffc02013ba:	fcb572e3          	bgeu	a0,a1,ffffffffc020137e <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02013be:	85a6                	mv	a1,s1
ffffffffc02013c0:	02500513          	li	a0,37
ffffffffc02013c4:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02013c6:	fff44783          	lbu	a5,-1(s0)
ffffffffc02013ca:	8d22                	mv	s10,s0
ffffffffc02013cc:	f73788e3          	beq	a5,s3,ffffffffc020133c <vprintfmt+0x3a>
ffffffffc02013d0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02013d4:	1d7d                	addi	s10,s10,-1
ffffffffc02013d6:	ff379de3          	bne	a5,s3,ffffffffc02013d0 <vprintfmt+0xce>
ffffffffc02013da:	b78d                	j	ffffffffc020133c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02013dc:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02013e0:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02013e4:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02013e6:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02013ea:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02013ee:	02d86463          	bltu	a6,a3,ffffffffc0201416 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02013f2:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02013f6:	002c169b          	slliw	a3,s8,0x2
ffffffffc02013fa:	0186873b          	addw	a4,a3,s8
ffffffffc02013fe:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201402:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201404:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201408:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020140a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020140e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201412:	fed870e3          	bgeu	a6,a3,ffffffffc02013f2 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201416:	f40ddce3          	bgez	s11,ffffffffc020136e <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020141a:	8de2                	mv	s11,s8
ffffffffc020141c:	5c7d                	li	s8,-1
ffffffffc020141e:	bf81                	j	ffffffffc020136e <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201420:	fffdc693          	not	a3,s11
ffffffffc0201424:	96fd                	srai	a3,a3,0x3f
ffffffffc0201426:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020142a:	00144603          	lbu	a2,1(s0)
ffffffffc020142e:	2d81                	sext.w	s11,s11
ffffffffc0201430:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201432:	bf35                	j	ffffffffc020136e <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201434:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201438:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020143c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020143e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201440:	bfd9                	j	ffffffffc0201416 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201442:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201444:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201448:	01174463          	blt	a4,a7,ffffffffc0201450 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020144c:	1a088e63          	beqz	a7,ffffffffc0201608 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201450:	000a3603          	ld	a2,0(s4)
ffffffffc0201454:	46c1                	li	a3,16
ffffffffc0201456:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201458:	2781                	sext.w	a5,a5
ffffffffc020145a:	876e                	mv	a4,s11
ffffffffc020145c:	85a6                	mv	a1,s1
ffffffffc020145e:	854a                	mv	a0,s2
ffffffffc0201460:	e37ff0ef          	jal	ra,ffffffffc0201296 <printnum>
            break;
ffffffffc0201464:	bde1                	j	ffffffffc020133c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201466:	000a2503          	lw	a0,0(s4)
ffffffffc020146a:	85a6                	mv	a1,s1
ffffffffc020146c:	0a21                	addi	s4,s4,8
ffffffffc020146e:	9902                	jalr	s2
            break;
ffffffffc0201470:	b5f1                	j	ffffffffc020133c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201472:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201474:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201478:	01174463          	blt	a4,a7,ffffffffc0201480 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020147c:	18088163          	beqz	a7,ffffffffc02015fe <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201480:	000a3603          	ld	a2,0(s4)
ffffffffc0201484:	46a9                	li	a3,10
ffffffffc0201486:	8a2e                	mv	s4,a1
ffffffffc0201488:	bfc1                	j	ffffffffc0201458 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020148a:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020148e:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201490:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201492:	bdf1                	j	ffffffffc020136e <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201494:	85a6                	mv	a1,s1
ffffffffc0201496:	02500513          	li	a0,37
ffffffffc020149a:	9902                	jalr	s2
            break;
ffffffffc020149c:	b545                	j	ffffffffc020133c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020149e:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02014a2:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014a4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02014a6:	b5e1                	j	ffffffffc020136e <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02014a8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02014aa:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02014ae:	01174463          	blt	a4,a7,ffffffffc02014b6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02014b2:	14088163          	beqz	a7,ffffffffc02015f4 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02014b6:	000a3603          	ld	a2,0(s4)
ffffffffc02014ba:	46a1                	li	a3,8
ffffffffc02014bc:	8a2e                	mv	s4,a1
ffffffffc02014be:	bf69                	j	ffffffffc0201458 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02014c0:	03000513          	li	a0,48
ffffffffc02014c4:	85a6                	mv	a1,s1
ffffffffc02014c6:	e03e                	sd	a5,0(sp)
ffffffffc02014c8:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02014ca:	85a6                	mv	a1,s1
ffffffffc02014cc:	07800513          	li	a0,120
ffffffffc02014d0:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02014d2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02014d4:	6782                	ld	a5,0(sp)
ffffffffc02014d6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02014d8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02014dc:	bfb5                	j	ffffffffc0201458 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02014de:	000a3403          	ld	s0,0(s4)
ffffffffc02014e2:	008a0713          	addi	a4,s4,8
ffffffffc02014e6:	e03a                	sd	a4,0(sp)
ffffffffc02014e8:	14040263          	beqz	s0,ffffffffc020162c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02014ec:	0fb05763          	blez	s11,ffffffffc02015da <vprintfmt+0x2d8>
ffffffffc02014f0:	02d00693          	li	a3,45
ffffffffc02014f4:	0cd79163          	bne	a5,a3,ffffffffc02015b6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02014f8:	00044783          	lbu	a5,0(s0)
ffffffffc02014fc:	0007851b          	sext.w	a0,a5
ffffffffc0201500:	cf85                	beqz	a5,ffffffffc0201538 <vprintfmt+0x236>
ffffffffc0201502:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201506:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020150a:	000c4563          	bltz	s8,ffffffffc0201514 <vprintfmt+0x212>
ffffffffc020150e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201510:	036c0263          	beq	s8,s6,ffffffffc0201534 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201514:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201516:	0e0c8e63          	beqz	s9,ffffffffc0201612 <vprintfmt+0x310>
ffffffffc020151a:	3781                	addiw	a5,a5,-32
ffffffffc020151c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201612 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201520:	03f00513          	li	a0,63
ffffffffc0201524:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201526:	000a4783          	lbu	a5,0(s4)
ffffffffc020152a:	3dfd                	addiw	s11,s11,-1
ffffffffc020152c:	0a05                	addi	s4,s4,1
ffffffffc020152e:	0007851b          	sext.w	a0,a5
ffffffffc0201532:	ffe1                	bnez	a5,ffffffffc020150a <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201534:	01b05963          	blez	s11,ffffffffc0201546 <vprintfmt+0x244>
ffffffffc0201538:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020153a:	85a6                	mv	a1,s1
ffffffffc020153c:	02000513          	li	a0,32
ffffffffc0201540:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201542:	fe0d9be3          	bnez	s11,ffffffffc0201538 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201546:	6a02                	ld	s4,0(sp)
ffffffffc0201548:	bbd5                	j	ffffffffc020133c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020154a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020154c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201550:	01174463          	blt	a4,a7,ffffffffc0201558 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201554:	08088d63          	beqz	a7,ffffffffc02015ee <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201558:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020155c:	0a044d63          	bltz	s0,ffffffffc0201616 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201560:	8622                	mv	a2,s0
ffffffffc0201562:	8a66                	mv	s4,s9
ffffffffc0201564:	46a9                	li	a3,10
ffffffffc0201566:	bdcd                	j	ffffffffc0201458 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201568:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020156c:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc020156e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201570:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201574:	8fb5                	xor	a5,a5,a3
ffffffffc0201576:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020157a:	02d74163          	blt	a4,a3,ffffffffc020159c <vprintfmt+0x29a>
ffffffffc020157e:	00369793          	slli	a5,a3,0x3
ffffffffc0201582:	97de                	add	a5,a5,s7
ffffffffc0201584:	639c                	ld	a5,0(a5)
ffffffffc0201586:	cb99                	beqz	a5,ffffffffc020159c <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201588:	86be                	mv	a3,a5
ffffffffc020158a:	00001617          	auipc	a2,0x1
ffffffffc020158e:	d6e60613          	addi	a2,a2,-658 # ffffffffc02022f8 <buddy_system_pmm_manager+0x230>
ffffffffc0201592:	85a6                	mv	a1,s1
ffffffffc0201594:	854a                	mv	a0,s2
ffffffffc0201596:	0ce000ef          	jal	ra,ffffffffc0201664 <printfmt>
ffffffffc020159a:	b34d                	j	ffffffffc020133c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020159c:	00001617          	auipc	a2,0x1
ffffffffc02015a0:	d4c60613          	addi	a2,a2,-692 # ffffffffc02022e8 <buddy_system_pmm_manager+0x220>
ffffffffc02015a4:	85a6                	mv	a1,s1
ffffffffc02015a6:	854a                	mv	a0,s2
ffffffffc02015a8:	0bc000ef          	jal	ra,ffffffffc0201664 <printfmt>
ffffffffc02015ac:	bb41                	j	ffffffffc020133c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02015ae:	00001417          	auipc	s0,0x1
ffffffffc02015b2:	d3240413          	addi	s0,s0,-718 # ffffffffc02022e0 <buddy_system_pmm_manager+0x218>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02015b6:	85e2                	mv	a1,s8
ffffffffc02015b8:	8522                	mv	a0,s0
ffffffffc02015ba:	e43e                	sd	a5,8(sp)
ffffffffc02015bc:	1cc000ef          	jal	ra,ffffffffc0201788 <strnlen>
ffffffffc02015c0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02015c4:	01b05b63          	blez	s11,ffffffffc02015da <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02015c8:	67a2                	ld	a5,8(sp)
ffffffffc02015ca:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02015ce:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02015d0:	85a6                	mv	a1,s1
ffffffffc02015d2:	8552                	mv	a0,s4
ffffffffc02015d4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02015d6:	fe0d9ce3          	bnez	s11,ffffffffc02015ce <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02015da:	00044783          	lbu	a5,0(s0)
ffffffffc02015de:	00140a13          	addi	s4,s0,1
ffffffffc02015e2:	0007851b          	sext.w	a0,a5
ffffffffc02015e6:	d3a5                	beqz	a5,ffffffffc0201546 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02015e8:	05e00413          	li	s0,94
ffffffffc02015ec:	bf39                	j	ffffffffc020150a <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02015ee:	000a2403          	lw	s0,0(s4)
ffffffffc02015f2:	b7ad                	j	ffffffffc020155c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02015f4:	000a6603          	lwu	a2,0(s4)
ffffffffc02015f8:	46a1                	li	a3,8
ffffffffc02015fa:	8a2e                	mv	s4,a1
ffffffffc02015fc:	bdb1                	j	ffffffffc0201458 <vprintfmt+0x156>
ffffffffc02015fe:	000a6603          	lwu	a2,0(s4)
ffffffffc0201602:	46a9                	li	a3,10
ffffffffc0201604:	8a2e                	mv	s4,a1
ffffffffc0201606:	bd89                	j	ffffffffc0201458 <vprintfmt+0x156>
ffffffffc0201608:	000a6603          	lwu	a2,0(s4)
ffffffffc020160c:	46c1                	li	a3,16
ffffffffc020160e:	8a2e                	mv	s4,a1
ffffffffc0201610:	b5a1                	j	ffffffffc0201458 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201612:	9902                	jalr	s2
ffffffffc0201614:	bf09                	j	ffffffffc0201526 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201616:	85a6                	mv	a1,s1
ffffffffc0201618:	02d00513          	li	a0,45
ffffffffc020161c:	e03e                	sd	a5,0(sp)
ffffffffc020161e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201620:	6782                	ld	a5,0(sp)
ffffffffc0201622:	8a66                	mv	s4,s9
ffffffffc0201624:	40800633          	neg	a2,s0
ffffffffc0201628:	46a9                	li	a3,10
ffffffffc020162a:	b53d                	j	ffffffffc0201458 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020162c:	03b05163          	blez	s11,ffffffffc020164e <vprintfmt+0x34c>
ffffffffc0201630:	02d00693          	li	a3,45
ffffffffc0201634:	f6d79de3          	bne	a5,a3,ffffffffc02015ae <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201638:	00001417          	auipc	s0,0x1
ffffffffc020163c:	ca840413          	addi	s0,s0,-856 # ffffffffc02022e0 <buddy_system_pmm_manager+0x218>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201640:	02800793          	li	a5,40
ffffffffc0201644:	02800513          	li	a0,40
ffffffffc0201648:	00140a13          	addi	s4,s0,1
ffffffffc020164c:	bd6d                	j	ffffffffc0201506 <vprintfmt+0x204>
ffffffffc020164e:	00001a17          	auipc	s4,0x1
ffffffffc0201652:	c93a0a13          	addi	s4,s4,-877 # ffffffffc02022e1 <buddy_system_pmm_manager+0x219>
ffffffffc0201656:	02800513          	li	a0,40
ffffffffc020165a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020165e:	05e00413          	li	s0,94
ffffffffc0201662:	b565                	j	ffffffffc020150a <vprintfmt+0x208>

ffffffffc0201664 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201664:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201666:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020166a:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020166c:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020166e:	ec06                	sd	ra,24(sp)
ffffffffc0201670:	f83a                	sd	a4,48(sp)
ffffffffc0201672:	fc3e                	sd	a5,56(sp)
ffffffffc0201674:	e0c2                	sd	a6,64(sp)
ffffffffc0201676:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201678:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020167a:	c89ff0ef          	jal	ra,ffffffffc0201302 <vprintfmt>
}
ffffffffc020167e:	60e2                	ld	ra,24(sp)
ffffffffc0201680:	6161                	addi	sp,sp,80
ffffffffc0201682:	8082                	ret

ffffffffc0201684 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201684:	715d                	addi	sp,sp,-80
ffffffffc0201686:	e486                	sd	ra,72(sp)
ffffffffc0201688:	e0a6                	sd	s1,64(sp)
ffffffffc020168a:	fc4a                	sd	s2,56(sp)
ffffffffc020168c:	f84e                	sd	s3,48(sp)
ffffffffc020168e:	f452                	sd	s4,40(sp)
ffffffffc0201690:	f056                	sd	s5,32(sp)
ffffffffc0201692:	ec5a                	sd	s6,24(sp)
ffffffffc0201694:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201696:	c901                	beqz	a0,ffffffffc02016a6 <readline+0x22>
ffffffffc0201698:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc020169a:	00001517          	auipc	a0,0x1
ffffffffc020169e:	c5e50513          	addi	a0,a0,-930 # ffffffffc02022f8 <buddy_system_pmm_manager+0x230>
ffffffffc02016a2:	a19fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc02016a6:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02016a8:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02016aa:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02016ac:	4aa9                	li	s5,10
ffffffffc02016ae:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02016b0:	00005b97          	auipc	s7,0x5
ffffffffc02016b4:	a98b8b93          	addi	s7,s7,-1384 # ffffffffc0206148 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02016b8:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02016bc:	a77fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc02016c0:	00054a63          	bltz	a0,ffffffffc02016d4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02016c4:	00a95a63          	bge	s2,a0,ffffffffc02016d8 <readline+0x54>
ffffffffc02016c8:	029a5263          	bge	s4,s1,ffffffffc02016ec <readline+0x68>
        c = getchar();
ffffffffc02016cc:	a67fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc02016d0:	fe055ae3          	bgez	a0,ffffffffc02016c4 <readline+0x40>
            return NULL;
ffffffffc02016d4:	4501                	li	a0,0
ffffffffc02016d6:	a091                	j	ffffffffc020171a <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02016d8:	03351463          	bne	a0,s3,ffffffffc0201700 <readline+0x7c>
ffffffffc02016dc:	e8a9                	bnez	s1,ffffffffc020172e <readline+0xaa>
        c = getchar();
ffffffffc02016de:	a55fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc02016e2:	fe0549e3          	bltz	a0,ffffffffc02016d4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02016e6:	fea959e3          	bge	s2,a0,ffffffffc02016d8 <readline+0x54>
ffffffffc02016ea:	4481                	li	s1,0
            cputchar(c);
ffffffffc02016ec:	e42a                	sd	a0,8(sp)
ffffffffc02016ee:	a03fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc02016f2:	6522                	ld	a0,8(sp)
ffffffffc02016f4:	009b87b3          	add	a5,s7,s1
ffffffffc02016f8:	2485                	addiw	s1,s1,1
ffffffffc02016fa:	00a78023          	sb	a0,0(a5)
ffffffffc02016fe:	bf7d                	j	ffffffffc02016bc <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201700:	01550463          	beq	a0,s5,ffffffffc0201708 <readline+0x84>
ffffffffc0201704:	fb651ce3          	bne	a0,s6,ffffffffc02016bc <readline+0x38>
            cputchar(c);
ffffffffc0201708:	9e9fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc020170c:	00005517          	auipc	a0,0x5
ffffffffc0201710:	a3c50513          	addi	a0,a0,-1476 # ffffffffc0206148 <buf>
ffffffffc0201714:	94aa                	add	s1,s1,a0
ffffffffc0201716:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020171a:	60a6                	ld	ra,72(sp)
ffffffffc020171c:	6486                	ld	s1,64(sp)
ffffffffc020171e:	7962                	ld	s2,56(sp)
ffffffffc0201720:	79c2                	ld	s3,48(sp)
ffffffffc0201722:	7a22                	ld	s4,40(sp)
ffffffffc0201724:	7a82                	ld	s5,32(sp)
ffffffffc0201726:	6b62                	ld	s6,24(sp)
ffffffffc0201728:	6bc2                	ld	s7,16(sp)
ffffffffc020172a:	6161                	addi	sp,sp,80
ffffffffc020172c:	8082                	ret
            cputchar(c);
ffffffffc020172e:	4521                	li	a0,8
ffffffffc0201730:	9c1fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc0201734:	34fd                	addiw	s1,s1,-1
ffffffffc0201736:	b759                	j	ffffffffc02016bc <readline+0x38>

ffffffffc0201738 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201738:	4781                	li	a5,0
ffffffffc020173a:	00005717          	auipc	a4,0x5
ffffffffc020173e:	8e673703          	ld	a4,-1818(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201742:	88ba                	mv	a7,a4
ffffffffc0201744:	852a                	mv	a0,a0
ffffffffc0201746:	85be                	mv	a1,a5
ffffffffc0201748:	863e                	mv	a2,a5
ffffffffc020174a:	00000073          	ecall
ffffffffc020174e:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201750:	8082                	ret

ffffffffc0201752 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201752:	4781                	li	a5,0
ffffffffc0201754:	00005717          	auipc	a4,0x5
ffffffffc0201758:	e3c73703          	ld	a4,-452(a4) # ffffffffc0206590 <SBI_SET_TIMER>
ffffffffc020175c:	88ba                	mv	a7,a4
ffffffffc020175e:	852a                	mv	a0,a0
ffffffffc0201760:	85be                	mv	a1,a5
ffffffffc0201762:	863e                	mv	a2,a5
ffffffffc0201764:	00000073          	ecall
ffffffffc0201768:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc020176a:	8082                	ret

ffffffffc020176c <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc020176c:	4501                	li	a0,0
ffffffffc020176e:	00005797          	auipc	a5,0x5
ffffffffc0201772:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201776:	88be                	mv	a7,a5
ffffffffc0201778:	852a                	mv	a0,a0
ffffffffc020177a:	85aa                	mv	a1,a0
ffffffffc020177c:	862a                	mv	a2,a0
ffffffffc020177e:	00000073          	ecall
ffffffffc0201782:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc0201784:	2501                	sext.w	a0,a0
ffffffffc0201786:	8082                	ret

ffffffffc0201788 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201788:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020178a:	e589                	bnez	a1,ffffffffc0201794 <strnlen+0xc>
ffffffffc020178c:	a811                	j	ffffffffc02017a0 <strnlen+0x18>
        cnt ++;
ffffffffc020178e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201790:	00f58863          	beq	a1,a5,ffffffffc02017a0 <strnlen+0x18>
ffffffffc0201794:	00f50733          	add	a4,a0,a5
ffffffffc0201798:	00074703          	lbu	a4,0(a4)
ffffffffc020179c:	fb6d                	bnez	a4,ffffffffc020178e <strnlen+0x6>
ffffffffc020179e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02017a0:	852e                	mv	a0,a1
ffffffffc02017a2:	8082                	ret

ffffffffc02017a4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02017a4:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02017a8:	0005c703          	lbu	a4,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02017ac:	cb89                	beqz	a5,ffffffffc02017be <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02017ae:	0505                	addi	a0,a0,1
ffffffffc02017b0:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02017b2:	fee789e3          	beq	a5,a4,ffffffffc02017a4 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02017b6:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02017ba:	9d19                	subw	a0,a0,a4
ffffffffc02017bc:	8082                	ret
ffffffffc02017be:	4501                	li	a0,0
ffffffffc02017c0:	bfed                	j	ffffffffc02017ba <strcmp+0x16>

ffffffffc02017c2 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02017c2:	00054783          	lbu	a5,0(a0)
ffffffffc02017c6:	c799                	beqz	a5,ffffffffc02017d4 <strchr+0x12>
        if (*s == c) {
ffffffffc02017c8:	00f58763          	beq	a1,a5,ffffffffc02017d6 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02017cc:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02017d0:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02017d2:	fbfd                	bnez	a5,ffffffffc02017c8 <strchr+0x6>
    }
    return NULL;
ffffffffc02017d4:	4501                	li	a0,0
}
ffffffffc02017d6:	8082                	ret

ffffffffc02017d8 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02017d8:	ca01                	beqz	a2,ffffffffc02017e8 <memset+0x10>
ffffffffc02017da:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02017dc:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02017de:	0785                	addi	a5,a5,1
ffffffffc02017e0:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02017e4:	fec79de3          	bne	a5,a2,ffffffffc02017de <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02017e8:	8082                	ret
