
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
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
ffffffffc0200024:	c0209137          	lui	sp,0xc0209

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:


int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	0000a517          	auipc	a0,0xa
ffffffffc0200036:	00e50513          	addi	a0,a0,14 # ffffffffc020a040 <ide>
ffffffffc020003a:	00011617          	auipc	a2,0x11
ffffffffc020003e:	53260613          	addi	a2,a2,1330 # ffffffffc021156c <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
<<<<<<< HEAD
ffffffffc020004a:	3a4040ef          	jal	ra,ffffffffc02043ee <memset>
=======
ffffffffc020004a:	386040ef          	jal	ra,ffffffffc02043d0 <memset>
>>>>>>> 747620b (lab2)

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020004e:	00004597          	auipc	a1,0x4
<<<<<<< HEAD
ffffffffc0200052:	3ca58593          	addi	a1,a1,970 # ffffffffc0204418 <etext>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	3e250513          	addi	a0,a0,994 # ffffffffc0204438 <etext+0x20>
=======
ffffffffc0200052:	3b258593          	addi	a1,a1,946 # ffffffffc0204400 <etext+0x6>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	3ca50513          	addi	a0,a0,970 # ffffffffc0204420 <etext+0x26>
>>>>>>> 747620b (lab2)
ffffffffc020005e:	062000ef          	jal	ra,ffffffffc02000c0 <cprintf>

    print_kerninfo();
ffffffffc0200062:	0a6000ef          	jal	ra,ffffffffc0200108 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc0200066:	281010ef          	jal	ra,ffffffffc0201ae6 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	500000ef          	jal	ra,ffffffffc020056a <idt_init>

    vmm_init();                 // init virtual memory management
<<<<<<< HEAD
ffffffffc020006e:	650030ef          	jal	ra,ffffffffc02036be <vmm_init>
=======
ffffffffc020006e:	632030ef          	jal	ra,ffffffffc02036a0 <vmm_init>
>>>>>>> 747620b (lab2)

    ide_init();                 // init ide devices
ffffffffc0200072:	426000ef          	jal	ra,ffffffffc0200498 <ide_init>
    swap_init();                // init swap
ffffffffc0200076:	0d5020ef          	jal	ra,ffffffffc020294a <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020007a:	35c000ef          	jal	ra,ffffffffc02003d6 <clock_init>
    // intr_enable();              // enable irq interrupt

    asm("mret");
ffffffffc020007e:	30200073          	mret
    asm("ebreak");
ffffffffc0200082:	9002                	ebreak

    /* do nothing */
    while (1);
ffffffffc0200084:	a001                	j	ffffffffc0200084 <kern_init+0x52>

ffffffffc0200086 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200086:	1141                	addi	sp,sp,-16
ffffffffc0200088:	e022                	sd	s0,0(sp)
ffffffffc020008a:	e406                	sd	ra,8(sp)
ffffffffc020008c:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020008e:	39a000ef          	jal	ra,ffffffffc0200428 <cons_putc>
    (*cnt) ++;
ffffffffc0200092:	401c                	lw	a5,0(s0)
}
ffffffffc0200094:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200096:	2785                	addiw	a5,a5,1
ffffffffc0200098:	c01c                	sw	a5,0(s0)
}
ffffffffc020009a:	6402                	ld	s0,0(sp)
ffffffffc020009c:	0141                	addi	sp,sp,16
ffffffffc020009e:	8082                	ret

ffffffffc02000a0 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000a0:	1101                	addi	sp,sp,-32
ffffffffc02000a2:	862a                	mv	a2,a0
ffffffffc02000a4:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a6:	00000517          	auipc	a0,0x0
ffffffffc02000aa:	fe050513          	addi	a0,a0,-32 # ffffffffc0200086 <cputch>
ffffffffc02000ae:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000b0:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000b2:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
<<<<<<< HEAD
ffffffffc02000b4:	689030ef          	jal	ra,ffffffffc0203f3c <vprintfmt>
=======
ffffffffc02000b4:	66b030ef          	jal	ra,ffffffffc0203f1e <vprintfmt>
>>>>>>> 747620b (lab2)
    return cnt;
}
ffffffffc02000b8:	60e2                	ld	ra,24(sp)
ffffffffc02000ba:	4532                	lw	a0,12(sp)
ffffffffc02000bc:	6105                	addi	sp,sp,32
ffffffffc02000be:	8082                	ret

ffffffffc02000c0 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000c0:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000c2:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000c6:	8e2a                	mv	t3,a0
ffffffffc02000c8:	f42e                	sd	a1,40(sp)
ffffffffc02000ca:	f832                	sd	a2,48(sp)
ffffffffc02000cc:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ce:	00000517          	auipc	a0,0x0
ffffffffc02000d2:	fb850513          	addi	a0,a0,-72 # ffffffffc0200086 <cputch>
ffffffffc02000d6:	004c                	addi	a1,sp,4
ffffffffc02000d8:	869a                	mv	a3,t1
ffffffffc02000da:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000dc:	ec06                	sd	ra,24(sp)
ffffffffc02000de:	e0ba                	sd	a4,64(sp)
ffffffffc02000e0:	e4be                	sd	a5,72(sp)
ffffffffc02000e2:	e8c2                	sd	a6,80(sp)
ffffffffc02000e4:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000e6:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000e8:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
<<<<<<< HEAD
ffffffffc02000ea:	653030ef          	jal	ra,ffffffffc0203f3c <vprintfmt>
=======
ffffffffc02000ea:	635030ef          	jal	ra,ffffffffc0203f1e <vprintfmt>
>>>>>>> 747620b (lab2)
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000ee:	60e2                	ld	ra,24(sp)
ffffffffc02000f0:	4512                	lw	a0,4(sp)
ffffffffc02000f2:	6125                	addi	sp,sp,96
ffffffffc02000f4:	8082                	ret

ffffffffc02000f6 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000f6:	ae0d                	j	ffffffffc0200428 <cons_putc>

ffffffffc02000f8 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02000f8:	1141                	addi	sp,sp,-16
ffffffffc02000fa:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02000fc:	360000ef          	jal	ra,ffffffffc020045c <cons_getc>
ffffffffc0200100:	dd75                	beqz	a0,ffffffffc02000fc <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200102:	60a2                	ld	ra,8(sp)
ffffffffc0200104:	0141                	addi	sp,sp,16
ffffffffc0200106:	8082                	ret

ffffffffc0200108 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200108:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020010a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020010e:	33650513          	addi	a0,a0,822 # ffffffffc0204440 <etext+0x28>
=======
ffffffffc020010e:	31e50513          	addi	a0,a0,798 # ffffffffc0204428 <etext+0x2e>
>>>>>>> 747620b (lab2)
void print_kerninfo(void) {
ffffffffc0200112:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200114:	fadff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200118:	00000597          	auipc	a1,0x0
ffffffffc020011c:	f1a58593          	addi	a1,a1,-230 # ffffffffc0200032 <kern_init>
ffffffffc0200120:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200124:	34050513          	addi	a0,a0,832 # ffffffffc0204460 <etext+0x48>
ffffffffc0200128:	f99ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020012c:	00004597          	auipc	a1,0x4
ffffffffc0200130:	2ec58593          	addi	a1,a1,748 # ffffffffc0204418 <etext>
ffffffffc0200134:	00004517          	auipc	a0,0x4
ffffffffc0200138:	34c50513          	addi	a0,a0,844 # ffffffffc0204480 <etext+0x68>
=======
ffffffffc0200124:	32850513          	addi	a0,a0,808 # ffffffffc0204448 <etext+0x4e>
ffffffffc0200128:	f99ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020012c:	00004597          	auipc	a1,0x4
ffffffffc0200130:	2ce58593          	addi	a1,a1,718 # ffffffffc02043fa <etext>
ffffffffc0200134:	00004517          	auipc	a0,0x4
ffffffffc0200138:	33450513          	addi	a0,a0,820 # ffffffffc0204468 <etext+0x6e>
>>>>>>> 747620b (lab2)
ffffffffc020013c:	f85ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200140:	0000a597          	auipc	a1,0xa
ffffffffc0200144:	f0058593          	addi	a1,a1,-256 # ffffffffc020a040 <ide>
ffffffffc0200148:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020014c:	35850513          	addi	a0,a0,856 # ffffffffc02044a0 <etext+0x88>
=======
ffffffffc020014c:	34050513          	addi	a0,a0,832 # ffffffffc0204488 <etext+0x8e>
>>>>>>> 747620b (lab2)
ffffffffc0200150:	f71ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200154:	00011597          	auipc	a1,0x11
ffffffffc0200158:	41858593          	addi	a1,a1,1048 # ffffffffc021156c <end>
ffffffffc020015c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200160:	36450513          	addi	a0,a0,868 # ffffffffc02044c0 <etext+0xa8>
=======
ffffffffc0200160:	34c50513          	addi	a0,a0,844 # ffffffffc02044a8 <etext+0xae>
>>>>>>> 747620b (lab2)
ffffffffc0200164:	f5dff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200168:	00012597          	auipc	a1,0x12
ffffffffc020016c:	80358593          	addi	a1,a1,-2045 # ffffffffc021196b <end+0x3ff>
ffffffffc0200170:	00000797          	auipc	a5,0x0
ffffffffc0200174:	ec278793          	addi	a5,a5,-318 # ffffffffc0200032 <kern_init>
ffffffffc0200178:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020017c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200180:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200182:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200186:	95be                	add	a1,a1,a5
ffffffffc0200188:	85a9                	srai	a1,a1,0xa
ffffffffc020018a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020018e:	35650513          	addi	a0,a0,854 # ffffffffc02044e0 <etext+0xc8>
=======
ffffffffc020018e:	33e50513          	addi	a0,a0,830 # ffffffffc02044c8 <etext+0xce>
>>>>>>> 747620b (lab2)
}
ffffffffc0200192:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200194:	b735                	j	ffffffffc02000c0 <cprintf>

ffffffffc0200196 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200196:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc0200198:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc020019c:	37860613          	addi	a2,a2,888 # ffffffffc0204510 <etext+0xf8>
ffffffffc02001a0:	04e00593          	li	a1,78
ffffffffc02001a4:	00004517          	auipc	a0,0x4
ffffffffc02001a8:	38450513          	addi	a0,a0,900 # ffffffffc0204528 <etext+0x110>
=======
ffffffffc020019c:	36060613          	addi	a2,a2,864 # ffffffffc02044f8 <etext+0xfe>
ffffffffc02001a0:	04e00593          	li	a1,78
ffffffffc02001a4:	00004517          	auipc	a0,0x4
ffffffffc02001a8:	36c50513          	addi	a0,a0,876 # ffffffffc0204510 <etext+0x116>
>>>>>>> 747620b (lab2)
void print_stackframe(void) {
ffffffffc02001ac:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02001ae:	1cc000ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02001b2 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02001b2:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02001b4:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02001b8:	38c60613          	addi	a2,a2,908 # ffffffffc0204540 <etext+0x128>
ffffffffc02001bc:	00004597          	auipc	a1,0x4
ffffffffc02001c0:	3a458593          	addi	a1,a1,932 # ffffffffc0204560 <etext+0x148>
ffffffffc02001c4:	00004517          	auipc	a0,0x4
ffffffffc02001c8:	3a450513          	addi	a0,a0,932 # ffffffffc0204568 <etext+0x150>
=======
ffffffffc02001b8:	37460613          	addi	a2,a2,884 # ffffffffc0204528 <etext+0x12e>
ffffffffc02001bc:	00004597          	auipc	a1,0x4
ffffffffc02001c0:	38c58593          	addi	a1,a1,908 # ffffffffc0204548 <etext+0x14e>
ffffffffc02001c4:	00004517          	auipc	a0,0x4
ffffffffc02001c8:	38c50513          	addi	a0,a0,908 # ffffffffc0204550 <etext+0x156>
>>>>>>> 747620b (lab2)
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02001cc:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02001ce:	ef3ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc02001d2:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02001d6:	3a660613          	addi	a2,a2,934 # ffffffffc0204578 <etext+0x160>
ffffffffc02001da:	00004597          	auipc	a1,0x4
ffffffffc02001de:	3c658593          	addi	a1,a1,966 # ffffffffc02045a0 <etext+0x188>
ffffffffc02001e2:	00004517          	auipc	a0,0x4
ffffffffc02001e6:	38650513          	addi	a0,a0,902 # ffffffffc0204568 <etext+0x150>
ffffffffc02001ea:	ed7ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc02001ee:	00004617          	auipc	a2,0x4
ffffffffc02001f2:	3c260613          	addi	a2,a2,962 # ffffffffc02045b0 <etext+0x198>
ffffffffc02001f6:	00004597          	auipc	a1,0x4
ffffffffc02001fa:	3da58593          	addi	a1,a1,986 # ffffffffc02045d0 <etext+0x1b8>
ffffffffc02001fe:	00004517          	auipc	a0,0x4
ffffffffc0200202:	36a50513          	addi	a0,a0,874 # ffffffffc0204568 <etext+0x150>
=======
ffffffffc02001d6:	38e60613          	addi	a2,a2,910 # ffffffffc0204560 <etext+0x166>
ffffffffc02001da:	00004597          	auipc	a1,0x4
ffffffffc02001de:	3ae58593          	addi	a1,a1,942 # ffffffffc0204588 <etext+0x18e>
ffffffffc02001e2:	00004517          	auipc	a0,0x4
ffffffffc02001e6:	36e50513          	addi	a0,a0,878 # ffffffffc0204550 <etext+0x156>
ffffffffc02001ea:	ed7ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc02001ee:	00004617          	auipc	a2,0x4
ffffffffc02001f2:	3aa60613          	addi	a2,a2,938 # ffffffffc0204598 <etext+0x19e>
ffffffffc02001f6:	00004597          	auipc	a1,0x4
ffffffffc02001fa:	3c258593          	addi	a1,a1,962 # ffffffffc02045b8 <etext+0x1be>
ffffffffc02001fe:	00004517          	auipc	a0,0x4
ffffffffc0200202:	35250513          	addi	a0,a0,850 # ffffffffc0204550 <etext+0x156>
>>>>>>> 747620b (lab2)
ffffffffc0200206:	ebbff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    }
    return 0;
}
ffffffffc020020a:	60a2                	ld	ra,8(sp)
ffffffffc020020c:	4501                	li	a0,0
ffffffffc020020e:	0141                	addi	sp,sp,16
ffffffffc0200210:	8082                	ret

ffffffffc0200212 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200212:	1141                	addi	sp,sp,-16
ffffffffc0200214:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200216:	ef3ff0ef          	jal	ra,ffffffffc0200108 <print_kerninfo>
    return 0;
}
ffffffffc020021a:	60a2                	ld	ra,8(sp)
ffffffffc020021c:	4501                	li	a0,0
ffffffffc020021e:	0141                	addi	sp,sp,16
ffffffffc0200220:	8082                	ret

ffffffffc0200222 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200222:	1141                	addi	sp,sp,-16
ffffffffc0200224:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200226:	f71ff0ef          	jal	ra,ffffffffc0200196 <print_stackframe>
    return 0;
}
ffffffffc020022a:	60a2                	ld	ra,8(sp)
ffffffffc020022c:	4501                	li	a0,0
ffffffffc020022e:	0141                	addi	sp,sp,16
ffffffffc0200230:	8082                	ret

ffffffffc0200232 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200232:	7115                	addi	sp,sp,-224
ffffffffc0200234:	ed5e                	sd	s7,152(sp)
ffffffffc0200236:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200238:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020023c:	3a850513          	addi	a0,a0,936 # ffffffffc02045e0 <etext+0x1c8>
=======
ffffffffc020023c:	39050513          	addi	a0,a0,912 # ffffffffc02045c8 <etext+0x1ce>
>>>>>>> 747620b (lab2)
kmonitor(struct trapframe *tf) {
ffffffffc0200240:	ed86                	sd	ra,216(sp)
ffffffffc0200242:	e9a2                	sd	s0,208(sp)
ffffffffc0200244:	e5a6                	sd	s1,200(sp)
ffffffffc0200246:	e1ca                	sd	s2,192(sp)
ffffffffc0200248:	fd4e                	sd	s3,184(sp)
ffffffffc020024a:	f952                	sd	s4,176(sp)
ffffffffc020024c:	f556                	sd	s5,168(sp)
ffffffffc020024e:	f15a                	sd	s6,160(sp)
ffffffffc0200250:	e962                	sd	s8,144(sp)
ffffffffc0200252:	e566                	sd	s9,136(sp)
ffffffffc0200254:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200256:	e6bff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020025a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020025e:	3ae50513          	addi	a0,a0,942 # ffffffffc0204608 <etext+0x1f0>
=======
ffffffffc020025e:	39650513          	addi	a0,a0,918 # ffffffffc02045f0 <etext+0x1f6>
>>>>>>> 747620b (lab2)
ffffffffc0200262:	e5fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    if (tf != NULL) {
ffffffffc0200266:	000b8563          	beqz	s7,ffffffffc0200270 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020026a:	855e                	mv	a0,s7
ffffffffc020026c:	4e8000ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc0200270:	00004c17          	auipc	s8,0x4
<<<<<<< HEAD
ffffffffc0200274:	400c0c13          	addi	s8,s8,1024 # ffffffffc0204670 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc0200278:	00006917          	auipc	s2,0x6
ffffffffc020027c:	85090913          	addi	s2,s2,-1968 # ffffffffc0205ac8 <default_pmm_manager+0x928>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200280:	00004497          	auipc	s1,0x4
ffffffffc0200284:	3b048493          	addi	s1,s1,944 # ffffffffc0204630 <etext+0x218>
=======
ffffffffc0200274:	3e8c0c13          	addi	s8,s8,1000 # ffffffffc0204658 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc0200278:	00006917          	auipc	s2,0x6
ffffffffc020027c:	83890913          	addi	s2,s2,-1992 # ffffffffc0205ab0 <default_pmm_manager+0x928>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200280:	00004497          	auipc	s1,0x4
ffffffffc0200284:	39848493          	addi	s1,s1,920 # ffffffffc0204618 <etext+0x21e>
>>>>>>> 747620b (lab2)
        if (argc == MAXARGS - 1) {
ffffffffc0200288:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020028a:	00004b17          	auipc	s6,0x4
<<<<<<< HEAD
ffffffffc020028e:	3aeb0b13          	addi	s6,s6,942 # ffffffffc0204638 <etext+0x220>
        argv[argc ++] = buf;
ffffffffc0200292:	00004a17          	auipc	s4,0x4
ffffffffc0200296:	2cea0a13          	addi	s4,s4,718 # ffffffffc0204560 <etext+0x148>
=======
ffffffffc020028e:	396b0b13          	addi	s6,s6,918 # ffffffffc0204620 <etext+0x226>
        argv[argc ++] = buf;
ffffffffc0200292:	00004a17          	auipc	s4,0x4
ffffffffc0200296:	2b6a0a13          	addi	s4,s4,694 # ffffffffc0204548 <etext+0x14e>
>>>>>>> 747620b (lab2)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020029a:	4a8d                	li	s5,3
        if ((buf = readline("")) != NULL) {
ffffffffc020029c:	854a                	mv	a0,s2
<<<<<<< HEAD
ffffffffc020029e:	020040ef          	jal	ra,ffffffffc02042be <readline>
=======
ffffffffc020029e:	002040ef          	jal	ra,ffffffffc02042a0 <readline>
>>>>>>> 747620b (lab2)
ffffffffc02002a2:	842a                	mv	s0,a0
ffffffffc02002a4:	dd65                	beqz	a0,ffffffffc020029c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002a6:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002aa:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002ac:	e1bd                	bnez	a1,ffffffffc0200312 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02002ae:	fe0c87e3          	beqz	s9,ffffffffc020029c <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002b2:	6582                	ld	a1,0(sp)
ffffffffc02002b4:	00004d17          	auipc	s10,0x4
<<<<<<< HEAD
ffffffffc02002b8:	3bcd0d13          	addi	s10,s10,956 # ffffffffc0204670 <commands>
=======
ffffffffc02002b8:	3a4d0d13          	addi	s10,s10,932 # ffffffffc0204658 <commands>
>>>>>>> 747620b (lab2)
        argv[argc ++] = buf;
ffffffffc02002bc:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002be:	4401                	li	s0,0
ffffffffc02002c0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
<<<<<<< HEAD
ffffffffc02002c2:	0f8040ef          	jal	ra,ffffffffc02043ba <strcmp>
=======
ffffffffc02002c2:	0da040ef          	jal	ra,ffffffffc020439c <strcmp>
>>>>>>> 747620b (lab2)
ffffffffc02002c6:	c919                	beqz	a0,ffffffffc02002dc <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002c8:	2405                	addiw	s0,s0,1
ffffffffc02002ca:	0b540063          	beq	s0,s5,ffffffffc020036a <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002ce:	000d3503          	ld	a0,0(s10)
ffffffffc02002d2:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
<<<<<<< HEAD
ffffffffc02002d6:	0e4040ef          	jal	ra,ffffffffc02043ba <strcmp>
=======
ffffffffc02002d6:	0c6040ef          	jal	ra,ffffffffc020439c <strcmp>
>>>>>>> 747620b (lab2)
ffffffffc02002da:	f57d                	bnez	a0,ffffffffc02002c8 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02002dc:	00141793          	slli	a5,s0,0x1
ffffffffc02002e0:	97a2                	add	a5,a5,s0
ffffffffc02002e2:	078e                	slli	a5,a5,0x3
ffffffffc02002e4:	97e2                	add	a5,a5,s8
ffffffffc02002e6:	6b9c                	ld	a5,16(a5)
ffffffffc02002e8:	865e                	mv	a2,s7
ffffffffc02002ea:	002c                	addi	a1,sp,8
ffffffffc02002ec:	fffc851b          	addiw	a0,s9,-1
ffffffffc02002f0:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02002f2:	fa0555e3          	bgez	a0,ffffffffc020029c <kmonitor+0x6a>
}
ffffffffc02002f6:	60ee                	ld	ra,216(sp)
ffffffffc02002f8:	644e                	ld	s0,208(sp)
ffffffffc02002fa:	64ae                	ld	s1,200(sp)
ffffffffc02002fc:	690e                	ld	s2,192(sp)
ffffffffc02002fe:	79ea                	ld	s3,184(sp)
ffffffffc0200300:	7a4a                	ld	s4,176(sp)
ffffffffc0200302:	7aaa                	ld	s5,168(sp)
ffffffffc0200304:	7b0a                	ld	s6,160(sp)
ffffffffc0200306:	6bea                	ld	s7,152(sp)
ffffffffc0200308:	6c4a                	ld	s8,144(sp)
ffffffffc020030a:	6caa                	ld	s9,136(sp)
ffffffffc020030c:	6d0a                	ld	s10,128(sp)
ffffffffc020030e:	612d                	addi	sp,sp,224
ffffffffc0200310:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200312:	8526                	mv	a0,s1
<<<<<<< HEAD
ffffffffc0200314:	0c4040ef          	jal	ra,ffffffffc02043d8 <strchr>
=======
ffffffffc0200314:	0a6040ef          	jal	ra,ffffffffc02043ba <strchr>
>>>>>>> 747620b (lab2)
ffffffffc0200318:	c901                	beqz	a0,ffffffffc0200328 <kmonitor+0xf6>
ffffffffc020031a:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc020031e:	00040023          	sb	zero,0(s0)
ffffffffc0200322:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200324:	d5c9                	beqz	a1,ffffffffc02002ae <kmonitor+0x7c>
ffffffffc0200326:	b7f5                	j	ffffffffc0200312 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200328:	00044783          	lbu	a5,0(s0)
ffffffffc020032c:	d3c9                	beqz	a5,ffffffffc02002ae <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc020032e:	033c8963          	beq	s9,s3,ffffffffc0200360 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200332:	003c9793          	slli	a5,s9,0x3
ffffffffc0200336:	0118                	addi	a4,sp,128
ffffffffc0200338:	97ba                	add	a5,a5,a4
ffffffffc020033a:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020033e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200342:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200344:	e591                	bnez	a1,ffffffffc0200350 <kmonitor+0x11e>
ffffffffc0200346:	b7b5                	j	ffffffffc02002b2 <kmonitor+0x80>
ffffffffc0200348:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020034c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020034e:	d1a5                	beqz	a1,ffffffffc02002ae <kmonitor+0x7c>
ffffffffc0200350:	8526                	mv	a0,s1
<<<<<<< HEAD
ffffffffc0200352:	086040ef          	jal	ra,ffffffffc02043d8 <strchr>
=======
ffffffffc0200352:	068040ef          	jal	ra,ffffffffc02043ba <strchr>
>>>>>>> 747620b (lab2)
ffffffffc0200356:	d96d                	beqz	a0,ffffffffc0200348 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200358:	00044583          	lbu	a1,0(s0)
ffffffffc020035c:	d9a9                	beqz	a1,ffffffffc02002ae <kmonitor+0x7c>
ffffffffc020035e:	bf55                	j	ffffffffc0200312 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200360:	45c1                	li	a1,16
ffffffffc0200362:	855a                	mv	a0,s6
ffffffffc0200364:	d5dff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc0200368:	b7e9                	j	ffffffffc0200332 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020036a:	6582                	ld	a1,0(sp)
ffffffffc020036c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200370:	2ec50513          	addi	a0,a0,748 # ffffffffc0204658 <etext+0x240>
=======
ffffffffc0200370:	2d450513          	addi	a0,a0,724 # ffffffffc0204640 <etext+0x246>
>>>>>>> 747620b (lab2)
ffffffffc0200374:	d4dff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    return 0;
ffffffffc0200378:	b715                	j	ffffffffc020029c <kmonitor+0x6a>

ffffffffc020037a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020037a:	00011317          	auipc	t1,0x11
ffffffffc020037e:	17e30313          	addi	t1,t1,382 # ffffffffc02114f8 <is_panic>
ffffffffc0200382:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200386:	715d                	addi	sp,sp,-80
ffffffffc0200388:	ec06                	sd	ra,24(sp)
ffffffffc020038a:	e822                	sd	s0,16(sp)
ffffffffc020038c:	f436                	sd	a3,40(sp)
ffffffffc020038e:	f83a                	sd	a4,48(sp)
ffffffffc0200390:	fc3e                	sd	a5,56(sp)
ffffffffc0200392:	e0c2                	sd	a6,64(sp)
ffffffffc0200394:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200396:	020e1a63          	bnez	t3,ffffffffc02003ca <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020039a:	4785                	li	a5,1
ffffffffc020039c:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003a0:	8432                	mv	s0,a2
ffffffffc02003a2:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003a4:	862e                	mv	a2,a1
ffffffffc02003a6:	85aa                	mv	a1,a0
ffffffffc02003a8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02003ac:	31050513          	addi	a0,a0,784 # ffffffffc02046b8 <commands+0x48>
=======
ffffffffc02003ac:	2f850513          	addi	a0,a0,760 # ffffffffc02046a0 <commands+0x48>
>>>>>>> 747620b (lab2)
    va_start(ap, fmt);
ffffffffc02003b0:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003b2:	d0fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003b6:	65a2                	ld	a1,8(sp)
ffffffffc02003b8:	8522                	mv	a0,s0
ffffffffc02003ba:	ce7ff0ef          	jal	ra,ffffffffc02000a0 <vcprintf>
    cprintf("\n");
ffffffffc02003be:	00005517          	auipc	a0,0x5
<<<<<<< HEAD
ffffffffc02003c2:	25a50513          	addi	a0,a0,602 # ffffffffc0205618 <default_pmm_manager+0x478>
=======
ffffffffc02003c2:	24250513          	addi	a0,a0,578 # ffffffffc0205600 <default_pmm_manager+0x478>
>>>>>>> 747620b (lab2)
ffffffffc02003c6:	cfbff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02003ca:	12a000ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02003ce:	4501                	li	a0,0
ffffffffc02003d0:	e63ff0ef          	jal	ra,ffffffffc0200232 <kmonitor>
    while (1) {
ffffffffc02003d4:	bfed                	j	ffffffffc02003ce <__panic+0x54>

ffffffffc02003d6 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02003d6:	67e1                	lui	a5,0x18
ffffffffc02003d8:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02003dc:	00011717          	auipc	a4,0x11
ffffffffc02003e0:	12f73623          	sd	a5,300(a4) # ffffffffc0211508 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02003e4:	c0102573          	rdtime	a0
static inline void sbi_set_timer(uint64_t stime_value)
{
#if __riscv_xlen == 32
	SBI_CALL_2(SBI_SET_TIMER, stime_value, stime_value >> 32);
#else
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02003e8:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02003ea:	953e                	add	a0,a0,a5
ffffffffc02003ec:	4601                	li	a2,0
ffffffffc02003ee:	4881                	li	a7,0
ffffffffc02003f0:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02003f4:	02000793          	li	a5,32
ffffffffc02003f8:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02003fc:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200400:	2dc50513          	addi	a0,a0,732 # ffffffffc02046d8 <commands+0x68>
=======
ffffffffc0200400:	2c450513          	addi	a0,a0,708 # ffffffffc02046c0 <commands+0x68>
>>>>>>> 747620b (lab2)
    ticks = 0;
ffffffffc0200404:	00011797          	auipc	a5,0x11
ffffffffc0200408:	0e07be23          	sd	zero,252(a5) # ffffffffc0211500 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020040c:	b955                	j	ffffffffc02000c0 <cprintf>

ffffffffc020040e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020040e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200412:	00011797          	auipc	a5,0x11
ffffffffc0200416:	0f67b783          	ld	a5,246(a5) # ffffffffc0211508 <timebase>
ffffffffc020041a:	953e                	add	a0,a0,a5
ffffffffc020041c:	4581                	li	a1,0
ffffffffc020041e:	4601                	li	a2,0
ffffffffc0200420:	4881                	li	a7,0
ffffffffc0200422:	00000073          	ecall
ffffffffc0200426:	8082                	ret

ffffffffc0200428 <cons_putc>:
#include <intr.h>
#include <mmu.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200428:	100027f3          	csrr	a5,sstatus
ffffffffc020042c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020042e:	0ff57513          	zext.b	a0,a0
ffffffffc0200432:	e799                	bnez	a5,ffffffffc0200440 <cons_putc+0x18>
ffffffffc0200434:	4581                	li	a1,0
ffffffffc0200436:	4601                	li	a2,0
ffffffffc0200438:	4885                	li	a7,1
ffffffffc020043a:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc020043e:	8082                	ret

/* cons_init - initializes the console devices */
void cons_init(void) {}

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200440:	1101                	addi	sp,sp,-32
ffffffffc0200442:	ec06                	sd	ra,24(sp)
ffffffffc0200444:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200446:	0ae000ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc020044a:	6522                	ld	a0,8(sp)
ffffffffc020044c:	4581                	li	a1,0
ffffffffc020044e:	4601                	li	a2,0
ffffffffc0200450:	4885                	li	a7,1
ffffffffc0200452:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200456:	60e2                	ld	ra,24(sp)
ffffffffc0200458:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020045a:	a851                	j	ffffffffc02004ee <intr_enable>

ffffffffc020045c <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020045c:	100027f3          	csrr	a5,sstatus
ffffffffc0200460:	8b89                	andi	a5,a5,2
ffffffffc0200462:	eb89                	bnez	a5,ffffffffc0200474 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200464:	4501                	li	a0,0
ffffffffc0200466:	4581                	li	a1,0
ffffffffc0200468:	4601                	li	a2,0
ffffffffc020046a:	4889                	li	a7,2
ffffffffc020046c:	00000073          	ecall
ffffffffc0200470:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200472:	8082                	ret
int cons_getc(void) {
ffffffffc0200474:	1101                	addi	sp,sp,-32
ffffffffc0200476:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200478:	07c000ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc020047c:	4501                	li	a0,0
ffffffffc020047e:	4581                	li	a1,0
ffffffffc0200480:	4601                	li	a2,0
ffffffffc0200482:	4889                	li	a7,2
ffffffffc0200484:	00000073          	ecall
ffffffffc0200488:	2501                	sext.w	a0,a0
ffffffffc020048a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020048c:	062000ef          	jal	ra,ffffffffc02004ee <intr_enable>
}
ffffffffc0200490:	60e2                	ld	ra,24(sp)
ffffffffc0200492:	6522                	ld	a0,8(sp)
ffffffffc0200494:	6105                	addi	sp,sp,32
ffffffffc0200496:	8082                	ret

ffffffffc0200498 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc0200498:	8082                	ret

ffffffffc020049a <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc020049a:	00253513          	sltiu	a0,a0,2
ffffffffc020049e:	8082                	ret

ffffffffc02004a0 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02004a0:	03800513          	li	a0,56
ffffffffc02004a4:	8082                	ret

ffffffffc02004a6 <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02004a6:	0000a797          	auipc	a5,0xa
ffffffffc02004aa:	b9a78793          	addi	a5,a5,-1126 # ffffffffc020a040 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc02004ae:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02004b2:	1141                	addi	sp,sp,-16
ffffffffc02004b4:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02004b6:	95be                	add	a1,a1,a5
ffffffffc02004b8:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02004bc:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
<<<<<<< HEAD
ffffffffc02004be:	743030ef          	jal	ra,ffffffffc0204400 <memcpy>
=======
ffffffffc02004be:	725030ef          	jal	ra,ffffffffc02043e2 <memcpy>
>>>>>>> 747620b (lab2)
    return 0;
}
ffffffffc02004c2:	60a2                	ld	ra,8(sp)
ffffffffc02004c4:	4501                	li	a0,0
ffffffffc02004c6:	0141                	addi	sp,sp,16
ffffffffc02004c8:	8082                	ret

ffffffffc02004ca <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc02004ca:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02004ce:	0000a517          	auipc	a0,0xa
ffffffffc02004d2:	b7250513          	addi	a0,a0,-1166 # ffffffffc020a040 <ide>
                   size_t nsecs) {
ffffffffc02004d6:	1141                	addi	sp,sp,-16
ffffffffc02004d8:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02004da:	953e                	add	a0,a0,a5
ffffffffc02004dc:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc02004e0:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
<<<<<<< HEAD
ffffffffc02004e2:	71f030ef          	jal	ra,ffffffffc0204400 <memcpy>
=======
ffffffffc02004e2:	701030ef          	jal	ra,ffffffffc02043e2 <memcpy>
>>>>>>> 747620b (lab2)
    return 0;
}
ffffffffc02004e6:	60a2                	ld	ra,8(sp)
ffffffffc02004e8:	4501                	li	a0,0
ffffffffc02004ea:	0141                	addi	sp,sp,16
ffffffffc02004ec:	8082                	ret

ffffffffc02004ee <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004ee:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004f4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004f8:	8082                	ret

ffffffffc02004fa <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02004fa:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc02004fe:	1141                	addi	sp,sp,-16
ffffffffc0200500:	e022                	sd	s0,0(sp)
ffffffffc0200502:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200504:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200508:	11053583          	ld	a1,272(a0)
static int pgfault_handler(struct trapframe *tf) {
ffffffffc020050c:	842a                	mv	s0,a0
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc020050e:	05500613          	li	a2,85
ffffffffc0200512:	c399                	beqz	a5,ffffffffc0200518 <pgfault_handler+0x1e>
ffffffffc0200514:	04b00613          	li	a2,75
ffffffffc0200518:	11843703          	ld	a4,280(s0)
ffffffffc020051c:	47bd                	li	a5,15
ffffffffc020051e:	05700693          	li	a3,87
ffffffffc0200522:	00f70463          	beq	a4,a5,ffffffffc020052a <pgfault_handler+0x30>
ffffffffc0200526:	05200693          	li	a3,82
ffffffffc020052a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020052e:	1ce50513          	addi	a0,a0,462 # ffffffffc02046f8 <commands+0x88>
=======
ffffffffc020052e:	1b650513          	addi	a0,a0,438 # ffffffffc02046e0 <commands+0x88>
>>>>>>> 747620b (lab2)
ffffffffc0200532:	b8fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc0200536:	00011517          	auipc	a0,0x11
ffffffffc020053a:	02a53503          	ld	a0,42(a0) # ffffffffc0211560 <check_mm_struct>
ffffffffc020053e:	c911                	beqz	a0,ffffffffc0200552 <pgfault_handler+0x58>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200540:	11043603          	ld	a2,272(s0)
ffffffffc0200544:	11843583          	ld	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc0200548:	6402                	ld	s0,0(sp)
ffffffffc020054a:	60a2                	ld	ra,8(sp)
ffffffffc020054c:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
<<<<<<< HEAD
ffffffffc020054e:	7480306f          	j	ffffffffc0203c96 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc0200552:	00004617          	auipc	a2,0x4
ffffffffc0200556:	1c660613          	addi	a2,a2,454 # ffffffffc0204718 <commands+0xa8>
ffffffffc020055a:	07800593          	li	a1,120
ffffffffc020055e:	00004517          	auipc	a0,0x4
ffffffffc0200562:	1d250513          	addi	a0,a0,466 # ffffffffc0204730 <commands+0xc0>
=======
ffffffffc020054e:	72a0306f          	j	ffffffffc0203c78 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc0200552:	00004617          	auipc	a2,0x4
ffffffffc0200556:	1ae60613          	addi	a2,a2,430 # ffffffffc0204700 <commands+0xa8>
ffffffffc020055a:	07800593          	li	a1,120
ffffffffc020055e:	00004517          	auipc	a0,0x4
ffffffffc0200562:	1ba50513          	addi	a0,a0,442 # ffffffffc0204718 <commands+0xc0>
>>>>>>> 747620b (lab2)
ffffffffc0200566:	e15ff0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020056a <idt_init>:
    write_csr(sscratch, 0);
ffffffffc020056a:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc020056e:	00000797          	auipc	a5,0x0
ffffffffc0200572:	4b278793          	addi	a5,a5,1202 # ffffffffc0200a20 <__alltraps>
ffffffffc0200576:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SIE);
ffffffffc020057a:	100167f3          	csrrsi	a5,sstatus,2
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020057e:	000407b7          	lui	a5,0x40
ffffffffc0200582:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200588:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc020058a:	1141                	addi	sp,sp,-16
ffffffffc020058c:	e022                	sd	s0,0(sp)
ffffffffc020058e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200590:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200594:	1b850513          	addi	a0,a0,440 # ffffffffc0204748 <commands+0xd8>
=======
ffffffffc0200594:	1a050513          	addi	a0,a0,416 # ffffffffc0204730 <commands+0xd8>
>>>>>>> 747620b (lab2)
void print_regs(struct pushregs *gpr) {
ffffffffc0200598:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020059a:	b27ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020059e:	640c                	ld	a1,8(s0)
ffffffffc02005a0:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005a4:	1c050513          	addi	a0,a0,448 # ffffffffc0204760 <commands+0xf0>
=======
ffffffffc02005a4:	1a850513          	addi	a0,a0,424 # ffffffffc0204748 <commands+0xf0>
>>>>>>> 747620b (lab2)
ffffffffc02005a8:	b19ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005ac:	680c                	ld	a1,16(s0)
ffffffffc02005ae:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005b2:	1ca50513          	addi	a0,a0,458 # ffffffffc0204778 <commands+0x108>
=======
ffffffffc02005b2:	1b250513          	addi	a0,a0,434 # ffffffffc0204760 <commands+0x108>
>>>>>>> 747620b (lab2)
ffffffffc02005b6:	b0bff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005ba:	6c0c                	ld	a1,24(s0)
ffffffffc02005bc:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005c0:	1d450513          	addi	a0,a0,468 # ffffffffc0204790 <commands+0x120>
=======
ffffffffc02005c0:	1bc50513          	addi	a0,a0,444 # ffffffffc0204778 <commands+0x120>
>>>>>>> 747620b (lab2)
ffffffffc02005c4:	afdff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005c8:	700c                	ld	a1,32(s0)
ffffffffc02005ca:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005ce:	1de50513          	addi	a0,a0,478 # ffffffffc02047a8 <commands+0x138>
=======
ffffffffc02005ce:	1c650513          	addi	a0,a0,454 # ffffffffc0204790 <commands+0x138>
>>>>>>> 747620b (lab2)
ffffffffc02005d2:	aefff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005d6:	740c                	ld	a1,40(s0)
ffffffffc02005d8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005dc:	1e850513          	addi	a0,a0,488 # ffffffffc02047c0 <commands+0x150>
=======
ffffffffc02005dc:	1d050513          	addi	a0,a0,464 # ffffffffc02047a8 <commands+0x150>
>>>>>>> 747620b (lab2)
ffffffffc02005e0:	ae1ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005e4:	780c                	ld	a1,48(s0)
ffffffffc02005e6:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005ea:	1f250513          	addi	a0,a0,498 # ffffffffc02047d8 <commands+0x168>
=======
ffffffffc02005ea:	1da50513          	addi	a0,a0,474 # ffffffffc02047c0 <commands+0x168>
>>>>>>> 747620b (lab2)
ffffffffc02005ee:	ad3ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005f2:	7c0c                	ld	a1,56(s0)
ffffffffc02005f4:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02005f8:	1fc50513          	addi	a0,a0,508 # ffffffffc02047f0 <commands+0x180>
=======
ffffffffc02005f8:	1e450513          	addi	a0,a0,484 # ffffffffc02047d8 <commands+0x180>
>>>>>>> 747620b (lab2)
ffffffffc02005fc:	ac5ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200600:	602c                	ld	a1,64(s0)
ffffffffc0200602:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200606:	20650513          	addi	a0,a0,518 # ffffffffc0204808 <commands+0x198>
=======
ffffffffc0200606:	1ee50513          	addi	a0,a0,494 # ffffffffc02047f0 <commands+0x198>
>>>>>>> 747620b (lab2)
ffffffffc020060a:	ab7ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020060e:	642c                	ld	a1,72(s0)
ffffffffc0200610:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200614:	21050513          	addi	a0,a0,528 # ffffffffc0204820 <commands+0x1b0>
=======
ffffffffc0200614:	1f850513          	addi	a0,a0,504 # ffffffffc0204808 <commands+0x1b0>
>>>>>>> 747620b (lab2)
ffffffffc0200618:	aa9ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020061c:	682c                	ld	a1,80(s0)
ffffffffc020061e:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200622:	21a50513          	addi	a0,a0,538 # ffffffffc0204838 <commands+0x1c8>
=======
ffffffffc0200622:	20250513          	addi	a0,a0,514 # ffffffffc0204820 <commands+0x1c8>
>>>>>>> 747620b (lab2)
ffffffffc0200626:	a9bff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020062a:	6c2c                	ld	a1,88(s0)
ffffffffc020062c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200630:	22450513          	addi	a0,a0,548 # ffffffffc0204850 <commands+0x1e0>
=======
ffffffffc0200630:	20c50513          	addi	a0,a0,524 # ffffffffc0204838 <commands+0x1e0>
>>>>>>> 747620b (lab2)
ffffffffc0200634:	a8dff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200638:	702c                	ld	a1,96(s0)
ffffffffc020063a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020063e:	22e50513          	addi	a0,a0,558 # ffffffffc0204868 <commands+0x1f8>
=======
ffffffffc020063e:	21650513          	addi	a0,a0,534 # ffffffffc0204850 <commands+0x1f8>
>>>>>>> 747620b (lab2)
ffffffffc0200642:	a7fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200646:	742c                	ld	a1,104(s0)
ffffffffc0200648:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020064c:	23850513          	addi	a0,a0,568 # ffffffffc0204880 <commands+0x210>
=======
ffffffffc020064c:	22050513          	addi	a0,a0,544 # ffffffffc0204868 <commands+0x210>
>>>>>>> 747620b (lab2)
ffffffffc0200650:	a71ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200654:	782c                	ld	a1,112(s0)
ffffffffc0200656:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020065a:	24250513          	addi	a0,a0,578 # ffffffffc0204898 <commands+0x228>
=======
ffffffffc020065a:	22a50513          	addi	a0,a0,554 # ffffffffc0204880 <commands+0x228>
>>>>>>> 747620b (lab2)
ffffffffc020065e:	a63ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200662:	7c2c                	ld	a1,120(s0)
ffffffffc0200664:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200668:	24c50513          	addi	a0,a0,588 # ffffffffc02048b0 <commands+0x240>
=======
ffffffffc0200668:	23450513          	addi	a0,a0,564 # ffffffffc0204898 <commands+0x240>
>>>>>>> 747620b (lab2)
ffffffffc020066c:	a55ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200670:	604c                	ld	a1,128(s0)
ffffffffc0200672:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200676:	25650513          	addi	a0,a0,598 # ffffffffc02048c8 <commands+0x258>
=======
ffffffffc0200676:	23e50513          	addi	a0,a0,574 # ffffffffc02048b0 <commands+0x258>
>>>>>>> 747620b (lab2)
ffffffffc020067a:	a47ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020067e:	644c                	ld	a1,136(s0)
ffffffffc0200680:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200684:	26050513          	addi	a0,a0,608 # ffffffffc02048e0 <commands+0x270>
=======
ffffffffc0200684:	24850513          	addi	a0,a0,584 # ffffffffc02048c8 <commands+0x270>
>>>>>>> 747620b (lab2)
ffffffffc0200688:	a39ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020068c:	684c                	ld	a1,144(s0)
ffffffffc020068e:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200692:	26a50513          	addi	a0,a0,618 # ffffffffc02048f8 <commands+0x288>
=======
ffffffffc0200692:	25250513          	addi	a0,a0,594 # ffffffffc02048e0 <commands+0x288>
>>>>>>> 747620b (lab2)
ffffffffc0200696:	a2bff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020069a:	6c4c                	ld	a1,152(s0)
ffffffffc020069c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006a0:	27450513          	addi	a0,a0,628 # ffffffffc0204910 <commands+0x2a0>
=======
ffffffffc02006a0:	25c50513          	addi	a0,a0,604 # ffffffffc02048f8 <commands+0x2a0>
>>>>>>> 747620b (lab2)
ffffffffc02006a4:	a1dff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006a8:	704c                	ld	a1,160(s0)
ffffffffc02006aa:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006ae:	27e50513          	addi	a0,a0,638 # ffffffffc0204928 <commands+0x2b8>
=======
ffffffffc02006ae:	26650513          	addi	a0,a0,614 # ffffffffc0204910 <commands+0x2b8>
>>>>>>> 747620b (lab2)
ffffffffc02006b2:	a0fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006b6:	744c                	ld	a1,168(s0)
ffffffffc02006b8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006bc:	28850513          	addi	a0,a0,648 # ffffffffc0204940 <commands+0x2d0>
=======
ffffffffc02006bc:	27050513          	addi	a0,a0,624 # ffffffffc0204928 <commands+0x2d0>
>>>>>>> 747620b (lab2)
ffffffffc02006c0:	a01ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006c4:	784c                	ld	a1,176(s0)
ffffffffc02006c6:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006ca:	29250513          	addi	a0,a0,658 # ffffffffc0204958 <commands+0x2e8>
=======
ffffffffc02006ca:	27a50513          	addi	a0,a0,634 # ffffffffc0204940 <commands+0x2e8>
>>>>>>> 747620b (lab2)
ffffffffc02006ce:	9f3ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006d2:	7c4c                	ld	a1,184(s0)
ffffffffc02006d4:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006d8:	29c50513          	addi	a0,a0,668 # ffffffffc0204970 <commands+0x300>
=======
ffffffffc02006d8:	28450513          	addi	a0,a0,644 # ffffffffc0204958 <commands+0x300>
>>>>>>> 747620b (lab2)
ffffffffc02006dc:	9e5ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006e0:	606c                	ld	a1,192(s0)
ffffffffc02006e2:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006e6:	2a650513          	addi	a0,a0,678 # ffffffffc0204988 <commands+0x318>
=======
ffffffffc02006e6:	28e50513          	addi	a0,a0,654 # ffffffffc0204970 <commands+0x318>
>>>>>>> 747620b (lab2)
ffffffffc02006ea:	9d7ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006ee:	646c                	ld	a1,200(s0)
ffffffffc02006f0:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02006f4:	2b050513          	addi	a0,a0,688 # ffffffffc02049a0 <commands+0x330>
=======
ffffffffc02006f4:	29850513          	addi	a0,a0,664 # ffffffffc0204988 <commands+0x330>
>>>>>>> 747620b (lab2)
ffffffffc02006f8:	9c9ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02006fc:	686c                	ld	a1,208(s0)
ffffffffc02006fe:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200702:	2ba50513          	addi	a0,a0,698 # ffffffffc02049b8 <commands+0x348>
=======
ffffffffc0200702:	2a250513          	addi	a0,a0,674 # ffffffffc02049a0 <commands+0x348>
>>>>>>> 747620b (lab2)
ffffffffc0200706:	9bbff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc020070a:	6c6c                	ld	a1,216(s0)
ffffffffc020070c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200710:	2c450513          	addi	a0,a0,708 # ffffffffc02049d0 <commands+0x360>
=======
ffffffffc0200710:	2ac50513          	addi	a0,a0,684 # ffffffffc02049b8 <commands+0x360>
>>>>>>> 747620b (lab2)
ffffffffc0200714:	9adff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200718:	706c                	ld	a1,224(s0)
ffffffffc020071a:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020071e:	2ce50513          	addi	a0,a0,718 # ffffffffc02049e8 <commands+0x378>
=======
ffffffffc020071e:	2b650513          	addi	a0,a0,694 # ffffffffc02049d0 <commands+0x378>
>>>>>>> 747620b (lab2)
ffffffffc0200722:	99fff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200726:	746c                	ld	a1,232(s0)
ffffffffc0200728:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020072c:	2d850513          	addi	a0,a0,728 # ffffffffc0204a00 <commands+0x390>
=======
ffffffffc020072c:	2c050513          	addi	a0,a0,704 # ffffffffc02049e8 <commands+0x390>
>>>>>>> 747620b (lab2)
ffffffffc0200730:	991ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200734:	786c                	ld	a1,240(s0)
ffffffffc0200736:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020073a:	2e250513          	addi	a0,a0,738 # ffffffffc0204a18 <commands+0x3a8>
=======
ffffffffc020073a:	2ca50513          	addi	a0,a0,714 # ffffffffc0204a00 <commands+0x3a8>
>>>>>>> 747620b (lab2)
ffffffffc020073e:	983ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200742:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200744:	6402                	ld	s0,0(sp)
ffffffffc0200746:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200748:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020074c:	2e850513          	addi	a0,a0,744 # ffffffffc0204a30 <commands+0x3c0>
=======
ffffffffc020074c:	2d050513          	addi	a0,a0,720 # ffffffffc0204a18 <commands+0x3c0>
>>>>>>> 747620b (lab2)
}
ffffffffc0200750:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200752:	b2bd                	j	ffffffffc02000c0 <cprintf>

ffffffffc0200754 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200754:	1141                	addi	sp,sp,-16
ffffffffc0200756:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200758:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc020075a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020075c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200760:	2ec50513          	addi	a0,a0,748 # ffffffffc0204a48 <commands+0x3d8>
=======
ffffffffc0200760:	2d450513          	addi	a0,a0,724 # ffffffffc0204a30 <commands+0x3d8>
>>>>>>> 747620b (lab2)
void print_trapframe(struct trapframe *tf) {
ffffffffc0200764:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200766:	95bff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc020076a:	8522                	mv	a0,s0
ffffffffc020076c:	e1dff0ef          	jal	ra,ffffffffc0200588 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200770:	10043583          	ld	a1,256(s0)
ffffffffc0200774:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200778:	2ec50513          	addi	a0,a0,748 # ffffffffc0204a60 <commands+0x3f0>
=======
ffffffffc0200778:	2d450513          	addi	a0,a0,724 # ffffffffc0204a48 <commands+0x3f0>
>>>>>>> 747620b (lab2)
ffffffffc020077c:	945ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200780:	10843583          	ld	a1,264(s0)
ffffffffc0200784:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200788:	2f450513          	addi	a0,a0,756 # ffffffffc0204a78 <commands+0x408>
=======
ffffffffc0200788:	2dc50513          	addi	a0,a0,732 # ffffffffc0204a60 <commands+0x408>
>>>>>>> 747620b (lab2)
ffffffffc020078c:	935ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200790:	11043583          	ld	a1,272(s0)
ffffffffc0200794:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200798:	2fc50513          	addi	a0,a0,764 # ffffffffc0204a90 <commands+0x420>
=======
ffffffffc0200798:	2e450513          	addi	a0,a0,740 # ffffffffc0204a78 <commands+0x420>
>>>>>>> 747620b (lab2)
ffffffffc020079c:	925ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a0:	11843583          	ld	a1,280(s0)
}
ffffffffc02007a4:	6402                	ld	s0,0(sp)
ffffffffc02007a6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02007ac:	30050513          	addi	a0,a0,768 # ffffffffc0204aa8 <commands+0x438>
=======
ffffffffc02007ac:	2e850513          	addi	a0,a0,744 # ffffffffc0204a90 <commands+0x438>
>>>>>>> 747620b (lab2)
}
ffffffffc02007b0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007b2:	90fff06f          	j	ffffffffc02000c0 <cprintf>

ffffffffc02007b6 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02007b6:	11853783          	ld	a5,280(a0)
ffffffffc02007ba:	472d                	li	a4,11
ffffffffc02007bc:	0786                	slli	a5,a5,0x1
ffffffffc02007be:	8385                	srli	a5,a5,0x1
ffffffffc02007c0:	06f76c63          	bltu	a4,a5,ffffffffc0200838 <interrupt_handler+0x82>
ffffffffc02007c4:	00004717          	auipc	a4,0x4
<<<<<<< HEAD
ffffffffc02007c8:	3ac70713          	addi	a4,a4,940 # ffffffffc0204b70 <commands+0x500>
=======
ffffffffc02007c8:	39470713          	addi	a4,a4,916 # ffffffffc0204b58 <commands+0x500>
>>>>>>> 747620b (lab2)
ffffffffc02007cc:	078a                	slli	a5,a5,0x2
ffffffffc02007ce:	97ba                	add	a5,a5,a4
ffffffffc02007d0:	439c                	lw	a5,0(a5)
ffffffffc02007d2:	97ba                	add	a5,a5,a4
ffffffffc02007d4:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02007d6:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02007da:	34a50513          	addi	a0,a0,842 # ffffffffc0204b20 <commands+0x4b0>
ffffffffc02007de:	8e3ff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007e2:	00004517          	auipc	a0,0x4
ffffffffc02007e6:	31e50513          	addi	a0,a0,798 # ffffffffc0204b00 <commands+0x490>
ffffffffc02007ea:	8d7ff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007ee:	00004517          	auipc	a0,0x4
ffffffffc02007f2:	2d250513          	addi	a0,a0,722 # ffffffffc0204ac0 <commands+0x450>
ffffffffc02007f6:	8cbff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007fa:	00004517          	auipc	a0,0x4
ffffffffc02007fe:	2e650513          	addi	a0,a0,742 # ffffffffc0204ae0 <commands+0x470>
=======
ffffffffc02007da:	33250513          	addi	a0,a0,818 # ffffffffc0204b08 <commands+0x4b0>
ffffffffc02007de:	8e3ff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007e2:	00004517          	auipc	a0,0x4
ffffffffc02007e6:	30650513          	addi	a0,a0,774 # ffffffffc0204ae8 <commands+0x490>
ffffffffc02007ea:	8d7ff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007ee:	00004517          	auipc	a0,0x4
ffffffffc02007f2:	2ba50513          	addi	a0,a0,698 # ffffffffc0204aa8 <commands+0x450>
ffffffffc02007f6:	8cbff06f          	j	ffffffffc02000c0 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007fa:	00004517          	auipc	a0,0x4
ffffffffc02007fe:	2ce50513          	addi	a0,a0,718 # ffffffffc0204ac8 <commands+0x470>
>>>>>>> 747620b (lab2)
ffffffffc0200802:	8bfff06f          	j	ffffffffc02000c0 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200806:	1141                	addi	sp,sp,-16
ffffffffc0200808:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc020080a:	c05ff0ef          	jal	ra,ffffffffc020040e <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc020080e:	00011697          	auipc	a3,0x11
ffffffffc0200812:	cf268693          	addi	a3,a3,-782 # ffffffffc0211500 <ticks>
ffffffffc0200816:	629c                	ld	a5,0(a3)
ffffffffc0200818:	06400713          	li	a4,100
ffffffffc020081c:	0785                	addi	a5,a5,1
ffffffffc020081e:	02e7f733          	remu	a4,a5,a4
ffffffffc0200822:	e29c                	sd	a5,0(a3)
ffffffffc0200824:	cb19                	beqz	a4,ffffffffc020083a <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200826:	60a2                	ld	ra,8(sp)
ffffffffc0200828:	0141                	addi	sp,sp,16
ffffffffc020082a:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc020082c:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200830:	32450513          	addi	a0,a0,804 # ffffffffc0204b50 <commands+0x4e0>
=======
ffffffffc0200830:	30c50513          	addi	a0,a0,780 # ffffffffc0204b38 <commands+0x4e0>
>>>>>>> 747620b (lab2)
ffffffffc0200834:	88dff06f          	j	ffffffffc02000c0 <cprintf>
            print_trapframe(tf);
ffffffffc0200838:	bf31                	j	ffffffffc0200754 <print_trapframe>
}
ffffffffc020083a:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020083c:	06400593          	li	a1,100
ffffffffc0200840:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200844:	30050513          	addi	a0,a0,768 # ffffffffc0204b40 <commands+0x4d0>
=======
ffffffffc0200844:	2e850513          	addi	a0,a0,744 # ffffffffc0204b28 <commands+0x4d0>
>>>>>>> 747620b (lab2)
}
ffffffffc0200848:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020084a:	877ff06f          	j	ffffffffc02000c0 <cprintf>

ffffffffc020084e <exception_handler>:


void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc020084e:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200852:	1101                	addi	sp,sp,-32
ffffffffc0200854:	e822                	sd	s0,16(sp)
ffffffffc0200856:	ec06                	sd	ra,24(sp)
ffffffffc0200858:	e426                	sd	s1,8(sp)
ffffffffc020085a:	473d                	li	a4,15
ffffffffc020085c:	842a                	mv	s0,a0
ffffffffc020085e:	18f76263          	bltu	a4,a5,ffffffffc02009e2 <exception_handler+0x194>
ffffffffc0200862:	00004717          	auipc	a4,0x4
<<<<<<< HEAD
ffffffffc0200866:	53e70713          	addi	a4,a4,1342 # ffffffffc0204da0 <commands+0x730>
=======
ffffffffc0200866:	52670713          	addi	a4,a4,1318 # ffffffffc0204d88 <commands+0x730>
>>>>>>> 747620b (lab2)
ffffffffc020086a:	078a                	slli	a5,a5,0x2
ffffffffc020086c:	97ba                	add	a5,a5,a4
ffffffffc020086e:	439c                	lw	a5,0(a5)
ffffffffc0200870:	97ba                	add	a5,a5,a4
ffffffffc0200872:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc0200874:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc0200878:	51450513          	addi	a0,a0,1300 # ffffffffc0204d88 <commands+0x718>
=======
ffffffffc0200878:	4fc50513          	addi	a0,a0,1276 # ffffffffc0204d70 <commands+0x718>
>>>>>>> 747620b (lab2)
ffffffffc020087c:	845ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200880:	8522                	mv	a0,s0
ffffffffc0200882:	c79ff0ef          	jal	ra,ffffffffc02004fa <pgfault_handler>
ffffffffc0200886:	84aa                	mv	s1,a0
ffffffffc0200888:	16051363          	bnez	a0,ffffffffc02009ee <exception_handler+0x1a0>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc020088c:	60e2                	ld	ra,24(sp)
ffffffffc020088e:	6442                	ld	s0,16(sp)
ffffffffc0200890:	64a2                	ld	s1,8(sp)
ffffffffc0200892:	6105                	addi	sp,sp,32
ffffffffc0200894:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc0200896:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc020089a:	30a50513          	addi	a0,a0,778 # ffffffffc0204ba0 <commands+0x530>
=======
ffffffffc020089a:	2f250513          	addi	a0,a0,754 # ffffffffc0204b88 <commands+0x530>
>>>>>>> 747620b (lab2)
}
ffffffffc020089e:	6442                	ld	s0,16(sp)
ffffffffc02008a0:	60e2                	ld	ra,24(sp)
ffffffffc02008a2:	64a2                	ld	s1,8(sp)
ffffffffc02008a4:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008a6:	81bff06f          	j	ffffffffc02000c0 <cprintf>
ffffffffc02008aa:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02008ae:	31650513          	addi	a0,a0,790 # ffffffffc0204bc0 <commands+0x550>
=======
ffffffffc02008ae:	2fe50513          	addi	a0,a0,766 # ffffffffc0204ba8 <commands+0x550>
>>>>>>> 747620b (lab2)
ffffffffc02008b2:	b7f5                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Illegal instruction exception at 0x%16llx\n", tf->epc);
ffffffffc02008b4:	10853583          	ld	a1,264(a0)
ffffffffc02008b8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02008bc:	32850513          	addi	a0,a0,808 # ffffffffc0204be0 <commands+0x570>
=======
ffffffffc02008bc:	31050513          	addi	a0,a0,784 # ffffffffc0204bc8 <commands+0x570>
>>>>>>> 747620b (lab2)
ffffffffc02008c0:	801ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            tf->epc += 4;
ffffffffc02008c4:	10843783          	ld	a5,264(s0)
ffffffffc02008c8:	0791                	addi	a5,a5,4
ffffffffc02008ca:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc02008ce:	bf7d                	j	ffffffffc020088c <exception_handler+0x3e>
            cprintf("Exeption type: breakpoint\n");
ffffffffc02008d0:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02008d4:	34050513          	addi	a0,a0,832 # ffffffffc0204c10 <commands+0x5a0>
=======
ffffffffc02008d4:	32850513          	addi	a0,a0,808 # ffffffffc0204bf8 <commands+0x5a0>
>>>>>>> 747620b (lab2)
ffffffffc02008d8:	fe8ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            cprintf("ebreak caught at 0x%016llx\n", tf->epc);
ffffffffc02008dc:	10843583          	ld	a1,264(s0)
ffffffffc02008e0:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02008e4:	35050513          	addi	a0,a0,848 # ffffffffc0204c30 <commands+0x5c0>
=======
ffffffffc02008e4:	33850513          	addi	a0,a0,824 # ffffffffc0204c18 <commands+0x5c0>
>>>>>>> 747620b (lab2)
ffffffffc02008e8:	fd8ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            tf->epc += 2;
ffffffffc02008ec:	10843783          	ld	a5,264(s0)
ffffffffc02008f0:	0789                	addi	a5,a5,2
ffffffffc02008f2:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc02008f6:	bf59                	j	ffffffffc020088c <exception_handler+0x3e>
            cprintf("Load address misaligned\n");
ffffffffc02008f8:	00004517          	auipc	a0,0x4
<<<<<<< HEAD
ffffffffc02008fc:	35850513          	addi	a0,a0,856 # ffffffffc0204c50 <commands+0x5e0>
ffffffffc0200900:	bf79                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	36e50513          	addi	a0,a0,878 # ffffffffc0204c70 <commands+0x600>
=======
ffffffffc02008fc:	34050513          	addi	a0,a0,832 # ffffffffc0204c38 <commands+0x5e0>
ffffffffc0200900:	bf79                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	35650513          	addi	a0,a0,854 # ffffffffc0204c58 <commands+0x600>
>>>>>>> 747620b (lab2)
ffffffffc020090a:	fb6ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc020090e:	8522                	mv	a0,s0
ffffffffc0200910:	bebff0ef          	jal	ra,ffffffffc02004fa <pgfault_handler>
ffffffffc0200914:	84aa                	mv	s1,a0
ffffffffc0200916:	d93d                	beqz	a0,ffffffffc020088c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200918:	8522                	mv	a0,s0
ffffffffc020091a:	e3bff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc020091e:	86a6                	mv	a3,s1
ffffffffc0200920:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc0200924:	36860613          	addi	a2,a2,872 # ffffffffc0204c88 <commands+0x618>
ffffffffc0200928:	0cd00593          	li	a1,205
ffffffffc020092c:	00004517          	auipc	a0,0x4
ffffffffc0200930:	e0450513          	addi	a0,a0,-508 # ffffffffc0204730 <commands+0xc0>
ffffffffc0200934:	a47ff0ef          	jal	ra,ffffffffc020037a <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc0200938:	00004517          	auipc	a0,0x4
ffffffffc020093c:	37050513          	addi	a0,a0,880 # ffffffffc0204ca8 <commands+0x638>
ffffffffc0200940:	bfb9                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	37e50513          	addi	a0,a0,894 # ffffffffc0204cc0 <commands+0x650>
=======
ffffffffc0200924:	35060613          	addi	a2,a2,848 # ffffffffc0204c70 <commands+0x618>
ffffffffc0200928:	0cd00593          	li	a1,205
ffffffffc020092c:	00004517          	auipc	a0,0x4
ffffffffc0200930:	dec50513          	addi	a0,a0,-532 # ffffffffc0204718 <commands+0xc0>
ffffffffc0200934:	a47ff0ef          	jal	ra,ffffffffc020037a <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc0200938:	00004517          	auipc	a0,0x4
ffffffffc020093c:	35850513          	addi	a0,a0,856 # ffffffffc0204c90 <commands+0x638>
ffffffffc0200940:	bfb9                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	36650513          	addi	a0,a0,870 # ffffffffc0204ca8 <commands+0x650>
>>>>>>> 747620b (lab2)
ffffffffc020094a:	f76ff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc020094e:	8522                	mv	a0,s0
ffffffffc0200950:	babff0ef          	jal	ra,ffffffffc02004fa <pgfault_handler>
ffffffffc0200954:	84aa                	mv	s1,a0
ffffffffc0200956:	d91d                	beqz	a0,ffffffffc020088c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200958:	8522                	mv	a0,s0
ffffffffc020095a:	dfbff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc020095e:	86a6                	mv	a3,s1
ffffffffc0200960:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc0200964:	32860613          	addi	a2,a2,808 # ffffffffc0204c88 <commands+0x618>
ffffffffc0200968:	0d700593          	li	a1,215
ffffffffc020096c:	00004517          	auipc	a0,0x4
ffffffffc0200970:	dc450513          	addi	a0,a0,-572 # ffffffffc0204730 <commands+0xc0>
ffffffffc0200974:	a07ff0ef          	jal	ra,ffffffffc020037a <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc0200978:	00004517          	auipc	a0,0x4
ffffffffc020097c:	36050513          	addi	a0,a0,864 # ffffffffc0204cd8 <commands+0x668>
ffffffffc0200980:	bf39                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc0200982:	00004517          	auipc	a0,0x4
ffffffffc0200986:	37650513          	addi	a0,a0,886 # ffffffffc0204cf8 <commands+0x688>
ffffffffc020098a:	bf11                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc020098c:	00004517          	auipc	a0,0x4
ffffffffc0200990:	38c50513          	addi	a0,a0,908 # ffffffffc0204d18 <commands+0x6a8>
ffffffffc0200994:	b729                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200996:	00004517          	auipc	a0,0x4
ffffffffc020099a:	3a250513          	addi	a0,a0,930 # ffffffffc0204d38 <commands+0x6c8>
ffffffffc020099e:	b701                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	3b850513          	addi	a0,a0,952 # ffffffffc0204d58 <commands+0x6e8>
ffffffffc02009a8:	bddd                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	3c650513          	addi	a0,a0,966 # ffffffffc0204d70 <commands+0x700>
=======
ffffffffc0200964:	31060613          	addi	a2,a2,784 # ffffffffc0204c70 <commands+0x618>
ffffffffc0200968:	0d700593          	li	a1,215
ffffffffc020096c:	00004517          	auipc	a0,0x4
ffffffffc0200970:	dac50513          	addi	a0,a0,-596 # ffffffffc0204718 <commands+0xc0>
ffffffffc0200974:	a07ff0ef          	jal	ra,ffffffffc020037a <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc0200978:	00004517          	auipc	a0,0x4
ffffffffc020097c:	34850513          	addi	a0,a0,840 # ffffffffc0204cc0 <commands+0x668>
ffffffffc0200980:	bf39                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc0200982:	00004517          	auipc	a0,0x4
ffffffffc0200986:	35e50513          	addi	a0,a0,862 # ffffffffc0204ce0 <commands+0x688>
ffffffffc020098a:	bf11                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc020098c:	00004517          	auipc	a0,0x4
ffffffffc0200990:	37450513          	addi	a0,a0,884 # ffffffffc0204d00 <commands+0x6a8>
ffffffffc0200994:	b729                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200996:	00004517          	auipc	a0,0x4
ffffffffc020099a:	38a50513          	addi	a0,a0,906 # ffffffffc0204d20 <commands+0x6c8>
ffffffffc020099e:	b701                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	3a050513          	addi	a0,a0,928 # ffffffffc0204d40 <commands+0x6e8>
ffffffffc02009a8:	bddd                	j	ffffffffc020089e <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	3ae50513          	addi	a0,a0,942 # ffffffffc0204d58 <commands+0x700>
>>>>>>> 747620b (lab2)
ffffffffc02009b2:	f0eff0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02009b6:	8522                	mv	a0,s0
ffffffffc02009b8:	b43ff0ef          	jal	ra,ffffffffc02004fa <pgfault_handler>
ffffffffc02009bc:	84aa                	mv	s1,a0
ffffffffc02009be:	ec0507e3          	beqz	a0,ffffffffc020088c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009c2:	8522                	mv	a0,s0
ffffffffc02009c4:	d91ff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009c8:	86a6                	mv	a3,s1
ffffffffc02009ca:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02009ce:	2be60613          	addi	a2,a2,702 # ffffffffc0204c88 <commands+0x618>
ffffffffc02009d2:	0ed00593          	li	a1,237
ffffffffc02009d6:	00004517          	auipc	a0,0x4
ffffffffc02009da:	d5a50513          	addi	a0,a0,-678 # ffffffffc0204730 <commands+0xc0>
=======
ffffffffc02009ce:	2a660613          	addi	a2,a2,678 # ffffffffc0204c70 <commands+0x618>
ffffffffc02009d2:	0ed00593          	li	a1,237
ffffffffc02009d6:	00004517          	auipc	a0,0x4
ffffffffc02009da:	d4250513          	addi	a0,a0,-702 # ffffffffc0204718 <commands+0xc0>
>>>>>>> 747620b (lab2)
ffffffffc02009de:	99dff0ef          	jal	ra,ffffffffc020037a <__panic>
            print_trapframe(tf);
ffffffffc02009e2:	8522                	mv	a0,s0
}
ffffffffc02009e4:	6442                	ld	s0,16(sp)
ffffffffc02009e6:	60e2                	ld	ra,24(sp)
ffffffffc02009e8:	64a2                	ld	s1,8(sp)
ffffffffc02009ea:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc02009ec:	b3a5                	j	ffffffffc0200754 <print_trapframe>
                print_trapframe(tf);
ffffffffc02009ee:	8522                	mv	a0,s0
ffffffffc02009f0:	d65ff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009f4:	86a6                	mv	a3,s1
ffffffffc02009f6:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02009fa:	29260613          	addi	a2,a2,658 # ffffffffc0204c88 <commands+0x618>
ffffffffc02009fe:	0f400593          	li	a1,244
ffffffffc0200a02:	00004517          	auipc	a0,0x4
ffffffffc0200a06:	d2e50513          	addi	a0,a0,-722 # ffffffffc0204730 <commands+0xc0>
=======
ffffffffc02009fa:	27a60613          	addi	a2,a2,634 # ffffffffc0204c70 <commands+0x618>
ffffffffc02009fe:	0f400593          	li	a1,244
ffffffffc0200a02:	00004517          	auipc	a0,0x4
ffffffffc0200a06:	d1650513          	addi	a0,a0,-746 # ffffffffc0204718 <commands+0xc0>
>>>>>>> 747620b (lab2)
ffffffffc0200a0a:	971ff0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0200a0e <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200a0e:	11853783          	ld	a5,280(a0)
ffffffffc0200a12:	0007c363          	bltz	a5,ffffffffc0200a18 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200a16:	bd25                	j	ffffffffc020084e <exception_handler>
        interrupt_handler(tf);
ffffffffc0200a18:	bb79                	j	ffffffffc02007b6 <interrupt_handler>
ffffffffc0200a1a:	0000                	unimp
ffffffffc0200a1c:	0000                	unimp
	...

ffffffffc0200a20 <__alltraps>:
    .endm

    .align 4
    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200a20:	14011073          	csrw	sscratch,sp
ffffffffc0200a24:	712d                	addi	sp,sp,-288
ffffffffc0200a26:	e406                	sd	ra,8(sp)
ffffffffc0200a28:	ec0e                	sd	gp,24(sp)
ffffffffc0200a2a:	f012                	sd	tp,32(sp)
ffffffffc0200a2c:	f416                	sd	t0,40(sp)
ffffffffc0200a2e:	f81a                	sd	t1,48(sp)
ffffffffc0200a30:	fc1e                	sd	t2,56(sp)
ffffffffc0200a32:	e0a2                	sd	s0,64(sp)
ffffffffc0200a34:	e4a6                	sd	s1,72(sp)
ffffffffc0200a36:	e8aa                	sd	a0,80(sp)
ffffffffc0200a38:	ecae                	sd	a1,88(sp)
ffffffffc0200a3a:	f0b2                	sd	a2,96(sp)
ffffffffc0200a3c:	f4b6                	sd	a3,104(sp)
ffffffffc0200a3e:	f8ba                	sd	a4,112(sp)
ffffffffc0200a40:	fcbe                	sd	a5,120(sp)
ffffffffc0200a42:	e142                	sd	a6,128(sp)
ffffffffc0200a44:	e546                	sd	a7,136(sp)
ffffffffc0200a46:	e94a                	sd	s2,144(sp)
ffffffffc0200a48:	ed4e                	sd	s3,152(sp)
ffffffffc0200a4a:	f152                	sd	s4,160(sp)
ffffffffc0200a4c:	f556                	sd	s5,168(sp)
ffffffffc0200a4e:	f95a                	sd	s6,176(sp)
ffffffffc0200a50:	fd5e                	sd	s7,184(sp)
ffffffffc0200a52:	e1e2                	sd	s8,192(sp)
ffffffffc0200a54:	e5e6                	sd	s9,200(sp)
ffffffffc0200a56:	e9ea                	sd	s10,208(sp)
ffffffffc0200a58:	edee                	sd	s11,216(sp)
ffffffffc0200a5a:	f1f2                	sd	t3,224(sp)
ffffffffc0200a5c:	f5f6                	sd	t4,232(sp)
ffffffffc0200a5e:	f9fa                	sd	t5,240(sp)
ffffffffc0200a60:	fdfe                	sd	t6,248(sp)
ffffffffc0200a62:	14002473          	csrr	s0,sscratch
ffffffffc0200a66:	100024f3          	csrr	s1,sstatus
ffffffffc0200a6a:	14102973          	csrr	s2,sepc
ffffffffc0200a6e:	143029f3          	csrr	s3,stval
ffffffffc0200a72:	14202a73          	csrr	s4,scause
ffffffffc0200a76:	e822                	sd	s0,16(sp)
ffffffffc0200a78:	e226                	sd	s1,256(sp)
ffffffffc0200a7a:	e64a                	sd	s2,264(sp)
ffffffffc0200a7c:	ea4e                	sd	s3,272(sp)
ffffffffc0200a7e:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200a80:	850a                	mv	a0,sp
    jal trap
ffffffffc0200a82:	f8dff0ef          	jal	ra,ffffffffc0200a0e <trap>

ffffffffc0200a86 <__trapret>:
    // sp should be the same as before "jal trap"
    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200a86:	6492                	ld	s1,256(sp)
ffffffffc0200a88:	6932                	ld	s2,264(sp)
ffffffffc0200a8a:	10049073          	csrw	sstatus,s1
ffffffffc0200a8e:	14191073          	csrw	sepc,s2
ffffffffc0200a92:	60a2                	ld	ra,8(sp)
ffffffffc0200a94:	61e2                	ld	gp,24(sp)
ffffffffc0200a96:	7202                	ld	tp,32(sp)
ffffffffc0200a98:	72a2                	ld	t0,40(sp)
ffffffffc0200a9a:	7342                	ld	t1,48(sp)
ffffffffc0200a9c:	73e2                	ld	t2,56(sp)
ffffffffc0200a9e:	6406                	ld	s0,64(sp)
ffffffffc0200aa0:	64a6                	ld	s1,72(sp)
ffffffffc0200aa2:	6546                	ld	a0,80(sp)
ffffffffc0200aa4:	65e6                	ld	a1,88(sp)
ffffffffc0200aa6:	7606                	ld	a2,96(sp)
ffffffffc0200aa8:	76a6                	ld	a3,104(sp)
ffffffffc0200aaa:	7746                	ld	a4,112(sp)
ffffffffc0200aac:	77e6                	ld	a5,120(sp)
ffffffffc0200aae:	680a                	ld	a6,128(sp)
ffffffffc0200ab0:	68aa                	ld	a7,136(sp)
ffffffffc0200ab2:	694a                	ld	s2,144(sp)
ffffffffc0200ab4:	69ea                	ld	s3,152(sp)
ffffffffc0200ab6:	7a0a                	ld	s4,160(sp)
ffffffffc0200ab8:	7aaa                	ld	s5,168(sp)
ffffffffc0200aba:	7b4a                	ld	s6,176(sp)
ffffffffc0200abc:	7bea                	ld	s7,184(sp)
ffffffffc0200abe:	6c0e                	ld	s8,192(sp)
ffffffffc0200ac0:	6cae                	ld	s9,200(sp)
ffffffffc0200ac2:	6d4e                	ld	s10,208(sp)
ffffffffc0200ac4:	6dee                	ld	s11,216(sp)
ffffffffc0200ac6:	7e0e                	ld	t3,224(sp)
ffffffffc0200ac8:	7eae                	ld	t4,232(sp)
ffffffffc0200aca:	7f4e                	ld	t5,240(sp)
ffffffffc0200acc:	7fee                	ld	t6,248(sp)
ffffffffc0200ace:	6142                	ld	sp,16(sp)
    // go back from supervisor call
    sret
ffffffffc0200ad0:	10200073          	sret
	...

ffffffffc0200ae0 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200ae0:	00010797          	auipc	a5,0x10
ffffffffc0200ae4:	56078793          	addi	a5,a5,1376 # ffffffffc0211040 <free_area>
ffffffffc0200ae8:	e79c                	sd	a5,8(a5)
ffffffffc0200aea:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200aec:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200af0:	8082                	ret

ffffffffc0200af2 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200af2:	00010517          	auipc	a0,0x10
ffffffffc0200af6:	55e56503          	lwu	a0,1374(a0) # ffffffffc0211050 <free_area+0x10>
ffffffffc0200afa:	8082                	ret

ffffffffc0200afc <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200afc:	715d                	addi	sp,sp,-80
ffffffffc0200afe:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b00:	00010417          	auipc	s0,0x10
ffffffffc0200b04:	54040413          	addi	s0,s0,1344 # ffffffffc0211040 <free_area>
ffffffffc0200b08:	641c                	ld	a5,8(s0)
ffffffffc0200b0a:	e486                	sd	ra,72(sp)
ffffffffc0200b0c:	fc26                	sd	s1,56(sp)
ffffffffc0200b0e:	f84a                	sd	s2,48(sp)
ffffffffc0200b10:	f44e                	sd	s3,40(sp)
ffffffffc0200b12:	f052                	sd	s4,32(sp)
ffffffffc0200b14:	ec56                	sd	s5,24(sp)
ffffffffc0200b16:	e85a                	sd	s6,16(sp)
ffffffffc0200b18:	e45e                	sd	s7,8(sp)
ffffffffc0200b1a:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b1c:	2c878763          	beq	a5,s0,ffffffffc0200dea <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0200b20:	4481                	li	s1,0
ffffffffc0200b22:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200b24:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200b28:	8b09                	andi	a4,a4,2
ffffffffc0200b2a:	2c070463          	beqz	a4,ffffffffc0200df2 <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0200b2e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200b32:	679c                	ld	a5,8(a5)
ffffffffc0200b34:	2905                	addiw	s2,s2,1
ffffffffc0200b36:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b38:	fe8796e3          	bne	a5,s0,ffffffffc0200b24 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200b3c:	89a6                	mv	s3,s1
ffffffffc0200b3e:	385000ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc0200b42:	71351863          	bne	a0,s3,ffffffffc0201252 <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200b46:	4505                	li	a0,1
ffffffffc0200b48:	2a9000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200b4c:	8a2a                	mv	s4,a0
ffffffffc0200b4e:	44050263          	beqz	a0,ffffffffc0200f92 <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200b52:	4505                	li	a0,1
ffffffffc0200b54:	29d000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200b58:	89aa                	mv	s3,a0
ffffffffc0200b5a:	70050c63          	beqz	a0,ffffffffc0201272 <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200b5e:	4505                	li	a0,1
ffffffffc0200b60:	291000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200b64:	8aaa                	mv	s5,a0
ffffffffc0200b66:	4a050663          	beqz	a0,ffffffffc0201012 <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200b6a:	2b3a0463          	beq	s4,s3,ffffffffc0200e12 <default_check+0x316>
ffffffffc0200b6e:	2aaa0263          	beq	s4,a0,ffffffffc0200e12 <default_check+0x316>
ffffffffc0200b72:	2aa98063          	beq	s3,a0,ffffffffc0200e12 <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200b76:	000a2783          	lw	a5,0(s4)
ffffffffc0200b7a:	2a079c63          	bnez	a5,ffffffffc0200e32 <default_check+0x336>
ffffffffc0200b7e:	0009a783          	lw	a5,0(s3)
ffffffffc0200b82:	2a079863          	bnez	a5,ffffffffc0200e32 <default_check+0x336>
ffffffffc0200b86:	411c                	lw	a5,0(a0)
ffffffffc0200b88:	2a079563          	bnez	a5,ffffffffc0200e32 <default_check+0x336>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200b8c:	00011797          	auipc	a5,0x11
ffffffffc0200b90:	99c7b783          	ld	a5,-1636(a5) # ffffffffc0211528 <pages>
ffffffffc0200b94:	40fa0733          	sub	a4,s4,a5
ffffffffc0200b98:	870d                	srai	a4,a4,0x3
ffffffffc0200b9a:	00005597          	auipc	a1,0x5
<<<<<<< HEAD
ffffffffc0200b9e:	6d65b583          	ld	a1,1750(a1) # ffffffffc0206270 <error_string+0x38>
ffffffffc0200ba2:	02b70733          	mul	a4,a4,a1
ffffffffc0200ba6:	00005617          	auipc	a2,0x5
ffffffffc0200baa:	6d263603          	ld	a2,1746(a2) # ffffffffc0206278 <nbase>
=======
ffffffffc0200b9e:	6ae5b583          	ld	a1,1710(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0200ba2:	02b70733          	mul	a4,a4,a1
ffffffffc0200ba6:	00005617          	auipc	a2,0x5
ffffffffc0200baa:	6aa63603          	ld	a2,1706(a2) # ffffffffc0206250 <nbase>
>>>>>>> 747620b (lab2)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200bae:	00011697          	auipc	a3,0x11
ffffffffc0200bb2:	9726b683          	ld	a3,-1678(a3) # ffffffffc0211520 <npage>
ffffffffc0200bb6:	06b2                	slli	a3,a3,0xc
ffffffffc0200bb8:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200bba:	0732                	slli	a4,a4,0xc
ffffffffc0200bbc:	28d77b63          	bgeu	a4,a3,ffffffffc0200e52 <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200bc0:	40f98733          	sub	a4,s3,a5
ffffffffc0200bc4:	870d                	srai	a4,a4,0x3
ffffffffc0200bc6:	02b70733          	mul	a4,a4,a1
ffffffffc0200bca:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200bcc:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200bce:	4cd77263          	bgeu	a4,a3,ffffffffc0201092 <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200bd2:	40f507b3          	sub	a5,a0,a5
ffffffffc0200bd6:	878d                	srai	a5,a5,0x3
ffffffffc0200bd8:	02b787b3          	mul	a5,a5,a1
ffffffffc0200bdc:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200bde:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200be0:	30d7f963          	bgeu	a5,a3,ffffffffc0200ef2 <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0200be4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200be6:	00043c03          	ld	s8,0(s0)
ffffffffc0200bea:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200bee:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200bf2:	e400                	sd	s0,8(s0)
ffffffffc0200bf4:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200bf6:	00010797          	auipc	a5,0x10
ffffffffc0200bfa:	4407ad23          	sw	zero,1114(a5) # ffffffffc0211050 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200bfe:	1f3000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c02:	2c051863          	bnez	a0,ffffffffc0200ed2 <default_check+0x3d6>
    free_page(p0);
ffffffffc0200c06:	4585                	li	a1,1
ffffffffc0200c08:	8552                	mv	a0,s4
ffffffffc0200c0a:	279000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_page(p1);
ffffffffc0200c0e:	4585                	li	a1,1
ffffffffc0200c10:	854e                	mv	a0,s3
ffffffffc0200c12:	271000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_page(p2);
ffffffffc0200c16:	4585                	li	a1,1
ffffffffc0200c18:	8556                	mv	a0,s5
ffffffffc0200c1a:	269000ef          	jal	ra,ffffffffc0201682 <free_pages>
    assert(nr_free == 3);
ffffffffc0200c1e:	4818                	lw	a4,16(s0)
ffffffffc0200c20:	478d                	li	a5,3
ffffffffc0200c22:	28f71863          	bne	a4,a5,ffffffffc0200eb2 <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c26:	4505                	li	a0,1
ffffffffc0200c28:	1c9000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c2c:	89aa                	mv	s3,a0
ffffffffc0200c2e:	26050263          	beqz	a0,ffffffffc0200e92 <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c32:	4505                	li	a0,1
ffffffffc0200c34:	1bd000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c38:	8aaa                	mv	s5,a0
ffffffffc0200c3a:	3a050c63          	beqz	a0,ffffffffc0200ff2 <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c3e:	4505                	li	a0,1
ffffffffc0200c40:	1b1000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c44:	8a2a                	mv	s4,a0
ffffffffc0200c46:	38050663          	beqz	a0,ffffffffc0200fd2 <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0200c4a:	4505                	li	a0,1
ffffffffc0200c4c:	1a5000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c50:	36051163          	bnez	a0,ffffffffc0200fb2 <default_check+0x4b6>
    free_page(p0);
ffffffffc0200c54:	4585                	li	a1,1
ffffffffc0200c56:	854e                	mv	a0,s3
ffffffffc0200c58:	22b000ef          	jal	ra,ffffffffc0201682 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200c5c:	641c                	ld	a5,8(s0)
ffffffffc0200c5e:	20878a63          	beq	a5,s0,ffffffffc0200e72 <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0200c62:	4505                	li	a0,1
ffffffffc0200c64:	18d000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c68:	30a99563          	bne	s3,a0,ffffffffc0200f72 <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0200c6c:	4505                	li	a0,1
ffffffffc0200c6e:	183000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200c72:	2e051063          	bnez	a0,ffffffffc0200f52 <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0200c76:	481c                	lw	a5,16(s0)
ffffffffc0200c78:	2a079d63          	bnez	a5,ffffffffc0200f32 <default_check+0x436>
    free_page(p);
ffffffffc0200c7c:	854e                	mv	a0,s3
ffffffffc0200c7e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200c80:	01843023          	sd	s8,0(s0)
ffffffffc0200c84:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200c88:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200c8c:	1f7000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_page(p1);
ffffffffc0200c90:	4585                	li	a1,1
ffffffffc0200c92:	8556                	mv	a0,s5
ffffffffc0200c94:	1ef000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_page(p2);
ffffffffc0200c98:	4585                	li	a1,1
ffffffffc0200c9a:	8552                	mv	a0,s4
ffffffffc0200c9c:	1e7000ef          	jal	ra,ffffffffc0201682 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200ca0:	4515                	li	a0,5
ffffffffc0200ca2:	14f000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200ca6:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200ca8:	26050563          	beqz	a0,ffffffffc0200f12 <default_check+0x416>
ffffffffc0200cac:	651c                	ld	a5,8(a0)
ffffffffc0200cae:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200cb0:	8b85                	andi	a5,a5,1
ffffffffc0200cb2:	54079063          	bnez	a5,ffffffffc02011f2 <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200cb6:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200cb8:	00043b03          	ld	s6,0(s0)
ffffffffc0200cbc:	00843a83          	ld	s5,8(s0)
ffffffffc0200cc0:	e000                	sd	s0,0(s0)
ffffffffc0200cc2:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200cc4:	12d000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200cc8:	50051563          	bnez	a0,ffffffffc02011d2 <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200ccc:	09098a13          	addi	s4,s3,144
ffffffffc0200cd0:	8552                	mv	a0,s4
ffffffffc0200cd2:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200cd4:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200cd8:	00010797          	auipc	a5,0x10
ffffffffc0200cdc:	3607ac23          	sw	zero,888(a5) # ffffffffc0211050 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200ce0:	1a3000ef          	jal	ra,ffffffffc0201682 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200ce4:	4511                	li	a0,4
ffffffffc0200ce6:	10b000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200cea:	4c051463          	bnez	a0,ffffffffc02011b2 <default_check+0x6b6>
ffffffffc0200cee:	0989b783          	ld	a5,152(s3)
ffffffffc0200cf2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200cf4:	8b85                	andi	a5,a5,1
ffffffffc0200cf6:	48078e63          	beqz	a5,ffffffffc0201192 <default_check+0x696>
ffffffffc0200cfa:	0a89a703          	lw	a4,168(s3)
ffffffffc0200cfe:	478d                	li	a5,3
ffffffffc0200d00:	48f71963          	bne	a4,a5,ffffffffc0201192 <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200d04:	450d                	li	a0,3
ffffffffc0200d06:	0eb000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d0a:	8c2a                	mv	s8,a0
ffffffffc0200d0c:	46050363          	beqz	a0,ffffffffc0201172 <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0200d10:	4505                	li	a0,1
ffffffffc0200d12:	0df000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d16:	42051e63          	bnez	a0,ffffffffc0201152 <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0200d1a:	418a1c63          	bne	s4,s8,ffffffffc0201132 <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200d1e:	4585                	li	a1,1
ffffffffc0200d20:	854e                	mv	a0,s3
ffffffffc0200d22:	161000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_pages(p1, 3);
ffffffffc0200d26:	458d                	li	a1,3
ffffffffc0200d28:	8552                	mv	a0,s4
ffffffffc0200d2a:	159000ef          	jal	ra,ffffffffc0201682 <free_pages>
ffffffffc0200d2e:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200d32:	04898c13          	addi	s8,s3,72
ffffffffc0200d36:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200d38:	8b85                	andi	a5,a5,1
ffffffffc0200d3a:	3c078c63          	beqz	a5,ffffffffc0201112 <default_check+0x616>
ffffffffc0200d3e:	0189a703          	lw	a4,24(s3)
ffffffffc0200d42:	4785                	li	a5,1
ffffffffc0200d44:	3cf71763          	bne	a4,a5,ffffffffc0201112 <default_check+0x616>
ffffffffc0200d48:	008a3783          	ld	a5,8(s4)
ffffffffc0200d4c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200d4e:	8b85                	andi	a5,a5,1
ffffffffc0200d50:	3a078163          	beqz	a5,ffffffffc02010f2 <default_check+0x5f6>
ffffffffc0200d54:	018a2703          	lw	a4,24(s4)
ffffffffc0200d58:	478d                	li	a5,3
ffffffffc0200d5a:	38f71c63          	bne	a4,a5,ffffffffc02010f2 <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200d5e:	4505                	li	a0,1
ffffffffc0200d60:	091000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d64:	36a99763          	bne	s3,a0,ffffffffc02010d2 <default_check+0x5d6>
    free_page(p0);
ffffffffc0200d68:	4585                	li	a1,1
ffffffffc0200d6a:	119000ef          	jal	ra,ffffffffc0201682 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200d6e:	4509                	li	a0,2
ffffffffc0200d70:	081000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d74:	32aa1f63          	bne	s4,a0,ffffffffc02010b2 <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0200d78:	4589                	li	a1,2
ffffffffc0200d7a:	109000ef          	jal	ra,ffffffffc0201682 <free_pages>
    free_page(p2);
ffffffffc0200d7e:	4585                	li	a1,1
ffffffffc0200d80:	8562                	mv	a0,s8
ffffffffc0200d82:	101000ef          	jal	ra,ffffffffc0201682 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200d86:	4515                	li	a0,5
ffffffffc0200d88:	069000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d8c:	89aa                	mv	s3,a0
ffffffffc0200d8e:	48050263          	beqz	a0,ffffffffc0201212 <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0200d92:	4505                	li	a0,1
ffffffffc0200d94:	05d000ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0200d98:	2c051d63          	bnez	a0,ffffffffc0201072 <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0200d9c:	481c                	lw	a5,16(s0)
ffffffffc0200d9e:	2a079a63          	bnez	a5,ffffffffc0201052 <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200da2:	4595                	li	a1,5
ffffffffc0200da4:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200da6:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200daa:	01643023          	sd	s6,0(s0)
ffffffffc0200dae:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200db2:	0d1000ef          	jal	ra,ffffffffc0201682 <free_pages>
    return listelm->next;
ffffffffc0200db6:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200db8:	00878963          	beq	a5,s0,ffffffffc0200dca <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200dbc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200dc0:	679c                	ld	a5,8(a5)
ffffffffc0200dc2:	397d                	addiw	s2,s2,-1
ffffffffc0200dc4:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200dc6:	fe879be3          	bne	a5,s0,ffffffffc0200dbc <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0200dca:	26091463          	bnez	s2,ffffffffc0201032 <default_check+0x536>
    assert(total == 0);
ffffffffc0200dce:	46049263          	bnez	s1,ffffffffc0201232 <default_check+0x736>
}
ffffffffc0200dd2:	60a6                	ld	ra,72(sp)
ffffffffc0200dd4:	6406                	ld	s0,64(sp)
ffffffffc0200dd6:	74e2                	ld	s1,56(sp)
ffffffffc0200dd8:	7942                	ld	s2,48(sp)
ffffffffc0200dda:	79a2                	ld	s3,40(sp)
ffffffffc0200ddc:	7a02                	ld	s4,32(sp)
ffffffffc0200dde:	6ae2                	ld	s5,24(sp)
ffffffffc0200de0:	6b42                	ld	s6,16(sp)
ffffffffc0200de2:	6ba2                	ld	s7,8(sp)
ffffffffc0200de4:	6c02                	ld	s8,0(sp)
ffffffffc0200de6:	6161                	addi	sp,sp,80
ffffffffc0200de8:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200dea:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200dec:	4481                	li	s1,0
ffffffffc0200dee:	4901                	li	s2,0
ffffffffc0200df0:	b3b9                	j	ffffffffc0200b3e <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0200df2:	00004697          	auipc	a3,0x4
<<<<<<< HEAD
ffffffffc0200df6:	fee68693          	addi	a3,a3,-18 # ffffffffc0204de0 <commands+0x770>
ffffffffc0200dfa:	00004617          	auipc	a2,0x4
ffffffffc0200dfe:	ff660613          	addi	a2,a2,-10 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200e02:	0f000593          	li	a1,240
ffffffffc0200e06:	00004517          	auipc	a0,0x4
ffffffffc0200e0a:	00250513          	addi	a0,a0,2 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200e0e:	d6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e12:	00004697          	auipc	a3,0x4
ffffffffc0200e16:	08e68693          	addi	a3,a3,142 # ffffffffc0204ea0 <commands+0x830>
ffffffffc0200e1a:	00004617          	auipc	a2,0x4
ffffffffc0200e1e:	fd660613          	addi	a2,a2,-42 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200e22:	0bd00593          	li	a1,189
ffffffffc0200e26:	00004517          	auipc	a0,0x4
ffffffffc0200e2a:	fe250513          	addi	a0,a0,-30 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200e2e:	d4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e32:	00004697          	auipc	a3,0x4
ffffffffc0200e36:	09668693          	addi	a3,a3,150 # ffffffffc0204ec8 <commands+0x858>
ffffffffc0200e3a:	00004617          	auipc	a2,0x4
ffffffffc0200e3e:	fb660613          	addi	a2,a2,-74 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200e42:	0be00593          	li	a1,190
ffffffffc0200e46:	00004517          	auipc	a0,0x4
ffffffffc0200e4a:	fc250513          	addi	a0,a0,-62 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200e4e:	d2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e52:	00004697          	auipc	a3,0x4
ffffffffc0200e56:	0b668693          	addi	a3,a3,182 # ffffffffc0204f08 <commands+0x898>
ffffffffc0200e5a:	00004617          	auipc	a2,0x4
ffffffffc0200e5e:	f9660613          	addi	a2,a2,-106 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200e62:	0c000593          	li	a1,192
ffffffffc0200e66:	00004517          	auipc	a0,0x4
ffffffffc0200e6a:	fa250513          	addi	a0,a0,-94 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200e6e:	d0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200e72:	00004697          	auipc	a3,0x4
ffffffffc0200e76:	11e68693          	addi	a3,a3,286 # ffffffffc0204f90 <commands+0x920>
ffffffffc0200e7a:	00004617          	auipc	a2,0x4
ffffffffc0200e7e:	f7660613          	addi	a2,a2,-138 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200e82:	0d900593          	li	a1,217
ffffffffc0200e86:	00004517          	auipc	a0,0x4
ffffffffc0200e8a:	f8250513          	addi	a0,a0,-126 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200e8e:	cecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e92:	00004697          	auipc	a3,0x4
ffffffffc0200e96:	fae68693          	addi	a3,a3,-82 # ffffffffc0204e40 <commands+0x7d0>
ffffffffc0200e9a:	00004617          	auipc	a2,0x4
ffffffffc0200e9e:	f5660613          	addi	a2,a2,-170 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200ea2:	0d200593          	li	a1,210
ffffffffc0200ea6:	00004517          	auipc	a0,0x4
ffffffffc0200eaa:	f6250513          	addi	a0,a0,-158 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200eae:	cccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 3);
ffffffffc0200eb2:	00004697          	auipc	a3,0x4
ffffffffc0200eb6:	0ce68693          	addi	a3,a3,206 # ffffffffc0204f80 <commands+0x910>
ffffffffc0200eba:	00004617          	auipc	a2,0x4
ffffffffc0200ebe:	f3660613          	addi	a2,a2,-202 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200ec2:	0d000593          	li	a1,208
ffffffffc0200ec6:	00004517          	auipc	a0,0x4
ffffffffc0200eca:	f4250513          	addi	a0,a0,-190 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200ece:	cacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200ed2:	00004697          	auipc	a3,0x4
ffffffffc0200ed6:	09668693          	addi	a3,a3,150 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc0200eda:	00004617          	auipc	a2,0x4
ffffffffc0200ede:	f1660613          	addi	a2,a2,-234 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200ee2:	0cb00593          	li	a1,203
ffffffffc0200ee6:	00004517          	auipc	a0,0x4
ffffffffc0200eea:	f2250513          	addi	a0,a0,-222 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200eee:	c8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200ef2:	00004697          	auipc	a3,0x4
ffffffffc0200ef6:	05668693          	addi	a3,a3,86 # ffffffffc0204f48 <commands+0x8d8>
ffffffffc0200efa:	00004617          	auipc	a2,0x4
ffffffffc0200efe:	ef660613          	addi	a2,a2,-266 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200f02:	0c200593          	li	a1,194
ffffffffc0200f06:	00004517          	auipc	a0,0x4
ffffffffc0200f0a:	f0250513          	addi	a0,a0,-254 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200f0e:	c6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 != NULL);
ffffffffc0200f12:	00004697          	auipc	a3,0x4
ffffffffc0200f16:	0c668693          	addi	a3,a3,198 # ffffffffc0204fd8 <commands+0x968>
ffffffffc0200f1a:	00004617          	auipc	a2,0x4
ffffffffc0200f1e:	ed660613          	addi	a2,a2,-298 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200f22:	0f800593          	li	a1,248
ffffffffc0200f26:	00004517          	auipc	a0,0x4
ffffffffc0200f2a:	ee250513          	addi	a0,a0,-286 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200f2e:	c4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 0);
ffffffffc0200f32:	00004697          	auipc	a3,0x4
ffffffffc0200f36:	09668693          	addi	a3,a3,150 # ffffffffc0204fc8 <commands+0x958>
ffffffffc0200f3a:	00004617          	auipc	a2,0x4
ffffffffc0200f3e:	eb660613          	addi	a2,a2,-330 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200f42:	0df00593          	li	a1,223
ffffffffc0200f46:	00004517          	auipc	a0,0x4
ffffffffc0200f4a:	ec250513          	addi	a0,a0,-318 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200f4e:	c2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f52:	00004697          	auipc	a3,0x4
ffffffffc0200f56:	01668693          	addi	a3,a3,22 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc0200f5a:	00004617          	auipc	a2,0x4
ffffffffc0200f5e:	e9660613          	addi	a2,a2,-362 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200f62:	0dd00593          	li	a1,221
ffffffffc0200f66:	00004517          	auipc	a0,0x4
ffffffffc0200f6a:	ea250513          	addi	a0,a0,-350 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200f6e:	c0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200f72:	00004697          	auipc	a3,0x4
ffffffffc0200f76:	03668693          	addi	a3,a3,54 # ffffffffc0204fa8 <commands+0x938>
ffffffffc0200f7a:	00004617          	auipc	a2,0x4
ffffffffc0200f7e:	e7660613          	addi	a2,a2,-394 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200f82:	0dc00593          	li	a1,220
ffffffffc0200f86:	00004517          	auipc	a0,0x4
ffffffffc0200f8a:	e8250513          	addi	a0,a0,-382 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200f8e:	becff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f92:	00004697          	auipc	a3,0x4
ffffffffc0200f96:	eae68693          	addi	a3,a3,-338 # ffffffffc0204e40 <commands+0x7d0>
ffffffffc0200f9a:	00004617          	auipc	a2,0x4
ffffffffc0200f9e:	e5660613          	addi	a2,a2,-426 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200fa2:	0b900593          	li	a1,185
ffffffffc0200fa6:	00004517          	auipc	a0,0x4
ffffffffc0200faa:	e6250513          	addi	a0,a0,-414 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200fae:	bccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fb2:	00004697          	auipc	a3,0x4
ffffffffc0200fb6:	fb668693          	addi	a3,a3,-74 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc0200fba:	00004617          	auipc	a2,0x4
ffffffffc0200fbe:	e3660613          	addi	a2,a2,-458 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200fc2:	0d600593          	li	a1,214
ffffffffc0200fc6:	00004517          	auipc	a0,0x4
ffffffffc0200fca:	e4250513          	addi	a0,a0,-446 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200fce:	bacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200fd2:	00004697          	auipc	a3,0x4
ffffffffc0200fd6:	eae68693          	addi	a3,a3,-338 # ffffffffc0204e80 <commands+0x810>
ffffffffc0200fda:	00004617          	auipc	a2,0x4
ffffffffc0200fde:	e1660613          	addi	a2,a2,-490 # ffffffffc0204df0 <commands+0x780>
ffffffffc0200fe2:	0d400593          	li	a1,212
ffffffffc0200fe6:	00004517          	auipc	a0,0x4
ffffffffc0200fea:	e2250513          	addi	a0,a0,-478 # ffffffffc0204e08 <commands+0x798>
ffffffffc0200fee:	b8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ff2:	00004697          	auipc	a3,0x4
ffffffffc0200ff6:	e6e68693          	addi	a3,a3,-402 # ffffffffc0204e60 <commands+0x7f0>
ffffffffc0200ffa:	00004617          	auipc	a2,0x4
ffffffffc0200ffe:	df660613          	addi	a2,a2,-522 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201002:	0d300593          	li	a1,211
ffffffffc0201006:	00004517          	auipc	a0,0x4
ffffffffc020100a:	e0250513          	addi	a0,a0,-510 # ffffffffc0204e08 <commands+0x798>
ffffffffc020100e:	b6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201012:	00004697          	auipc	a3,0x4
ffffffffc0201016:	e6e68693          	addi	a3,a3,-402 # ffffffffc0204e80 <commands+0x810>
ffffffffc020101a:	00004617          	auipc	a2,0x4
ffffffffc020101e:	dd660613          	addi	a2,a2,-554 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201022:	0bb00593          	li	a1,187
ffffffffc0201026:	00004517          	auipc	a0,0x4
ffffffffc020102a:	de250513          	addi	a0,a0,-542 # ffffffffc0204e08 <commands+0x798>
ffffffffc020102e:	b4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(count == 0);
ffffffffc0201032:	00004697          	auipc	a3,0x4
ffffffffc0201036:	0f668693          	addi	a3,a3,246 # ffffffffc0205128 <commands+0xab8>
ffffffffc020103a:	00004617          	auipc	a2,0x4
ffffffffc020103e:	db660613          	addi	a2,a2,-586 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201042:	12500593          	li	a1,293
ffffffffc0201046:	00004517          	auipc	a0,0x4
ffffffffc020104a:	dc250513          	addi	a0,a0,-574 # ffffffffc0204e08 <commands+0x798>
ffffffffc020104e:	b2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 0);
ffffffffc0201052:	00004697          	auipc	a3,0x4
ffffffffc0201056:	f7668693          	addi	a3,a3,-138 # ffffffffc0204fc8 <commands+0x958>
ffffffffc020105a:	00004617          	auipc	a2,0x4
ffffffffc020105e:	d9660613          	addi	a2,a2,-618 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201062:	11a00593          	li	a1,282
ffffffffc0201066:	00004517          	auipc	a0,0x4
ffffffffc020106a:	da250513          	addi	a0,a0,-606 # ffffffffc0204e08 <commands+0x798>
ffffffffc020106e:	b0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201072:	00004697          	auipc	a3,0x4
ffffffffc0201076:	ef668693          	addi	a3,a3,-266 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc020107a:	00004617          	auipc	a2,0x4
ffffffffc020107e:	d7660613          	addi	a2,a2,-650 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201082:	11800593          	li	a1,280
ffffffffc0201086:	00004517          	auipc	a0,0x4
ffffffffc020108a:	d8250513          	addi	a0,a0,-638 # ffffffffc0204e08 <commands+0x798>
ffffffffc020108e:	aecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201092:	00004697          	auipc	a3,0x4
ffffffffc0201096:	e9668693          	addi	a3,a3,-362 # ffffffffc0204f28 <commands+0x8b8>
ffffffffc020109a:	00004617          	auipc	a2,0x4
ffffffffc020109e:	d5660613          	addi	a2,a2,-682 # ffffffffc0204df0 <commands+0x780>
ffffffffc02010a2:	0c100593          	li	a1,193
ffffffffc02010a6:	00004517          	auipc	a0,0x4
ffffffffc02010aa:	d6250513          	addi	a0,a0,-670 # ffffffffc0204e08 <commands+0x798>
ffffffffc02010ae:	accff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02010b2:	00004697          	auipc	a3,0x4
ffffffffc02010b6:	03668693          	addi	a3,a3,54 # ffffffffc02050e8 <commands+0xa78>
ffffffffc02010ba:	00004617          	auipc	a2,0x4
ffffffffc02010be:	d3660613          	addi	a2,a2,-714 # ffffffffc0204df0 <commands+0x780>
ffffffffc02010c2:	11200593          	li	a1,274
ffffffffc02010c6:	00004517          	auipc	a0,0x4
ffffffffc02010ca:	d4250513          	addi	a0,a0,-702 # ffffffffc0204e08 <commands+0x798>
ffffffffc02010ce:	aacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02010d2:	00004697          	auipc	a3,0x4
ffffffffc02010d6:	ff668693          	addi	a3,a3,-10 # ffffffffc02050c8 <commands+0xa58>
ffffffffc02010da:	00004617          	auipc	a2,0x4
ffffffffc02010de:	d1660613          	addi	a2,a2,-746 # ffffffffc0204df0 <commands+0x780>
ffffffffc02010e2:	11000593          	li	a1,272
ffffffffc02010e6:	00004517          	auipc	a0,0x4
ffffffffc02010ea:	d2250513          	addi	a0,a0,-734 # ffffffffc0204e08 <commands+0x798>
ffffffffc02010ee:	a8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02010f2:	00004697          	auipc	a3,0x4
ffffffffc02010f6:	fae68693          	addi	a3,a3,-82 # ffffffffc02050a0 <commands+0xa30>
ffffffffc02010fa:	00004617          	auipc	a2,0x4
ffffffffc02010fe:	cf660613          	addi	a2,a2,-778 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201102:	10e00593          	li	a1,270
ffffffffc0201106:	00004517          	auipc	a0,0x4
ffffffffc020110a:	d0250513          	addi	a0,a0,-766 # ffffffffc0204e08 <commands+0x798>
ffffffffc020110e:	a6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201112:	00004697          	auipc	a3,0x4
ffffffffc0201116:	f6668693          	addi	a3,a3,-154 # ffffffffc0205078 <commands+0xa08>
ffffffffc020111a:	00004617          	auipc	a2,0x4
ffffffffc020111e:	cd660613          	addi	a2,a2,-810 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201122:	10d00593          	li	a1,269
ffffffffc0201126:	00004517          	auipc	a0,0x4
ffffffffc020112a:	ce250513          	addi	a0,a0,-798 # ffffffffc0204e08 <commands+0x798>
ffffffffc020112e:	a4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201132:	00004697          	auipc	a3,0x4
ffffffffc0201136:	f3668693          	addi	a3,a3,-202 # ffffffffc0205068 <commands+0x9f8>
ffffffffc020113a:	00004617          	auipc	a2,0x4
ffffffffc020113e:	cb660613          	addi	a2,a2,-842 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201142:	10800593          	li	a1,264
ffffffffc0201146:	00004517          	auipc	a0,0x4
ffffffffc020114a:	cc250513          	addi	a0,a0,-830 # ffffffffc0204e08 <commands+0x798>
ffffffffc020114e:	a2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201152:	00004697          	auipc	a3,0x4
ffffffffc0201156:	e1668693          	addi	a3,a3,-490 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc020115a:	00004617          	auipc	a2,0x4
ffffffffc020115e:	c9660613          	addi	a2,a2,-874 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201162:	10700593          	li	a1,263
ffffffffc0201166:	00004517          	auipc	a0,0x4
ffffffffc020116a:	ca250513          	addi	a0,a0,-862 # ffffffffc0204e08 <commands+0x798>
ffffffffc020116e:	a0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201172:	00004697          	auipc	a3,0x4
ffffffffc0201176:	ed668693          	addi	a3,a3,-298 # ffffffffc0205048 <commands+0x9d8>
ffffffffc020117a:	00004617          	auipc	a2,0x4
ffffffffc020117e:	c7660613          	addi	a2,a2,-906 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201182:	10600593          	li	a1,262
ffffffffc0201186:	00004517          	auipc	a0,0x4
ffffffffc020118a:	c8250513          	addi	a0,a0,-894 # ffffffffc0204e08 <commands+0x798>
ffffffffc020118e:	9ecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201192:	00004697          	auipc	a3,0x4
ffffffffc0201196:	e8668693          	addi	a3,a3,-378 # ffffffffc0205018 <commands+0x9a8>
ffffffffc020119a:	00004617          	auipc	a2,0x4
ffffffffc020119e:	c5660613          	addi	a2,a2,-938 # ffffffffc0204df0 <commands+0x780>
ffffffffc02011a2:	10500593          	li	a1,261
ffffffffc02011a6:	00004517          	auipc	a0,0x4
ffffffffc02011aa:	c6250513          	addi	a0,a0,-926 # ffffffffc0204e08 <commands+0x798>
ffffffffc02011ae:	9ccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02011b2:	00004697          	auipc	a3,0x4
ffffffffc02011b6:	e4e68693          	addi	a3,a3,-434 # ffffffffc0205000 <commands+0x990>
ffffffffc02011ba:	00004617          	auipc	a2,0x4
ffffffffc02011be:	c3660613          	addi	a2,a2,-970 # ffffffffc0204df0 <commands+0x780>
ffffffffc02011c2:	10400593          	li	a1,260
ffffffffc02011c6:	00004517          	auipc	a0,0x4
ffffffffc02011ca:	c4250513          	addi	a0,a0,-958 # ffffffffc0204e08 <commands+0x798>
ffffffffc02011ce:	9acff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011d2:	00004697          	auipc	a3,0x4
ffffffffc02011d6:	d9668693          	addi	a3,a3,-618 # ffffffffc0204f68 <commands+0x8f8>
ffffffffc02011da:	00004617          	auipc	a2,0x4
ffffffffc02011de:	c1660613          	addi	a2,a2,-1002 # ffffffffc0204df0 <commands+0x780>
ffffffffc02011e2:	0fe00593          	li	a1,254
ffffffffc02011e6:	00004517          	auipc	a0,0x4
ffffffffc02011ea:	c2250513          	addi	a0,a0,-990 # ffffffffc0204e08 <commands+0x798>
ffffffffc02011ee:	98cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(!PageProperty(p0));
ffffffffc02011f2:	00004697          	auipc	a3,0x4
ffffffffc02011f6:	df668693          	addi	a3,a3,-522 # ffffffffc0204fe8 <commands+0x978>
ffffffffc02011fa:	00004617          	auipc	a2,0x4
ffffffffc02011fe:	bf660613          	addi	a2,a2,-1034 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201202:	0f900593          	li	a1,249
ffffffffc0201206:	00004517          	auipc	a0,0x4
ffffffffc020120a:	c0250513          	addi	a0,a0,-1022 # ffffffffc0204e08 <commands+0x798>
ffffffffc020120e:	96cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201212:	00004697          	auipc	a3,0x4
ffffffffc0201216:	ef668693          	addi	a3,a3,-266 # ffffffffc0205108 <commands+0xa98>
ffffffffc020121a:	00004617          	auipc	a2,0x4
ffffffffc020121e:	bd660613          	addi	a2,a2,-1066 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201222:	11700593          	li	a1,279
ffffffffc0201226:	00004517          	auipc	a0,0x4
ffffffffc020122a:	be250513          	addi	a0,a0,-1054 # ffffffffc0204e08 <commands+0x798>
ffffffffc020122e:	94cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(total == 0);
ffffffffc0201232:	00004697          	auipc	a3,0x4
ffffffffc0201236:	f0668693          	addi	a3,a3,-250 # ffffffffc0205138 <commands+0xac8>
ffffffffc020123a:	00004617          	auipc	a2,0x4
ffffffffc020123e:	bb660613          	addi	a2,a2,-1098 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201242:	12600593          	li	a1,294
ffffffffc0201246:	00004517          	auipc	a0,0x4
ffffffffc020124a:	bc250513          	addi	a0,a0,-1086 # ffffffffc0204e08 <commands+0x798>
ffffffffc020124e:	92cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201252:	00004697          	auipc	a3,0x4
ffffffffc0201256:	bce68693          	addi	a3,a3,-1074 # ffffffffc0204e20 <commands+0x7b0>
ffffffffc020125a:	00004617          	auipc	a2,0x4
ffffffffc020125e:	b9660613          	addi	a2,a2,-1130 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201262:	0f300593          	li	a1,243
ffffffffc0201266:	00004517          	auipc	a0,0x4
ffffffffc020126a:	ba250513          	addi	a0,a0,-1118 # ffffffffc0204e08 <commands+0x798>
ffffffffc020126e:	90cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201272:	00004697          	auipc	a3,0x4
ffffffffc0201276:	bee68693          	addi	a3,a3,-1042 # ffffffffc0204e60 <commands+0x7f0>
ffffffffc020127a:	00004617          	auipc	a2,0x4
ffffffffc020127e:	b7660613          	addi	a2,a2,-1162 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201282:	0ba00593          	li	a1,186
ffffffffc0201286:	00004517          	auipc	a0,0x4
ffffffffc020128a:	b8250513          	addi	a0,a0,-1150 # ffffffffc0204e08 <commands+0x798>
=======
ffffffffc0200df6:	fd668693          	addi	a3,a3,-42 # ffffffffc0204dc8 <commands+0x770>
ffffffffc0200dfa:	00004617          	auipc	a2,0x4
ffffffffc0200dfe:	fde60613          	addi	a2,a2,-34 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200e02:	0f000593          	li	a1,240
ffffffffc0200e06:	00004517          	auipc	a0,0x4
ffffffffc0200e0a:	fea50513          	addi	a0,a0,-22 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200e0e:	d6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e12:	00004697          	auipc	a3,0x4
ffffffffc0200e16:	07668693          	addi	a3,a3,118 # ffffffffc0204e88 <commands+0x830>
ffffffffc0200e1a:	00004617          	auipc	a2,0x4
ffffffffc0200e1e:	fbe60613          	addi	a2,a2,-66 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200e22:	0bd00593          	li	a1,189
ffffffffc0200e26:	00004517          	auipc	a0,0x4
ffffffffc0200e2a:	fca50513          	addi	a0,a0,-54 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200e2e:	d4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e32:	00004697          	auipc	a3,0x4
ffffffffc0200e36:	07e68693          	addi	a3,a3,126 # ffffffffc0204eb0 <commands+0x858>
ffffffffc0200e3a:	00004617          	auipc	a2,0x4
ffffffffc0200e3e:	f9e60613          	addi	a2,a2,-98 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200e42:	0be00593          	li	a1,190
ffffffffc0200e46:	00004517          	auipc	a0,0x4
ffffffffc0200e4a:	faa50513          	addi	a0,a0,-86 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200e4e:	d2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e52:	00004697          	auipc	a3,0x4
ffffffffc0200e56:	09e68693          	addi	a3,a3,158 # ffffffffc0204ef0 <commands+0x898>
ffffffffc0200e5a:	00004617          	auipc	a2,0x4
ffffffffc0200e5e:	f7e60613          	addi	a2,a2,-130 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200e62:	0c000593          	li	a1,192
ffffffffc0200e66:	00004517          	auipc	a0,0x4
ffffffffc0200e6a:	f8a50513          	addi	a0,a0,-118 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200e6e:	d0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200e72:	00004697          	auipc	a3,0x4
ffffffffc0200e76:	10668693          	addi	a3,a3,262 # ffffffffc0204f78 <commands+0x920>
ffffffffc0200e7a:	00004617          	auipc	a2,0x4
ffffffffc0200e7e:	f5e60613          	addi	a2,a2,-162 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200e82:	0d900593          	li	a1,217
ffffffffc0200e86:	00004517          	auipc	a0,0x4
ffffffffc0200e8a:	f6a50513          	addi	a0,a0,-150 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200e8e:	cecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e92:	00004697          	auipc	a3,0x4
ffffffffc0200e96:	f9668693          	addi	a3,a3,-106 # ffffffffc0204e28 <commands+0x7d0>
ffffffffc0200e9a:	00004617          	auipc	a2,0x4
ffffffffc0200e9e:	f3e60613          	addi	a2,a2,-194 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200ea2:	0d200593          	li	a1,210
ffffffffc0200ea6:	00004517          	auipc	a0,0x4
ffffffffc0200eaa:	f4a50513          	addi	a0,a0,-182 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200eae:	cccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 3);
ffffffffc0200eb2:	00004697          	auipc	a3,0x4
ffffffffc0200eb6:	0b668693          	addi	a3,a3,182 # ffffffffc0204f68 <commands+0x910>
ffffffffc0200eba:	00004617          	auipc	a2,0x4
ffffffffc0200ebe:	f1e60613          	addi	a2,a2,-226 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200ec2:	0d000593          	li	a1,208
ffffffffc0200ec6:	00004517          	auipc	a0,0x4
ffffffffc0200eca:	f2a50513          	addi	a0,a0,-214 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200ece:	cacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200ed2:	00004697          	auipc	a3,0x4
ffffffffc0200ed6:	07e68693          	addi	a3,a3,126 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc0200eda:	00004617          	auipc	a2,0x4
ffffffffc0200ede:	efe60613          	addi	a2,a2,-258 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200ee2:	0cb00593          	li	a1,203
ffffffffc0200ee6:	00004517          	auipc	a0,0x4
ffffffffc0200eea:	f0a50513          	addi	a0,a0,-246 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200eee:	c8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200ef2:	00004697          	auipc	a3,0x4
ffffffffc0200ef6:	03e68693          	addi	a3,a3,62 # ffffffffc0204f30 <commands+0x8d8>
ffffffffc0200efa:	00004617          	auipc	a2,0x4
ffffffffc0200efe:	ede60613          	addi	a2,a2,-290 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200f02:	0c200593          	li	a1,194
ffffffffc0200f06:	00004517          	auipc	a0,0x4
ffffffffc0200f0a:	eea50513          	addi	a0,a0,-278 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200f0e:	c6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 != NULL);
ffffffffc0200f12:	00004697          	auipc	a3,0x4
ffffffffc0200f16:	0ae68693          	addi	a3,a3,174 # ffffffffc0204fc0 <commands+0x968>
ffffffffc0200f1a:	00004617          	auipc	a2,0x4
ffffffffc0200f1e:	ebe60613          	addi	a2,a2,-322 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200f22:	0f800593          	li	a1,248
ffffffffc0200f26:	00004517          	auipc	a0,0x4
ffffffffc0200f2a:	eca50513          	addi	a0,a0,-310 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200f2e:	c4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 0);
ffffffffc0200f32:	00004697          	auipc	a3,0x4
ffffffffc0200f36:	07e68693          	addi	a3,a3,126 # ffffffffc0204fb0 <commands+0x958>
ffffffffc0200f3a:	00004617          	auipc	a2,0x4
ffffffffc0200f3e:	e9e60613          	addi	a2,a2,-354 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200f42:	0df00593          	li	a1,223
ffffffffc0200f46:	00004517          	auipc	a0,0x4
ffffffffc0200f4a:	eaa50513          	addi	a0,a0,-342 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200f4e:	c2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f52:	00004697          	auipc	a3,0x4
ffffffffc0200f56:	ffe68693          	addi	a3,a3,-2 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc0200f5a:	00004617          	auipc	a2,0x4
ffffffffc0200f5e:	e7e60613          	addi	a2,a2,-386 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200f62:	0dd00593          	li	a1,221
ffffffffc0200f66:	00004517          	auipc	a0,0x4
ffffffffc0200f6a:	e8a50513          	addi	a0,a0,-374 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200f6e:	c0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200f72:	00004697          	auipc	a3,0x4
ffffffffc0200f76:	01e68693          	addi	a3,a3,30 # ffffffffc0204f90 <commands+0x938>
ffffffffc0200f7a:	00004617          	auipc	a2,0x4
ffffffffc0200f7e:	e5e60613          	addi	a2,a2,-418 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200f82:	0dc00593          	li	a1,220
ffffffffc0200f86:	00004517          	auipc	a0,0x4
ffffffffc0200f8a:	e6a50513          	addi	a0,a0,-406 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200f8e:	becff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f92:	00004697          	auipc	a3,0x4
ffffffffc0200f96:	e9668693          	addi	a3,a3,-362 # ffffffffc0204e28 <commands+0x7d0>
ffffffffc0200f9a:	00004617          	auipc	a2,0x4
ffffffffc0200f9e:	e3e60613          	addi	a2,a2,-450 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200fa2:	0b900593          	li	a1,185
ffffffffc0200fa6:	00004517          	auipc	a0,0x4
ffffffffc0200faa:	e4a50513          	addi	a0,a0,-438 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200fae:	bccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fb2:	00004697          	auipc	a3,0x4
ffffffffc0200fb6:	f9e68693          	addi	a3,a3,-98 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc0200fba:	00004617          	auipc	a2,0x4
ffffffffc0200fbe:	e1e60613          	addi	a2,a2,-482 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200fc2:	0d600593          	li	a1,214
ffffffffc0200fc6:	00004517          	auipc	a0,0x4
ffffffffc0200fca:	e2a50513          	addi	a0,a0,-470 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200fce:	bacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200fd2:	00004697          	auipc	a3,0x4
ffffffffc0200fd6:	e9668693          	addi	a3,a3,-362 # ffffffffc0204e68 <commands+0x810>
ffffffffc0200fda:	00004617          	auipc	a2,0x4
ffffffffc0200fde:	dfe60613          	addi	a2,a2,-514 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0200fe2:	0d400593          	li	a1,212
ffffffffc0200fe6:	00004517          	auipc	a0,0x4
ffffffffc0200fea:	e0a50513          	addi	a0,a0,-502 # ffffffffc0204df0 <commands+0x798>
ffffffffc0200fee:	b8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ff2:	00004697          	auipc	a3,0x4
ffffffffc0200ff6:	e5668693          	addi	a3,a3,-426 # ffffffffc0204e48 <commands+0x7f0>
ffffffffc0200ffa:	00004617          	auipc	a2,0x4
ffffffffc0200ffe:	dde60613          	addi	a2,a2,-546 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201002:	0d300593          	li	a1,211
ffffffffc0201006:	00004517          	auipc	a0,0x4
ffffffffc020100a:	dea50513          	addi	a0,a0,-534 # ffffffffc0204df0 <commands+0x798>
ffffffffc020100e:	b6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201012:	00004697          	auipc	a3,0x4
ffffffffc0201016:	e5668693          	addi	a3,a3,-426 # ffffffffc0204e68 <commands+0x810>
ffffffffc020101a:	00004617          	auipc	a2,0x4
ffffffffc020101e:	dbe60613          	addi	a2,a2,-578 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201022:	0bb00593          	li	a1,187
ffffffffc0201026:	00004517          	auipc	a0,0x4
ffffffffc020102a:	dca50513          	addi	a0,a0,-566 # ffffffffc0204df0 <commands+0x798>
ffffffffc020102e:	b4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(count == 0);
ffffffffc0201032:	00004697          	auipc	a3,0x4
ffffffffc0201036:	0de68693          	addi	a3,a3,222 # ffffffffc0205110 <commands+0xab8>
ffffffffc020103a:	00004617          	auipc	a2,0x4
ffffffffc020103e:	d9e60613          	addi	a2,a2,-610 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201042:	12500593          	li	a1,293
ffffffffc0201046:	00004517          	auipc	a0,0x4
ffffffffc020104a:	daa50513          	addi	a0,a0,-598 # ffffffffc0204df0 <commands+0x798>
ffffffffc020104e:	b2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free == 0);
ffffffffc0201052:	00004697          	auipc	a3,0x4
ffffffffc0201056:	f5e68693          	addi	a3,a3,-162 # ffffffffc0204fb0 <commands+0x958>
ffffffffc020105a:	00004617          	auipc	a2,0x4
ffffffffc020105e:	d7e60613          	addi	a2,a2,-642 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201062:	11a00593          	li	a1,282
ffffffffc0201066:	00004517          	auipc	a0,0x4
ffffffffc020106a:	d8a50513          	addi	a0,a0,-630 # ffffffffc0204df0 <commands+0x798>
ffffffffc020106e:	b0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201072:	00004697          	auipc	a3,0x4
ffffffffc0201076:	ede68693          	addi	a3,a3,-290 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc020107a:	00004617          	auipc	a2,0x4
ffffffffc020107e:	d5e60613          	addi	a2,a2,-674 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201082:	11800593          	li	a1,280
ffffffffc0201086:	00004517          	auipc	a0,0x4
ffffffffc020108a:	d6a50513          	addi	a0,a0,-662 # ffffffffc0204df0 <commands+0x798>
ffffffffc020108e:	aecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201092:	00004697          	auipc	a3,0x4
ffffffffc0201096:	e7e68693          	addi	a3,a3,-386 # ffffffffc0204f10 <commands+0x8b8>
ffffffffc020109a:	00004617          	auipc	a2,0x4
ffffffffc020109e:	d3e60613          	addi	a2,a2,-706 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02010a2:	0c100593          	li	a1,193
ffffffffc02010a6:	00004517          	auipc	a0,0x4
ffffffffc02010aa:	d4a50513          	addi	a0,a0,-694 # ffffffffc0204df0 <commands+0x798>
ffffffffc02010ae:	accff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02010b2:	00004697          	auipc	a3,0x4
ffffffffc02010b6:	01e68693          	addi	a3,a3,30 # ffffffffc02050d0 <commands+0xa78>
ffffffffc02010ba:	00004617          	auipc	a2,0x4
ffffffffc02010be:	d1e60613          	addi	a2,a2,-738 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02010c2:	11200593          	li	a1,274
ffffffffc02010c6:	00004517          	auipc	a0,0x4
ffffffffc02010ca:	d2a50513          	addi	a0,a0,-726 # ffffffffc0204df0 <commands+0x798>
ffffffffc02010ce:	aacff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02010d2:	00004697          	auipc	a3,0x4
ffffffffc02010d6:	fde68693          	addi	a3,a3,-34 # ffffffffc02050b0 <commands+0xa58>
ffffffffc02010da:	00004617          	auipc	a2,0x4
ffffffffc02010de:	cfe60613          	addi	a2,a2,-770 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02010e2:	11000593          	li	a1,272
ffffffffc02010e6:	00004517          	auipc	a0,0x4
ffffffffc02010ea:	d0a50513          	addi	a0,a0,-758 # ffffffffc0204df0 <commands+0x798>
ffffffffc02010ee:	a8cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02010f2:	00004697          	auipc	a3,0x4
ffffffffc02010f6:	f9668693          	addi	a3,a3,-106 # ffffffffc0205088 <commands+0xa30>
ffffffffc02010fa:	00004617          	auipc	a2,0x4
ffffffffc02010fe:	cde60613          	addi	a2,a2,-802 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201102:	10e00593          	li	a1,270
ffffffffc0201106:	00004517          	auipc	a0,0x4
ffffffffc020110a:	cea50513          	addi	a0,a0,-790 # ffffffffc0204df0 <commands+0x798>
ffffffffc020110e:	a6cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201112:	00004697          	auipc	a3,0x4
ffffffffc0201116:	f4e68693          	addi	a3,a3,-178 # ffffffffc0205060 <commands+0xa08>
ffffffffc020111a:	00004617          	auipc	a2,0x4
ffffffffc020111e:	cbe60613          	addi	a2,a2,-834 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201122:	10d00593          	li	a1,269
ffffffffc0201126:	00004517          	auipc	a0,0x4
ffffffffc020112a:	cca50513          	addi	a0,a0,-822 # ffffffffc0204df0 <commands+0x798>
ffffffffc020112e:	a4cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201132:	00004697          	auipc	a3,0x4
ffffffffc0201136:	f1e68693          	addi	a3,a3,-226 # ffffffffc0205050 <commands+0x9f8>
ffffffffc020113a:	00004617          	auipc	a2,0x4
ffffffffc020113e:	c9e60613          	addi	a2,a2,-866 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201142:	10800593          	li	a1,264
ffffffffc0201146:	00004517          	auipc	a0,0x4
ffffffffc020114a:	caa50513          	addi	a0,a0,-854 # ffffffffc0204df0 <commands+0x798>
ffffffffc020114e:	a2cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201152:	00004697          	auipc	a3,0x4
ffffffffc0201156:	dfe68693          	addi	a3,a3,-514 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc020115a:	00004617          	auipc	a2,0x4
ffffffffc020115e:	c7e60613          	addi	a2,a2,-898 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201162:	10700593          	li	a1,263
ffffffffc0201166:	00004517          	auipc	a0,0x4
ffffffffc020116a:	c8a50513          	addi	a0,a0,-886 # ffffffffc0204df0 <commands+0x798>
ffffffffc020116e:	a0cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201172:	00004697          	auipc	a3,0x4
ffffffffc0201176:	ebe68693          	addi	a3,a3,-322 # ffffffffc0205030 <commands+0x9d8>
ffffffffc020117a:	00004617          	auipc	a2,0x4
ffffffffc020117e:	c5e60613          	addi	a2,a2,-930 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201182:	10600593          	li	a1,262
ffffffffc0201186:	00004517          	auipc	a0,0x4
ffffffffc020118a:	c6a50513          	addi	a0,a0,-918 # ffffffffc0204df0 <commands+0x798>
ffffffffc020118e:	9ecff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201192:	00004697          	auipc	a3,0x4
ffffffffc0201196:	e6e68693          	addi	a3,a3,-402 # ffffffffc0205000 <commands+0x9a8>
ffffffffc020119a:	00004617          	auipc	a2,0x4
ffffffffc020119e:	c3e60613          	addi	a2,a2,-962 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02011a2:	10500593          	li	a1,261
ffffffffc02011a6:	00004517          	auipc	a0,0x4
ffffffffc02011aa:	c4a50513          	addi	a0,a0,-950 # ffffffffc0204df0 <commands+0x798>
ffffffffc02011ae:	9ccff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02011b2:	00004697          	auipc	a3,0x4
ffffffffc02011b6:	e3668693          	addi	a3,a3,-458 # ffffffffc0204fe8 <commands+0x990>
ffffffffc02011ba:	00004617          	auipc	a2,0x4
ffffffffc02011be:	c1e60613          	addi	a2,a2,-994 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02011c2:	10400593          	li	a1,260
ffffffffc02011c6:	00004517          	auipc	a0,0x4
ffffffffc02011ca:	c2a50513          	addi	a0,a0,-982 # ffffffffc0204df0 <commands+0x798>
ffffffffc02011ce:	9acff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011d2:	00004697          	auipc	a3,0x4
ffffffffc02011d6:	d7e68693          	addi	a3,a3,-642 # ffffffffc0204f50 <commands+0x8f8>
ffffffffc02011da:	00004617          	auipc	a2,0x4
ffffffffc02011de:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02011e2:	0fe00593          	li	a1,254
ffffffffc02011e6:	00004517          	auipc	a0,0x4
ffffffffc02011ea:	c0a50513          	addi	a0,a0,-1014 # ffffffffc0204df0 <commands+0x798>
ffffffffc02011ee:	98cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(!PageProperty(p0));
ffffffffc02011f2:	00004697          	auipc	a3,0x4
ffffffffc02011f6:	dde68693          	addi	a3,a3,-546 # ffffffffc0204fd0 <commands+0x978>
ffffffffc02011fa:	00004617          	auipc	a2,0x4
ffffffffc02011fe:	bde60613          	addi	a2,a2,-1058 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201202:	0f900593          	li	a1,249
ffffffffc0201206:	00004517          	auipc	a0,0x4
ffffffffc020120a:	bea50513          	addi	a0,a0,-1046 # ffffffffc0204df0 <commands+0x798>
ffffffffc020120e:	96cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201212:	00004697          	auipc	a3,0x4
ffffffffc0201216:	ede68693          	addi	a3,a3,-290 # ffffffffc02050f0 <commands+0xa98>
ffffffffc020121a:	00004617          	auipc	a2,0x4
ffffffffc020121e:	bbe60613          	addi	a2,a2,-1090 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201222:	11700593          	li	a1,279
ffffffffc0201226:	00004517          	auipc	a0,0x4
ffffffffc020122a:	bca50513          	addi	a0,a0,-1078 # ffffffffc0204df0 <commands+0x798>
ffffffffc020122e:	94cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(total == 0);
ffffffffc0201232:	00004697          	auipc	a3,0x4
ffffffffc0201236:	eee68693          	addi	a3,a3,-274 # ffffffffc0205120 <commands+0xac8>
ffffffffc020123a:	00004617          	auipc	a2,0x4
ffffffffc020123e:	b9e60613          	addi	a2,a2,-1122 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201242:	12600593          	li	a1,294
ffffffffc0201246:	00004517          	auipc	a0,0x4
ffffffffc020124a:	baa50513          	addi	a0,a0,-1110 # ffffffffc0204df0 <commands+0x798>
ffffffffc020124e:	92cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201252:	00004697          	auipc	a3,0x4
ffffffffc0201256:	bb668693          	addi	a3,a3,-1098 # ffffffffc0204e08 <commands+0x7b0>
ffffffffc020125a:	00004617          	auipc	a2,0x4
ffffffffc020125e:	b7e60613          	addi	a2,a2,-1154 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201262:	0f300593          	li	a1,243
ffffffffc0201266:	00004517          	auipc	a0,0x4
ffffffffc020126a:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0204df0 <commands+0x798>
ffffffffc020126e:	90cff0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201272:	00004697          	auipc	a3,0x4
ffffffffc0201276:	bd668693          	addi	a3,a3,-1066 # ffffffffc0204e48 <commands+0x7f0>
ffffffffc020127a:	00004617          	auipc	a2,0x4
ffffffffc020127e:	b5e60613          	addi	a2,a2,-1186 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201282:	0ba00593          	li	a1,186
ffffffffc0201286:	00004517          	auipc	a0,0x4
ffffffffc020128a:	b6a50513          	addi	a0,a0,-1174 # ffffffffc0204df0 <commands+0x798>
>>>>>>> 747620b (lab2)
ffffffffc020128e:	8ecff0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0201292 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201292:	1141                	addi	sp,sp,-16
ffffffffc0201294:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201296:	14058a63          	beqz	a1,ffffffffc02013ea <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020129a:	00359693          	slli	a3,a1,0x3
ffffffffc020129e:	96ae                	add	a3,a3,a1
ffffffffc02012a0:	068e                	slli	a3,a3,0x3
ffffffffc02012a2:	96aa                	add	a3,a3,a0
ffffffffc02012a4:	87aa                	mv	a5,a0
ffffffffc02012a6:	02d50263          	beq	a0,a3,ffffffffc02012ca <default_free_pages+0x38>
ffffffffc02012aa:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02012ac:	8b05                	andi	a4,a4,1
ffffffffc02012ae:	10071e63          	bnez	a4,ffffffffc02013ca <default_free_pages+0x138>
ffffffffc02012b2:	6798                	ld	a4,8(a5)
ffffffffc02012b4:	8b09                	andi	a4,a4,2
ffffffffc02012b6:	10071a63          	bnez	a4,ffffffffc02013ca <default_free_pages+0x138>
        p->flags = 0;
ffffffffc02012ba:	0007b423          	sd	zero,8(a5)
    return pa2page(PDE_ADDR(pde));
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02012be:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02012c2:	04878793          	addi	a5,a5,72
ffffffffc02012c6:	fed792e3          	bne	a5,a3,ffffffffc02012aa <default_free_pages+0x18>
    base->property = n;
ffffffffc02012ca:	2581                	sext.w	a1,a1
ffffffffc02012cc:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc02012ce:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02012d2:	4789                	li	a5,2
ffffffffc02012d4:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02012d8:	00010697          	auipc	a3,0x10
ffffffffc02012dc:	d6868693          	addi	a3,a3,-664 # ffffffffc0211040 <free_area>
ffffffffc02012e0:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02012e2:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02012e4:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02012e8:	9db9                	addw	a1,a1,a4
ffffffffc02012ea:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02012ec:	0ad78863          	beq	a5,a3,ffffffffc020139c <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02012f0:	fe078713          	addi	a4,a5,-32
ffffffffc02012f4:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02012f8:	4581                	li	a1,0
            if (base < page) {
ffffffffc02012fa:	00e56a63          	bltu	a0,a4,ffffffffc020130e <default_free_pages+0x7c>
    return listelm->next;
ffffffffc02012fe:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201300:	06d70263          	beq	a4,a3,ffffffffc0201364 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0201304:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201306:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc020130a:	fee57ae3          	bgeu	a0,a4,ffffffffc02012fe <default_free_pages+0x6c>
ffffffffc020130e:	c199                	beqz	a1,ffffffffc0201314 <default_free_pages+0x82>
ffffffffc0201310:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201314:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201316:	e390                	sd	a2,0(a5)
ffffffffc0201318:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020131a:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020131c:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc020131e:	02d70063          	beq	a4,a3,ffffffffc020133e <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201322:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201326:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc020132a:	02081613          	slli	a2,a6,0x20
ffffffffc020132e:	9201                	srli	a2,a2,0x20
ffffffffc0201330:	00361793          	slli	a5,a2,0x3
ffffffffc0201334:	97b2                	add	a5,a5,a2
ffffffffc0201336:	078e                	slli	a5,a5,0x3
ffffffffc0201338:	97ae                	add	a5,a5,a1
ffffffffc020133a:	02f50f63          	beq	a0,a5,ffffffffc0201378 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc020133e:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc0201340:	00d70f63          	beq	a4,a3,ffffffffc020135e <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0201344:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc0201346:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc020134a:	02059613          	slli	a2,a1,0x20
ffffffffc020134e:	9201                	srli	a2,a2,0x20
ffffffffc0201350:	00361793          	slli	a5,a2,0x3
ffffffffc0201354:	97b2                	add	a5,a5,a2
ffffffffc0201356:	078e                	slli	a5,a5,0x3
ffffffffc0201358:	97aa                	add	a5,a5,a0
ffffffffc020135a:	04f68863          	beq	a3,a5,ffffffffc02013aa <default_free_pages+0x118>
}
ffffffffc020135e:	60a2                	ld	ra,8(sp)
ffffffffc0201360:	0141                	addi	sp,sp,16
ffffffffc0201362:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201364:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201366:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc0201368:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020136a:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020136c:	02d70563          	beq	a4,a3,ffffffffc0201396 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201370:	8832                	mv	a6,a2
ffffffffc0201372:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201374:	87ba                	mv	a5,a4
ffffffffc0201376:	bf41                	j	ffffffffc0201306 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc0201378:	4d1c                	lw	a5,24(a0)
ffffffffc020137a:	0107883b          	addw	a6,a5,a6
ffffffffc020137e:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201382:	57f5                	li	a5,-3
ffffffffc0201384:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201388:	7110                	ld	a2,32(a0)
ffffffffc020138a:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc020138c:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020138e:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201390:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201392:	e390                	sd	a2,0(a5)
ffffffffc0201394:	b775                	j	ffffffffc0201340 <default_free_pages+0xae>
ffffffffc0201396:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201398:	873e                	mv	a4,a5
ffffffffc020139a:	b761                	j	ffffffffc0201322 <default_free_pages+0x90>
}
ffffffffc020139c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020139e:	e390                	sd	a2,0(a5)
ffffffffc02013a0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013a2:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02013a4:	f11c                	sd	a5,32(a0)
ffffffffc02013a6:	0141                	addi	sp,sp,16
ffffffffc02013a8:	8082                	ret
            base->property += p->property;
ffffffffc02013aa:	ff872783          	lw	a5,-8(a4)
ffffffffc02013ae:	fe870693          	addi	a3,a4,-24
ffffffffc02013b2:	9dbd                	addw	a1,a1,a5
ffffffffc02013b4:	cd0c                	sw	a1,24(a0)
ffffffffc02013b6:	57f5                	li	a5,-3
ffffffffc02013b8:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02013bc:	6314                	ld	a3,0(a4)
ffffffffc02013be:	671c                	ld	a5,8(a4)
}
ffffffffc02013c0:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02013c2:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02013c4:	e394                	sd	a3,0(a5)
ffffffffc02013c6:	0141                	addi	sp,sp,16
ffffffffc02013c8:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02013ca:	00004697          	auipc	a3,0x4
<<<<<<< HEAD
ffffffffc02013ce:	d8668693          	addi	a3,a3,-634 # ffffffffc0205150 <commands+0xae0>
ffffffffc02013d2:	00004617          	auipc	a2,0x4
ffffffffc02013d6:	a1e60613          	addi	a2,a2,-1506 # ffffffffc0204df0 <commands+0x780>
ffffffffc02013da:	08300593          	li	a1,131
ffffffffc02013de:	00004517          	auipc	a0,0x4
ffffffffc02013e2:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0204e08 <commands+0x798>
ffffffffc02013e6:	f95fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0);
ffffffffc02013ea:	00004697          	auipc	a3,0x4
ffffffffc02013ee:	d5e68693          	addi	a3,a3,-674 # ffffffffc0205148 <commands+0xad8>
ffffffffc02013f2:	00004617          	auipc	a2,0x4
ffffffffc02013f6:	9fe60613          	addi	a2,a2,-1538 # ffffffffc0204df0 <commands+0x780>
ffffffffc02013fa:	08000593          	li	a1,128
ffffffffc02013fe:	00004517          	auipc	a0,0x4
ffffffffc0201402:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0204e08 <commands+0x798>
=======
ffffffffc02013ce:	d6e68693          	addi	a3,a3,-658 # ffffffffc0205138 <commands+0xae0>
ffffffffc02013d2:	00004617          	auipc	a2,0x4
ffffffffc02013d6:	a0660613          	addi	a2,a2,-1530 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02013da:	08300593          	li	a1,131
ffffffffc02013de:	00004517          	auipc	a0,0x4
ffffffffc02013e2:	a1250513          	addi	a0,a0,-1518 # ffffffffc0204df0 <commands+0x798>
ffffffffc02013e6:	f95fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0);
ffffffffc02013ea:	00004697          	auipc	a3,0x4
ffffffffc02013ee:	d4668693          	addi	a3,a3,-698 # ffffffffc0205130 <commands+0xad8>
ffffffffc02013f2:	00004617          	auipc	a2,0x4
ffffffffc02013f6:	9e660613          	addi	a2,a2,-1562 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02013fa:	08000593          	li	a1,128
ffffffffc02013fe:	00004517          	auipc	a0,0x4
ffffffffc0201402:	9f250513          	addi	a0,a0,-1550 # ffffffffc0204df0 <commands+0x798>
>>>>>>> 747620b (lab2)
ffffffffc0201406:	f75fe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020140a <default_alloc_pages>:
    assert(n > 0);
ffffffffc020140a:	c959                	beqz	a0,ffffffffc02014a0 <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc020140c:	00010597          	auipc	a1,0x10
ffffffffc0201410:	c3458593          	addi	a1,a1,-972 # ffffffffc0211040 <free_area>
ffffffffc0201414:	0105a803          	lw	a6,16(a1)
ffffffffc0201418:	862a                	mv	a2,a0
ffffffffc020141a:	02081793          	slli	a5,a6,0x20
ffffffffc020141e:	9381                	srli	a5,a5,0x20
ffffffffc0201420:	00a7ee63          	bltu	a5,a0,ffffffffc020143c <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201424:	87ae                	mv	a5,a1
ffffffffc0201426:	a801                	j	ffffffffc0201436 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201428:	ff87a703          	lw	a4,-8(a5)
ffffffffc020142c:	02071693          	slli	a3,a4,0x20
ffffffffc0201430:	9281                	srli	a3,a3,0x20
ffffffffc0201432:	00c6f763          	bgeu	a3,a2,ffffffffc0201440 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201436:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201438:	feb798e3          	bne	a5,a1,ffffffffc0201428 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020143c:	4501                	li	a0,0
}
ffffffffc020143e:	8082                	ret
    return listelm->prev;
ffffffffc0201440:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201444:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201448:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc020144c:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc0201450:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201454:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201458:	02d67b63          	bgeu	a2,a3,ffffffffc020148e <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc020145c:	00361693          	slli	a3,a2,0x3
ffffffffc0201460:	96b2                	add	a3,a3,a2
ffffffffc0201462:	068e                	slli	a3,a3,0x3
ffffffffc0201464:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc0201466:	41c7073b          	subw	a4,a4,t3
ffffffffc020146a:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020146c:	00868613          	addi	a2,a3,8
ffffffffc0201470:	4709                	li	a4,2
ffffffffc0201472:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201476:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020147a:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc020147e:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201482:	e310                	sd	a2,0(a4)
ffffffffc0201484:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201488:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc020148a:	0316b023          	sd	a7,32(a3)
ffffffffc020148e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201492:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201496:	5775                	li	a4,-3
ffffffffc0201498:	17a1                	addi	a5,a5,-24
ffffffffc020149a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020149e:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02014a0:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02014a2:	00004697          	auipc	a3,0x4
<<<<<<< HEAD
ffffffffc02014a6:	ca668693          	addi	a3,a3,-858 # ffffffffc0205148 <commands+0xad8>
ffffffffc02014aa:	00004617          	auipc	a2,0x4
ffffffffc02014ae:	94660613          	addi	a2,a2,-1722 # ffffffffc0204df0 <commands+0x780>
ffffffffc02014b2:	06200593          	li	a1,98
ffffffffc02014b6:	00004517          	auipc	a0,0x4
ffffffffc02014ba:	95250513          	addi	a0,a0,-1710 # ffffffffc0204e08 <commands+0x798>
=======
ffffffffc02014a6:	c8e68693          	addi	a3,a3,-882 # ffffffffc0205130 <commands+0xad8>
ffffffffc02014aa:	00004617          	auipc	a2,0x4
ffffffffc02014ae:	92e60613          	addi	a2,a2,-1746 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02014b2:	06200593          	li	a1,98
ffffffffc02014b6:	00004517          	auipc	a0,0x4
ffffffffc02014ba:	93a50513          	addi	a0,a0,-1734 # ffffffffc0204df0 <commands+0x798>
>>>>>>> 747620b (lab2)
default_alloc_pages(size_t n) {
ffffffffc02014be:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014c0:	ebbfe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02014c4 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02014c4:	1141                	addi	sp,sp,-16
ffffffffc02014c6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014c8:	c9e1                	beqz	a1,ffffffffc0201598 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02014ca:	00359693          	slli	a3,a1,0x3
ffffffffc02014ce:	96ae                	add	a3,a3,a1
ffffffffc02014d0:	068e                	slli	a3,a3,0x3
ffffffffc02014d2:	96aa                	add	a3,a3,a0
ffffffffc02014d4:	87aa                	mv	a5,a0
ffffffffc02014d6:	00d50f63          	beq	a0,a3,ffffffffc02014f4 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02014da:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02014dc:	8b05                	andi	a4,a4,1
ffffffffc02014de:	cf49                	beqz	a4,ffffffffc0201578 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02014e0:	0007ac23          	sw	zero,24(a5)
ffffffffc02014e4:	0007b423          	sd	zero,8(a5)
ffffffffc02014e8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02014ec:	04878793          	addi	a5,a5,72
ffffffffc02014f0:	fed795e3          	bne	a5,a3,ffffffffc02014da <default_init_memmap+0x16>
    base->property = n;
ffffffffc02014f4:	2581                	sext.w	a1,a1
ffffffffc02014f6:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02014f8:	4789                	li	a5,2
ffffffffc02014fa:	00850713          	addi	a4,a0,8
ffffffffc02014fe:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201502:	00010697          	auipc	a3,0x10
ffffffffc0201506:	b3e68693          	addi	a3,a3,-1218 # ffffffffc0211040 <free_area>
ffffffffc020150a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020150c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020150e:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0201512:	9db9                	addw	a1,a1,a4
ffffffffc0201514:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201516:	04d78a63          	beq	a5,a3,ffffffffc020156a <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc020151a:	fe078713          	addi	a4,a5,-32
ffffffffc020151e:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201522:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201524:	00e56a63          	bltu	a0,a4,ffffffffc0201538 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201528:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020152a:	02d70263          	beq	a4,a3,ffffffffc020154e <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020152e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201530:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc0201534:	fee57ae3          	bgeu	a0,a4,ffffffffc0201528 <default_init_memmap+0x64>
ffffffffc0201538:	c199                	beqz	a1,ffffffffc020153e <default_init_memmap+0x7a>
ffffffffc020153a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020153e:	6398                	ld	a4,0(a5)
}
ffffffffc0201540:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201542:	e390                	sd	a2,0(a5)
ffffffffc0201544:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201546:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0201548:	f118                	sd	a4,32(a0)
ffffffffc020154a:	0141                	addi	sp,sp,16
ffffffffc020154c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020154e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201550:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc0201552:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201554:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201556:	00d70663          	beq	a4,a3,ffffffffc0201562 <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc020155a:	8832                	mv	a6,a2
ffffffffc020155c:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020155e:	87ba                	mv	a5,a4
ffffffffc0201560:	bfc1                	j	ffffffffc0201530 <default_init_memmap+0x6c>
}
ffffffffc0201562:	60a2                	ld	ra,8(sp)
ffffffffc0201564:	e290                	sd	a2,0(a3)
ffffffffc0201566:	0141                	addi	sp,sp,16
ffffffffc0201568:	8082                	ret
ffffffffc020156a:	60a2                	ld	ra,8(sp)
ffffffffc020156c:	e390                	sd	a2,0(a5)
ffffffffc020156e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201570:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0201572:	f11c                	sd	a5,32(a0)
ffffffffc0201574:	0141                	addi	sp,sp,16
ffffffffc0201576:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201578:	00004697          	auipc	a3,0x4
<<<<<<< HEAD
ffffffffc020157c:	c0068693          	addi	a3,a3,-1024 # ffffffffc0205178 <commands+0xb08>
ffffffffc0201580:	00004617          	auipc	a2,0x4
ffffffffc0201584:	87060613          	addi	a2,a2,-1936 # ffffffffc0204df0 <commands+0x780>
ffffffffc0201588:	04900593          	li	a1,73
ffffffffc020158c:	00004517          	auipc	a0,0x4
ffffffffc0201590:	87c50513          	addi	a0,a0,-1924 # ffffffffc0204e08 <commands+0x798>
ffffffffc0201594:	de7fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0);
ffffffffc0201598:	00004697          	auipc	a3,0x4
ffffffffc020159c:	bb068693          	addi	a3,a3,-1104 # ffffffffc0205148 <commands+0xad8>
ffffffffc02015a0:	00004617          	auipc	a2,0x4
ffffffffc02015a4:	85060613          	addi	a2,a2,-1968 # ffffffffc0204df0 <commands+0x780>
ffffffffc02015a8:	04600593          	li	a1,70
ffffffffc02015ac:	00004517          	auipc	a0,0x4
ffffffffc02015b0:	85c50513          	addi	a0,a0,-1956 # ffffffffc0204e08 <commands+0x798>
=======
ffffffffc020157c:	be868693          	addi	a3,a3,-1048 # ffffffffc0205160 <commands+0xb08>
ffffffffc0201580:	00004617          	auipc	a2,0x4
ffffffffc0201584:	85860613          	addi	a2,a2,-1960 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0201588:	04900593          	li	a1,73
ffffffffc020158c:	00004517          	auipc	a0,0x4
ffffffffc0201590:	86450513          	addi	a0,a0,-1948 # ffffffffc0204df0 <commands+0x798>
ffffffffc0201594:	de7fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0);
ffffffffc0201598:	00004697          	auipc	a3,0x4
ffffffffc020159c:	b9868693          	addi	a3,a3,-1128 # ffffffffc0205130 <commands+0xad8>
ffffffffc02015a0:	00004617          	auipc	a2,0x4
ffffffffc02015a4:	83860613          	addi	a2,a2,-1992 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02015a8:	04600593          	li	a1,70
ffffffffc02015ac:	00004517          	auipc	a0,0x4
ffffffffc02015b0:	84450513          	addi	a0,a0,-1980 # ffffffffc0204df0 <commands+0x798>
>>>>>>> 747620b (lab2)
ffffffffc02015b4:	dc7fe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02015b8 <pa2page.part.0>:
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc02015b8:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02015ba:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02015be:	c1e60613          	addi	a2,a2,-994 # ffffffffc02051d8 <default_pmm_manager+0x38>
ffffffffc02015c2:	06500593          	li	a1,101
ffffffffc02015c6:	00004517          	auipc	a0,0x4
ffffffffc02015ca:	c3250513          	addi	a0,a0,-974 # ffffffffc02051f8 <default_pmm_manager+0x58>
=======
ffffffffc02015be:	c0660613          	addi	a2,a2,-1018 # ffffffffc02051c0 <default_pmm_manager+0x38>
ffffffffc02015c2:	06500593          	li	a1,101
ffffffffc02015c6:	00004517          	auipc	a0,0x4
ffffffffc02015ca:	c1a50513          	addi	a0,a0,-998 # ffffffffc02051e0 <default_pmm_manager+0x58>
>>>>>>> 747620b (lab2)
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc02015ce:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc02015d0:	dabfe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02015d4 <pte2page.part.0>:
static inline struct Page *pte2page(pte_t pte) {
ffffffffc02015d4:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc02015d6:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02015da:	c3260613          	addi	a2,a2,-974 # ffffffffc0205208 <default_pmm_manager+0x68>
ffffffffc02015de:	07000593          	li	a1,112
ffffffffc02015e2:	00004517          	auipc	a0,0x4
ffffffffc02015e6:	c1650513          	addi	a0,a0,-1002 # ffffffffc02051f8 <default_pmm_manager+0x58>
=======
ffffffffc02015da:	c1a60613          	addi	a2,a2,-998 # ffffffffc02051f0 <default_pmm_manager+0x68>
ffffffffc02015de:	07000593          	li	a1,112
ffffffffc02015e2:	00004517          	auipc	a0,0x4
ffffffffc02015e6:	bfe50513          	addi	a0,a0,-1026 # ffffffffc02051e0 <default_pmm_manager+0x58>
>>>>>>> 747620b (lab2)
static inline struct Page *pte2page(pte_t pte) {
ffffffffc02015ea:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc02015ec:	d8ffe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02015f0 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc02015f0:	7139                	addi	sp,sp,-64
ffffffffc02015f2:	f426                	sd	s1,40(sp)
ffffffffc02015f4:	f04a                	sd	s2,32(sp)
ffffffffc02015f6:	ec4e                	sd	s3,24(sp)
ffffffffc02015f8:	e852                	sd	s4,16(sp)
ffffffffc02015fa:	e456                	sd	s5,8(sp)
ffffffffc02015fc:	e05a                	sd	s6,0(sp)
ffffffffc02015fe:	fc06                	sd	ra,56(sp)
ffffffffc0201600:	f822                	sd	s0,48(sp)
ffffffffc0201602:	84aa                	mv	s1,a0
ffffffffc0201604:	00010917          	auipc	s2,0x10
ffffffffc0201608:	f2c90913          	addi	s2,s2,-212 # ffffffffc0211530 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc020160c:	4a05                	li	s4,1
ffffffffc020160e:	00010a97          	auipc	s5,0x10
ffffffffc0201612:	f42a8a93          	addi	s5,s5,-190 # ffffffffc0211550 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0201616:	0005099b          	sext.w	s3,a0
ffffffffc020161a:	00010b17          	auipc	s6,0x10
ffffffffc020161e:	f46b0b13          	addi	s6,s6,-186 # ffffffffc0211560 <check_mm_struct>
ffffffffc0201622:	a01d                	j	ffffffffc0201648 <alloc_pages+0x58>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0201624:	00093783          	ld	a5,0(s2)
ffffffffc0201628:	6f9c                	ld	a5,24(a5)
ffffffffc020162a:	9782                	jalr	a5
ffffffffc020162c:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc020162e:	4601                	li	a2,0
ffffffffc0201630:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201632:	ec0d                	bnez	s0,ffffffffc020166c <alloc_pages+0x7c>
ffffffffc0201634:	029a6c63          	bltu	s4,s1,ffffffffc020166c <alloc_pages+0x7c>
ffffffffc0201638:	000aa783          	lw	a5,0(s5)
ffffffffc020163c:	2781                	sext.w	a5,a5
ffffffffc020163e:	c79d                	beqz	a5,ffffffffc020166c <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201640:	000b3503          	ld	a0,0(s6)
ffffffffc0201644:	189010ef          	jal	ra,ffffffffc0202fcc <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201648:	100027f3          	csrr	a5,sstatus
ffffffffc020164c:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc020164e:	8526                	mv	a0,s1
ffffffffc0201650:	dbf1                	beqz	a5,ffffffffc0201624 <alloc_pages+0x34>
        intr_disable();
ffffffffc0201652:	ea3fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc0201656:	00093783          	ld	a5,0(s2)
ffffffffc020165a:	8526                	mv	a0,s1
ffffffffc020165c:	6f9c                	ld	a5,24(a5)
ffffffffc020165e:	9782                	jalr	a5
ffffffffc0201660:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201662:	e8dfe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201666:	4601                	li	a2,0
ffffffffc0201668:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc020166a:	d469                	beqz	s0,ffffffffc0201634 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc020166c:	70e2                	ld	ra,56(sp)
ffffffffc020166e:	8522                	mv	a0,s0
ffffffffc0201670:	7442                	ld	s0,48(sp)
ffffffffc0201672:	74a2                	ld	s1,40(sp)
ffffffffc0201674:	7902                	ld	s2,32(sp)
ffffffffc0201676:	69e2                	ld	s3,24(sp)
ffffffffc0201678:	6a42                	ld	s4,16(sp)
ffffffffc020167a:	6aa2                	ld	s5,8(sp)
ffffffffc020167c:	6b02                	ld	s6,0(sp)
ffffffffc020167e:	6121                	addi	sp,sp,64
ffffffffc0201680:	8082                	ret

ffffffffc0201682 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201682:	100027f3          	csrr	a5,sstatus
ffffffffc0201686:	8b89                	andi	a5,a5,2
ffffffffc0201688:	e799                	bnez	a5,ffffffffc0201696 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc020168a:	00010797          	auipc	a5,0x10
ffffffffc020168e:	ea67b783          	ld	a5,-346(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201692:	739c                	ld	a5,32(a5)
ffffffffc0201694:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201696:	1101                	addi	sp,sp,-32
ffffffffc0201698:	ec06                	sd	ra,24(sp)
ffffffffc020169a:	e822                	sd	s0,16(sp)
ffffffffc020169c:	e426                	sd	s1,8(sp)
ffffffffc020169e:	842a                	mv	s0,a0
ffffffffc02016a0:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02016a2:	e53fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc02016a6:	00010797          	auipc	a5,0x10
ffffffffc02016aa:	e8a7b783          	ld	a5,-374(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02016ae:	739c                	ld	a5,32(a5)
ffffffffc02016b0:	85a6                	mv	a1,s1
ffffffffc02016b2:	8522                	mv	a0,s0
ffffffffc02016b4:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc02016b6:	6442                	ld	s0,16(sp)
ffffffffc02016b8:	60e2                	ld	ra,24(sp)
ffffffffc02016ba:	64a2                	ld	s1,8(sp)
ffffffffc02016bc:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02016be:	e31fe06f          	j	ffffffffc02004ee <intr_enable>

ffffffffc02016c2 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016c2:	100027f3          	csrr	a5,sstatus
ffffffffc02016c6:	8b89                	andi	a5,a5,2
ffffffffc02016c8:	e799                	bnez	a5,ffffffffc02016d6 <nr_free_pages+0x14>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02016ca:	00010797          	auipc	a5,0x10
ffffffffc02016ce:	e667b783          	ld	a5,-410(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02016d2:	779c                	ld	a5,40(a5)
ffffffffc02016d4:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02016d6:	1141                	addi	sp,sp,-16
ffffffffc02016d8:	e406                	sd	ra,8(sp)
ffffffffc02016da:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02016dc:	e19fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02016e0:	00010797          	auipc	a5,0x10
ffffffffc02016e4:	e507b783          	ld	a5,-432(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02016e8:	779c                	ld	a5,40(a5)
ffffffffc02016ea:	9782                	jalr	a5
ffffffffc02016ec:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02016ee:	e01fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02016f2:	60a2                	ld	ra,8(sp)
ffffffffc02016f4:	8522                	mv	a0,s0
ffffffffc02016f6:	6402                	ld	s0,0(sp)
ffffffffc02016f8:	0141                	addi	sp,sp,16
ffffffffc02016fa:	8082                	ret

ffffffffc02016fc <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];    // 计算虚拟地址 la 对应的一级页目录项的索引
ffffffffc02016fc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201700:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201704:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];    // 计算虚拟地址 la 对应的一级页目录项的索引
ffffffffc0201706:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201708:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];    // 计算虚拟地址 la 对应的一级页目录项的索引
ffffffffc020170a:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc020170e:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201710:	f84a                	sd	s2,48(sp)
ffffffffc0201712:	f44e                	sd	s3,40(sp)
ffffffffc0201714:	f052                	sd	s4,32(sp)
ffffffffc0201716:	e486                	sd	ra,72(sp)
ffffffffc0201718:	e0a2                	sd	s0,64(sp)
ffffffffc020171a:	ec56                	sd	s5,24(sp)
ffffffffc020171c:	e85a                	sd	s6,16(sp)
ffffffffc020171e:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201720:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201724:	892e                	mv	s2,a1
ffffffffc0201726:	8a32                	mv	s4,a2
ffffffffc0201728:	00010997          	auipc	s3,0x10
ffffffffc020172c:	df898993          	addi	s3,s3,-520 # ffffffffc0211520 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201730:	efb5                	bnez	a5,ffffffffc02017ac <get_pte+0xb0>
        struct Page *page;              // 无效创建新页目录项
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201732:	14060c63          	beqz	a2,ffffffffc020188a <get_pte+0x18e>
ffffffffc0201736:	4505                	li	a0,1
ffffffffc0201738:	eb9ff0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc020173c:	842a                	mv	s0,a0
ffffffffc020173e:	14050663          	beqz	a0,ffffffffc020188a <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201742:	00010b97          	auipc	s7,0x10
ffffffffc0201746:	de6b8b93          	addi	s7,s7,-538 # ffffffffc0211528 <pages>
ffffffffc020174a:	000bb503          	ld	a0,0(s7)
ffffffffc020174e:	00005b17          	auipc	s6,0x5
<<<<<<< HEAD
ffffffffc0201752:	b22b3b03          	ld	s6,-1246(s6) # ffffffffc0206270 <error_string+0x38>
=======
ffffffffc0201752:	afab3b03          	ld	s6,-1286(s6) # ffffffffc0206248 <error_string+0x38>
>>>>>>> 747620b (lab2)
ffffffffc0201756:	00080ab7          	lui	s5,0x80
ffffffffc020175a:	40a40533          	sub	a0,s0,a0
ffffffffc020175e:	850d                	srai	a0,a0,0x3
ffffffffc0201760:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);   // KADDR(物理地址) -> 物理地址对应的虚拟地址。PADDR相反
ffffffffc0201764:	00010997          	auipc	s3,0x10
ffffffffc0201768:	dbc98993          	addi	s3,s3,-580 # ffffffffc0211520 <npage>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020176c:	4785                	li	a5,1
ffffffffc020176e:	0009b703          	ld	a4,0(s3)
ffffffffc0201772:	c01c                	sw	a5,0(s0)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201774:	9556                	add	a0,a0,s5
ffffffffc0201776:	00c51793          	slli	a5,a0,0xc
ffffffffc020177a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020177c:	0532                	slli	a0,a0,0xc
ffffffffc020177e:	14e7fd63          	bgeu	a5,a4,ffffffffc02018d8 <get_pte+0x1dc>
ffffffffc0201782:	00010797          	auipc	a5,0x10
ffffffffc0201786:	db67b783          	ld	a5,-586(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc020178a:	6605                	lui	a2,0x1
ffffffffc020178c:	4581                	li	a1,0
ffffffffc020178e:	953e                	add	a0,a0,a5
<<<<<<< HEAD
ffffffffc0201790:	45f020ef          	jal	ra,ffffffffc02043ee <memset>
=======
ffffffffc0201790:	441020ef          	jal	ra,ffffffffc02043d0 <memset>
>>>>>>> 747620b (lab2)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201794:	000bb683          	ld	a3,0(s7)
ffffffffc0201798:	40d406b3          	sub	a3,s0,a3
ffffffffc020179c:	868d                	srai	a3,a3,0x3
ffffffffc020179e:	036686b3          	mul	a3,a3,s6
ffffffffc02017a2:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02017a4:	06aa                	slli	a3,a3,0xa
ffffffffc02017a6:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02017aa:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02017ac:	77fd                	lui	a5,0xfffff
ffffffffc02017ae:	068a                	slli	a3,a3,0x2
ffffffffc02017b0:	0009b703          	ld	a4,0(s3)
ffffffffc02017b4:	8efd                	and	a3,a3,a5
ffffffffc02017b6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02017ba:	0ce7fa63          	bgeu	a5,a4,ffffffffc020188e <get_pte+0x192>
ffffffffc02017be:	00010a97          	auipc	s5,0x10
ffffffffc02017c2:	d7aa8a93          	addi	s5,s5,-646 # ffffffffc0211538 <va_pa_offset>
ffffffffc02017c6:	000ab403          	ld	s0,0(s5)
ffffffffc02017ca:	01595793          	srli	a5,s2,0x15
ffffffffc02017ce:	1ff7f793          	andi	a5,a5,511
ffffffffc02017d2:	96a2                	add	a3,a3,s0
ffffffffc02017d4:	00379413          	slli	s0,a5,0x3
ffffffffc02017d8:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc02017da:	6014                	ld	a3,0(s0)
ffffffffc02017dc:	0016f793          	andi	a5,a3,1
ffffffffc02017e0:	ebad                	bnez	a5,ffffffffc0201852 <get_pte+0x156>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc02017e2:	0a0a0463          	beqz	s4,ffffffffc020188a <get_pte+0x18e>
ffffffffc02017e6:	4505                	li	a0,1
ffffffffc02017e8:	e09ff0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc02017ec:	84aa                	mv	s1,a0
ffffffffc02017ee:	cd51                	beqz	a0,ffffffffc020188a <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02017f0:	00010b97          	auipc	s7,0x10
ffffffffc02017f4:	d38b8b93          	addi	s7,s7,-712 # ffffffffc0211528 <pages>
ffffffffc02017f8:	000bb503          	ld	a0,0(s7)
ffffffffc02017fc:	00005b17          	auipc	s6,0x5
<<<<<<< HEAD
ffffffffc0201800:	a74b3b03          	ld	s6,-1420(s6) # ffffffffc0206270 <error_string+0x38>
=======
ffffffffc0201800:	a4cb3b03          	ld	s6,-1460(s6) # ffffffffc0206248 <error_string+0x38>
>>>>>>> 747620b (lab2)
ffffffffc0201804:	00080a37          	lui	s4,0x80
ffffffffc0201808:	40a48533          	sub	a0,s1,a0
ffffffffc020180c:	850d                	srai	a0,a0,0x3
ffffffffc020180e:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201812:	4785                	li	a5,1
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201814:	0009b703          	ld	a4,0(s3)
ffffffffc0201818:	c09c                	sw	a5,0(s1)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020181a:	9552                	add	a0,a0,s4
ffffffffc020181c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201820:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201822:	0532                	slli	a0,a0,0xc
ffffffffc0201824:	08e7fd63          	bgeu	a5,a4,ffffffffc02018be <get_pte+0x1c2>
ffffffffc0201828:	000ab783          	ld	a5,0(s5)
ffffffffc020182c:	6605                	lui	a2,0x1
ffffffffc020182e:	4581                	li	a1,0
ffffffffc0201830:	953e                	add	a0,a0,a5
<<<<<<< HEAD
ffffffffc0201832:	3bd020ef          	jal	ra,ffffffffc02043ee <memset>
=======
ffffffffc0201832:	39f020ef          	jal	ra,ffffffffc02043d0 <memset>
>>>>>>> 747620b (lab2)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201836:	000bb683          	ld	a3,0(s7)
ffffffffc020183a:	40d486b3          	sub	a3,s1,a3
ffffffffc020183e:	868d                	srai	a3,a3,0x3
ffffffffc0201840:	036686b3          	mul	a3,a3,s6
ffffffffc0201844:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201846:	06aa                	slli	a3,a3,0xa
ffffffffc0201848:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020184c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020184e:	0009b703          	ld	a4,0(s3)
ffffffffc0201852:	068a                	slli	a3,a3,0x2
ffffffffc0201854:	757d                	lui	a0,0xfffff
ffffffffc0201856:	8ee9                	and	a3,a3,a0
ffffffffc0201858:	00c6d793          	srli	a5,a3,0xc
ffffffffc020185c:	04e7f563          	bgeu	a5,a4,ffffffffc02018a6 <get_pte+0x1aa>
ffffffffc0201860:	000ab503          	ld	a0,0(s5)
ffffffffc0201864:	00c95913          	srli	s2,s2,0xc
ffffffffc0201868:	1ff97913          	andi	s2,s2,511
ffffffffc020186c:	96aa                	add	a3,a3,a0
ffffffffc020186e:	00391513          	slli	a0,s2,0x3
ffffffffc0201872:	9536                	add	a0,a0,a3
}
ffffffffc0201874:	60a6                	ld	ra,72(sp)
ffffffffc0201876:	6406                	ld	s0,64(sp)
ffffffffc0201878:	74e2                	ld	s1,56(sp)
ffffffffc020187a:	7942                	ld	s2,48(sp)
ffffffffc020187c:	79a2                	ld	s3,40(sp)
ffffffffc020187e:	7a02                	ld	s4,32(sp)
ffffffffc0201880:	6ae2                	ld	s5,24(sp)
ffffffffc0201882:	6b42                	ld	s6,16(sp)
ffffffffc0201884:	6ba2                	ld	s7,8(sp)
ffffffffc0201886:	6161                	addi	sp,sp,80
ffffffffc0201888:	8082                	ret
            return NULL;
ffffffffc020188a:	4501                	li	a0,0
ffffffffc020188c:	b7e5                	j	ffffffffc0201874 <get_pte+0x178>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020188e:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc0201892:	9a260613          	addi	a2,a2,-1630 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0201896:	10200593          	li	a1,258
ffffffffc020189a:	00004517          	auipc	a0,0x4
ffffffffc020189e:	9be50513          	addi	a0,a0,-1602 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02018a2:	ad9fe0ef          	jal	ra,ffffffffc020037a <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02018a6:	00004617          	auipc	a2,0x4
ffffffffc02018aa:	98a60613          	addi	a2,a2,-1654 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc02018ae:	10f00593          	li	a1,271
ffffffffc02018b2:	00004517          	auipc	a0,0x4
ffffffffc02018b6:	9a650513          	addi	a0,a0,-1626 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc0201892:	98a60613          	addi	a2,a2,-1654 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0201896:	10200593          	li	a1,258
ffffffffc020189a:	00004517          	auipc	a0,0x4
ffffffffc020189e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02018a2:	ad9fe0ef          	jal	ra,ffffffffc020037a <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02018a6:	00004617          	auipc	a2,0x4
ffffffffc02018aa:	97260613          	addi	a2,a2,-1678 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc02018ae:	10f00593          	li	a1,271
ffffffffc02018b2:	00004517          	auipc	a0,0x4
ffffffffc02018b6:	98e50513          	addi	a0,a0,-1650 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc02018ba:	ac1fe0ef          	jal	ra,ffffffffc020037a <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc02018be:	86aa                	mv	a3,a0
ffffffffc02018c0:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02018c4:	97060613          	addi	a2,a2,-1680 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc02018c8:	10b00593          	li	a1,267
ffffffffc02018cc:	00004517          	auipc	a0,0x4
ffffffffc02018d0:	98c50513          	addi	a0,a0,-1652 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc02018c4:	95860613          	addi	a2,a2,-1704 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc02018c8:	10b00593          	li	a1,267
ffffffffc02018cc:	00004517          	auipc	a0,0x4
ffffffffc02018d0:	97450513          	addi	a0,a0,-1676 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc02018d4:	aa7fe0ef          	jal	ra,ffffffffc020037a <__panic>
        memset(KADDR(pa), 0, PGSIZE);   // KADDR(物理地址) -> 物理地址对应的虚拟地址。PADDR相反
ffffffffc02018d8:	86aa                	mv	a3,a0
ffffffffc02018da:	00004617          	auipc	a2,0x4
<<<<<<< HEAD
ffffffffc02018de:	95660613          	addi	a2,a2,-1706 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc02018e2:	0ff00593          	li	a1,255
ffffffffc02018e6:	00004517          	auipc	a0,0x4
ffffffffc02018ea:	97250513          	addi	a0,a0,-1678 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc02018de:	93e60613          	addi	a2,a2,-1730 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc02018e2:	0ff00593          	li	a1,255
ffffffffc02018e6:	00004517          	auipc	a0,0x4
ffffffffc02018ea:	95a50513          	addi	a0,a0,-1702 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc02018ee:	a8dfe0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02018f2 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc02018f2:	1141                	addi	sp,sp,-16
ffffffffc02018f4:	e022                	sd	s0,0(sp)
ffffffffc02018f6:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02018f8:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc02018fa:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02018fc:	e01ff0ef          	jal	ra,ffffffffc02016fc <get_pte>
    if (ptep_store != NULL) {
ffffffffc0201900:	c011                	beqz	s0,ffffffffc0201904 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0201902:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201904:	c511                	beqz	a0,ffffffffc0201910 <get_page+0x1e>
ffffffffc0201906:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201908:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc020190a:	0017f713          	andi	a4,a5,1
ffffffffc020190e:	e709                	bnez	a4,ffffffffc0201918 <get_page+0x26>
}
ffffffffc0201910:	60a2                	ld	ra,8(sp)
ffffffffc0201912:	6402                	ld	s0,0(sp)
ffffffffc0201914:	0141                	addi	sp,sp,16
ffffffffc0201916:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201918:	078a                	slli	a5,a5,0x2
ffffffffc020191a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020191c:	00010717          	auipc	a4,0x10
ffffffffc0201920:	c0473703          	ld	a4,-1020(a4) # ffffffffc0211520 <npage>
ffffffffc0201924:	02e7f263          	bgeu	a5,a4,ffffffffc0201948 <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0201928:	fff80537          	lui	a0,0xfff80
ffffffffc020192c:	97aa                	add	a5,a5,a0
ffffffffc020192e:	60a2                	ld	ra,8(sp)
ffffffffc0201930:	6402                	ld	s0,0(sp)
ffffffffc0201932:	00379513          	slli	a0,a5,0x3
ffffffffc0201936:	97aa                	add	a5,a5,a0
ffffffffc0201938:	078e                	slli	a5,a5,0x3
ffffffffc020193a:	00010517          	auipc	a0,0x10
ffffffffc020193e:	bee53503          	ld	a0,-1042(a0) # ffffffffc0211528 <pages>
ffffffffc0201942:	953e                	add	a0,a0,a5
ffffffffc0201944:	0141                	addi	sp,sp,16
ffffffffc0201946:	8082                	ret
ffffffffc0201948:	c71ff0ef          	jal	ra,ffffffffc02015b8 <pa2page.part.0>

ffffffffc020194c <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc020194c:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020194e:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201950:	ec06                	sd	ra,24(sp)
ffffffffc0201952:	e822                	sd	s0,16(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201954:	da9ff0ef          	jal	ra,ffffffffc02016fc <get_pte>
    if (ptep != NULL) {
ffffffffc0201958:	c511                	beqz	a0,ffffffffc0201964 <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc020195a:	611c                	ld	a5,0(a0)
ffffffffc020195c:	842a                	mv	s0,a0
ffffffffc020195e:	0017f713          	andi	a4,a5,1
ffffffffc0201962:	e709                	bnez	a4,ffffffffc020196c <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201964:	60e2                	ld	ra,24(sp)
ffffffffc0201966:	6442                	ld	s0,16(sp)
ffffffffc0201968:	6105                	addi	sp,sp,32
ffffffffc020196a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020196c:	078a                	slli	a5,a5,0x2
ffffffffc020196e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201970:	00010717          	auipc	a4,0x10
ffffffffc0201974:	bb073703          	ld	a4,-1104(a4) # ffffffffc0211520 <npage>
ffffffffc0201978:	06e7f563          	bgeu	a5,a4,ffffffffc02019e2 <page_remove+0x96>
    return &pages[PPN(pa) - nbase];
ffffffffc020197c:	fff80737          	lui	a4,0xfff80
ffffffffc0201980:	97ba                	add	a5,a5,a4
ffffffffc0201982:	00379513          	slli	a0,a5,0x3
ffffffffc0201986:	97aa                	add	a5,a5,a0
ffffffffc0201988:	078e                	slli	a5,a5,0x3
ffffffffc020198a:	00010517          	auipc	a0,0x10
ffffffffc020198e:	b9e53503          	ld	a0,-1122(a0) # ffffffffc0211528 <pages>
ffffffffc0201992:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0201994:	411c                	lw	a5,0(a0)
ffffffffc0201996:	fff7871b          	addiw	a4,a5,-1
ffffffffc020199a:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020199c:	cb09                	beqz	a4,ffffffffc02019ae <page_remove+0x62>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc020199e:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc02019a2:	12000073          	sfence.vma
}
ffffffffc02019a6:	60e2                	ld	ra,24(sp)
ffffffffc02019a8:	6442                	ld	s0,16(sp)
ffffffffc02019aa:	6105                	addi	sp,sp,32
ffffffffc02019ac:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019ae:	100027f3          	csrr	a5,sstatus
ffffffffc02019b2:	8b89                	andi	a5,a5,2
ffffffffc02019b4:	eb89                	bnez	a5,ffffffffc02019c6 <page_remove+0x7a>
    { pmm_manager->free_pages(base, n); }
ffffffffc02019b6:	00010797          	auipc	a5,0x10
ffffffffc02019ba:	b7a7b783          	ld	a5,-1158(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02019be:	739c                	ld	a5,32(a5)
ffffffffc02019c0:	4585                	li	a1,1
ffffffffc02019c2:	9782                	jalr	a5
    if (flag) {
ffffffffc02019c4:	bfe9                	j	ffffffffc020199e <page_remove+0x52>
        intr_disable();
ffffffffc02019c6:	e42a                	sd	a0,8(sp)
ffffffffc02019c8:	b2dfe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc02019cc:	00010797          	auipc	a5,0x10
ffffffffc02019d0:	b647b783          	ld	a5,-1180(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02019d4:	739c                	ld	a5,32(a5)
ffffffffc02019d6:	6522                	ld	a0,8(sp)
ffffffffc02019d8:	4585                	li	a1,1
ffffffffc02019da:	9782                	jalr	a5
        intr_enable();
ffffffffc02019dc:	b13fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc02019e0:	bf7d                	j	ffffffffc020199e <page_remove+0x52>
ffffffffc02019e2:	bd7ff0ef          	jal	ra,ffffffffc02015b8 <pa2page.part.0>

ffffffffc02019e6 <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc02019e6:	7179                	addi	sp,sp,-48
ffffffffc02019e8:	87b2                	mv	a5,a2
ffffffffc02019ea:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02019ec:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc02019ee:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02019f0:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc02019f2:	ec26                	sd	s1,24(sp)
ffffffffc02019f4:	f406                	sd	ra,40(sp)
ffffffffc02019f6:	e84a                	sd	s2,16(sp)
ffffffffc02019f8:	e44e                	sd	s3,8(sp)
ffffffffc02019fa:	e052                	sd	s4,0(sp)
ffffffffc02019fc:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02019fe:	cffff0ef          	jal	ra,ffffffffc02016fc <get_pte>
    if (ptep == NULL) {
ffffffffc0201a02:	cd71                	beqz	a0,ffffffffc0201ade <page_insert+0xf8>
    page->ref += 1;
ffffffffc0201a04:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_V) {
ffffffffc0201a06:	611c                	ld	a5,0(a0)
ffffffffc0201a08:	89aa                	mv	s3,a0
ffffffffc0201a0a:	0016871b          	addiw	a4,a3,1
ffffffffc0201a0e:	c018                	sw	a4,0(s0)
ffffffffc0201a10:	0017f713          	andi	a4,a5,1
ffffffffc0201a14:	e331                	bnez	a4,ffffffffc0201a58 <page_insert+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201a16:	00010797          	auipc	a5,0x10
ffffffffc0201a1a:	b127b783          	ld	a5,-1262(a5) # ffffffffc0211528 <pages>
ffffffffc0201a1e:	40f407b3          	sub	a5,s0,a5
ffffffffc0201a22:	878d                	srai	a5,a5,0x3
ffffffffc0201a24:	00005417          	auipc	s0,0x5
<<<<<<< HEAD
ffffffffc0201a28:	84c43403          	ld	s0,-1972(s0) # ffffffffc0206270 <error_string+0x38>
=======
ffffffffc0201a28:	82443403          	ld	s0,-2012(s0) # ffffffffc0206248 <error_string+0x38>
>>>>>>> 747620b (lab2)
ffffffffc0201a2c:	028787b3          	mul	a5,a5,s0
ffffffffc0201a30:	00080437          	lui	s0,0x80
ffffffffc0201a34:	97a2                	add	a5,a5,s0
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201a36:	07aa                	slli	a5,a5,0xa
ffffffffc0201a38:	8cdd                	or	s1,s1,a5
ffffffffc0201a3a:	0014e493          	ori	s1,s1,1
            page_ref_dec(page);
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0201a3e:	0099b023          	sd	s1,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0201a42:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0201a46:	4501                	li	a0,0
}
ffffffffc0201a48:	70a2                	ld	ra,40(sp)
ffffffffc0201a4a:	7402                	ld	s0,32(sp)
ffffffffc0201a4c:	64e2                	ld	s1,24(sp)
ffffffffc0201a4e:	6942                	ld	s2,16(sp)
ffffffffc0201a50:	69a2                	ld	s3,8(sp)
ffffffffc0201a52:	6a02                	ld	s4,0(sp)
ffffffffc0201a54:	6145                	addi	sp,sp,48
ffffffffc0201a56:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201a58:	00279713          	slli	a4,a5,0x2
ffffffffc0201a5c:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201a5e:	00010797          	auipc	a5,0x10
ffffffffc0201a62:	ac27b783          	ld	a5,-1342(a5) # ffffffffc0211520 <npage>
ffffffffc0201a66:	06f77e63          	bgeu	a4,a5,ffffffffc0201ae2 <page_insert+0xfc>
    return &pages[PPN(pa) - nbase];
ffffffffc0201a6a:	fff807b7          	lui	a5,0xfff80
ffffffffc0201a6e:	973e                	add	a4,a4,a5
ffffffffc0201a70:	00010a17          	auipc	s4,0x10
ffffffffc0201a74:	ab8a0a13          	addi	s4,s4,-1352 # ffffffffc0211528 <pages>
ffffffffc0201a78:	000a3783          	ld	a5,0(s4)
ffffffffc0201a7c:	00371913          	slli	s2,a4,0x3
ffffffffc0201a80:	993a                	add	s2,s2,a4
ffffffffc0201a82:	090e                	slli	s2,s2,0x3
ffffffffc0201a84:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0201a86:	03240063          	beq	s0,s2,ffffffffc0201aa6 <page_insert+0xc0>
    page->ref -= 1;
ffffffffc0201a8a:	00092783          	lw	a5,0(s2)
ffffffffc0201a8e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201a92:	00e92023          	sw	a4,0(s2)
        if (page_ref(page) ==
ffffffffc0201a96:	cb11                	beqz	a4,ffffffffc0201aaa <page_insert+0xc4>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0201a98:	0009b023          	sd	zero,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0201a9c:	12000073          	sfence.vma
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201aa0:	000a3783          	ld	a5,0(s4)
}
ffffffffc0201aa4:	bfad                	j	ffffffffc0201a1e <page_insert+0x38>
    page->ref -= 1;
ffffffffc0201aa6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0201aa8:	bf9d                	j	ffffffffc0201a1e <page_insert+0x38>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201aaa:	100027f3          	csrr	a5,sstatus
ffffffffc0201aae:	8b89                	andi	a5,a5,2
ffffffffc0201ab0:	eb91                	bnez	a5,ffffffffc0201ac4 <page_insert+0xde>
    { pmm_manager->free_pages(base, n); }
ffffffffc0201ab2:	00010797          	auipc	a5,0x10
ffffffffc0201ab6:	a7e7b783          	ld	a5,-1410(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201aba:	739c                	ld	a5,32(a5)
ffffffffc0201abc:	4585                	li	a1,1
ffffffffc0201abe:	854a                	mv	a0,s2
ffffffffc0201ac0:	9782                	jalr	a5
    if (flag) {
ffffffffc0201ac2:	bfd9                	j	ffffffffc0201a98 <page_insert+0xb2>
        intr_disable();
ffffffffc0201ac4:	a31fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc0201ac8:	00010797          	auipc	a5,0x10
ffffffffc0201acc:	a687b783          	ld	a5,-1432(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201ad0:	739c                	ld	a5,32(a5)
ffffffffc0201ad2:	4585                	li	a1,1
ffffffffc0201ad4:	854a                	mv	a0,s2
ffffffffc0201ad6:	9782                	jalr	a5
        intr_enable();
ffffffffc0201ad8:	a17fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc0201adc:	bf75                	j	ffffffffc0201a98 <page_insert+0xb2>
        return -E_NO_MEM;
ffffffffc0201ade:	5571                	li	a0,-4
ffffffffc0201ae0:	b7a5                	j	ffffffffc0201a48 <page_insert+0x62>
ffffffffc0201ae2:	ad7ff0ef          	jal	ra,ffffffffc02015b8 <pa2page.part.0>

ffffffffc0201ae6 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201ae6:	00003797          	auipc	a5,0x3
<<<<<<< HEAD
ffffffffc0201aea:	6ba78793          	addi	a5,a5,1722 # ffffffffc02051a0 <default_pmm_manager>
=======
ffffffffc0201aea:	6a278793          	addi	a5,a5,1698 # ffffffffc0205188 <default_pmm_manager>
>>>>>>> 747620b (lab2)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201aee:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0201af0:	7159                	addi	sp,sp,-112
ffffffffc0201af2:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201af4:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201af8:	77450513          	addi	a0,a0,1908 # ffffffffc0205268 <default_pmm_manager+0xc8>
=======
ffffffffc0201af8:	75c50513          	addi	a0,a0,1884 # ffffffffc0205250 <default_pmm_manager+0xc8>
>>>>>>> 747620b (lab2)
    pmm_manager = &default_pmm_manager;
ffffffffc0201afc:	00010b97          	auipc	s7,0x10
ffffffffc0201b00:	a34b8b93          	addi	s7,s7,-1484 # ffffffffc0211530 <pmm_manager>
void pmm_init(void) {
ffffffffc0201b04:	f486                	sd	ra,104(sp)
ffffffffc0201b06:	f0a2                	sd	s0,96(sp)
ffffffffc0201b08:	eca6                	sd	s1,88(sp)
ffffffffc0201b0a:	e8ca                	sd	s2,80(sp)
ffffffffc0201b0c:	e4ce                	sd	s3,72(sp)
ffffffffc0201b0e:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201b10:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0201b14:	e0d2                	sd	s4,64(sp)
ffffffffc0201b16:	fc56                	sd	s5,56(sp)
ffffffffc0201b18:	f062                	sd	s8,32(sp)
ffffffffc0201b1a:	ec66                	sd	s9,24(sp)
ffffffffc0201b1c:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201b1e:	da2fe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    pmm_manager->init();
ffffffffc0201b22:	000bb783          	ld	a5,0(s7)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0201b26:	4445                	li	s0,17
ffffffffc0201b28:	40100913          	li	s2,1025
    pmm_manager->init();
ffffffffc0201b2c:	679c                	ld	a5,8(a5)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201b2e:	00010997          	auipc	s3,0x10
ffffffffc0201b32:	a0a98993          	addi	s3,s3,-1526 # ffffffffc0211538 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0201b36:	00010497          	auipc	s1,0x10
ffffffffc0201b3a:	9ea48493          	addi	s1,s1,-1558 # ffffffffc0211520 <npage>
    pmm_manager->init();
ffffffffc0201b3e:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201b40:	57f5                	li	a5,-3
ffffffffc0201b42:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0201b44:	07e006b7          	lui	a3,0x7e00
ffffffffc0201b48:	01b41613          	slli	a2,s0,0x1b
ffffffffc0201b4c:	01591593          	slli	a1,s2,0x15
ffffffffc0201b50:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201b54:	73050513          	addi	a0,a0,1840 # ffffffffc0205280 <default_pmm_manager+0xe0>
=======
ffffffffc0201b54:	71850513          	addi	a0,a0,1816 # ffffffffc0205268 <default_pmm_manager+0xe0>
>>>>>>> 747620b (lab2)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201b58:	00f9b023          	sd	a5,0(s3)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0201b5c:	d64fe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0201b60:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201b64:	75050513          	addi	a0,a0,1872 # ffffffffc02052b0 <default_pmm_manager+0x110>
=======
ffffffffc0201b64:	73850513          	addi	a0,a0,1848 # ffffffffc0205298 <default_pmm_manager+0x110>
>>>>>>> 747620b (lab2)
ffffffffc0201b68:	d58fe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201b6c:	01b41693          	slli	a3,s0,0x1b
ffffffffc0201b70:	16fd                	addi	a3,a3,-1
ffffffffc0201b72:	07e005b7          	lui	a1,0x7e00
ffffffffc0201b76:	01591613          	slli	a2,s2,0x15
ffffffffc0201b7a:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201b7e:	74e50513          	addi	a0,a0,1870 # ffffffffc02052c8 <default_pmm_manager+0x128>
=======
ffffffffc0201b7e:	73650513          	addi	a0,a0,1846 # ffffffffc02052b0 <default_pmm_manager+0x128>
>>>>>>> 747620b (lab2)
ffffffffc0201b82:	d3efe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201b86:	777d                	lui	a4,0xfffff
ffffffffc0201b88:	00011797          	auipc	a5,0x11
ffffffffc0201b8c:	9e378793          	addi	a5,a5,-1565 # ffffffffc021256b <end+0xfff>
ffffffffc0201b90:	8ff9                	and	a5,a5,a4
ffffffffc0201b92:	00010b17          	auipc	s6,0x10
ffffffffc0201b96:	996b0b13          	addi	s6,s6,-1642 # ffffffffc0211528 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201b9a:	00088737          	lui	a4,0x88
ffffffffc0201b9e:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201ba0:	00fb3023          	sd	a5,0(s6)
ffffffffc0201ba4:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201ba6:	4701                	li	a4,0
ffffffffc0201ba8:	4505                	li	a0,1
ffffffffc0201baa:	fff805b7          	lui	a1,0xfff80
ffffffffc0201bae:	a019                	j	ffffffffc0201bb4 <pmm_init+0xce>
        SetPageReserved(pages + i);
ffffffffc0201bb0:	000b3783          	ld	a5,0(s6)
ffffffffc0201bb4:	97b6                	add	a5,a5,a3
ffffffffc0201bb6:	07a1                	addi	a5,a5,8
ffffffffc0201bb8:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201bbc:	609c                	ld	a5,0(s1)
ffffffffc0201bbe:	0705                	addi	a4,a4,1
ffffffffc0201bc0:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc0201bc4:	00b78633          	add	a2,a5,a1
ffffffffc0201bc8:	fec764e3          	bltu	a4,a2,ffffffffc0201bb0 <pmm_init+0xca>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201bcc:	000b3503          	ld	a0,0(s6)
ffffffffc0201bd0:	00379693          	slli	a3,a5,0x3
ffffffffc0201bd4:	96be                	add	a3,a3,a5
ffffffffc0201bd6:	fdc00737          	lui	a4,0xfdc00
ffffffffc0201bda:	972a                	add	a4,a4,a0
ffffffffc0201bdc:	068e                	slli	a3,a3,0x3
ffffffffc0201bde:	96ba                	add	a3,a3,a4
ffffffffc0201be0:	c0200737          	lui	a4,0xc0200
ffffffffc0201be4:	64e6e463          	bltu	a3,a4,ffffffffc020222c <pmm_init+0x746>
ffffffffc0201be8:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc0201bec:	4645                	li	a2,17
ffffffffc0201bee:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201bf0:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201bf2:	4ec6e263          	bltu	a3,a2,ffffffffc02020d6 <pmm_init+0x5f0>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201bf6:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201bfa:	00010917          	auipc	s2,0x10
ffffffffc0201bfe:	91e90913          	addi	s2,s2,-1762 # ffffffffc0211518 <boot_pgdir>
    pmm_manager->check();
ffffffffc0201c02:	7b9c                	ld	a5,48(a5)
ffffffffc0201c04:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201c06:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201c0a:	71250513          	addi	a0,a0,1810 # ffffffffc0205318 <default_pmm_manager+0x178>
=======
ffffffffc0201c0a:	6fa50513          	addi	a0,a0,1786 # ffffffffc0205300 <default_pmm_manager+0x178>
>>>>>>> 747620b (lab2)
ffffffffc0201c0e:	cb2fe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201c12:	00007697          	auipc	a3,0x7
ffffffffc0201c16:	3ee68693          	addi	a3,a3,1006 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0201c1a:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201c1e:	c02007b7          	lui	a5,0xc0200
ffffffffc0201c22:	62f6e163          	bltu	a3,a5,ffffffffc0202244 <pmm_init+0x75e>
ffffffffc0201c26:	0009b783          	ld	a5,0(s3)
ffffffffc0201c2a:	8e9d                	sub	a3,a3,a5
ffffffffc0201c2c:	00010797          	auipc	a5,0x10
ffffffffc0201c30:	8ed7b223          	sd	a3,-1820(a5) # ffffffffc0211510 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c34:	100027f3          	csrr	a5,sstatus
ffffffffc0201c38:	8b89                	andi	a5,a5,2
ffffffffc0201c3a:	4c079763          	bnez	a5,ffffffffc0202108 <pmm_init+0x622>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0201c3e:	000bb783          	ld	a5,0(s7)
ffffffffc0201c42:	779c                	ld	a5,40(a5)
ffffffffc0201c44:	9782                	jalr	a5
ffffffffc0201c46:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0201c48:	6098                	ld	a4,0(s1)
ffffffffc0201c4a:	c80007b7          	lui	a5,0xc8000
ffffffffc0201c4e:	83b1                	srli	a5,a5,0xc
ffffffffc0201c50:	62e7e663          	bltu	a5,a4,ffffffffc020227c <pmm_init+0x796>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0201c54:	00093503          	ld	a0,0(s2)
ffffffffc0201c58:	60050263          	beqz	a0,ffffffffc020225c <pmm_init+0x776>
ffffffffc0201c5c:	03451793          	slli	a5,a0,0x34
ffffffffc0201c60:	5e079e63          	bnez	a5,ffffffffc020225c <pmm_init+0x776>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0201c64:	4601                	li	a2,0
ffffffffc0201c66:	4581                	li	a1,0
ffffffffc0201c68:	c8bff0ef          	jal	ra,ffffffffc02018f2 <get_page>
ffffffffc0201c6c:	66051a63          	bnez	a0,ffffffffc02022e0 <pmm_init+0x7fa>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc0201c70:	4505                	li	a0,1
ffffffffc0201c72:	97fff0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0201c76:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0201c78:	00093503          	ld	a0,0(s2)
ffffffffc0201c7c:	4681                	li	a3,0
ffffffffc0201c7e:	4601                	li	a2,0
ffffffffc0201c80:	85d2                	mv	a1,s4
ffffffffc0201c82:	d65ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0201c86:	62051d63          	bnez	a0,ffffffffc02022c0 <pmm_init+0x7da>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0201c8a:	00093503          	ld	a0,0(s2)
ffffffffc0201c8e:	4601                	li	a2,0
ffffffffc0201c90:	4581                	li	a1,0
ffffffffc0201c92:	a6bff0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0201c96:	60050563          	beqz	a0,ffffffffc02022a0 <pmm_init+0x7ba>
    assert(pte2page(*ptep) == p1);
ffffffffc0201c9a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0201c9c:	0017f713          	andi	a4,a5,1
ffffffffc0201ca0:	5e070e63          	beqz	a4,ffffffffc020229c <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc0201ca4:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201ca6:	078a                	slli	a5,a5,0x2
ffffffffc0201ca8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201caa:	56c7ff63          	bgeu	a5,a2,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201cae:	fff80737          	lui	a4,0xfff80
ffffffffc0201cb2:	97ba                	add	a5,a5,a4
ffffffffc0201cb4:	000b3683          	ld	a3,0(s6)
ffffffffc0201cb8:	00379713          	slli	a4,a5,0x3
ffffffffc0201cbc:	97ba                	add	a5,a5,a4
ffffffffc0201cbe:	078e                	slli	a5,a5,0x3
ffffffffc0201cc0:	97b6                	add	a5,a5,a3
ffffffffc0201cc2:	14fa18e3          	bne	s4,a5,ffffffffc0202612 <pmm_init+0xb2c>
    assert(page_ref(p1) == 1);
ffffffffc0201cc6:	000a2703          	lw	a4,0(s4)
ffffffffc0201cca:	4785                	li	a5,1
ffffffffc0201ccc:	16f71fe3          	bne	a4,a5,ffffffffc020264a <pmm_init+0xb64>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0201cd0:	00093503          	ld	a0,0(s2)
ffffffffc0201cd4:	77fd                	lui	a5,0xfffff
ffffffffc0201cd6:	6114                	ld	a3,0(a0)
ffffffffc0201cd8:	068a                	slli	a3,a3,0x2
ffffffffc0201cda:	8efd                	and	a3,a3,a5
ffffffffc0201cdc:	00c6d713          	srli	a4,a3,0xc
ffffffffc0201ce0:	14c779e3          	bgeu	a4,a2,ffffffffc0202632 <pmm_init+0xb4c>
ffffffffc0201ce4:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201ce8:	96e2                	add	a3,a3,s8
ffffffffc0201cea:	0006ba83          	ld	s5,0(a3)
ffffffffc0201cee:	0a8a                	slli	s5,s5,0x2
ffffffffc0201cf0:	00fafab3          	and	s5,s5,a5
ffffffffc0201cf4:	00cad793          	srli	a5,s5,0xc
ffffffffc0201cf8:	66c7f463          	bgeu	a5,a2,ffffffffc0202360 <pmm_init+0x87a>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201cfc:	4601                	li	a2,0
ffffffffc0201cfe:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201d00:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201d02:	9fbff0ef          	jal	ra,ffffffffc02016fc <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201d06:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201d08:	63551c63          	bne	a0,s5,ffffffffc0202340 <pmm_init+0x85a>

    p2 = alloc_page();
ffffffffc0201d0c:	4505                	li	a0,1
ffffffffc0201d0e:	8e3ff0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0201d12:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0201d14:	00093503          	ld	a0,0(s2)
ffffffffc0201d18:	46d1                	li	a3,20
ffffffffc0201d1a:	6605                	lui	a2,0x1
ffffffffc0201d1c:	85d6                	mv	a1,s5
ffffffffc0201d1e:	cc9ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0201d22:	5c051f63          	bnez	a0,ffffffffc0202300 <pmm_init+0x81a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201d26:	00093503          	ld	a0,0(s2)
ffffffffc0201d2a:	4601                	li	a2,0
ffffffffc0201d2c:	6585                	lui	a1,0x1
ffffffffc0201d2e:	9cfff0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0201d32:	12050ce3          	beqz	a0,ffffffffc020266a <pmm_init+0xb84>
    assert(*ptep & PTE_U);
ffffffffc0201d36:	611c                	ld	a5,0(a0)
ffffffffc0201d38:	0107f713          	andi	a4,a5,16
ffffffffc0201d3c:	72070f63          	beqz	a4,ffffffffc020247a <pmm_init+0x994>
    assert(*ptep & PTE_W);
ffffffffc0201d40:	8b91                	andi	a5,a5,4
ffffffffc0201d42:	6e078c63          	beqz	a5,ffffffffc020243a <pmm_init+0x954>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0201d46:	00093503          	ld	a0,0(s2)
ffffffffc0201d4a:	611c                	ld	a5,0(a0)
ffffffffc0201d4c:	8bc1                	andi	a5,a5,16
ffffffffc0201d4e:	6c078663          	beqz	a5,ffffffffc020241a <pmm_init+0x934>
    assert(page_ref(p2) == 1);
ffffffffc0201d52:	000aa703          	lw	a4,0(s5)
ffffffffc0201d56:	4785                	li	a5,1
ffffffffc0201d58:	5cf71463          	bne	a4,a5,ffffffffc0202320 <pmm_init+0x83a>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0201d5c:	4681                	li	a3,0
ffffffffc0201d5e:	6605                	lui	a2,0x1
ffffffffc0201d60:	85d2                	mv	a1,s4
ffffffffc0201d62:	c85ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0201d66:	66051a63          	bnez	a0,ffffffffc02023da <pmm_init+0x8f4>
    assert(page_ref(p1) == 2);
ffffffffc0201d6a:	000a2703          	lw	a4,0(s4)
ffffffffc0201d6e:	4789                	li	a5,2
ffffffffc0201d70:	64f71563          	bne	a4,a5,ffffffffc02023ba <pmm_init+0x8d4>
    assert(page_ref(p2) == 0);
ffffffffc0201d74:	000aa783          	lw	a5,0(s5)
ffffffffc0201d78:	62079163          	bnez	a5,ffffffffc020239a <pmm_init+0x8b4>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201d7c:	00093503          	ld	a0,0(s2)
ffffffffc0201d80:	4601                	li	a2,0
ffffffffc0201d82:	6585                	lui	a1,0x1
ffffffffc0201d84:	979ff0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0201d88:	5e050963          	beqz	a0,ffffffffc020237a <pmm_init+0x894>
    assert(pte2page(*ptep) == p1);
ffffffffc0201d8c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0201d8e:	00177793          	andi	a5,a4,1
ffffffffc0201d92:	50078563          	beqz	a5,ffffffffc020229c <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc0201d96:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201d98:	00271793          	slli	a5,a4,0x2
ffffffffc0201d9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201d9e:	48d7f563          	bgeu	a5,a3,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201da2:	fff806b7          	lui	a3,0xfff80
ffffffffc0201da6:	97b6                	add	a5,a5,a3
ffffffffc0201da8:	000b3603          	ld	a2,0(s6)
ffffffffc0201dac:	00379693          	slli	a3,a5,0x3
ffffffffc0201db0:	97b6                	add	a5,a5,a3
ffffffffc0201db2:	078e                	slli	a5,a5,0x3
ffffffffc0201db4:	97b2                	add	a5,a5,a2
ffffffffc0201db6:	72fa1263          	bne	s4,a5,ffffffffc02024da <pmm_init+0x9f4>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201dba:	8b41                	andi	a4,a4,16
ffffffffc0201dbc:	6e071f63          	bnez	a4,ffffffffc02024ba <pmm_init+0x9d4>

    page_remove(boot_pgdir, 0x0);
ffffffffc0201dc0:	00093503          	ld	a0,0(s2)
ffffffffc0201dc4:	4581                	li	a1,0
ffffffffc0201dc6:	b87ff0ef          	jal	ra,ffffffffc020194c <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0201dca:	000a2703          	lw	a4,0(s4)
ffffffffc0201dce:	4785                	li	a5,1
ffffffffc0201dd0:	6cf71563          	bne	a4,a5,ffffffffc020249a <pmm_init+0x9b4>
    assert(page_ref(p2) == 0);
ffffffffc0201dd4:	000aa783          	lw	a5,0(s5)
ffffffffc0201dd8:	78079d63          	bnez	a5,ffffffffc0202572 <pmm_init+0xa8c>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0201ddc:	00093503          	ld	a0,0(s2)
ffffffffc0201de0:	6585                	lui	a1,0x1
ffffffffc0201de2:	b6bff0ef          	jal	ra,ffffffffc020194c <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0201de6:	000a2783          	lw	a5,0(s4)
ffffffffc0201dea:	76079463          	bnez	a5,ffffffffc0202552 <pmm_init+0xa6c>
    assert(page_ref(p2) == 0);
ffffffffc0201dee:	000aa783          	lw	a5,0(s5)
ffffffffc0201df2:	74079063          	bnez	a5,ffffffffc0202532 <pmm_init+0xa4c>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0201df6:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0201dfa:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201dfc:	000a3783          	ld	a5,0(s4)
ffffffffc0201e00:	078a                	slli	a5,a5,0x2
ffffffffc0201e02:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201e04:	42c7f263          	bgeu	a5,a2,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e08:	fff80737          	lui	a4,0xfff80
ffffffffc0201e0c:	973e                	add	a4,a4,a5
ffffffffc0201e0e:	00371793          	slli	a5,a4,0x3
ffffffffc0201e12:	000b3503          	ld	a0,0(s6)
ffffffffc0201e16:	97ba                	add	a5,a5,a4
ffffffffc0201e18:	078e                	slli	a5,a5,0x3
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0201e1a:	00f50733          	add	a4,a0,a5
ffffffffc0201e1e:	4314                	lw	a3,0(a4)
ffffffffc0201e20:	4705                	li	a4,1
ffffffffc0201e22:	6ee69863          	bne	a3,a4,ffffffffc0202512 <pmm_init+0xa2c>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201e26:	4037d693          	srai	a3,a5,0x3
ffffffffc0201e2a:	00004c97          	auipc	s9,0x4
<<<<<<< HEAD
ffffffffc0201e2e:	446cbc83          	ld	s9,1094(s9) # ffffffffc0206270 <error_string+0x38>
=======
ffffffffc0201e2e:	41ecbc83          	ld	s9,1054(s9) # ffffffffc0206248 <error_string+0x38>
>>>>>>> 747620b (lab2)
ffffffffc0201e32:	039686b3          	mul	a3,a3,s9
ffffffffc0201e36:	000805b7          	lui	a1,0x80
ffffffffc0201e3a:	96ae                	add	a3,a3,a1
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201e3c:	00c69713          	slli	a4,a3,0xc
ffffffffc0201e40:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e42:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201e44:	6ac77b63          	bgeu	a4,a2,ffffffffc02024fa <pmm_init+0xa14>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0201e48:	0009b703          	ld	a4,0(s3)
ffffffffc0201e4c:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0201e4e:	629c                	ld	a5,0(a3)
ffffffffc0201e50:	078a                	slli	a5,a5,0x2
ffffffffc0201e52:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201e54:	3cc7fa63          	bgeu	a5,a2,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e58:	8f8d                	sub	a5,a5,a1
ffffffffc0201e5a:	00379713          	slli	a4,a5,0x3
ffffffffc0201e5e:	97ba                	add	a5,a5,a4
ffffffffc0201e60:	078e                	slli	a5,a5,0x3
ffffffffc0201e62:	953e                	add	a0,a0,a5
ffffffffc0201e64:	100027f3          	csrr	a5,sstatus
ffffffffc0201e68:	8b89                	andi	a5,a5,2
ffffffffc0201e6a:	2e079963          	bnez	a5,ffffffffc020215c <pmm_init+0x676>
    { pmm_manager->free_pages(base, n); }
ffffffffc0201e6e:	000bb783          	ld	a5,0(s7)
ffffffffc0201e72:	4585                	li	a1,1
ffffffffc0201e74:	739c                	ld	a5,32(a5)
ffffffffc0201e76:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0201e78:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0201e7c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201e7e:	078a                	slli	a5,a5,0x2
ffffffffc0201e80:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201e82:	3ae7f363          	bgeu	a5,a4,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e86:	fff80737          	lui	a4,0xfff80
ffffffffc0201e8a:	97ba                	add	a5,a5,a4
ffffffffc0201e8c:	000b3503          	ld	a0,0(s6)
ffffffffc0201e90:	00379713          	slli	a4,a5,0x3
ffffffffc0201e94:	97ba                	add	a5,a5,a4
ffffffffc0201e96:	078e                	slli	a5,a5,0x3
ffffffffc0201e98:	953e                	add	a0,a0,a5
ffffffffc0201e9a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e9e:	8b89                	andi	a5,a5,2
ffffffffc0201ea0:	2a079263          	bnez	a5,ffffffffc0202144 <pmm_init+0x65e>
ffffffffc0201ea4:	000bb783          	ld	a5,0(s7)
ffffffffc0201ea8:	4585                	li	a1,1
ffffffffc0201eaa:	739c                	ld	a5,32(a5)
ffffffffc0201eac:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0201eae:	00093783          	ld	a5,0(s2)
ffffffffc0201eb2:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda94>
ffffffffc0201eb6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eba:	8b89                	andi	a5,a5,2
ffffffffc0201ebc:	26079a63          	bnez	a5,ffffffffc0202130 <pmm_init+0x64a>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0201ec0:	000bb783          	ld	a5,0(s7)
ffffffffc0201ec4:	779c                	ld	a5,40(a5)
ffffffffc0201ec6:	9782                	jalr	a5
ffffffffc0201ec8:	8a2a                	mv	s4,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc0201eca:	73441463          	bne	s0,s4,ffffffffc02025f2 <pmm_init+0xb0c>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0201ece:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0201ed2:	73250513          	addi	a0,a0,1842 # ffffffffc0205600 <default_pmm_manager+0x460>
=======
ffffffffc0201ed2:	71a50513          	addi	a0,a0,1818 # ffffffffc02055e8 <default_pmm_manager+0x460>
>>>>>>> 747620b (lab2)
ffffffffc0201ed6:	9eafe0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc0201eda:	100027f3          	csrr	a5,sstatus
ffffffffc0201ede:	8b89                	andi	a5,a5,2
ffffffffc0201ee0:	22079e63          	bnez	a5,ffffffffc020211c <pmm_init+0x636>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0201ee4:	000bb783          	ld	a5,0(s7)
ffffffffc0201ee8:	779c                	ld	a5,40(a5)
ffffffffc0201eea:	9782                	jalr	a5
ffffffffc0201eec:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201eee:	6098                	ld	a4,0(s1)
ffffffffc0201ef0:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201ef4:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201ef6:	00c71793          	slli	a5,a4,0xc
ffffffffc0201efa:	6a05                	lui	s4,0x1
ffffffffc0201efc:	02f47c63          	bgeu	s0,a5,ffffffffc0201f34 <pmm_init+0x44e>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201f00:	00c45793          	srli	a5,s0,0xc
ffffffffc0201f04:	00093503          	ld	a0,0(s2)
ffffffffc0201f08:	30e7f363          	bgeu	a5,a4,ffffffffc020220e <pmm_init+0x728>
ffffffffc0201f0c:	0009b583          	ld	a1,0(s3)
ffffffffc0201f10:	4601                	li	a2,0
ffffffffc0201f12:	95a2                	add	a1,a1,s0
ffffffffc0201f14:	fe8ff0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0201f18:	2c050b63          	beqz	a0,ffffffffc02021ee <pmm_init+0x708>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201f1c:	611c                	ld	a5,0(a0)
ffffffffc0201f1e:	078a                	slli	a5,a5,0x2
ffffffffc0201f20:	0157f7b3          	and	a5,a5,s5
ffffffffc0201f24:	2a879563          	bne	a5,s0,ffffffffc02021ce <pmm_init+0x6e8>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201f28:	6098                	ld	a4,0(s1)
ffffffffc0201f2a:	9452                	add	s0,s0,s4
ffffffffc0201f2c:	00c71793          	slli	a5,a4,0xc
ffffffffc0201f30:	fcf468e3          	bltu	s0,a5,ffffffffc0201f00 <pmm_init+0x41a>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc0201f34:	00093783          	ld	a5,0(s2)
ffffffffc0201f38:	639c                	ld	a5,0(a5)
ffffffffc0201f3a:	68079c63          	bnez	a5,ffffffffc02025d2 <pmm_init+0xaec>

    struct Page *p;
    p = alloc_page();
ffffffffc0201f3e:	4505                	li	a0,1
ffffffffc0201f40:	eb0ff0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0201f44:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201f46:	00093503          	ld	a0,0(s2)
ffffffffc0201f4a:	4699                	li	a3,6
ffffffffc0201f4c:	10000613          	li	a2,256
ffffffffc0201f50:	85d6                	mv	a1,s5
ffffffffc0201f52:	a95ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0201f56:	64051e63          	bnez	a0,ffffffffc02025b2 <pmm_init+0xacc>
    assert(page_ref(p) == 1);
ffffffffc0201f5a:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda94>
ffffffffc0201f5e:	4785                	li	a5,1
ffffffffc0201f60:	62f71963          	bne	a4,a5,ffffffffc0202592 <pmm_init+0xaac>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201f64:	00093503          	ld	a0,0(s2)
ffffffffc0201f68:	6405                	lui	s0,0x1
ffffffffc0201f6a:	4699                	li	a3,6
ffffffffc0201f6c:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0201f70:	85d6                	mv	a1,s5
ffffffffc0201f72:	a75ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0201f76:	48051263          	bnez	a0,ffffffffc02023fa <pmm_init+0x914>
    assert(page_ref(p) == 2);
ffffffffc0201f7a:	000aa703          	lw	a4,0(s5)
ffffffffc0201f7e:	4789                	li	a5,2
ffffffffc0201f80:	74f71563          	bne	a4,a5,ffffffffc02026ca <pmm_init+0xbe4>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0201f84:	00003597          	auipc	a1,0x3
<<<<<<< HEAD
ffffffffc0201f88:	7b458593          	addi	a1,a1,1972 # ffffffffc0205738 <default_pmm_manager+0x598>
ffffffffc0201f8c:	10000513          	li	a0,256
ffffffffc0201f90:	418020ef          	jal	ra,ffffffffc02043a8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201f94:	10040593          	addi	a1,s0,256
ffffffffc0201f98:	10000513          	li	a0,256
ffffffffc0201f9c:	41e020ef          	jal	ra,ffffffffc02043ba <strcmp>
=======
ffffffffc0201f88:	79c58593          	addi	a1,a1,1948 # ffffffffc0205720 <default_pmm_manager+0x598>
ffffffffc0201f8c:	10000513          	li	a0,256
ffffffffc0201f90:	3fa020ef          	jal	ra,ffffffffc020438a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201f94:	10040593          	addi	a1,s0,256
ffffffffc0201f98:	10000513          	li	a0,256
ffffffffc0201f9c:	400020ef          	jal	ra,ffffffffc020439c <strcmp>
>>>>>>> 747620b (lab2)
ffffffffc0201fa0:	70051563          	bnez	a0,ffffffffc02026aa <pmm_init+0xbc4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201fa4:	000b3683          	ld	a3,0(s6)
ffffffffc0201fa8:	00080d37          	lui	s10,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201fac:	547d                	li	s0,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201fae:	40da86b3          	sub	a3,s5,a3
ffffffffc0201fb2:	868d                	srai	a3,a3,0x3
ffffffffc0201fb4:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201fb8:	609c                	ld	a5,0(s1)
ffffffffc0201fba:	8031                	srli	s0,s0,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201fbc:	96ea                	add	a3,a3,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201fbe:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fc2:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201fc4:	52f77b63          	bgeu	a4,a5,ffffffffc02024fa <pmm_init+0xa14>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201fc8:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201fcc:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201fd0:	96be                	add	a3,a3,a5
ffffffffc0201fd2:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb94>
    assert(strlen((const char *)0x100) == 0);
<<<<<<< HEAD
ffffffffc0201fd6:	39c020ef          	jal	ra,ffffffffc0204372 <strlen>
=======
ffffffffc0201fd6:	37e020ef          	jal	ra,ffffffffc0204354 <strlen>
>>>>>>> 747620b (lab2)
ffffffffc0201fda:	6a051863          	bnez	a0,ffffffffc020268a <pmm_init+0xba4>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0201fde:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0201fe2:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201fe4:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201fe8:	078a                	slli	a5,a5,0x2
ffffffffc0201fea:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201fec:	22e7fe63          	bgeu	a5,a4,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0201ff0:	41a787b3          	sub	a5,a5,s10
ffffffffc0201ff4:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201ff8:	96be                	add	a3,a3,a5
ffffffffc0201ffa:	03968cb3          	mul	s9,a3,s9
ffffffffc0201ffe:	01ac86b3          	add	a3,s9,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0202002:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202004:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0202006:	4ee47a63          	bgeu	s0,a4,ffffffffc02024fa <pmm_init+0xa14>
ffffffffc020200a:	0009b403          	ld	s0,0(s3)
ffffffffc020200e:	9436                	add	s0,s0,a3
ffffffffc0202010:	100027f3          	csrr	a5,sstatus
ffffffffc0202014:	8b89                	andi	a5,a5,2
ffffffffc0202016:	1a079163          	bnez	a5,ffffffffc02021b8 <pmm_init+0x6d2>
    { pmm_manager->free_pages(base, n); }
ffffffffc020201a:	000bb783          	ld	a5,0(s7)
ffffffffc020201e:	4585                	li	a1,1
ffffffffc0202020:	8556                	mv	a0,s5
ffffffffc0202022:	739c                	ld	a5,32(a5)
ffffffffc0202024:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202026:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202028:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020202a:	078a                	slli	a5,a5,0x2
ffffffffc020202c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020202e:	1ee7fd63          	bgeu	a5,a4,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0202032:	fff80737          	lui	a4,0xfff80
ffffffffc0202036:	97ba                	add	a5,a5,a4
ffffffffc0202038:	000b3503          	ld	a0,0(s6)
ffffffffc020203c:	00379713          	slli	a4,a5,0x3
ffffffffc0202040:	97ba                	add	a5,a5,a4
ffffffffc0202042:	078e                	slli	a5,a5,0x3
ffffffffc0202044:	953e                	add	a0,a0,a5
ffffffffc0202046:	100027f3          	csrr	a5,sstatus
ffffffffc020204a:	8b89                	andi	a5,a5,2
ffffffffc020204c:	14079a63          	bnez	a5,ffffffffc02021a0 <pmm_init+0x6ba>
ffffffffc0202050:	000bb783          	ld	a5,0(s7)
ffffffffc0202054:	4585                	li	a1,1
ffffffffc0202056:	739c                	ld	a5,32(a5)
ffffffffc0202058:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020205a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc020205e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202060:	078a                	slli	a5,a5,0x2
ffffffffc0202062:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202064:	1ce7f263          	bgeu	a5,a4,ffffffffc0202228 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0202068:	fff80737          	lui	a4,0xfff80
ffffffffc020206c:	97ba                	add	a5,a5,a4
ffffffffc020206e:	000b3503          	ld	a0,0(s6)
ffffffffc0202072:	00379713          	slli	a4,a5,0x3
ffffffffc0202076:	97ba                	add	a5,a5,a4
ffffffffc0202078:	078e                	slli	a5,a5,0x3
ffffffffc020207a:	953e                	add	a0,a0,a5
ffffffffc020207c:	100027f3          	csrr	a5,sstatus
ffffffffc0202080:	8b89                	andi	a5,a5,2
ffffffffc0202082:	10079363          	bnez	a5,ffffffffc0202188 <pmm_init+0x6a2>
ffffffffc0202086:	000bb783          	ld	a5,0(s7)
ffffffffc020208a:	4585                	li	a1,1
ffffffffc020208c:	739c                	ld	a5,32(a5)
ffffffffc020208e:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0202090:	00093783          	ld	a5,0(s2)
ffffffffc0202094:	0007b023          	sd	zero,0(a5)
ffffffffc0202098:	100027f3          	csrr	a5,sstatus
ffffffffc020209c:	8b89                	andi	a5,a5,2
ffffffffc020209e:	0c079b63          	bnez	a5,ffffffffc0202174 <pmm_init+0x68e>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02020a2:	000bb783          	ld	a5,0(s7)
ffffffffc02020a6:	779c                	ld	a5,40(a5)
ffffffffc02020a8:	9782                	jalr	a5
ffffffffc02020aa:	842a                	mv	s0,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02020ac:	3a8c1763          	bne	s8,s0,ffffffffc020245a <pmm_init+0x974>
}
ffffffffc02020b0:	7406                	ld	s0,96(sp)
ffffffffc02020b2:	70a6                	ld	ra,104(sp)
ffffffffc02020b4:	64e6                	ld	s1,88(sp)
ffffffffc02020b6:	6946                	ld	s2,80(sp)
ffffffffc02020b8:	69a6                	ld	s3,72(sp)
ffffffffc02020ba:	6a06                	ld	s4,64(sp)
ffffffffc02020bc:	7ae2                	ld	s5,56(sp)
ffffffffc02020be:	7b42                	ld	s6,48(sp)
ffffffffc02020c0:	7ba2                	ld	s7,40(sp)
ffffffffc02020c2:	7c02                	ld	s8,32(sp)
ffffffffc02020c4:	6ce2                	ld	s9,24(sp)
ffffffffc02020c6:	6d42                	ld	s10,16(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02020c8:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc02020cc:	6e850513          	addi	a0,a0,1768 # ffffffffc02057b0 <default_pmm_manager+0x610>
=======
ffffffffc02020cc:	6d050513          	addi	a0,a0,1744 # ffffffffc0205798 <default_pmm_manager+0x610>
>>>>>>> 747620b (lab2)
}
ffffffffc02020d0:	6165                	addi	sp,sp,112
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02020d2:	feffd06f          	j	ffffffffc02000c0 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02020d6:	6705                	lui	a4,0x1
ffffffffc02020d8:	177d                	addi	a4,a4,-1
ffffffffc02020da:	96ba                	add	a3,a3,a4
ffffffffc02020dc:	777d                	lui	a4,0xfffff
ffffffffc02020de:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc02020e0:	00c75693          	srli	a3,a4,0xc
ffffffffc02020e4:	14f6f263          	bgeu	a3,a5,ffffffffc0202228 <pmm_init+0x742>
    pmm_manager->init_memmap(base, n);
ffffffffc02020e8:	000bb803          	ld	a6,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc02020ec:	95b6                	add	a1,a1,a3
ffffffffc02020ee:	00359793          	slli	a5,a1,0x3
ffffffffc02020f2:	97ae                	add	a5,a5,a1
ffffffffc02020f4:	01083683          	ld	a3,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02020f8:	40e60733          	sub	a4,a2,a4
ffffffffc02020fc:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02020fe:	00c75593          	srli	a1,a4,0xc
ffffffffc0202102:	953e                	add	a0,a0,a5
ffffffffc0202104:	9682                	jalr	a3
}
ffffffffc0202106:	bcc5                	j	ffffffffc0201bf6 <pmm_init+0x110>
        intr_disable();
ffffffffc0202108:	becfe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc020210c:	000bb783          	ld	a5,0(s7)
ffffffffc0202110:	779c                	ld	a5,40(a5)
ffffffffc0202112:	9782                	jalr	a5
ffffffffc0202114:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202116:	bd8fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc020211a:	b63d                	j	ffffffffc0201c48 <pmm_init+0x162>
        intr_disable();
ffffffffc020211c:	bd8fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc0202120:	000bb783          	ld	a5,0(s7)
ffffffffc0202124:	779c                	ld	a5,40(a5)
ffffffffc0202126:	9782                	jalr	a5
ffffffffc0202128:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020212a:	bc4fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc020212e:	b3c1                	j	ffffffffc0201eee <pmm_init+0x408>
        intr_disable();
ffffffffc0202130:	bc4fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc0202134:	000bb783          	ld	a5,0(s7)
ffffffffc0202138:	779c                	ld	a5,40(a5)
ffffffffc020213a:	9782                	jalr	a5
ffffffffc020213c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020213e:	bb0fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc0202142:	b361                	j	ffffffffc0201eca <pmm_init+0x3e4>
ffffffffc0202144:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202146:	baefe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc020214a:	000bb783          	ld	a5,0(s7)
ffffffffc020214e:	6522                	ld	a0,8(sp)
ffffffffc0202150:	4585                	li	a1,1
ffffffffc0202152:	739c                	ld	a5,32(a5)
ffffffffc0202154:	9782                	jalr	a5
        intr_enable();
ffffffffc0202156:	b98fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc020215a:	bb91                	j	ffffffffc0201eae <pmm_init+0x3c8>
ffffffffc020215c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020215e:	b96fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc0202162:	000bb783          	ld	a5,0(s7)
ffffffffc0202166:	6522                	ld	a0,8(sp)
ffffffffc0202168:	4585                	li	a1,1
ffffffffc020216a:	739c                	ld	a5,32(a5)
ffffffffc020216c:	9782                	jalr	a5
        intr_enable();
ffffffffc020216e:	b80fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc0202172:	b319                	j	ffffffffc0201e78 <pmm_init+0x392>
        intr_disable();
ffffffffc0202174:	b80fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202178:	000bb783          	ld	a5,0(s7)
ffffffffc020217c:	779c                	ld	a5,40(a5)
ffffffffc020217e:	9782                	jalr	a5
ffffffffc0202180:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202182:	b6cfe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc0202186:	b71d                	j	ffffffffc02020ac <pmm_init+0x5c6>
ffffffffc0202188:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020218a:	b6afe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc020218e:	000bb783          	ld	a5,0(s7)
ffffffffc0202192:	6522                	ld	a0,8(sp)
ffffffffc0202194:	4585                	li	a1,1
ffffffffc0202196:	739c                	ld	a5,32(a5)
ffffffffc0202198:	9782                	jalr	a5
        intr_enable();
ffffffffc020219a:	b54fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc020219e:	bdcd                	j	ffffffffc0202090 <pmm_init+0x5aa>
ffffffffc02021a0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02021a2:	b52fe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc02021a6:	000bb783          	ld	a5,0(s7)
ffffffffc02021aa:	6522                	ld	a0,8(sp)
ffffffffc02021ac:	4585                	li	a1,1
ffffffffc02021ae:	739c                	ld	a5,32(a5)
ffffffffc02021b0:	9782                	jalr	a5
        intr_enable();
ffffffffc02021b2:	b3cfe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc02021b6:	b555                	j	ffffffffc020205a <pmm_init+0x574>
        intr_disable();
ffffffffc02021b8:	b3cfe0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc02021bc:	000bb783          	ld	a5,0(s7)
ffffffffc02021c0:	4585                	li	a1,1
ffffffffc02021c2:	8556                	mv	a0,s5
ffffffffc02021c4:	739c                	ld	a5,32(a5)
ffffffffc02021c6:	9782                	jalr	a5
        intr_enable();
ffffffffc02021c8:	b26fe0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc02021cc:	bda9                	j	ffffffffc0202026 <pmm_init+0x540>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02021ce:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc02021d2:	49268693          	addi	a3,a3,1170 # ffffffffc0205660 <default_pmm_manager+0x4c0>
ffffffffc02021d6:	00003617          	auipc	a2,0x3
ffffffffc02021da:	c1a60613          	addi	a2,a2,-998 # ffffffffc0204df0 <commands+0x780>
ffffffffc02021de:	1ce00593          	li	a1,462
ffffffffc02021e2:	00003517          	auipc	a0,0x3
ffffffffc02021e6:	07650513          	addi	a0,a0,118 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02021ea:	990fe0ef          	jal	ra,ffffffffc020037a <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02021ee:	00003697          	auipc	a3,0x3
ffffffffc02021f2:	43268693          	addi	a3,a3,1074 # ffffffffc0205620 <default_pmm_manager+0x480>
ffffffffc02021f6:	00003617          	auipc	a2,0x3
ffffffffc02021fa:	bfa60613          	addi	a2,a2,-1030 # ffffffffc0204df0 <commands+0x780>
ffffffffc02021fe:	1cd00593          	li	a1,461
ffffffffc0202202:	00003517          	auipc	a0,0x3
ffffffffc0202206:	05650513          	addi	a0,a0,86 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020220a:	970fe0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc020220e:	86a2                	mv	a3,s0
ffffffffc0202210:	00003617          	auipc	a2,0x3
ffffffffc0202214:	02060613          	addi	a2,a2,32 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0202218:	1cd00593          	li	a1,461
ffffffffc020221c:	00003517          	auipc	a0,0x3
ffffffffc0202220:	03c50513          	addi	a0,a0,60 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc02021d2:	47a68693          	addi	a3,a3,1146 # ffffffffc0205648 <default_pmm_manager+0x4c0>
ffffffffc02021d6:	00003617          	auipc	a2,0x3
ffffffffc02021da:	c0260613          	addi	a2,a2,-1022 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02021de:	1ce00593          	li	a1,462
ffffffffc02021e2:	00003517          	auipc	a0,0x3
ffffffffc02021e6:	05e50513          	addi	a0,a0,94 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02021ea:	990fe0ef          	jal	ra,ffffffffc020037a <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02021ee:	00003697          	auipc	a3,0x3
ffffffffc02021f2:	41a68693          	addi	a3,a3,1050 # ffffffffc0205608 <default_pmm_manager+0x480>
ffffffffc02021f6:	00003617          	auipc	a2,0x3
ffffffffc02021fa:	be260613          	addi	a2,a2,-1054 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02021fe:	1cd00593          	li	a1,461
ffffffffc0202202:	00003517          	auipc	a0,0x3
ffffffffc0202206:	03e50513          	addi	a0,a0,62 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020220a:	970fe0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc020220e:	86a2                	mv	a3,s0
ffffffffc0202210:	00003617          	auipc	a2,0x3
ffffffffc0202214:	00860613          	addi	a2,a2,8 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0202218:	1cd00593          	li	a1,461
ffffffffc020221c:	00003517          	auipc	a0,0x3
ffffffffc0202220:	02450513          	addi	a0,a0,36 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc0202224:	956fe0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0202228:	b90ff0ef          	jal	ra,ffffffffc02015b8 <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020222c:	00003617          	auipc	a2,0x3
<<<<<<< HEAD
ffffffffc0202230:	0c460613          	addi	a2,a2,196 # ffffffffc02052f0 <default_pmm_manager+0x150>
ffffffffc0202234:	07700593          	li	a1,119
ffffffffc0202238:	00003517          	auipc	a0,0x3
ffffffffc020223c:	02050513          	addi	a0,a0,32 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202240:	93afe0ef          	jal	ra,ffffffffc020037a <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0202244:	00003617          	auipc	a2,0x3
ffffffffc0202248:	0ac60613          	addi	a2,a2,172 # ffffffffc02052f0 <default_pmm_manager+0x150>
ffffffffc020224c:	0bd00593          	li	a1,189
ffffffffc0202250:	00003517          	auipc	a0,0x3
ffffffffc0202254:	00850513          	addi	a0,a0,8 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202258:	922fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc020225c:	00003697          	auipc	a3,0x3
ffffffffc0202260:	0fc68693          	addi	a3,a3,252 # ffffffffc0205358 <default_pmm_manager+0x1b8>
ffffffffc0202264:	00003617          	auipc	a2,0x3
ffffffffc0202268:	b8c60613          	addi	a2,a2,-1140 # ffffffffc0204df0 <commands+0x780>
ffffffffc020226c:	19300593          	li	a1,403
ffffffffc0202270:	00003517          	auipc	a0,0x3
ffffffffc0202274:	fe850513          	addi	a0,a0,-24 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202278:	902fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020227c:	00003697          	auipc	a3,0x3
ffffffffc0202280:	0bc68693          	addi	a3,a3,188 # ffffffffc0205338 <default_pmm_manager+0x198>
ffffffffc0202284:	00003617          	auipc	a2,0x3
ffffffffc0202288:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0204df0 <commands+0x780>
ffffffffc020228c:	19200593          	li	a1,402
ffffffffc0202290:	00003517          	auipc	a0,0x3
ffffffffc0202294:	fc850513          	addi	a0,a0,-56 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc0202230:	0ac60613          	addi	a2,a2,172 # ffffffffc02052d8 <default_pmm_manager+0x150>
ffffffffc0202234:	07700593          	li	a1,119
ffffffffc0202238:	00003517          	auipc	a0,0x3
ffffffffc020223c:	00850513          	addi	a0,a0,8 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202240:	93afe0ef          	jal	ra,ffffffffc020037a <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0202244:	00003617          	auipc	a2,0x3
ffffffffc0202248:	09460613          	addi	a2,a2,148 # ffffffffc02052d8 <default_pmm_manager+0x150>
ffffffffc020224c:	0bd00593          	li	a1,189
ffffffffc0202250:	00003517          	auipc	a0,0x3
ffffffffc0202254:	ff050513          	addi	a0,a0,-16 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202258:	922fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc020225c:	00003697          	auipc	a3,0x3
ffffffffc0202260:	0e468693          	addi	a3,a3,228 # ffffffffc0205340 <default_pmm_manager+0x1b8>
ffffffffc0202264:	00003617          	auipc	a2,0x3
ffffffffc0202268:	b7460613          	addi	a2,a2,-1164 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020226c:	19300593          	li	a1,403
ffffffffc0202270:	00003517          	auipc	a0,0x3
ffffffffc0202274:	fd050513          	addi	a0,a0,-48 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202278:	902fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020227c:	00003697          	auipc	a3,0x3
ffffffffc0202280:	0a468693          	addi	a3,a3,164 # ffffffffc0205320 <default_pmm_manager+0x198>
ffffffffc0202284:	00003617          	auipc	a2,0x3
ffffffffc0202288:	b5460613          	addi	a2,a2,-1196 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020228c:	19200593          	li	a1,402
ffffffffc0202290:	00003517          	auipc	a0,0x3
ffffffffc0202294:	fb050513          	addi	a0,a0,-80 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc0202298:	8e2fe0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc020229c:	b38ff0ef          	jal	ra,ffffffffc02015d4 <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02022a0:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc02022a4:	14868693          	addi	a3,a3,328 # ffffffffc02053e8 <default_pmm_manager+0x248>
ffffffffc02022a8:	00003617          	auipc	a2,0x3
ffffffffc02022ac:	b4860613          	addi	a2,a2,-1208 # ffffffffc0204df0 <commands+0x780>
ffffffffc02022b0:	19a00593          	li	a1,410
ffffffffc02022b4:	00003517          	auipc	a0,0x3
ffffffffc02022b8:	fa450513          	addi	a0,a0,-92 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02022bc:	8befe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02022c0:	00003697          	auipc	a3,0x3
ffffffffc02022c4:	0f868693          	addi	a3,a3,248 # ffffffffc02053b8 <default_pmm_manager+0x218>
ffffffffc02022c8:	00003617          	auipc	a2,0x3
ffffffffc02022cc:	b2860613          	addi	a2,a2,-1240 # ffffffffc0204df0 <commands+0x780>
ffffffffc02022d0:	19800593          	li	a1,408
ffffffffc02022d4:	00003517          	auipc	a0,0x3
ffffffffc02022d8:	f8450513          	addi	a0,a0,-124 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02022dc:	89efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02022e0:	00003697          	auipc	a3,0x3
ffffffffc02022e4:	0b068693          	addi	a3,a3,176 # ffffffffc0205390 <default_pmm_manager+0x1f0>
ffffffffc02022e8:	00003617          	auipc	a2,0x3
ffffffffc02022ec:	b0860613          	addi	a2,a2,-1272 # ffffffffc0204df0 <commands+0x780>
ffffffffc02022f0:	19400593          	li	a1,404
ffffffffc02022f4:	00003517          	auipc	a0,0x3
ffffffffc02022f8:	f6450513          	addi	a0,a0,-156 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02022fc:	87efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202300:	00003697          	auipc	a3,0x3
ffffffffc0202304:	17068693          	addi	a3,a3,368 # ffffffffc0205470 <default_pmm_manager+0x2d0>
ffffffffc0202308:	00003617          	auipc	a2,0x3
ffffffffc020230c:	ae860613          	addi	a2,a2,-1304 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202310:	1a300593          	li	a1,419
ffffffffc0202314:	00003517          	auipc	a0,0x3
ffffffffc0202318:	f4450513          	addi	a0,a0,-188 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020231c:	85efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202320:	00003697          	auipc	a3,0x3
ffffffffc0202324:	1f068693          	addi	a3,a3,496 # ffffffffc0205510 <default_pmm_manager+0x370>
ffffffffc0202328:	00003617          	auipc	a2,0x3
ffffffffc020232c:	ac860613          	addi	a2,a2,-1336 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202330:	1a800593          	li	a1,424
ffffffffc0202334:	00003517          	auipc	a0,0x3
ffffffffc0202338:	f2450513          	addi	a0,a0,-220 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020233c:	83efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202340:	00003697          	auipc	a3,0x3
ffffffffc0202344:	10868693          	addi	a3,a3,264 # ffffffffc0205448 <default_pmm_manager+0x2a8>
ffffffffc0202348:	00003617          	auipc	a2,0x3
ffffffffc020234c:	aa860613          	addi	a2,a2,-1368 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202350:	1a000593          	li	a1,416
ffffffffc0202354:	00003517          	auipc	a0,0x3
ffffffffc0202358:	f0450513          	addi	a0,a0,-252 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc02022a4:	13068693          	addi	a3,a3,304 # ffffffffc02053d0 <default_pmm_manager+0x248>
ffffffffc02022a8:	00003617          	auipc	a2,0x3
ffffffffc02022ac:	b3060613          	addi	a2,a2,-1232 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02022b0:	19a00593          	li	a1,410
ffffffffc02022b4:	00003517          	auipc	a0,0x3
ffffffffc02022b8:	f8c50513          	addi	a0,a0,-116 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02022bc:	8befe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02022c0:	00003697          	auipc	a3,0x3
ffffffffc02022c4:	0e068693          	addi	a3,a3,224 # ffffffffc02053a0 <default_pmm_manager+0x218>
ffffffffc02022c8:	00003617          	auipc	a2,0x3
ffffffffc02022cc:	b1060613          	addi	a2,a2,-1264 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02022d0:	19800593          	li	a1,408
ffffffffc02022d4:	00003517          	auipc	a0,0x3
ffffffffc02022d8:	f6c50513          	addi	a0,a0,-148 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02022dc:	89efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02022e0:	00003697          	auipc	a3,0x3
ffffffffc02022e4:	09868693          	addi	a3,a3,152 # ffffffffc0205378 <default_pmm_manager+0x1f0>
ffffffffc02022e8:	00003617          	auipc	a2,0x3
ffffffffc02022ec:	af060613          	addi	a2,a2,-1296 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02022f0:	19400593          	li	a1,404
ffffffffc02022f4:	00003517          	auipc	a0,0x3
ffffffffc02022f8:	f4c50513          	addi	a0,a0,-180 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02022fc:	87efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202300:	00003697          	auipc	a3,0x3
ffffffffc0202304:	15868693          	addi	a3,a3,344 # ffffffffc0205458 <default_pmm_manager+0x2d0>
ffffffffc0202308:	00003617          	auipc	a2,0x3
ffffffffc020230c:	ad060613          	addi	a2,a2,-1328 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202310:	1a300593          	li	a1,419
ffffffffc0202314:	00003517          	auipc	a0,0x3
ffffffffc0202318:	f2c50513          	addi	a0,a0,-212 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020231c:	85efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202320:	00003697          	auipc	a3,0x3
ffffffffc0202324:	1d868693          	addi	a3,a3,472 # ffffffffc02054f8 <default_pmm_manager+0x370>
ffffffffc0202328:	00003617          	auipc	a2,0x3
ffffffffc020232c:	ab060613          	addi	a2,a2,-1360 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202330:	1a800593          	li	a1,424
ffffffffc0202334:	00003517          	auipc	a0,0x3
ffffffffc0202338:	f0c50513          	addi	a0,a0,-244 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020233c:	83efe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202340:	00003697          	auipc	a3,0x3
ffffffffc0202344:	0f068693          	addi	a3,a3,240 # ffffffffc0205430 <default_pmm_manager+0x2a8>
ffffffffc0202348:	00003617          	auipc	a2,0x3
ffffffffc020234c:	a9060613          	addi	a2,a2,-1392 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202350:	1a000593          	li	a1,416
ffffffffc0202354:	00003517          	auipc	a0,0x3
ffffffffc0202358:	eec50513          	addi	a0,a0,-276 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc020235c:	81efe0ef          	jal	ra,ffffffffc020037a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202360:	86d6                	mv	a3,s5
ffffffffc0202362:	00003617          	auipc	a2,0x3
<<<<<<< HEAD
ffffffffc0202366:	ece60613          	addi	a2,a2,-306 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc020236a:	19f00593          	li	a1,415
ffffffffc020236e:	00003517          	auipc	a0,0x3
ffffffffc0202372:	eea50513          	addi	a0,a0,-278 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202376:	804fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020237a:	00003697          	auipc	a3,0x3
ffffffffc020237e:	12e68693          	addi	a3,a3,302 # ffffffffc02054a8 <default_pmm_manager+0x308>
ffffffffc0202382:	00003617          	auipc	a2,0x3
ffffffffc0202386:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0204df0 <commands+0x780>
ffffffffc020238a:	1ad00593          	li	a1,429
ffffffffc020238e:	00003517          	auipc	a0,0x3
ffffffffc0202392:	eca50513          	addi	a0,a0,-310 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202396:	fe5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020239a:	00003697          	auipc	a3,0x3
ffffffffc020239e:	1d668693          	addi	a3,a3,470 # ffffffffc0205570 <default_pmm_manager+0x3d0>
ffffffffc02023a2:	00003617          	auipc	a2,0x3
ffffffffc02023a6:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0204df0 <commands+0x780>
ffffffffc02023aa:	1ac00593          	li	a1,428
ffffffffc02023ae:	00003517          	auipc	a0,0x3
ffffffffc02023b2:	eaa50513          	addi	a0,a0,-342 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02023b6:	fc5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02023ba:	00003697          	auipc	a3,0x3
ffffffffc02023be:	19e68693          	addi	a3,a3,414 # ffffffffc0205558 <default_pmm_manager+0x3b8>
ffffffffc02023c2:	00003617          	auipc	a2,0x3
ffffffffc02023c6:	a2e60613          	addi	a2,a2,-1490 # ffffffffc0204df0 <commands+0x780>
ffffffffc02023ca:	1ab00593          	li	a1,427
ffffffffc02023ce:	00003517          	auipc	a0,0x3
ffffffffc02023d2:	e8a50513          	addi	a0,a0,-374 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02023d6:	fa5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02023da:	00003697          	auipc	a3,0x3
ffffffffc02023de:	14e68693          	addi	a3,a3,334 # ffffffffc0205528 <default_pmm_manager+0x388>
ffffffffc02023e2:	00003617          	auipc	a2,0x3
ffffffffc02023e6:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0204df0 <commands+0x780>
ffffffffc02023ea:	1aa00593          	li	a1,426
ffffffffc02023ee:	00003517          	auipc	a0,0x3
ffffffffc02023f2:	e6a50513          	addi	a0,a0,-406 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02023f6:	f85fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02023fa:	00003697          	auipc	a3,0x3
ffffffffc02023fe:	2e668693          	addi	a3,a3,742 # ffffffffc02056e0 <default_pmm_manager+0x540>
ffffffffc0202402:	00003617          	auipc	a2,0x3
ffffffffc0202406:	9ee60613          	addi	a2,a2,-1554 # ffffffffc0204df0 <commands+0x780>
ffffffffc020240a:	1d800593          	li	a1,472
ffffffffc020240e:	00003517          	auipc	a0,0x3
ffffffffc0202412:	e4a50513          	addi	a0,a0,-438 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202416:	f65fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020241a:	00003697          	auipc	a3,0x3
ffffffffc020241e:	0de68693          	addi	a3,a3,222 # ffffffffc02054f8 <default_pmm_manager+0x358>
ffffffffc0202422:	00003617          	auipc	a2,0x3
ffffffffc0202426:	9ce60613          	addi	a2,a2,-1586 # ffffffffc0204df0 <commands+0x780>
ffffffffc020242a:	1a700593          	li	a1,423
ffffffffc020242e:	00003517          	auipc	a0,0x3
ffffffffc0202432:	e2a50513          	addi	a0,a0,-470 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202436:	f45fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*ptep & PTE_W);
ffffffffc020243a:	00003697          	auipc	a3,0x3
ffffffffc020243e:	0ae68693          	addi	a3,a3,174 # ffffffffc02054e8 <default_pmm_manager+0x348>
ffffffffc0202442:	00003617          	auipc	a2,0x3
ffffffffc0202446:	9ae60613          	addi	a2,a2,-1618 # ffffffffc0204df0 <commands+0x780>
ffffffffc020244a:	1a600593          	li	a1,422
ffffffffc020244e:	00003517          	auipc	a0,0x3
ffffffffc0202452:	e0a50513          	addi	a0,a0,-502 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202456:	f25fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc020245a:	00003697          	auipc	a3,0x3
ffffffffc020245e:	18668693          	addi	a3,a3,390 # ffffffffc02055e0 <default_pmm_manager+0x440>
ffffffffc0202462:	00003617          	auipc	a2,0x3
ffffffffc0202466:	98e60613          	addi	a2,a2,-1650 # ffffffffc0204df0 <commands+0x780>
ffffffffc020246a:	1e800593          	li	a1,488
ffffffffc020246e:	00003517          	auipc	a0,0x3
ffffffffc0202472:	dea50513          	addi	a0,a0,-534 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202476:	f05fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*ptep & PTE_U);
ffffffffc020247a:	00003697          	auipc	a3,0x3
ffffffffc020247e:	05e68693          	addi	a3,a3,94 # ffffffffc02054d8 <default_pmm_manager+0x338>
ffffffffc0202482:	00003617          	auipc	a2,0x3
ffffffffc0202486:	96e60613          	addi	a2,a2,-1682 # ffffffffc0204df0 <commands+0x780>
ffffffffc020248a:	1a500593          	li	a1,421
ffffffffc020248e:	00003517          	auipc	a0,0x3
ffffffffc0202492:	dca50513          	addi	a0,a0,-566 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202496:	ee5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020249a:	00003697          	auipc	a3,0x3
ffffffffc020249e:	f9668693          	addi	a3,a3,-106 # ffffffffc0205430 <default_pmm_manager+0x290>
ffffffffc02024a2:	00003617          	auipc	a2,0x3
ffffffffc02024a6:	94e60613          	addi	a2,a2,-1714 # ffffffffc0204df0 <commands+0x780>
ffffffffc02024aa:	1b200593          	li	a1,434
ffffffffc02024ae:	00003517          	auipc	a0,0x3
ffffffffc02024b2:	daa50513          	addi	a0,a0,-598 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02024b6:	ec5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02024ba:	00003697          	auipc	a3,0x3
ffffffffc02024be:	0ce68693          	addi	a3,a3,206 # ffffffffc0205588 <default_pmm_manager+0x3e8>
ffffffffc02024c2:	00003617          	auipc	a2,0x3
ffffffffc02024c6:	92e60613          	addi	a2,a2,-1746 # ffffffffc0204df0 <commands+0x780>
ffffffffc02024ca:	1af00593          	li	a1,431
ffffffffc02024ce:	00003517          	auipc	a0,0x3
ffffffffc02024d2:	d8a50513          	addi	a0,a0,-630 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02024d6:	ea5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02024da:	00003697          	auipc	a3,0x3
ffffffffc02024de:	f3e68693          	addi	a3,a3,-194 # ffffffffc0205418 <default_pmm_manager+0x278>
ffffffffc02024e2:	00003617          	auipc	a2,0x3
ffffffffc02024e6:	90e60613          	addi	a2,a2,-1778 # ffffffffc0204df0 <commands+0x780>
ffffffffc02024ea:	1ae00593          	li	a1,430
ffffffffc02024ee:	00003517          	auipc	a0,0x3
ffffffffc02024f2:	d6a50513          	addi	a0,a0,-662 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02024f6:	e85fd0ef          	jal	ra,ffffffffc020037a <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02024fa:	00003617          	auipc	a2,0x3
ffffffffc02024fe:	d3660613          	addi	a2,a2,-714 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0202502:	06a00593          	li	a1,106
ffffffffc0202506:	00003517          	auipc	a0,0x3
ffffffffc020250a:	cf250513          	addi	a0,a0,-782 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc020250e:	e6dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202512:	00003697          	auipc	a3,0x3
ffffffffc0202516:	0a668693          	addi	a3,a3,166 # ffffffffc02055b8 <default_pmm_manager+0x418>
ffffffffc020251a:	00003617          	auipc	a2,0x3
ffffffffc020251e:	8d660613          	addi	a2,a2,-1834 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202522:	1b900593          	li	a1,441
ffffffffc0202526:	00003517          	auipc	a0,0x3
ffffffffc020252a:	d3250513          	addi	a0,a0,-718 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020252e:	e4dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202532:	00003697          	auipc	a3,0x3
ffffffffc0202536:	03e68693          	addi	a3,a3,62 # ffffffffc0205570 <default_pmm_manager+0x3d0>
ffffffffc020253a:	00003617          	auipc	a2,0x3
ffffffffc020253e:	8b660613          	addi	a2,a2,-1866 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202542:	1b700593          	li	a1,439
ffffffffc0202546:	00003517          	auipc	a0,0x3
ffffffffc020254a:	d1250513          	addi	a0,a0,-750 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020254e:	e2dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202552:	00003697          	auipc	a3,0x3
ffffffffc0202556:	04e68693          	addi	a3,a3,78 # ffffffffc02055a0 <default_pmm_manager+0x400>
ffffffffc020255a:	00003617          	auipc	a2,0x3
ffffffffc020255e:	89660613          	addi	a2,a2,-1898 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202562:	1b600593          	li	a1,438
ffffffffc0202566:	00003517          	auipc	a0,0x3
ffffffffc020256a:	cf250513          	addi	a0,a0,-782 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020256e:	e0dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202572:	00003697          	auipc	a3,0x3
ffffffffc0202576:	ffe68693          	addi	a3,a3,-2 # ffffffffc0205570 <default_pmm_manager+0x3d0>
ffffffffc020257a:	00003617          	auipc	a2,0x3
ffffffffc020257e:	87660613          	addi	a2,a2,-1930 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202582:	1b300593          	li	a1,435
ffffffffc0202586:	00003517          	auipc	a0,0x3
ffffffffc020258a:	cd250513          	addi	a0,a0,-814 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020258e:	dedfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202592:	00003697          	auipc	a3,0x3
ffffffffc0202596:	13668693          	addi	a3,a3,310 # ffffffffc02056c8 <default_pmm_manager+0x528>
ffffffffc020259a:	00003617          	auipc	a2,0x3
ffffffffc020259e:	85660613          	addi	a2,a2,-1962 # ffffffffc0204df0 <commands+0x780>
ffffffffc02025a2:	1d700593          	li	a1,471
ffffffffc02025a6:	00003517          	auipc	a0,0x3
ffffffffc02025aa:	cb250513          	addi	a0,a0,-846 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02025ae:	dcdfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02025b2:	00003697          	auipc	a3,0x3
ffffffffc02025b6:	0de68693          	addi	a3,a3,222 # ffffffffc0205690 <default_pmm_manager+0x4f0>
ffffffffc02025ba:	00003617          	auipc	a2,0x3
ffffffffc02025be:	83660613          	addi	a2,a2,-1994 # ffffffffc0204df0 <commands+0x780>
ffffffffc02025c2:	1d600593          	li	a1,470
ffffffffc02025c6:	00003517          	auipc	a0,0x3
ffffffffc02025ca:	c9250513          	addi	a0,a0,-878 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02025ce:	dadfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc02025d2:	00003697          	auipc	a3,0x3
ffffffffc02025d6:	0a668693          	addi	a3,a3,166 # ffffffffc0205678 <default_pmm_manager+0x4d8>
ffffffffc02025da:	00003617          	auipc	a2,0x3
ffffffffc02025de:	81660613          	addi	a2,a2,-2026 # ffffffffc0204df0 <commands+0x780>
ffffffffc02025e2:	1d200593          	li	a1,466
ffffffffc02025e6:	00003517          	auipc	a0,0x3
ffffffffc02025ea:	c7250513          	addi	a0,a0,-910 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02025ee:	d8dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc02025f2:	00003697          	auipc	a3,0x3
ffffffffc02025f6:	fee68693          	addi	a3,a3,-18 # ffffffffc02055e0 <default_pmm_manager+0x440>
ffffffffc02025fa:	00002617          	auipc	a2,0x2
ffffffffc02025fe:	7f660613          	addi	a2,a2,2038 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202602:	1c000593          	li	a1,448
ffffffffc0202606:	00003517          	auipc	a0,0x3
ffffffffc020260a:	c5250513          	addi	a0,a0,-942 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020260e:	d6dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202612:	00003697          	auipc	a3,0x3
ffffffffc0202616:	e0668693          	addi	a3,a3,-506 # ffffffffc0205418 <default_pmm_manager+0x278>
ffffffffc020261a:	00002617          	auipc	a2,0x2
ffffffffc020261e:	7d660613          	addi	a2,a2,2006 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202622:	19b00593          	li	a1,411
ffffffffc0202626:	00003517          	auipc	a0,0x3
ffffffffc020262a:	c3250513          	addi	a0,a0,-974 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc020262e:	d4dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202632:	00003617          	auipc	a2,0x3
ffffffffc0202636:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc020263a:	19e00593          	li	a1,414
ffffffffc020263e:	00003517          	auipc	a0,0x3
ffffffffc0202642:	c1a50513          	addi	a0,a0,-998 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202646:	d35fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020264a:	00003697          	auipc	a3,0x3
ffffffffc020264e:	de668693          	addi	a3,a3,-538 # ffffffffc0205430 <default_pmm_manager+0x290>
ffffffffc0202652:	00002617          	auipc	a2,0x2
ffffffffc0202656:	79e60613          	addi	a2,a2,1950 # ffffffffc0204df0 <commands+0x780>
ffffffffc020265a:	19c00593          	li	a1,412
ffffffffc020265e:	00003517          	auipc	a0,0x3
ffffffffc0202662:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202666:	d15fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020266a:	00003697          	auipc	a3,0x3
ffffffffc020266e:	e3e68693          	addi	a3,a3,-450 # ffffffffc02054a8 <default_pmm_manager+0x308>
ffffffffc0202672:	00002617          	auipc	a2,0x2
ffffffffc0202676:	77e60613          	addi	a2,a2,1918 # ffffffffc0204df0 <commands+0x780>
ffffffffc020267a:	1a400593          	li	a1,420
ffffffffc020267e:	00003517          	auipc	a0,0x3
ffffffffc0202682:	bda50513          	addi	a0,a0,-1062 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202686:	cf5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020268a:	00003697          	auipc	a3,0x3
ffffffffc020268e:	0fe68693          	addi	a3,a3,254 # ffffffffc0205788 <default_pmm_manager+0x5e8>
ffffffffc0202692:	00002617          	auipc	a2,0x2
ffffffffc0202696:	75e60613          	addi	a2,a2,1886 # ffffffffc0204df0 <commands+0x780>
ffffffffc020269a:	1e000593          	li	a1,480
ffffffffc020269e:	00003517          	auipc	a0,0x3
ffffffffc02026a2:	bba50513          	addi	a0,a0,-1094 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02026a6:	cd5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02026aa:	00003697          	auipc	a3,0x3
ffffffffc02026ae:	0a668693          	addi	a3,a3,166 # ffffffffc0205750 <default_pmm_manager+0x5b0>
ffffffffc02026b2:	00002617          	auipc	a2,0x2
ffffffffc02026b6:	73e60613          	addi	a2,a2,1854 # ffffffffc0204df0 <commands+0x780>
ffffffffc02026ba:	1dd00593          	li	a1,477
ffffffffc02026be:	00003517          	auipc	a0,0x3
ffffffffc02026c2:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc02026c6:	cb5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p) == 2);
ffffffffc02026ca:	00003697          	auipc	a3,0x3
ffffffffc02026ce:	05668693          	addi	a3,a3,86 # ffffffffc0205720 <default_pmm_manager+0x580>
ffffffffc02026d2:	00002617          	auipc	a2,0x2
ffffffffc02026d6:	71e60613          	addi	a2,a2,1822 # ffffffffc0204df0 <commands+0x780>
ffffffffc02026da:	1d900593          	li	a1,473
ffffffffc02026de:	00003517          	auipc	a0,0x3
ffffffffc02026e2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc0202366:	eb660613          	addi	a2,a2,-330 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc020236a:	19f00593          	li	a1,415
ffffffffc020236e:	00003517          	auipc	a0,0x3
ffffffffc0202372:	ed250513          	addi	a0,a0,-302 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202376:	804fe0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020237a:	00003697          	auipc	a3,0x3
ffffffffc020237e:	11668693          	addi	a3,a3,278 # ffffffffc0205490 <default_pmm_manager+0x308>
ffffffffc0202382:	00003617          	auipc	a2,0x3
ffffffffc0202386:	a5660613          	addi	a2,a2,-1450 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020238a:	1ad00593          	li	a1,429
ffffffffc020238e:	00003517          	auipc	a0,0x3
ffffffffc0202392:	eb250513          	addi	a0,a0,-334 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202396:	fe5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020239a:	00003697          	auipc	a3,0x3
ffffffffc020239e:	1be68693          	addi	a3,a3,446 # ffffffffc0205558 <default_pmm_manager+0x3d0>
ffffffffc02023a2:	00003617          	auipc	a2,0x3
ffffffffc02023a6:	a3660613          	addi	a2,a2,-1482 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02023aa:	1ac00593          	li	a1,428
ffffffffc02023ae:	00003517          	auipc	a0,0x3
ffffffffc02023b2:	e9250513          	addi	a0,a0,-366 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02023b6:	fc5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02023ba:	00003697          	auipc	a3,0x3
ffffffffc02023be:	18668693          	addi	a3,a3,390 # ffffffffc0205540 <default_pmm_manager+0x3b8>
ffffffffc02023c2:	00003617          	auipc	a2,0x3
ffffffffc02023c6:	a1660613          	addi	a2,a2,-1514 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02023ca:	1ab00593          	li	a1,427
ffffffffc02023ce:	00003517          	auipc	a0,0x3
ffffffffc02023d2:	e7250513          	addi	a0,a0,-398 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02023d6:	fa5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02023da:	00003697          	auipc	a3,0x3
ffffffffc02023de:	13668693          	addi	a3,a3,310 # ffffffffc0205510 <default_pmm_manager+0x388>
ffffffffc02023e2:	00003617          	auipc	a2,0x3
ffffffffc02023e6:	9f660613          	addi	a2,a2,-1546 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02023ea:	1aa00593          	li	a1,426
ffffffffc02023ee:	00003517          	auipc	a0,0x3
ffffffffc02023f2:	e5250513          	addi	a0,a0,-430 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02023f6:	f85fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02023fa:	00003697          	auipc	a3,0x3
ffffffffc02023fe:	2ce68693          	addi	a3,a3,718 # ffffffffc02056c8 <default_pmm_manager+0x540>
ffffffffc0202402:	00003617          	auipc	a2,0x3
ffffffffc0202406:	9d660613          	addi	a2,a2,-1578 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020240a:	1d800593          	li	a1,472
ffffffffc020240e:	00003517          	auipc	a0,0x3
ffffffffc0202412:	e3250513          	addi	a0,a0,-462 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202416:	f65fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020241a:	00003697          	auipc	a3,0x3
ffffffffc020241e:	0c668693          	addi	a3,a3,198 # ffffffffc02054e0 <default_pmm_manager+0x358>
ffffffffc0202422:	00003617          	auipc	a2,0x3
ffffffffc0202426:	9b660613          	addi	a2,a2,-1610 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020242a:	1a700593          	li	a1,423
ffffffffc020242e:	00003517          	auipc	a0,0x3
ffffffffc0202432:	e1250513          	addi	a0,a0,-494 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202436:	f45fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*ptep & PTE_W);
ffffffffc020243a:	00003697          	auipc	a3,0x3
ffffffffc020243e:	09668693          	addi	a3,a3,150 # ffffffffc02054d0 <default_pmm_manager+0x348>
ffffffffc0202442:	00003617          	auipc	a2,0x3
ffffffffc0202446:	99660613          	addi	a2,a2,-1642 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020244a:	1a600593          	li	a1,422
ffffffffc020244e:	00003517          	auipc	a0,0x3
ffffffffc0202452:	df250513          	addi	a0,a0,-526 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202456:	f25fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc020245a:	00003697          	auipc	a3,0x3
ffffffffc020245e:	16e68693          	addi	a3,a3,366 # ffffffffc02055c8 <default_pmm_manager+0x440>
ffffffffc0202462:	00003617          	auipc	a2,0x3
ffffffffc0202466:	97660613          	addi	a2,a2,-1674 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020246a:	1e800593          	li	a1,488
ffffffffc020246e:	00003517          	auipc	a0,0x3
ffffffffc0202472:	dd250513          	addi	a0,a0,-558 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202476:	f05fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*ptep & PTE_U);
ffffffffc020247a:	00003697          	auipc	a3,0x3
ffffffffc020247e:	04668693          	addi	a3,a3,70 # ffffffffc02054c0 <default_pmm_manager+0x338>
ffffffffc0202482:	00003617          	auipc	a2,0x3
ffffffffc0202486:	95660613          	addi	a2,a2,-1706 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020248a:	1a500593          	li	a1,421
ffffffffc020248e:	00003517          	auipc	a0,0x3
ffffffffc0202492:	db250513          	addi	a0,a0,-590 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202496:	ee5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020249a:	00003697          	auipc	a3,0x3
ffffffffc020249e:	f7e68693          	addi	a3,a3,-130 # ffffffffc0205418 <default_pmm_manager+0x290>
ffffffffc02024a2:	00003617          	auipc	a2,0x3
ffffffffc02024a6:	93660613          	addi	a2,a2,-1738 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02024aa:	1b200593          	li	a1,434
ffffffffc02024ae:	00003517          	auipc	a0,0x3
ffffffffc02024b2:	d9250513          	addi	a0,a0,-622 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02024b6:	ec5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02024ba:	00003697          	auipc	a3,0x3
ffffffffc02024be:	0b668693          	addi	a3,a3,182 # ffffffffc0205570 <default_pmm_manager+0x3e8>
ffffffffc02024c2:	00003617          	auipc	a2,0x3
ffffffffc02024c6:	91660613          	addi	a2,a2,-1770 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02024ca:	1af00593          	li	a1,431
ffffffffc02024ce:	00003517          	auipc	a0,0x3
ffffffffc02024d2:	d7250513          	addi	a0,a0,-654 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02024d6:	ea5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02024da:	00003697          	auipc	a3,0x3
ffffffffc02024de:	f2668693          	addi	a3,a3,-218 # ffffffffc0205400 <default_pmm_manager+0x278>
ffffffffc02024e2:	00003617          	auipc	a2,0x3
ffffffffc02024e6:	8f660613          	addi	a2,a2,-1802 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02024ea:	1ae00593          	li	a1,430
ffffffffc02024ee:	00003517          	auipc	a0,0x3
ffffffffc02024f2:	d5250513          	addi	a0,a0,-686 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02024f6:	e85fd0ef          	jal	ra,ffffffffc020037a <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02024fa:	00003617          	auipc	a2,0x3
ffffffffc02024fe:	d1e60613          	addi	a2,a2,-738 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0202502:	06a00593          	li	a1,106
ffffffffc0202506:	00003517          	auipc	a0,0x3
ffffffffc020250a:	cda50513          	addi	a0,a0,-806 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc020250e:	e6dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202512:	00003697          	auipc	a3,0x3
ffffffffc0202516:	08e68693          	addi	a3,a3,142 # ffffffffc02055a0 <default_pmm_manager+0x418>
ffffffffc020251a:	00003617          	auipc	a2,0x3
ffffffffc020251e:	8be60613          	addi	a2,a2,-1858 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202522:	1b900593          	li	a1,441
ffffffffc0202526:	00003517          	auipc	a0,0x3
ffffffffc020252a:	d1a50513          	addi	a0,a0,-742 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020252e:	e4dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202532:	00003697          	auipc	a3,0x3
ffffffffc0202536:	02668693          	addi	a3,a3,38 # ffffffffc0205558 <default_pmm_manager+0x3d0>
ffffffffc020253a:	00003617          	auipc	a2,0x3
ffffffffc020253e:	89e60613          	addi	a2,a2,-1890 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202542:	1b700593          	li	a1,439
ffffffffc0202546:	00003517          	auipc	a0,0x3
ffffffffc020254a:	cfa50513          	addi	a0,a0,-774 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020254e:	e2dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202552:	00003697          	auipc	a3,0x3
ffffffffc0202556:	03668693          	addi	a3,a3,54 # ffffffffc0205588 <default_pmm_manager+0x400>
ffffffffc020255a:	00003617          	auipc	a2,0x3
ffffffffc020255e:	87e60613          	addi	a2,a2,-1922 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202562:	1b600593          	li	a1,438
ffffffffc0202566:	00003517          	auipc	a0,0x3
ffffffffc020256a:	cda50513          	addi	a0,a0,-806 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020256e:	e0dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202572:	00003697          	auipc	a3,0x3
ffffffffc0202576:	fe668693          	addi	a3,a3,-26 # ffffffffc0205558 <default_pmm_manager+0x3d0>
ffffffffc020257a:	00003617          	auipc	a2,0x3
ffffffffc020257e:	85e60613          	addi	a2,a2,-1954 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202582:	1b300593          	li	a1,435
ffffffffc0202586:	00003517          	auipc	a0,0x3
ffffffffc020258a:	cba50513          	addi	a0,a0,-838 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020258e:	dedfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202592:	00003697          	auipc	a3,0x3
ffffffffc0202596:	11e68693          	addi	a3,a3,286 # ffffffffc02056b0 <default_pmm_manager+0x528>
ffffffffc020259a:	00003617          	auipc	a2,0x3
ffffffffc020259e:	83e60613          	addi	a2,a2,-1986 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02025a2:	1d700593          	li	a1,471
ffffffffc02025a6:	00003517          	auipc	a0,0x3
ffffffffc02025aa:	c9a50513          	addi	a0,a0,-870 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02025ae:	dcdfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02025b2:	00003697          	auipc	a3,0x3
ffffffffc02025b6:	0c668693          	addi	a3,a3,198 # ffffffffc0205678 <default_pmm_manager+0x4f0>
ffffffffc02025ba:	00003617          	auipc	a2,0x3
ffffffffc02025be:	81e60613          	addi	a2,a2,-2018 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02025c2:	1d600593          	li	a1,470
ffffffffc02025c6:	00003517          	auipc	a0,0x3
ffffffffc02025ca:	c7a50513          	addi	a0,a0,-902 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02025ce:	dadfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc02025d2:	00003697          	auipc	a3,0x3
ffffffffc02025d6:	08e68693          	addi	a3,a3,142 # ffffffffc0205660 <default_pmm_manager+0x4d8>
ffffffffc02025da:	00002617          	auipc	a2,0x2
ffffffffc02025de:	7fe60613          	addi	a2,a2,2046 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02025e2:	1d200593          	li	a1,466
ffffffffc02025e6:	00003517          	auipc	a0,0x3
ffffffffc02025ea:	c5a50513          	addi	a0,a0,-934 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02025ee:	d8dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc02025f2:	00003697          	auipc	a3,0x3
ffffffffc02025f6:	fd668693          	addi	a3,a3,-42 # ffffffffc02055c8 <default_pmm_manager+0x440>
ffffffffc02025fa:	00002617          	auipc	a2,0x2
ffffffffc02025fe:	7de60613          	addi	a2,a2,2014 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202602:	1c000593          	li	a1,448
ffffffffc0202606:	00003517          	auipc	a0,0x3
ffffffffc020260a:	c3a50513          	addi	a0,a0,-966 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020260e:	d6dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202612:	00003697          	auipc	a3,0x3
ffffffffc0202616:	dee68693          	addi	a3,a3,-530 # ffffffffc0205400 <default_pmm_manager+0x278>
ffffffffc020261a:	00002617          	auipc	a2,0x2
ffffffffc020261e:	7be60613          	addi	a2,a2,1982 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202622:	19b00593          	li	a1,411
ffffffffc0202626:	00003517          	auipc	a0,0x3
ffffffffc020262a:	c1a50513          	addi	a0,a0,-998 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc020262e:	d4dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202632:	00003617          	auipc	a2,0x3
ffffffffc0202636:	be660613          	addi	a2,a2,-1050 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc020263a:	19e00593          	li	a1,414
ffffffffc020263e:	00003517          	auipc	a0,0x3
ffffffffc0202642:	c0250513          	addi	a0,a0,-1022 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202646:	d35fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020264a:	00003697          	auipc	a3,0x3
ffffffffc020264e:	dce68693          	addi	a3,a3,-562 # ffffffffc0205418 <default_pmm_manager+0x290>
ffffffffc0202652:	00002617          	auipc	a2,0x2
ffffffffc0202656:	78660613          	addi	a2,a2,1926 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020265a:	19c00593          	li	a1,412
ffffffffc020265e:	00003517          	auipc	a0,0x3
ffffffffc0202662:	be250513          	addi	a0,a0,-1054 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202666:	d15fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020266a:	00003697          	auipc	a3,0x3
ffffffffc020266e:	e2668693          	addi	a3,a3,-474 # ffffffffc0205490 <default_pmm_manager+0x308>
ffffffffc0202672:	00002617          	auipc	a2,0x2
ffffffffc0202676:	76660613          	addi	a2,a2,1894 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020267a:	1a400593          	li	a1,420
ffffffffc020267e:	00003517          	auipc	a0,0x3
ffffffffc0202682:	bc250513          	addi	a0,a0,-1086 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202686:	cf5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020268a:	00003697          	auipc	a3,0x3
ffffffffc020268e:	0e668693          	addi	a3,a3,230 # ffffffffc0205770 <default_pmm_manager+0x5e8>
ffffffffc0202692:	00002617          	auipc	a2,0x2
ffffffffc0202696:	74660613          	addi	a2,a2,1862 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020269a:	1e000593          	li	a1,480
ffffffffc020269e:	00003517          	auipc	a0,0x3
ffffffffc02026a2:	ba250513          	addi	a0,a0,-1118 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02026a6:	cd5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02026aa:	00003697          	auipc	a3,0x3
ffffffffc02026ae:	08e68693          	addi	a3,a3,142 # ffffffffc0205738 <default_pmm_manager+0x5b0>
ffffffffc02026b2:	00002617          	auipc	a2,0x2
ffffffffc02026b6:	72660613          	addi	a2,a2,1830 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02026ba:	1dd00593          	li	a1,477
ffffffffc02026be:	00003517          	auipc	a0,0x3
ffffffffc02026c2:	b8250513          	addi	a0,a0,-1150 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc02026c6:	cb5fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(page_ref(p) == 2);
ffffffffc02026ca:	00003697          	auipc	a3,0x3
ffffffffc02026ce:	03e68693          	addi	a3,a3,62 # ffffffffc0205708 <default_pmm_manager+0x580>
ffffffffc02026d2:	00002617          	auipc	a2,0x2
ffffffffc02026d6:	70660613          	addi	a2,a2,1798 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02026da:	1d900593          	li	a1,473
ffffffffc02026de:	00003517          	auipc	a0,0x3
ffffffffc02026e2:	b6250513          	addi	a0,a0,-1182 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc02026e6:	c95fd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02026ea <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc02026ea:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc02026ee:	8082                	ret

ffffffffc02026f0 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc02026f0:	7179                	addi	sp,sp,-48
ffffffffc02026f2:	e84a                	sd	s2,16(sp)
ffffffffc02026f4:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc02026f6:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc02026f8:	f022                	sd	s0,32(sp)
ffffffffc02026fa:	ec26                	sd	s1,24(sp)
ffffffffc02026fc:	e44e                	sd	s3,8(sp)
ffffffffc02026fe:	f406                	sd	ra,40(sp)
ffffffffc0202700:	84ae                	mv	s1,a1
ffffffffc0202702:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0202704:	eedfe0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0202708:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc020270a:	cd09                	beqz	a0,ffffffffc0202724 <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc020270c:	85aa                	mv	a1,a0
ffffffffc020270e:	86ce                	mv	a3,s3
ffffffffc0202710:	8626                	mv	a2,s1
ffffffffc0202712:	854a                	mv	a0,s2
ffffffffc0202714:	ad2ff0ef          	jal	ra,ffffffffc02019e6 <page_insert>
ffffffffc0202718:	ed21                	bnez	a0,ffffffffc0202770 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc020271a:	0000f797          	auipc	a5,0xf
ffffffffc020271e:	e367a783          	lw	a5,-458(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0202722:	eb89                	bnez	a5,ffffffffc0202734 <pgdir_alloc_page+0x44>
}
ffffffffc0202724:	70a2                	ld	ra,40(sp)
ffffffffc0202726:	8522                	mv	a0,s0
ffffffffc0202728:	7402                	ld	s0,32(sp)
ffffffffc020272a:	64e2                	ld	s1,24(sp)
ffffffffc020272c:	6942                	ld	s2,16(sp)
ffffffffc020272e:	69a2                	ld	s3,8(sp)
ffffffffc0202730:	6145                	addi	sp,sp,48
ffffffffc0202732:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0202734:	4681                	li	a3,0
ffffffffc0202736:	8622                	mv	a2,s0
ffffffffc0202738:	85a6                	mv	a1,s1
ffffffffc020273a:	0000f517          	auipc	a0,0xf
ffffffffc020273e:	e2653503          	ld	a0,-474(a0) # ffffffffc0211560 <check_mm_struct>
ffffffffc0202742:	07f000ef          	jal	ra,ffffffffc0202fc0 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0202746:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0202748:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc020274a:	4785                	li	a5,1
ffffffffc020274c:	fcf70ce3          	beq	a4,a5,ffffffffc0202724 <pgdir_alloc_page+0x34>
ffffffffc0202750:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc0202754:	08068693          	addi	a3,a3,128 # ffffffffc02057d0 <default_pmm_manager+0x630>
ffffffffc0202758:	00002617          	auipc	a2,0x2
ffffffffc020275c:	69860613          	addi	a2,a2,1688 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202760:	17a00593          	li	a1,378
ffffffffc0202764:	00003517          	auipc	a0,0x3
ffffffffc0202768:	af450513          	addi	a0,a0,-1292 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc0202754:	06868693          	addi	a3,a3,104 # ffffffffc02057b8 <default_pmm_manager+0x630>
ffffffffc0202758:	00002617          	auipc	a2,0x2
ffffffffc020275c:	68060613          	addi	a2,a2,1664 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202760:	17a00593          	li	a1,378
ffffffffc0202764:	00003517          	auipc	a0,0x3
ffffffffc0202768:	adc50513          	addi	a0,a0,-1316 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc020276c:	c0ffd0ef          	jal	ra,ffffffffc020037a <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202770:	100027f3          	csrr	a5,sstatus
ffffffffc0202774:	8b89                	andi	a5,a5,2
ffffffffc0202776:	eb99                	bnez	a5,ffffffffc020278c <pgdir_alloc_page+0x9c>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202778:	0000f797          	auipc	a5,0xf
ffffffffc020277c:	db87b783          	ld	a5,-584(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0202780:	739c                	ld	a5,32(a5)
ffffffffc0202782:	8522                	mv	a0,s0
ffffffffc0202784:	4585                	li	a1,1
ffffffffc0202786:	9782                	jalr	a5
            return NULL;
ffffffffc0202788:	4401                	li	s0,0
ffffffffc020278a:	bf69                	j	ffffffffc0202724 <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc020278c:	d69fd0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202790:	0000f797          	auipc	a5,0xf
ffffffffc0202794:	da07b783          	ld	a5,-608(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0202798:	739c                	ld	a5,32(a5)
ffffffffc020279a:	8522                	mv	a0,s0
ffffffffc020279c:	4585                	li	a1,1
ffffffffc020279e:	9782                	jalr	a5
            return NULL;
ffffffffc02027a0:	4401                	li	s0,0
        intr_enable();
ffffffffc02027a2:	d4dfd0ef          	jal	ra,ffffffffc02004ee <intr_enable>
ffffffffc02027a6:	bfbd                	j	ffffffffc0202724 <pgdir_alloc_page+0x34>

ffffffffc02027a8 <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc02027a8:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc02027aa:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc02027ac:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc02027ae:	fff50713          	addi	a4,a0,-1
ffffffffc02027b2:	17f9                	addi	a5,a5,-2
ffffffffc02027b4:	04e7ea63          	bltu	a5,a4,ffffffffc0202808 <kmalloc+0x60>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc02027b8:	6785                	lui	a5,0x1
ffffffffc02027ba:	17fd                	addi	a5,a5,-1
ffffffffc02027bc:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc02027be:	8131                	srli	a0,a0,0xc
ffffffffc02027c0:	e31fe0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
    assert(base != NULL);
ffffffffc02027c4:	cd3d                	beqz	a0,ffffffffc0202842 <kmalloc+0x9a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02027c6:	0000f797          	auipc	a5,0xf
ffffffffc02027ca:	d627b783          	ld	a5,-670(a5) # ffffffffc0211528 <pages>
ffffffffc02027ce:	8d1d                	sub	a0,a0,a5
ffffffffc02027d0:	00004697          	auipc	a3,0x4
<<<<<<< HEAD
ffffffffc02027d4:	aa06b683          	ld	a3,-1376(a3) # ffffffffc0206270 <error_string+0x38>
=======
ffffffffc02027d4:	a786b683          	ld	a3,-1416(a3) # ffffffffc0206248 <error_string+0x38>
>>>>>>> 747620b (lab2)
ffffffffc02027d8:	850d                	srai	a0,a0,0x3
ffffffffc02027da:	02d50533          	mul	a0,a0,a3
ffffffffc02027de:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02027e2:	0000f717          	auipc	a4,0xf
ffffffffc02027e6:	d3e73703          	ld	a4,-706(a4) # ffffffffc0211520 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02027ea:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02027ec:	00c51793          	slli	a5,a0,0xc
ffffffffc02027f0:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02027f2:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02027f4:	02e7fa63          	bgeu	a5,a4,ffffffffc0202828 <kmalloc+0x80>
    ptr = page2kva(base);
    return ptr;
}
ffffffffc02027f8:	60a2                	ld	ra,8(sp)
ffffffffc02027fa:	0000f797          	auipc	a5,0xf
ffffffffc02027fe:	d3e7b783          	ld	a5,-706(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0202802:	953e                	add	a0,a0,a5
ffffffffc0202804:	0141                	addi	sp,sp,16
ffffffffc0202806:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0202808:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc020280c:	fe068693          	addi	a3,a3,-32 # ffffffffc02057e8 <default_pmm_manager+0x648>
ffffffffc0202810:	00002617          	auipc	a2,0x2
ffffffffc0202814:	5e060613          	addi	a2,a2,1504 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202818:	1f000593          	li	a1,496
ffffffffc020281c:	00003517          	auipc	a0,0x3
ffffffffc0202820:	a3c50513          	addi	a0,a0,-1476 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202824:	b57fd0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0202828:	86aa                	mv	a3,a0
ffffffffc020282a:	00003617          	auipc	a2,0x3
ffffffffc020282e:	a0660613          	addi	a2,a2,-1530 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0202832:	06a00593          	li	a1,106
ffffffffc0202836:	00003517          	auipc	a0,0x3
ffffffffc020283a:	9c250513          	addi	a0,a0,-1598 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc020283e:	b3dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(base != NULL);
ffffffffc0202842:	00003697          	auipc	a3,0x3
ffffffffc0202846:	fc668693          	addi	a3,a3,-58 # ffffffffc0205808 <default_pmm_manager+0x668>
ffffffffc020284a:	00002617          	auipc	a2,0x2
ffffffffc020284e:	5a660613          	addi	a2,a2,1446 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202852:	1f300593          	li	a1,499
ffffffffc0202856:	00003517          	auipc	a0,0x3
ffffffffc020285a:	a0250513          	addi	a0,a0,-1534 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc020280c:	fc868693          	addi	a3,a3,-56 # ffffffffc02057d0 <default_pmm_manager+0x648>
ffffffffc0202810:	00002617          	auipc	a2,0x2
ffffffffc0202814:	5c860613          	addi	a2,a2,1480 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202818:	1f000593          	li	a1,496
ffffffffc020281c:	00003517          	auipc	a0,0x3
ffffffffc0202820:	a2450513          	addi	a0,a0,-1500 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202824:	b57fd0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0202828:	86aa                	mv	a3,a0
ffffffffc020282a:	00003617          	auipc	a2,0x3
ffffffffc020282e:	9ee60613          	addi	a2,a2,-1554 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0202832:	06a00593          	li	a1,106
ffffffffc0202836:	00003517          	auipc	a0,0x3
ffffffffc020283a:	9aa50513          	addi	a0,a0,-1622 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc020283e:	b3dfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(base != NULL);
ffffffffc0202842:	00003697          	auipc	a3,0x3
ffffffffc0202846:	fae68693          	addi	a3,a3,-82 # ffffffffc02057f0 <default_pmm_manager+0x668>
ffffffffc020284a:	00002617          	auipc	a2,0x2
ffffffffc020284e:	58e60613          	addi	a2,a2,1422 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202852:	1f300593          	li	a1,499
ffffffffc0202856:	00003517          	auipc	a0,0x3
ffffffffc020285a:	9ea50513          	addi	a0,a0,-1558 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc020285e:	b1dfd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0202862 <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0202862:	1101                	addi	sp,sp,-32
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0202864:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0202866:	ec06                	sd	ra,24(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0202868:	fff58713          	addi	a4,a1,-1
ffffffffc020286c:	17f9                	addi	a5,a5,-2
ffffffffc020286e:	0ae7ee63          	bltu	a5,a4,ffffffffc020292a <kfree+0xc8>
    assert(ptr != NULL);
ffffffffc0202872:	cd41                	beqz	a0,ffffffffc020290a <kfree+0xa8>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0202874:	6785                	lui	a5,0x1
ffffffffc0202876:	17fd                	addi	a5,a5,-1
ffffffffc0202878:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc020287a:	c02007b7          	lui	a5,0xc0200
ffffffffc020287e:	81b1                	srli	a1,a1,0xc
ffffffffc0202880:	06f56863          	bltu	a0,a5,ffffffffc02028f0 <kfree+0x8e>
ffffffffc0202884:	0000f697          	auipc	a3,0xf
ffffffffc0202888:	cb46b683          	ld	a3,-844(a3) # ffffffffc0211538 <va_pa_offset>
ffffffffc020288c:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage) {
ffffffffc020288e:	8131                	srli	a0,a0,0xc
ffffffffc0202890:	0000f797          	auipc	a5,0xf
ffffffffc0202894:	c907b783          	ld	a5,-880(a5) # ffffffffc0211520 <npage>
ffffffffc0202898:	04f57a63          	bgeu	a0,a5,ffffffffc02028ec <kfree+0x8a>
    return &pages[PPN(pa) - nbase];
ffffffffc020289c:	fff806b7          	lui	a3,0xfff80
ffffffffc02028a0:	9536                	add	a0,a0,a3
ffffffffc02028a2:	00351793          	slli	a5,a0,0x3
ffffffffc02028a6:	953e                	add	a0,a0,a5
ffffffffc02028a8:	050e                	slli	a0,a0,0x3
ffffffffc02028aa:	0000f797          	auipc	a5,0xf
ffffffffc02028ae:	c7e7b783          	ld	a5,-898(a5) # ffffffffc0211528 <pages>
ffffffffc02028b2:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02028b4:	100027f3          	csrr	a5,sstatus
ffffffffc02028b8:	8b89                	andi	a5,a5,2
ffffffffc02028ba:	eb89                	bnez	a5,ffffffffc02028cc <kfree+0x6a>
    { pmm_manager->free_pages(base, n); }
ffffffffc02028bc:	0000f797          	auipc	a5,0xf
ffffffffc02028c0:	c747b783          	ld	a5,-908(a5) # ffffffffc0211530 <pmm_manager>
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc02028c4:	60e2                	ld	ra,24(sp)
    { pmm_manager->free_pages(base, n); }
ffffffffc02028c6:	739c                	ld	a5,32(a5)
}
ffffffffc02028c8:	6105                	addi	sp,sp,32
    { pmm_manager->free_pages(base, n); }
ffffffffc02028ca:	8782                	jr	a5
        intr_disable();
ffffffffc02028cc:	e42a                	sd	a0,8(sp)
ffffffffc02028ce:	e02e                	sd	a1,0(sp)
ffffffffc02028d0:	c25fd0ef          	jal	ra,ffffffffc02004f4 <intr_disable>
ffffffffc02028d4:	0000f797          	auipc	a5,0xf
ffffffffc02028d8:	c5c7b783          	ld	a5,-932(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02028dc:	6582                	ld	a1,0(sp)
ffffffffc02028de:	6522                	ld	a0,8(sp)
ffffffffc02028e0:	739c                	ld	a5,32(a5)
ffffffffc02028e2:	9782                	jalr	a5
}
ffffffffc02028e4:	60e2                	ld	ra,24(sp)
ffffffffc02028e6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02028e8:	c07fd06f          	j	ffffffffc02004ee <intr_enable>
ffffffffc02028ec:	ccdfe0ef          	jal	ra,ffffffffc02015b8 <pa2page.part.0>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc02028f0:	86aa                	mv	a3,a0
ffffffffc02028f2:	00003617          	auipc	a2,0x3
<<<<<<< HEAD
ffffffffc02028f6:	9fe60613          	addi	a2,a2,-1538 # ffffffffc02052f0 <default_pmm_manager+0x150>
ffffffffc02028fa:	06c00593          	li	a1,108
ffffffffc02028fe:	00003517          	auipc	a0,0x3
ffffffffc0202902:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0202906:	a75fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(ptr != NULL);
ffffffffc020290a:	00003697          	auipc	a3,0x3
ffffffffc020290e:	f0e68693          	addi	a3,a3,-242 # ffffffffc0205818 <default_pmm_manager+0x678>
ffffffffc0202912:	00002617          	auipc	a2,0x2
ffffffffc0202916:	4de60613          	addi	a2,a2,1246 # ffffffffc0204df0 <commands+0x780>
ffffffffc020291a:	1fa00593          	li	a1,506
ffffffffc020291e:	00003517          	auipc	a0,0x3
ffffffffc0202922:	93a50513          	addi	a0,a0,-1734 # ffffffffc0205258 <default_pmm_manager+0xb8>
ffffffffc0202926:	a55fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc020292a:	00003697          	auipc	a3,0x3
ffffffffc020292e:	ebe68693          	addi	a3,a3,-322 # ffffffffc02057e8 <default_pmm_manager+0x648>
ffffffffc0202932:	00002617          	auipc	a2,0x2
ffffffffc0202936:	4be60613          	addi	a2,a2,1214 # ffffffffc0204df0 <commands+0x780>
ffffffffc020293a:	1f900593          	li	a1,505
ffffffffc020293e:	00003517          	auipc	a0,0x3
ffffffffc0202942:	91a50513          	addi	a0,a0,-1766 # ffffffffc0205258 <default_pmm_manager+0xb8>
=======
ffffffffc02028f6:	9e660613          	addi	a2,a2,-1562 # ffffffffc02052d8 <default_pmm_manager+0x150>
ffffffffc02028fa:	06c00593          	li	a1,108
ffffffffc02028fe:	00003517          	auipc	a0,0x3
ffffffffc0202902:	8e250513          	addi	a0,a0,-1822 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0202906:	a75fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(ptr != NULL);
ffffffffc020290a:	00003697          	auipc	a3,0x3
ffffffffc020290e:	ef668693          	addi	a3,a3,-266 # ffffffffc0205800 <default_pmm_manager+0x678>
ffffffffc0202912:	00002617          	auipc	a2,0x2
ffffffffc0202916:	4c660613          	addi	a2,a2,1222 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020291a:	1fa00593          	li	a1,506
ffffffffc020291e:	00003517          	auipc	a0,0x3
ffffffffc0202922:	92250513          	addi	a0,a0,-1758 # ffffffffc0205240 <default_pmm_manager+0xb8>
ffffffffc0202926:	a55fd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc020292a:	00003697          	auipc	a3,0x3
ffffffffc020292e:	ea668693          	addi	a3,a3,-346 # ffffffffc02057d0 <default_pmm_manager+0x648>
ffffffffc0202932:	00002617          	auipc	a2,0x2
ffffffffc0202936:	4a660613          	addi	a2,a2,1190 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020293a:	1f900593          	li	a1,505
ffffffffc020293e:	00003517          	auipc	a0,0x3
ffffffffc0202942:	90250513          	addi	a0,a0,-1790 # ffffffffc0205240 <default_pmm_manager+0xb8>
>>>>>>> 747620b (lab2)
ffffffffc0202946:	a35fd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020294a <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc020294a:	7135                	addi	sp,sp,-160
ffffffffc020294c:	ed06                	sd	ra,152(sp)
ffffffffc020294e:	e922                	sd	s0,144(sp)
ffffffffc0202950:	e526                	sd	s1,136(sp)
ffffffffc0202952:	e14a                	sd	s2,128(sp)
ffffffffc0202954:	fcce                	sd	s3,120(sp)
ffffffffc0202956:	f8d2                	sd	s4,112(sp)
ffffffffc0202958:	f4d6                	sd	s5,104(sp)
ffffffffc020295a:	f0da                	sd	s6,96(sp)
ffffffffc020295c:	ecde                	sd	s7,88(sp)
ffffffffc020295e:	e8e2                	sd	s8,80(sp)
ffffffffc0202960:	e4e6                	sd	s9,72(sp)
ffffffffc0202962:	e0ea                	sd	s10,64(sp)
ffffffffc0202964:	fc6e                	sd	s11,56(sp)
     swapfs_init();
<<<<<<< HEAD
ffffffffc0202966:	3fe010ef          	jal	ra,ffffffffc0203d64 <swapfs_init>
=======
ffffffffc0202966:	3e0010ef          	jal	ra,ffffffffc0203d46 <swapfs_init>
>>>>>>> 747620b (lab2)

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc020296a:	0000f697          	auipc	a3,0xf
ffffffffc020296e:	bd66b683          	ld	a3,-1066(a3) # ffffffffc0211540 <max_swap_offset>
ffffffffc0202972:	010007b7          	lui	a5,0x1000
ffffffffc0202976:	ff968713          	addi	a4,a3,-7
ffffffffc020297a:	17e1                	addi	a5,a5,-8
ffffffffc020297c:	3ee7e063          	bltu	a5,a4,ffffffffc0202d5c <swap_init+0x412>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_clock; //use first in first out Page Replacement Algorithm
ffffffffc0202980:	00007797          	auipc	a5,0x7
ffffffffc0202984:	68078793          	addi	a5,a5,1664 # ffffffffc020a000 <swap_manager_clock>
     int r = sm->init();
ffffffffc0202988:	6798                	ld	a4,8(a5)
     sm = &swap_manager_clock; //use first in first out Page Replacement Algorithm
ffffffffc020298a:	0000fb17          	auipc	s6,0xf
ffffffffc020298e:	bbeb0b13          	addi	s6,s6,-1090 # ffffffffc0211548 <sm>
ffffffffc0202992:	00fb3023          	sd	a5,0(s6)
     int r = sm->init();
ffffffffc0202996:	9702                	jalr	a4
ffffffffc0202998:	89aa                	mv	s3,a0
     
     if (r == 0)
ffffffffc020299a:	c10d                	beqz	a0,ffffffffc02029bc <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020299c:	60ea                	ld	ra,152(sp)
ffffffffc020299e:	644a                	ld	s0,144(sp)
ffffffffc02029a0:	64aa                	ld	s1,136(sp)
ffffffffc02029a2:	690a                	ld	s2,128(sp)
ffffffffc02029a4:	7a46                	ld	s4,112(sp)
ffffffffc02029a6:	7aa6                	ld	s5,104(sp)
ffffffffc02029a8:	7b06                	ld	s6,96(sp)
ffffffffc02029aa:	6be6                	ld	s7,88(sp)
ffffffffc02029ac:	6c46                	ld	s8,80(sp)
ffffffffc02029ae:	6ca6                	ld	s9,72(sp)
ffffffffc02029b0:	6d06                	ld	s10,64(sp)
ffffffffc02029b2:	7de2                	ld	s11,56(sp)
ffffffffc02029b4:	854e                	mv	a0,s3
ffffffffc02029b6:	79e6                	ld	s3,120(sp)
ffffffffc02029b8:	610d                	addi	sp,sp,160
ffffffffc02029ba:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02029bc:	000b3783          	ld	a5,0(s6)
ffffffffc02029c0:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc02029c4:	e9850513          	addi	a0,a0,-360 # ffffffffc0205858 <default_pmm_manager+0x6b8>
=======
ffffffffc02029c4:	e8050513          	addi	a0,a0,-384 # ffffffffc0205840 <default_pmm_manager+0x6b8>
>>>>>>> 747620b (lab2)
    return listelm->next;
ffffffffc02029c8:	0000e497          	auipc	s1,0xe
ffffffffc02029cc:	67848493          	addi	s1,s1,1656 # ffffffffc0211040 <free_area>
ffffffffc02029d0:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc02029d2:	4785                	li	a5,1
ffffffffc02029d4:	0000f717          	auipc	a4,0xf
ffffffffc02029d8:	b6f72e23          	sw	a5,-1156(a4) # ffffffffc0211550 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02029dc:	ee4fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
ffffffffc02029e0:	649c                	ld	a5,8(s1)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc02029e2:	4401                	li	s0,0
ffffffffc02029e4:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02029e6:	2c978163          	beq	a5,s1,ffffffffc0202ca8 <swap_init+0x35e>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02029ea:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02029ee:	8b09                	andi	a4,a4,2
ffffffffc02029f0:	2a070e63          	beqz	a4,ffffffffc0202cac <swap_init+0x362>
        count ++, total += p->property;
ffffffffc02029f4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02029f8:	679c                	ld	a5,8(a5)
ffffffffc02029fa:	2d05                	addiw	s10,s10,1
ffffffffc02029fc:	9c39                	addw	s0,s0,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc02029fe:	fe9796e3          	bne	a5,s1,ffffffffc02029ea <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc0202a02:	8922                	mv	s2,s0
ffffffffc0202a04:	cbffe0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc0202a08:	47251663          	bne	a0,s2,ffffffffc0202e74 <swap_init+0x52a>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc0202a0c:	8622                	mv	a2,s0
ffffffffc0202a0e:	85ea                	mv	a1,s10
ffffffffc0202a10:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202a14:	e6050513          	addi	a0,a0,-416 # ffffffffc0205870 <default_pmm_manager+0x6d0>
=======
ffffffffc0202a14:	e4850513          	addi	a0,a0,-440 # ffffffffc0205858 <default_pmm_manager+0x6d0>
>>>>>>> 747620b (lab2)
ffffffffc0202a18:	ea8fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
<<<<<<< HEAD
ffffffffc0202a1c:	2e7000ef          	jal	ra,ffffffffc0203502 <mm_create>
=======
ffffffffc0202a1c:	2c9000ef          	jal	ra,ffffffffc02034e4 <mm_create>
>>>>>>> 747620b (lab2)
ffffffffc0202a20:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc0202a22:	52050963          	beqz	a0,ffffffffc0202f54 <swap_init+0x60a>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0202a26:	0000f797          	auipc	a5,0xf
ffffffffc0202a2a:	b3a78793          	addi	a5,a5,-1222 # ffffffffc0211560 <check_mm_struct>
ffffffffc0202a2e:	6398                	ld	a4,0(a5)
ffffffffc0202a30:	54071263          	bnez	a4,ffffffffc0202f74 <swap_init+0x62a>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202a34:	0000fb97          	auipc	s7,0xf
ffffffffc0202a38:	ae4bbb83          	ld	s7,-1308(s7) # ffffffffc0211518 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc0202a3c:	000bb703          	ld	a4,0(s7)
     check_mm_struct = mm;
ffffffffc0202a40:	e388                	sd	a0,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202a42:	01753c23          	sd	s7,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0202a46:	3c071763          	bnez	a4,ffffffffc0202e14 <swap_init+0x4ca>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc0202a4a:	6599                	lui	a1,0x6
ffffffffc0202a4c:	460d                	li	a2,3
ffffffffc0202a4e:	6505                	lui	a0,0x1
<<<<<<< HEAD
ffffffffc0202a50:	2fb000ef          	jal	ra,ffffffffc020354a <vma_create>
=======
ffffffffc0202a50:	2dd000ef          	jal	ra,ffffffffc020352c <vma_create>
>>>>>>> 747620b (lab2)
ffffffffc0202a54:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0202a56:	3c050f63          	beqz	a0,ffffffffc0202e34 <swap_init+0x4ea>

     insert_vma_struct(mm, vma);
ffffffffc0202a5a:	8556                	mv	a0,s5
<<<<<<< HEAD
ffffffffc0202a5c:	35d000ef          	jal	ra,ffffffffc02035b8 <insert_vma_struct>
=======
ffffffffc0202a5c:	33f000ef          	jal	ra,ffffffffc020359a <insert_vma_struct>
>>>>>>> 747620b (lab2)

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0202a60:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202a64:	e8050513          	addi	a0,a0,-384 # ffffffffc02058e0 <default_pmm_manager+0x740>
=======
ffffffffc0202a64:	e6850513          	addi	a0,a0,-408 # ffffffffc02058c8 <default_pmm_manager+0x740>
>>>>>>> 747620b (lab2)
ffffffffc0202a68:	e58fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0202a6c:	018ab503          	ld	a0,24(s5)
ffffffffc0202a70:	4605                	li	a2,1
ffffffffc0202a72:	6585                	lui	a1,0x1
ffffffffc0202a74:	c89fe0ef          	jal	ra,ffffffffc02016fc <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0202a78:	3c050e63          	beqz	a0,ffffffffc0202e54 <swap_init+0x50a>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202a7c:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202a80:	eb450513          	addi	a0,a0,-332 # ffffffffc0205930 <default_pmm_manager+0x790>
=======
ffffffffc0202a80:	e9c50513          	addi	a0,a0,-356 # ffffffffc0205918 <default_pmm_manager+0x790>
>>>>>>> 747620b (lab2)
ffffffffc0202a84:	0000e917          	auipc	s2,0xe
ffffffffc0202a88:	5f490913          	addi	s2,s2,1524 # ffffffffc0211078 <check_rp>
ffffffffc0202a8c:	e34fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202a90:	0000ea17          	auipc	s4,0xe
ffffffffc0202a94:	608a0a13          	addi	s4,s4,1544 # ffffffffc0211098 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202a98:	8c4a                	mv	s8,s2
          check_rp[i] = alloc_page();
ffffffffc0202a9a:	4505                	li	a0,1
ffffffffc0202a9c:	b55fe0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
ffffffffc0202aa0:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc0202aa4:	28050c63          	beqz	a0,ffffffffc0202d3c <swap_init+0x3f2>
ffffffffc0202aa8:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0202aaa:	8b89                	andi	a5,a5,2
ffffffffc0202aac:	26079863          	bnez	a5,ffffffffc0202d1c <swap_init+0x3d2>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202ab0:	0c21                	addi	s8,s8,8
ffffffffc0202ab2:	ff4c14e3          	bne	s8,s4,ffffffffc0202a9a <swap_init+0x150>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0202ab6:	609c                	ld	a5,0(s1)
ffffffffc0202ab8:	0084bd83          	ld	s11,8(s1)
    elm->prev = elm->next = elm;
ffffffffc0202abc:	e084                	sd	s1,0(s1)
ffffffffc0202abe:	f03e                	sd	a5,32(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc0202ac0:	489c                	lw	a5,16(s1)
ffffffffc0202ac2:	e484                	sd	s1,8(s1)
     nr_free = 0;
ffffffffc0202ac4:	0000ec17          	auipc	s8,0xe
ffffffffc0202ac8:	5b4c0c13          	addi	s8,s8,1460 # ffffffffc0211078 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc0202acc:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc0202ace:	0000e797          	auipc	a5,0xe
ffffffffc0202ad2:	5807a123          	sw	zero,1410(a5) # ffffffffc0211050 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0202ad6:	000c3503          	ld	a0,0(s8)
ffffffffc0202ada:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202adc:	0c21                	addi	s8,s8,8
        free_pages(check_rp[i],1);
ffffffffc0202ade:	ba5fe0ef          	jal	ra,ffffffffc0201682 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202ae2:	ff4c1ae3          	bne	s8,s4,ffffffffc0202ad6 <swap_init+0x18c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202ae6:	0104ac03          	lw	s8,16(s1)
ffffffffc0202aea:	4791                	li	a5,4
ffffffffc0202aec:	4afc1463          	bne	s8,a5,ffffffffc0202f94 <swap_init+0x64a>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0202af0:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202af4:	ec850513          	addi	a0,a0,-312 # ffffffffc02059b8 <default_pmm_manager+0x818>
=======
ffffffffc0202af4:	eb050513          	addi	a0,a0,-336 # ffffffffc02059a0 <default_pmm_manager+0x818>
>>>>>>> 747620b (lab2)
ffffffffc0202af8:	dc8fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202afc:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0202afe:	0000f797          	auipc	a5,0xf
ffffffffc0202b02:	a607a523          	sw	zero,-1430(a5) # ffffffffc0211568 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202b06:	4529                	li	a0,10
ffffffffc0202b08:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc0202b0c:	0000f597          	auipc	a1,0xf
ffffffffc0202b10:	a5c5a583          	lw	a1,-1444(a1) # ffffffffc0211568 <pgfault_num>
ffffffffc0202b14:	4805                	li	a6,1
ffffffffc0202b16:	0000f797          	auipc	a5,0xf
ffffffffc0202b1a:	a5278793          	addi	a5,a5,-1454 # ffffffffc0211568 <pgfault_num>
ffffffffc0202b1e:	3f059b63          	bne	a1,a6,ffffffffc0202f14 <swap_init+0x5ca>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0202b22:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0202b26:	4390                	lw	a2,0(a5)
ffffffffc0202b28:	2601                	sext.w	a2,a2
ffffffffc0202b2a:	40b61563          	bne	a2,a1,ffffffffc0202f34 <swap_init+0x5ea>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202b2e:	6589                	lui	a1,0x2
ffffffffc0202b30:	452d                	li	a0,11
ffffffffc0202b32:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0202b36:	4390                	lw	a2,0(a5)
ffffffffc0202b38:	4809                	li	a6,2
ffffffffc0202b3a:	2601                	sext.w	a2,a2
ffffffffc0202b3c:	35061c63          	bne	a2,a6,ffffffffc0202e94 <swap_init+0x54a>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0202b40:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc0202b44:	438c                	lw	a1,0(a5)
ffffffffc0202b46:	2581                	sext.w	a1,a1
ffffffffc0202b48:	36c59663          	bne	a1,a2,ffffffffc0202eb4 <swap_init+0x56a>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202b4c:	658d                	lui	a1,0x3
ffffffffc0202b4e:	4531                	li	a0,12
ffffffffc0202b50:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0202b54:	4390                	lw	a2,0(a5)
ffffffffc0202b56:	480d                	li	a6,3
ffffffffc0202b58:	2601                	sext.w	a2,a2
ffffffffc0202b5a:	37061d63          	bne	a2,a6,ffffffffc0202ed4 <swap_init+0x58a>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0202b5e:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc0202b62:	438c                	lw	a1,0(a5)
ffffffffc0202b64:	2581                	sext.w	a1,a1
ffffffffc0202b66:	38c59763          	bne	a1,a2,ffffffffc0202ef4 <swap_init+0x5aa>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202b6a:	6591                	lui	a1,0x4
ffffffffc0202b6c:	4535                	li	a0,13
ffffffffc0202b6e:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0202b72:	4390                	lw	a2,0(a5)
ffffffffc0202b74:	2601                	sext.w	a2,a2
ffffffffc0202b76:	21861f63          	bne	a2,s8,ffffffffc0202d94 <swap_init+0x44a>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc0202b7a:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc0202b7e:	439c                	lw	a5,0(a5)
ffffffffc0202b80:	2781                	sext.w	a5,a5
ffffffffc0202b82:	22c79963          	bne	a5,a2,ffffffffc0202db4 <swap_init+0x46a>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0202b86:	489c                	lw	a5,16(s1)
ffffffffc0202b88:	24079663          	bnez	a5,ffffffffc0202dd4 <swap_init+0x48a>
ffffffffc0202b8c:	0000e797          	auipc	a5,0xe
ffffffffc0202b90:	50c78793          	addi	a5,a5,1292 # ffffffffc0211098 <swap_in_seq_no>
ffffffffc0202b94:	0000e617          	auipc	a2,0xe
ffffffffc0202b98:	52c60613          	addi	a2,a2,1324 # ffffffffc02110c0 <swap_out_seq_no>
ffffffffc0202b9c:	0000e517          	auipc	a0,0xe
ffffffffc0202ba0:	52450513          	addi	a0,a0,1316 # ffffffffc02110c0 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0202ba4:	55fd                	li	a1,-1
ffffffffc0202ba6:	c38c                	sw	a1,0(a5)
ffffffffc0202ba8:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0202baa:	0791                	addi	a5,a5,4
ffffffffc0202bac:	0611                	addi	a2,a2,4
ffffffffc0202bae:	fef51ce3          	bne	a0,a5,ffffffffc0202ba6 <swap_init+0x25c>
ffffffffc0202bb2:	0000e817          	auipc	a6,0xe
ffffffffc0202bb6:	4a680813          	addi	a6,a6,1190 # ffffffffc0211058 <check_ptep>
ffffffffc0202bba:	0000e897          	auipc	a7,0xe
ffffffffc0202bbe:	4be88893          	addi	a7,a7,1214 # ffffffffc0211078 <check_rp>
ffffffffc0202bc2:	6585                	lui	a1,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc0202bc4:	0000fc97          	auipc	s9,0xf
ffffffffc0202bc8:	964c8c93          	addi	s9,s9,-1692 # ffffffffc0211528 <pages>
ffffffffc0202bcc:	00003c17          	auipc	s8,0x3
<<<<<<< HEAD
ffffffffc0202bd0:	6acc0c13          	addi	s8,s8,1708 # ffffffffc0206278 <nbase>
=======
ffffffffc0202bd0:	684c0c13          	addi	s8,s8,1668 # ffffffffc0206250 <nbase>
>>>>>>> 747620b (lab2)
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0202bd4:	00083023          	sd	zero,0(a6)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202bd8:	4601                	li	a2,0
ffffffffc0202bda:	855e                	mv	a0,s7
ffffffffc0202bdc:	ec46                	sd	a7,24(sp)
ffffffffc0202bde:	e82e                	sd	a1,16(sp)
         check_ptep[i]=0;
ffffffffc0202be0:	e442                	sd	a6,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202be2:	b1bfe0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0202be6:	6822                	ld	a6,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0202be8:	65c2                	ld	a1,16(sp)
ffffffffc0202bea:	68e2                	ld	a7,24(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202bec:	00a83023          	sd	a0,0(a6)
         assert(check_ptep[i] != NULL);
ffffffffc0202bf0:	0000f317          	auipc	t1,0xf
ffffffffc0202bf4:	93030313          	addi	t1,t1,-1744 # ffffffffc0211520 <npage>
ffffffffc0202bf8:	16050e63          	beqz	a0,ffffffffc0202d74 <swap_init+0x42a>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202bfc:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0202bfe:	0017f613          	andi	a2,a5,1
ffffffffc0202c02:	0e060563          	beqz	a2,ffffffffc0202cec <swap_init+0x3a2>
    if (PPN(pa) >= npage) {
ffffffffc0202c06:	00033603          	ld	a2,0(t1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202c0a:	078a                	slli	a5,a5,0x2
ffffffffc0202c0c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202c0e:	0ec7fb63          	bgeu	a5,a2,ffffffffc0202d04 <swap_init+0x3ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c12:	000c3603          	ld	a2,0(s8)
ffffffffc0202c16:	000cb503          	ld	a0,0(s9)
ffffffffc0202c1a:	0008bf03          	ld	t5,0(a7)
ffffffffc0202c1e:	8f91                	sub	a5,a5,a2
ffffffffc0202c20:	00379613          	slli	a2,a5,0x3
ffffffffc0202c24:	97b2                	add	a5,a5,a2
ffffffffc0202c26:	078e                	slli	a5,a5,0x3
ffffffffc0202c28:	97aa                	add	a5,a5,a0
ffffffffc0202c2a:	0aff1163          	bne	t5,a5,ffffffffc0202ccc <swap_init+0x382>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202c2e:	6785                	lui	a5,0x1
ffffffffc0202c30:	95be                	add	a1,a1,a5
ffffffffc0202c32:	6795                	lui	a5,0x5
ffffffffc0202c34:	0821                	addi	a6,a6,8
ffffffffc0202c36:	08a1                	addi	a7,a7,8
ffffffffc0202c38:	f8f59ee3          	bne	a1,a5,ffffffffc0202bd4 <swap_init+0x28a>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0202c3c:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202c40:	e2450513          	addi	a0,a0,-476 # ffffffffc0205a60 <default_pmm_manager+0x8c0>
=======
ffffffffc0202c40:	e0c50513          	addi	a0,a0,-500 # ffffffffc0205a48 <default_pmm_manager+0x8c0>
>>>>>>> 747620b (lab2)
ffffffffc0202c44:	c7cfd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    int ret = sm->check_swap();
ffffffffc0202c48:	000b3783          	ld	a5,0(s6)
ffffffffc0202c4c:	7f9c                	ld	a5,56(a5)
ffffffffc0202c4e:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc0202c50:	1a051263          	bnez	a0,ffffffffc0202df4 <swap_init+0x4aa>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc0202c54:	00093503          	ld	a0,0(s2)
ffffffffc0202c58:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202c5a:	0921                	addi	s2,s2,8
         free_pages(check_rp[i],1);
ffffffffc0202c5c:	a27fe0ef          	jal	ra,ffffffffc0201682 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202c60:	ff491ae3          	bne	s2,s4,ffffffffc0202c54 <swap_init+0x30a>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc0202c64:	8556                	mv	a0,s5
<<<<<<< HEAD
ffffffffc0202c66:	223000ef          	jal	ra,ffffffffc0203688 <mm_destroy>
=======
ffffffffc0202c66:	205000ef          	jal	ra,ffffffffc020366a <mm_destroy>
>>>>>>> 747620b (lab2)
         
     nr_free = nr_free_store;
ffffffffc0202c6a:	77a2                	ld	a5,40(sp)
     free_list = free_list_store;
ffffffffc0202c6c:	01b4b423          	sd	s11,8(s1)
     nr_free = nr_free_store;
ffffffffc0202c70:	c89c                	sw	a5,16(s1)
     free_list = free_list_store;
ffffffffc0202c72:	7782                	ld	a5,32(sp)
ffffffffc0202c74:	e09c                	sd	a5,0(s1)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c76:	009d8a63          	beq	s11,s1,ffffffffc0202c8a <swap_init+0x340>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0202c7a:	ff8da783          	lw	a5,-8(s11)
    return listelm->next;
ffffffffc0202c7e:	008dbd83          	ld	s11,8(s11)
ffffffffc0202c82:	3d7d                	addiw	s10,s10,-1
ffffffffc0202c84:	9c1d                	subw	s0,s0,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c86:	fe9d9ae3          	bne	s11,s1,ffffffffc0202c7a <swap_init+0x330>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc0202c8a:	8622                	mv	a2,s0
ffffffffc0202c8c:	85ea                	mv	a1,s10
ffffffffc0202c8e:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202c92:	e0250513          	addi	a0,a0,-510 # ffffffffc0205a90 <default_pmm_manager+0x8f0>
=======
ffffffffc0202c92:	dea50513          	addi	a0,a0,-534 # ffffffffc0205a78 <default_pmm_manager+0x8f0>
>>>>>>> 747620b (lab2)
ffffffffc0202c96:	c2afd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc0202c9a:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc0202c9e:	e1650513          	addi	a0,a0,-490 # ffffffffc0205ab0 <default_pmm_manager+0x910>
=======
ffffffffc0202c9e:	dfe50513          	addi	a0,a0,-514 # ffffffffc0205a98 <default_pmm_manager+0x910>
>>>>>>> 747620b (lab2)
ffffffffc0202ca2:	c1efd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
}
ffffffffc0202ca6:	b9dd                	j	ffffffffc020299c <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202ca8:	4901                	li	s2,0
ffffffffc0202caa:	bba9                	j	ffffffffc0202a04 <swap_init+0xba>
        assert(PageProperty(p));
ffffffffc0202cac:	00002697          	auipc	a3,0x2
<<<<<<< HEAD
ffffffffc0202cb0:	13468693          	addi	a3,a3,308 # ffffffffc0204de0 <commands+0x770>
ffffffffc0202cb4:	00002617          	auipc	a2,0x2
ffffffffc0202cb8:	13c60613          	addi	a2,a2,316 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202cbc:	0be00593          	li	a1,190
ffffffffc0202cc0:	00003517          	auipc	a0,0x3
ffffffffc0202cc4:	b8850513          	addi	a0,a0,-1144 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202cc8:	eb2fd0ef          	jal	ra,ffffffffc020037a <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202ccc:	00003697          	auipc	a3,0x3
ffffffffc0202cd0:	d6c68693          	addi	a3,a3,-660 # ffffffffc0205a38 <default_pmm_manager+0x898>
ffffffffc0202cd4:	00002617          	auipc	a2,0x2
ffffffffc0202cd8:	11c60613          	addi	a2,a2,284 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202cdc:	0fe00593          	li	a1,254
ffffffffc0202ce0:	00003517          	auipc	a0,0x3
ffffffffc0202ce4:	b6850513          	addi	a0,a0,-1176 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202ce8:	e92fd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0202cec:	00002617          	auipc	a2,0x2
ffffffffc0202cf0:	51c60613          	addi	a2,a2,1308 # ffffffffc0205208 <default_pmm_manager+0x68>
ffffffffc0202cf4:	07000593          	li	a1,112
ffffffffc0202cf8:	00002517          	auipc	a0,0x2
ffffffffc0202cfc:	50050513          	addi	a0,a0,1280 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0202d00:	e7afd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202d04:	00002617          	auipc	a2,0x2
ffffffffc0202d08:	4d460613          	addi	a2,a2,1236 # ffffffffc02051d8 <default_pmm_manager+0x38>
ffffffffc0202d0c:	06500593          	li	a1,101
ffffffffc0202d10:	00002517          	auipc	a0,0x2
ffffffffc0202d14:	4e850513          	addi	a0,a0,1256 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0202d18:	e62fd0ef          	jal	ra,ffffffffc020037a <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0202d1c:	00003697          	auipc	a3,0x3
ffffffffc0202d20:	c5468693          	addi	a3,a3,-940 # ffffffffc0205970 <default_pmm_manager+0x7d0>
ffffffffc0202d24:	00002617          	auipc	a2,0x2
ffffffffc0202d28:	0cc60613          	addi	a2,a2,204 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202d2c:	0df00593          	li	a1,223
ffffffffc0202d30:	00003517          	auipc	a0,0x3
ffffffffc0202d34:	b1850513          	addi	a0,a0,-1256 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202d38:	e42fd0ef          	jal	ra,ffffffffc020037a <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0202d3c:	00003697          	auipc	a3,0x3
ffffffffc0202d40:	c1c68693          	addi	a3,a3,-996 # ffffffffc0205958 <default_pmm_manager+0x7b8>
ffffffffc0202d44:	00002617          	auipc	a2,0x2
ffffffffc0202d48:	0ac60613          	addi	a2,a2,172 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202d4c:	0de00593          	li	a1,222
ffffffffc0202d50:	00003517          	auipc	a0,0x3
ffffffffc0202d54:	af850513          	addi	a0,a0,-1288 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202d58:	e22fd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0202d5c:	00003617          	auipc	a2,0x3
ffffffffc0202d60:	acc60613          	addi	a2,a2,-1332 # ffffffffc0205828 <default_pmm_manager+0x688>
ffffffffc0202d64:	02800593          	li	a1,40
ffffffffc0202d68:	00003517          	auipc	a0,0x3
ffffffffc0202d6c:	ae050513          	addi	a0,a0,-1312 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202d70:	e0afd0ef          	jal	ra,ffffffffc020037a <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0202d74:	00003697          	auipc	a3,0x3
ffffffffc0202d78:	cac68693          	addi	a3,a3,-852 # ffffffffc0205a20 <default_pmm_manager+0x880>
ffffffffc0202d7c:	00002617          	auipc	a2,0x2
ffffffffc0202d80:	07460613          	addi	a2,a2,116 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202d84:	0fd00593          	li	a1,253
ffffffffc0202d88:	00003517          	auipc	a0,0x3
ffffffffc0202d8c:	ac050513          	addi	a0,a0,-1344 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202d90:	deafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==4);
ffffffffc0202d94:	00003697          	auipc	a3,0x3
ffffffffc0202d98:	c7c68693          	addi	a3,a3,-900 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc0202d9c:	00002617          	auipc	a2,0x2
ffffffffc0202da0:	05460613          	addi	a2,a2,84 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202da4:	0a100593          	li	a1,161
ffffffffc0202da8:	00003517          	auipc	a0,0x3
ffffffffc0202dac:	aa050513          	addi	a0,a0,-1376 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202db0:	dcafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==4);
ffffffffc0202db4:	00003697          	auipc	a3,0x3
ffffffffc0202db8:	c5c68693          	addi	a3,a3,-932 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc0202dbc:	00002617          	auipc	a2,0x2
ffffffffc0202dc0:	03460613          	addi	a2,a2,52 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202dc4:	0a300593          	li	a1,163
ffffffffc0202dc8:	00003517          	auipc	a0,0x3
ffffffffc0202dcc:	a8050513          	addi	a0,a0,-1408 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202dd0:	daafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert( nr_free == 0);         
ffffffffc0202dd4:	00002697          	auipc	a3,0x2
ffffffffc0202dd8:	1f468693          	addi	a3,a3,500 # ffffffffc0204fc8 <commands+0x958>
ffffffffc0202ddc:	00002617          	auipc	a2,0x2
ffffffffc0202de0:	01460613          	addi	a2,a2,20 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202de4:	0f500593          	li	a1,245
ffffffffc0202de8:	00003517          	auipc	a0,0x3
ffffffffc0202dec:	a6050513          	addi	a0,a0,-1440 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202df0:	d8afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(ret==0);
ffffffffc0202df4:	00003697          	auipc	a3,0x3
ffffffffc0202df8:	c9468693          	addi	a3,a3,-876 # ffffffffc0205a88 <default_pmm_manager+0x8e8>
ffffffffc0202dfc:	00002617          	auipc	a2,0x2
ffffffffc0202e00:	ff460613          	addi	a2,a2,-12 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202e04:	10400593          	li	a1,260
ffffffffc0202e08:	00003517          	auipc	a0,0x3
ffffffffc0202e0c:	a4050513          	addi	a0,a0,-1472 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202e10:	d6afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgdir[0] == 0);
ffffffffc0202e14:	00003697          	auipc	a3,0x3
ffffffffc0202e18:	aac68693          	addi	a3,a3,-1364 # ffffffffc02058c0 <default_pmm_manager+0x720>
ffffffffc0202e1c:	00002617          	auipc	a2,0x2
ffffffffc0202e20:	fd460613          	addi	a2,a2,-44 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202e24:	0ce00593          	li	a1,206
ffffffffc0202e28:	00003517          	auipc	a0,0x3
ffffffffc0202e2c:	a2050513          	addi	a0,a0,-1504 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202e30:	d4afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(vma != NULL);
ffffffffc0202e34:	00003697          	auipc	a3,0x3
ffffffffc0202e38:	a9c68693          	addi	a3,a3,-1380 # ffffffffc02058d0 <default_pmm_manager+0x730>
ffffffffc0202e3c:	00002617          	auipc	a2,0x2
ffffffffc0202e40:	fb460613          	addi	a2,a2,-76 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202e44:	0d100593          	li	a1,209
ffffffffc0202e48:	00003517          	auipc	a0,0x3
ffffffffc0202e4c:	a0050513          	addi	a0,a0,-1536 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202e50:	d2afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0202e54:	00003697          	auipc	a3,0x3
ffffffffc0202e58:	ac468693          	addi	a3,a3,-1340 # ffffffffc0205918 <default_pmm_manager+0x778>
ffffffffc0202e5c:	00002617          	auipc	a2,0x2
ffffffffc0202e60:	f9460613          	addi	a2,a2,-108 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202e64:	0d900593          	li	a1,217
ffffffffc0202e68:	00003517          	auipc	a0,0x3
ffffffffc0202e6c:	9e050513          	addi	a0,a0,-1568 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202e70:	d0afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(total == nr_free_pages());
ffffffffc0202e74:	00002697          	auipc	a3,0x2
ffffffffc0202e78:	fac68693          	addi	a3,a3,-84 # ffffffffc0204e20 <commands+0x7b0>
ffffffffc0202e7c:	00002617          	auipc	a2,0x2
ffffffffc0202e80:	f7460613          	addi	a2,a2,-140 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202e84:	0c100593          	li	a1,193
ffffffffc0202e88:	00003517          	auipc	a0,0x3
ffffffffc0202e8c:	9c050513          	addi	a0,a0,-1600 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202e90:	ceafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==2);
ffffffffc0202e94:	00003697          	auipc	a3,0x3
ffffffffc0202e98:	b5c68693          	addi	a3,a3,-1188 # ffffffffc02059f0 <default_pmm_manager+0x850>
ffffffffc0202e9c:	00002617          	auipc	a2,0x2
ffffffffc0202ea0:	f5460613          	addi	a2,a2,-172 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202ea4:	09900593          	li	a1,153
ffffffffc0202ea8:	00003517          	auipc	a0,0x3
ffffffffc0202eac:	9a050513          	addi	a0,a0,-1632 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202eb0:	ccafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==2);
ffffffffc0202eb4:	00003697          	auipc	a3,0x3
ffffffffc0202eb8:	b3c68693          	addi	a3,a3,-1220 # ffffffffc02059f0 <default_pmm_manager+0x850>
ffffffffc0202ebc:	00002617          	auipc	a2,0x2
ffffffffc0202ec0:	f3460613          	addi	a2,a2,-204 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202ec4:	09b00593          	li	a1,155
ffffffffc0202ec8:	00003517          	auipc	a0,0x3
ffffffffc0202ecc:	98050513          	addi	a0,a0,-1664 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202ed0:	caafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==3);
ffffffffc0202ed4:	00003697          	auipc	a3,0x3
ffffffffc0202ed8:	b2c68693          	addi	a3,a3,-1236 # ffffffffc0205a00 <default_pmm_manager+0x860>
ffffffffc0202edc:	00002617          	auipc	a2,0x2
ffffffffc0202ee0:	f1460613          	addi	a2,a2,-236 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202ee4:	09d00593          	li	a1,157
ffffffffc0202ee8:	00003517          	auipc	a0,0x3
ffffffffc0202eec:	96050513          	addi	a0,a0,-1696 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202ef0:	c8afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==3);
ffffffffc0202ef4:	00003697          	auipc	a3,0x3
ffffffffc0202ef8:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0205a00 <default_pmm_manager+0x860>
ffffffffc0202efc:	00002617          	auipc	a2,0x2
ffffffffc0202f00:	ef460613          	addi	a2,a2,-268 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202f04:	09f00593          	li	a1,159
ffffffffc0202f08:	00003517          	auipc	a0,0x3
ffffffffc0202f0c:	94050513          	addi	a0,a0,-1728 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202f10:	c6afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==1);
ffffffffc0202f14:	00003697          	auipc	a3,0x3
ffffffffc0202f18:	acc68693          	addi	a3,a3,-1332 # ffffffffc02059e0 <default_pmm_manager+0x840>
ffffffffc0202f1c:	00002617          	auipc	a2,0x2
ffffffffc0202f20:	ed460613          	addi	a2,a2,-300 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202f24:	09500593          	li	a1,149
ffffffffc0202f28:	00003517          	auipc	a0,0x3
ffffffffc0202f2c:	92050513          	addi	a0,a0,-1760 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202f30:	c4afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==1);
ffffffffc0202f34:	00003697          	auipc	a3,0x3
ffffffffc0202f38:	aac68693          	addi	a3,a3,-1364 # ffffffffc02059e0 <default_pmm_manager+0x840>
ffffffffc0202f3c:	00002617          	auipc	a2,0x2
ffffffffc0202f40:	eb460613          	addi	a2,a2,-332 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202f44:	09700593          	li	a1,151
ffffffffc0202f48:	00003517          	auipc	a0,0x3
ffffffffc0202f4c:	90050513          	addi	a0,a0,-1792 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202f50:	c2afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(mm != NULL);
ffffffffc0202f54:	00003697          	auipc	a3,0x3
ffffffffc0202f58:	94468693          	addi	a3,a3,-1724 # ffffffffc0205898 <default_pmm_manager+0x6f8>
ffffffffc0202f5c:	00002617          	auipc	a2,0x2
ffffffffc0202f60:	e9460613          	addi	a2,a2,-364 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202f64:	0c600593          	li	a1,198
ffffffffc0202f68:	00003517          	auipc	a0,0x3
ffffffffc0202f6c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202f70:	c0afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0202f74:	00003697          	auipc	a3,0x3
ffffffffc0202f78:	93468693          	addi	a3,a3,-1740 # ffffffffc02058a8 <default_pmm_manager+0x708>
ffffffffc0202f7c:	00002617          	auipc	a2,0x2
ffffffffc0202f80:	e7460613          	addi	a2,a2,-396 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202f84:	0c900593          	li	a1,201
ffffffffc0202f88:	00003517          	auipc	a0,0x3
ffffffffc0202f8c:	8c050513          	addi	a0,a0,-1856 # ffffffffc0205848 <default_pmm_manager+0x6a8>
ffffffffc0202f90:	beafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202f94:	00003697          	auipc	a3,0x3
ffffffffc0202f98:	9fc68693          	addi	a3,a3,-1540 # ffffffffc0205990 <default_pmm_manager+0x7f0>
ffffffffc0202f9c:	00002617          	auipc	a2,0x2
ffffffffc0202fa0:	e5460613          	addi	a2,a2,-428 # ffffffffc0204df0 <commands+0x780>
ffffffffc0202fa4:	0ec00593          	li	a1,236
ffffffffc0202fa8:	00003517          	auipc	a0,0x3
ffffffffc0202fac:	8a050513          	addi	a0,a0,-1888 # ffffffffc0205848 <default_pmm_manager+0x6a8>
=======
ffffffffc0202cb0:	11c68693          	addi	a3,a3,284 # ffffffffc0204dc8 <commands+0x770>
ffffffffc0202cb4:	00002617          	auipc	a2,0x2
ffffffffc0202cb8:	12460613          	addi	a2,a2,292 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202cbc:	0be00593          	li	a1,190
ffffffffc0202cc0:	00003517          	auipc	a0,0x3
ffffffffc0202cc4:	b7050513          	addi	a0,a0,-1168 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202cc8:	eb2fd0ef          	jal	ra,ffffffffc020037a <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202ccc:	00003697          	auipc	a3,0x3
ffffffffc0202cd0:	d5468693          	addi	a3,a3,-684 # ffffffffc0205a20 <default_pmm_manager+0x898>
ffffffffc0202cd4:	00002617          	auipc	a2,0x2
ffffffffc0202cd8:	10460613          	addi	a2,a2,260 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202cdc:	0fe00593          	li	a1,254
ffffffffc0202ce0:	00003517          	auipc	a0,0x3
ffffffffc0202ce4:	b5050513          	addi	a0,a0,-1200 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202ce8:	e92fd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0202cec:	00002617          	auipc	a2,0x2
ffffffffc0202cf0:	50460613          	addi	a2,a2,1284 # ffffffffc02051f0 <default_pmm_manager+0x68>
ffffffffc0202cf4:	07000593          	li	a1,112
ffffffffc0202cf8:	00002517          	auipc	a0,0x2
ffffffffc0202cfc:	4e850513          	addi	a0,a0,1256 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0202d00:	e7afd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202d04:	00002617          	auipc	a2,0x2
ffffffffc0202d08:	4bc60613          	addi	a2,a2,1212 # ffffffffc02051c0 <default_pmm_manager+0x38>
ffffffffc0202d0c:	06500593          	li	a1,101
ffffffffc0202d10:	00002517          	auipc	a0,0x2
ffffffffc0202d14:	4d050513          	addi	a0,a0,1232 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0202d18:	e62fd0ef          	jal	ra,ffffffffc020037a <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0202d1c:	00003697          	auipc	a3,0x3
ffffffffc0202d20:	c3c68693          	addi	a3,a3,-964 # ffffffffc0205958 <default_pmm_manager+0x7d0>
ffffffffc0202d24:	00002617          	auipc	a2,0x2
ffffffffc0202d28:	0b460613          	addi	a2,a2,180 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202d2c:	0df00593          	li	a1,223
ffffffffc0202d30:	00003517          	auipc	a0,0x3
ffffffffc0202d34:	b0050513          	addi	a0,a0,-1280 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202d38:	e42fd0ef          	jal	ra,ffffffffc020037a <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0202d3c:	00003697          	auipc	a3,0x3
ffffffffc0202d40:	c0468693          	addi	a3,a3,-1020 # ffffffffc0205940 <default_pmm_manager+0x7b8>
ffffffffc0202d44:	00002617          	auipc	a2,0x2
ffffffffc0202d48:	09460613          	addi	a2,a2,148 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202d4c:	0de00593          	li	a1,222
ffffffffc0202d50:	00003517          	auipc	a0,0x3
ffffffffc0202d54:	ae050513          	addi	a0,a0,-1312 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202d58:	e22fd0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0202d5c:	00003617          	auipc	a2,0x3
ffffffffc0202d60:	ab460613          	addi	a2,a2,-1356 # ffffffffc0205810 <default_pmm_manager+0x688>
ffffffffc0202d64:	02800593          	li	a1,40
ffffffffc0202d68:	00003517          	auipc	a0,0x3
ffffffffc0202d6c:	ac850513          	addi	a0,a0,-1336 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202d70:	e0afd0ef          	jal	ra,ffffffffc020037a <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0202d74:	00003697          	auipc	a3,0x3
ffffffffc0202d78:	c9468693          	addi	a3,a3,-876 # ffffffffc0205a08 <default_pmm_manager+0x880>
ffffffffc0202d7c:	00002617          	auipc	a2,0x2
ffffffffc0202d80:	05c60613          	addi	a2,a2,92 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202d84:	0fd00593          	li	a1,253
ffffffffc0202d88:	00003517          	auipc	a0,0x3
ffffffffc0202d8c:	aa850513          	addi	a0,a0,-1368 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202d90:	deafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==4);
ffffffffc0202d94:	00003697          	auipc	a3,0x3
ffffffffc0202d98:	c6468693          	addi	a3,a3,-924 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc0202d9c:	00002617          	auipc	a2,0x2
ffffffffc0202da0:	03c60613          	addi	a2,a2,60 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202da4:	0a100593          	li	a1,161
ffffffffc0202da8:	00003517          	auipc	a0,0x3
ffffffffc0202dac:	a8850513          	addi	a0,a0,-1400 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202db0:	dcafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==4);
ffffffffc0202db4:	00003697          	auipc	a3,0x3
ffffffffc0202db8:	c4468693          	addi	a3,a3,-956 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc0202dbc:	00002617          	auipc	a2,0x2
ffffffffc0202dc0:	01c60613          	addi	a2,a2,28 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202dc4:	0a300593          	li	a1,163
ffffffffc0202dc8:	00003517          	auipc	a0,0x3
ffffffffc0202dcc:	a6850513          	addi	a0,a0,-1432 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202dd0:	daafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert( nr_free == 0);         
ffffffffc0202dd4:	00002697          	auipc	a3,0x2
ffffffffc0202dd8:	1dc68693          	addi	a3,a3,476 # ffffffffc0204fb0 <commands+0x958>
ffffffffc0202ddc:	00002617          	auipc	a2,0x2
ffffffffc0202de0:	ffc60613          	addi	a2,a2,-4 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202de4:	0f500593          	li	a1,245
ffffffffc0202de8:	00003517          	auipc	a0,0x3
ffffffffc0202dec:	a4850513          	addi	a0,a0,-1464 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202df0:	d8afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(ret==0);
ffffffffc0202df4:	00003697          	auipc	a3,0x3
ffffffffc0202df8:	c7c68693          	addi	a3,a3,-900 # ffffffffc0205a70 <default_pmm_manager+0x8e8>
ffffffffc0202dfc:	00002617          	auipc	a2,0x2
ffffffffc0202e00:	fdc60613          	addi	a2,a2,-36 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202e04:	10400593          	li	a1,260
ffffffffc0202e08:	00003517          	auipc	a0,0x3
ffffffffc0202e0c:	a2850513          	addi	a0,a0,-1496 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202e10:	d6afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgdir[0] == 0);
ffffffffc0202e14:	00003697          	auipc	a3,0x3
ffffffffc0202e18:	a9468693          	addi	a3,a3,-1388 # ffffffffc02058a8 <default_pmm_manager+0x720>
ffffffffc0202e1c:	00002617          	auipc	a2,0x2
ffffffffc0202e20:	fbc60613          	addi	a2,a2,-68 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202e24:	0ce00593          	li	a1,206
ffffffffc0202e28:	00003517          	auipc	a0,0x3
ffffffffc0202e2c:	a0850513          	addi	a0,a0,-1528 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202e30:	d4afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(vma != NULL);
ffffffffc0202e34:	00003697          	auipc	a3,0x3
ffffffffc0202e38:	a8468693          	addi	a3,a3,-1404 # ffffffffc02058b8 <default_pmm_manager+0x730>
ffffffffc0202e3c:	00002617          	auipc	a2,0x2
ffffffffc0202e40:	f9c60613          	addi	a2,a2,-100 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202e44:	0d100593          	li	a1,209
ffffffffc0202e48:	00003517          	auipc	a0,0x3
ffffffffc0202e4c:	9e850513          	addi	a0,a0,-1560 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202e50:	d2afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0202e54:	00003697          	auipc	a3,0x3
ffffffffc0202e58:	aac68693          	addi	a3,a3,-1364 # ffffffffc0205900 <default_pmm_manager+0x778>
ffffffffc0202e5c:	00002617          	auipc	a2,0x2
ffffffffc0202e60:	f7c60613          	addi	a2,a2,-132 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202e64:	0d900593          	li	a1,217
ffffffffc0202e68:	00003517          	auipc	a0,0x3
ffffffffc0202e6c:	9c850513          	addi	a0,a0,-1592 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202e70:	d0afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(total == nr_free_pages());
ffffffffc0202e74:	00002697          	auipc	a3,0x2
ffffffffc0202e78:	f9468693          	addi	a3,a3,-108 # ffffffffc0204e08 <commands+0x7b0>
ffffffffc0202e7c:	00002617          	auipc	a2,0x2
ffffffffc0202e80:	f5c60613          	addi	a2,a2,-164 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202e84:	0c100593          	li	a1,193
ffffffffc0202e88:	00003517          	auipc	a0,0x3
ffffffffc0202e8c:	9a850513          	addi	a0,a0,-1624 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202e90:	ceafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==2);
ffffffffc0202e94:	00003697          	auipc	a3,0x3
ffffffffc0202e98:	b4468693          	addi	a3,a3,-1212 # ffffffffc02059d8 <default_pmm_manager+0x850>
ffffffffc0202e9c:	00002617          	auipc	a2,0x2
ffffffffc0202ea0:	f3c60613          	addi	a2,a2,-196 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202ea4:	09900593          	li	a1,153
ffffffffc0202ea8:	00003517          	auipc	a0,0x3
ffffffffc0202eac:	98850513          	addi	a0,a0,-1656 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202eb0:	ccafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==2);
ffffffffc0202eb4:	00003697          	auipc	a3,0x3
ffffffffc0202eb8:	b2468693          	addi	a3,a3,-1244 # ffffffffc02059d8 <default_pmm_manager+0x850>
ffffffffc0202ebc:	00002617          	auipc	a2,0x2
ffffffffc0202ec0:	f1c60613          	addi	a2,a2,-228 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202ec4:	09b00593          	li	a1,155
ffffffffc0202ec8:	00003517          	auipc	a0,0x3
ffffffffc0202ecc:	96850513          	addi	a0,a0,-1688 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202ed0:	caafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==3);
ffffffffc0202ed4:	00003697          	auipc	a3,0x3
ffffffffc0202ed8:	b1468693          	addi	a3,a3,-1260 # ffffffffc02059e8 <default_pmm_manager+0x860>
ffffffffc0202edc:	00002617          	auipc	a2,0x2
ffffffffc0202ee0:	efc60613          	addi	a2,a2,-260 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202ee4:	09d00593          	li	a1,157
ffffffffc0202ee8:	00003517          	auipc	a0,0x3
ffffffffc0202eec:	94850513          	addi	a0,a0,-1720 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202ef0:	c8afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==3);
ffffffffc0202ef4:	00003697          	auipc	a3,0x3
ffffffffc0202ef8:	af468693          	addi	a3,a3,-1292 # ffffffffc02059e8 <default_pmm_manager+0x860>
ffffffffc0202efc:	00002617          	auipc	a2,0x2
ffffffffc0202f00:	edc60613          	addi	a2,a2,-292 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202f04:	09f00593          	li	a1,159
ffffffffc0202f08:	00003517          	auipc	a0,0x3
ffffffffc0202f0c:	92850513          	addi	a0,a0,-1752 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202f10:	c6afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==1);
ffffffffc0202f14:	00003697          	auipc	a3,0x3
ffffffffc0202f18:	ab468693          	addi	a3,a3,-1356 # ffffffffc02059c8 <default_pmm_manager+0x840>
ffffffffc0202f1c:	00002617          	auipc	a2,0x2
ffffffffc0202f20:	ebc60613          	addi	a2,a2,-324 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202f24:	09500593          	li	a1,149
ffffffffc0202f28:	00003517          	auipc	a0,0x3
ffffffffc0202f2c:	90850513          	addi	a0,a0,-1784 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202f30:	c4afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(pgfault_num==1);
ffffffffc0202f34:	00003697          	auipc	a3,0x3
ffffffffc0202f38:	a9468693          	addi	a3,a3,-1388 # ffffffffc02059c8 <default_pmm_manager+0x840>
ffffffffc0202f3c:	00002617          	auipc	a2,0x2
ffffffffc0202f40:	e9c60613          	addi	a2,a2,-356 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202f44:	09700593          	li	a1,151
ffffffffc0202f48:	00003517          	auipc	a0,0x3
ffffffffc0202f4c:	8e850513          	addi	a0,a0,-1816 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202f50:	c2afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(mm != NULL);
ffffffffc0202f54:	00003697          	auipc	a3,0x3
ffffffffc0202f58:	92c68693          	addi	a3,a3,-1748 # ffffffffc0205880 <default_pmm_manager+0x6f8>
ffffffffc0202f5c:	00002617          	auipc	a2,0x2
ffffffffc0202f60:	e7c60613          	addi	a2,a2,-388 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202f64:	0c600593          	li	a1,198
ffffffffc0202f68:	00003517          	auipc	a0,0x3
ffffffffc0202f6c:	8c850513          	addi	a0,a0,-1848 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202f70:	c0afd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0202f74:	00003697          	auipc	a3,0x3
ffffffffc0202f78:	91c68693          	addi	a3,a3,-1764 # ffffffffc0205890 <default_pmm_manager+0x708>
ffffffffc0202f7c:	00002617          	auipc	a2,0x2
ffffffffc0202f80:	e5c60613          	addi	a2,a2,-420 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202f84:	0c900593          	li	a1,201
ffffffffc0202f88:	00003517          	auipc	a0,0x3
ffffffffc0202f8c:	8a850513          	addi	a0,a0,-1880 # ffffffffc0205830 <default_pmm_manager+0x6a8>
ffffffffc0202f90:	beafd0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202f94:	00003697          	auipc	a3,0x3
ffffffffc0202f98:	9e468693          	addi	a3,a3,-1564 # ffffffffc0205978 <default_pmm_manager+0x7f0>
ffffffffc0202f9c:	00002617          	auipc	a2,0x2
ffffffffc0202fa0:	e3c60613          	addi	a2,a2,-452 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0202fa4:	0ec00593          	li	a1,236
ffffffffc0202fa8:	00003517          	auipc	a0,0x3
ffffffffc0202fac:	88850513          	addi	a0,a0,-1912 # ffffffffc0205830 <default_pmm_manager+0x6a8>
>>>>>>> 747620b (lab2)
ffffffffc0202fb0:	bcafd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0202fb4 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0202fb4:	0000e797          	auipc	a5,0xe
ffffffffc0202fb8:	5947b783          	ld	a5,1428(a5) # ffffffffc0211548 <sm>
ffffffffc0202fbc:	6b9c                	ld	a5,16(a5)
ffffffffc0202fbe:	8782                	jr	a5

ffffffffc0202fc0 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0202fc0:	0000e797          	auipc	a5,0xe
ffffffffc0202fc4:	5887b783          	ld	a5,1416(a5) # ffffffffc0211548 <sm>
ffffffffc0202fc8:	739c                	ld	a5,32(a5)
ffffffffc0202fca:	8782                	jr	a5

ffffffffc0202fcc <swap_out>:
{
ffffffffc0202fcc:	711d                	addi	sp,sp,-96
ffffffffc0202fce:	ec86                	sd	ra,88(sp)
ffffffffc0202fd0:	e8a2                	sd	s0,80(sp)
ffffffffc0202fd2:	e4a6                	sd	s1,72(sp)
ffffffffc0202fd4:	e0ca                	sd	s2,64(sp)
ffffffffc0202fd6:	fc4e                	sd	s3,56(sp)
ffffffffc0202fd8:	f852                	sd	s4,48(sp)
ffffffffc0202fda:	f456                	sd	s5,40(sp)
ffffffffc0202fdc:	f05a                	sd	s6,32(sp)
ffffffffc0202fde:	ec5e                	sd	s7,24(sp)
ffffffffc0202fe0:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0202fe2:	cde9                	beqz	a1,ffffffffc02030bc <swap_out+0xf0>
ffffffffc0202fe4:	8a2e                	mv	s4,a1
ffffffffc0202fe6:	892a                	mv	s2,a0
ffffffffc0202fe8:	8ab2                	mv	s5,a2
ffffffffc0202fea:	4401                	li	s0,0
ffffffffc0202fec:	0000e997          	auipc	s3,0xe
ffffffffc0202ff0:	55c98993          	addi	s3,s3,1372 # ffffffffc0211548 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202ff4:	00003b17          	auipc	s6,0x3
<<<<<<< HEAD
ffffffffc0202ff8:	b3cb0b13          	addi	s6,s6,-1220 # ffffffffc0205b30 <default_pmm_manager+0x990>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202ffc:	00003b97          	auipc	s7,0x3
ffffffffc0203000:	b1cb8b93          	addi	s7,s7,-1252 # ffffffffc0205b18 <default_pmm_manager+0x978>
=======
ffffffffc0202ff8:	b24b0b13          	addi	s6,s6,-1244 # ffffffffc0205b18 <default_pmm_manager+0x990>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202ffc:	00003b97          	auipc	s7,0x3
ffffffffc0203000:	b04b8b93          	addi	s7,s7,-1276 # ffffffffc0205b00 <default_pmm_manager+0x978>
>>>>>>> 747620b (lab2)
ffffffffc0203004:	a825                	j	ffffffffc020303c <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203006:	67a2                	ld	a5,8(sp)
ffffffffc0203008:	8626                	mv	a2,s1
ffffffffc020300a:	85a2                	mv	a1,s0
ffffffffc020300c:	63b4                	ld	a3,64(a5)
ffffffffc020300e:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0203010:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203012:	82b1                	srli	a3,a3,0xc
ffffffffc0203014:	0685                	addi	a3,a3,1
ffffffffc0203016:	8aafd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc020301a:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc020301c:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc020301e:	613c                	ld	a5,64(a0)
ffffffffc0203020:	83b1                	srli	a5,a5,0xc
ffffffffc0203022:	0785                	addi	a5,a5,1
ffffffffc0203024:	07a2                	slli	a5,a5,0x8
ffffffffc0203026:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc020302a:	e58fe0ef          	jal	ra,ffffffffc0201682 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc020302e:	01893503          	ld	a0,24(s2)
ffffffffc0203032:	85a6                	mv	a1,s1
ffffffffc0203034:	eb6ff0ef          	jal	ra,ffffffffc02026ea <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0203038:	048a0d63          	beq	s4,s0,ffffffffc0203092 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc020303c:	0009b783          	ld	a5,0(s3)
ffffffffc0203040:	8656                	mv	a2,s5
ffffffffc0203042:	002c                	addi	a1,sp,8
ffffffffc0203044:	7b9c                	ld	a5,48(a5)
ffffffffc0203046:	854a                	mv	a0,s2
ffffffffc0203048:	9782                	jalr	a5
          if (r != 0) {
ffffffffc020304a:	e12d                	bnez	a0,ffffffffc02030ac <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc020304c:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020304e:	01893503          	ld	a0,24(s2)
ffffffffc0203052:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0203054:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203056:	85a6                	mv	a1,s1
ffffffffc0203058:	ea4fe0ef          	jal	ra,ffffffffc02016fc <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc020305c:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020305e:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203060:	8b85                	andi	a5,a5,1
ffffffffc0203062:	cfb9                	beqz	a5,ffffffffc02030c0 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0203064:	65a2                	ld	a1,8(sp)
ffffffffc0203066:	61bc                	ld	a5,64(a1)
ffffffffc0203068:	83b1                	srli	a5,a5,0xc
ffffffffc020306a:	0785                	addi	a5,a5,1
ffffffffc020306c:	00879513          	slli	a0,a5,0x8
<<<<<<< HEAD
ffffffffc0203070:	5c7000ef          	jal	ra,ffffffffc0203e36 <swapfs_write>
=======
ffffffffc0203070:	5a9000ef          	jal	ra,ffffffffc0203e18 <swapfs_write>
>>>>>>> 747620b (lab2)
ffffffffc0203074:	d949                	beqz	a0,ffffffffc0203006 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203076:	855e                	mv	a0,s7
ffffffffc0203078:	848fd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020307c:	0009b783          	ld	a5,0(s3)
ffffffffc0203080:	6622                	ld	a2,8(sp)
ffffffffc0203082:	4681                	li	a3,0
ffffffffc0203084:	739c                	ld	a5,32(a5)
ffffffffc0203086:	85a6                	mv	a1,s1
ffffffffc0203088:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc020308a:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020308c:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc020308e:	fa8a17e3          	bne	s4,s0,ffffffffc020303c <swap_out+0x70>
}
ffffffffc0203092:	60e6                	ld	ra,88(sp)
ffffffffc0203094:	8522                	mv	a0,s0
ffffffffc0203096:	6446                	ld	s0,80(sp)
ffffffffc0203098:	64a6                	ld	s1,72(sp)
ffffffffc020309a:	6906                	ld	s2,64(sp)
ffffffffc020309c:	79e2                	ld	s3,56(sp)
ffffffffc020309e:	7a42                	ld	s4,48(sp)
ffffffffc02030a0:	7aa2                	ld	s5,40(sp)
ffffffffc02030a2:	7b02                	ld	s6,32(sp)
ffffffffc02030a4:	6be2                	ld	s7,24(sp)
ffffffffc02030a6:	6c42                	ld	s8,16(sp)
ffffffffc02030a8:	6125                	addi	sp,sp,96
ffffffffc02030aa:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc02030ac:	85a2                	mv	a1,s0
ffffffffc02030ae:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc02030b2:	a2250513          	addi	a0,a0,-1502 # ffffffffc0205ad0 <default_pmm_manager+0x930>
=======
ffffffffc02030b2:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0205ab8 <default_pmm_manager+0x930>
>>>>>>> 747620b (lab2)
ffffffffc02030b6:	80afd0ef          	jal	ra,ffffffffc02000c0 <cprintf>
                  break;
ffffffffc02030ba:	bfe1                	j	ffffffffc0203092 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc02030bc:	4401                	li	s0,0
ffffffffc02030be:	bfd1                	j	ffffffffc0203092 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc02030c0:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc02030c4:	a4068693          	addi	a3,a3,-1472 # ffffffffc0205b00 <default_pmm_manager+0x960>
ffffffffc02030c8:	00002617          	auipc	a2,0x2
ffffffffc02030cc:	d2860613          	addi	a2,a2,-728 # ffffffffc0204df0 <commands+0x780>
ffffffffc02030d0:	06800593          	li	a1,104
ffffffffc02030d4:	00002517          	auipc	a0,0x2
ffffffffc02030d8:	77450513          	addi	a0,a0,1908 # ffffffffc0205848 <default_pmm_manager+0x6a8>
=======
ffffffffc02030c4:	a2868693          	addi	a3,a3,-1496 # ffffffffc0205ae8 <default_pmm_manager+0x960>
ffffffffc02030c8:	00002617          	auipc	a2,0x2
ffffffffc02030cc:	d1060613          	addi	a2,a2,-752 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02030d0:	06800593          	li	a1,104
ffffffffc02030d4:	00002517          	auipc	a0,0x2
ffffffffc02030d8:	75c50513          	addi	a0,a0,1884 # ffffffffc0205830 <default_pmm_manager+0x6a8>
>>>>>>> 747620b (lab2)
ffffffffc02030dc:	a9efd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02030e0 <swap_in>:
{
ffffffffc02030e0:	7179                	addi	sp,sp,-48
ffffffffc02030e2:	e84a                	sd	s2,16(sp)
ffffffffc02030e4:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc02030e6:	4505                	li	a0,1
{
ffffffffc02030e8:	ec26                	sd	s1,24(sp)
ffffffffc02030ea:	e44e                	sd	s3,8(sp)
ffffffffc02030ec:	f406                	sd	ra,40(sp)
ffffffffc02030ee:	f022                	sd	s0,32(sp)
ffffffffc02030f0:	84ae                	mv	s1,a1
ffffffffc02030f2:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc02030f4:	cfcfe0ef          	jal	ra,ffffffffc02015f0 <alloc_pages>
     assert(result!=NULL);
ffffffffc02030f8:	c129                	beqz	a0,ffffffffc020313a <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc02030fa:	842a                	mv	s0,a0
ffffffffc02030fc:	01893503          	ld	a0,24(s2)
ffffffffc0203100:	4601                	li	a2,0
ffffffffc0203102:	85a6                	mv	a1,s1
ffffffffc0203104:	df8fe0ef          	jal	ra,ffffffffc02016fc <get_pte>
ffffffffc0203108:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0) // 将ptep内容写入result的位置
ffffffffc020310a:	6108                	ld	a0,0(a0)
ffffffffc020310c:	85a2                	mv	a1,s0
<<<<<<< HEAD
ffffffffc020310e:	48f000ef          	jal	ra,ffffffffc0203d9c <swapfs_read>
=======
ffffffffc020310e:	471000ef          	jal	ra,ffffffffc0203d7e <swapfs_read>
>>>>>>> 747620b (lab2)
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0203112:	00093583          	ld	a1,0(s2)
ffffffffc0203116:	8626                	mv	a2,s1
ffffffffc0203118:	00003517          	auipc	a0,0x3
<<<<<<< HEAD
ffffffffc020311c:	a6850513          	addi	a0,a0,-1432 # ffffffffc0205b80 <default_pmm_manager+0x9e0>
=======
ffffffffc020311c:	a5050513          	addi	a0,a0,-1456 # ffffffffc0205b68 <default_pmm_manager+0x9e0>
>>>>>>> 747620b (lab2)
ffffffffc0203120:	81a1                	srli	a1,a1,0x8
ffffffffc0203122:	f9ffc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
}
ffffffffc0203126:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0203128:	0089b023          	sd	s0,0(s3)
}
ffffffffc020312c:	7402                	ld	s0,32(sp)
ffffffffc020312e:	64e2                	ld	s1,24(sp)
ffffffffc0203130:	6942                	ld	s2,16(sp)
ffffffffc0203132:	69a2                	ld	s3,8(sp)
ffffffffc0203134:	4501                	li	a0,0
ffffffffc0203136:	6145                	addi	sp,sp,48
ffffffffc0203138:	8082                	ret
     assert(result!=NULL);
ffffffffc020313a:	00003697          	auipc	a3,0x3
<<<<<<< HEAD
ffffffffc020313e:	a3668693          	addi	a3,a3,-1482 # ffffffffc0205b70 <default_pmm_manager+0x9d0>
ffffffffc0203142:	00002617          	auipc	a2,0x2
ffffffffc0203146:	cae60613          	addi	a2,a2,-850 # ffffffffc0204df0 <commands+0x780>
ffffffffc020314a:	08000593          	li	a1,128
ffffffffc020314e:	00002517          	auipc	a0,0x2
ffffffffc0203152:	6fa50513          	addi	a0,a0,1786 # ffffffffc0205848 <default_pmm_manager+0x6a8>
=======
ffffffffc020313e:	a1e68693          	addi	a3,a3,-1506 # ffffffffc0205b58 <default_pmm_manager+0x9d0>
ffffffffc0203142:	00002617          	auipc	a2,0x2
ffffffffc0203146:	c9660613          	addi	a2,a2,-874 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020314a:	08000593          	li	a1,128
ffffffffc020314e:	00002517          	auipc	a0,0x2
ffffffffc0203152:	6e250513          	addi	a0,a0,1762 # ffffffffc0205830 <default_pmm_manager+0x6a8>
>>>>>>> 747620b (lab2)
ffffffffc0203156:	a24fd0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020315a <_clock_init>:

static int
_clock_init(void)
{
    return 0;
}
ffffffffc020315a:	4501                	li	a0,0
ffffffffc020315c:	8082                	ret

ffffffffc020315e <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc020315e:	4501                	li	a0,0
ffffffffc0203160:	8082                	ret

ffffffffc0203162 <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0203162:	4501                	li	a0,0
ffffffffc0203164:	8082                	ret

ffffffffc0203166 <_clock_check_swap>:
_clock_check_swap(void) {
ffffffffc0203166:	1141                	addi	sp,sp,-16
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0203168:	4731                	li	a4,12
_clock_check_swap(void) {
ffffffffc020316a:	e406                	sd	ra,8(sp)
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc020316c:	678d                	lui	a5,0x3
ffffffffc020316e:	00e78023          	sb	a4,0(a5) # 3000 <kern_entry-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc0203172:	0000e697          	auipc	a3,0xe
ffffffffc0203176:	3f66a683          	lw	a3,1014(a3) # ffffffffc0211568 <pgfault_num>
ffffffffc020317a:	4711                	li	a4,4
ffffffffc020317c:	0ae69363          	bne	a3,a4,ffffffffc0203222 <_clock_check_swap+0xbc>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203180:	6705                	lui	a4,0x1
ffffffffc0203182:	4629                	li	a2,10
ffffffffc0203184:	0000e797          	auipc	a5,0xe
ffffffffc0203188:	3e478793          	addi	a5,a5,996 # ffffffffc0211568 <pgfault_num>
ffffffffc020318c:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc0203190:	4398                	lw	a4,0(a5)
ffffffffc0203192:	2701                	sext.w	a4,a4
ffffffffc0203194:	20d71763          	bne	a4,a3,ffffffffc02033a2 <_clock_check_swap+0x23c>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0203198:	6691                	lui	a3,0x4
ffffffffc020319a:	4635                	li	a2,13
ffffffffc020319c:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc02031a0:	4394                	lw	a3,0(a5)
ffffffffc02031a2:	2681                	sext.w	a3,a3
ffffffffc02031a4:	1ce69f63          	bne	a3,a4,ffffffffc0203382 <_clock_check_swap+0x21c>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02031a8:	6709                	lui	a4,0x2
ffffffffc02031aa:	462d                	li	a2,11
ffffffffc02031ac:	00c70023          	sb	a2,0(a4) # 2000 <kern_entry-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc02031b0:	4398                	lw	a4,0(a5)
ffffffffc02031b2:	2701                	sext.w	a4,a4
ffffffffc02031b4:	1ad71763          	bne	a4,a3,ffffffffc0203362 <_clock_check_swap+0x1fc>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02031b8:	6715                	lui	a4,0x5
ffffffffc02031ba:	46b9                	li	a3,14
ffffffffc02031bc:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc02031c0:	4398                	lw	a4,0(a5)
ffffffffc02031c2:	4695                	li	a3,5
ffffffffc02031c4:	2701                	sext.w	a4,a4
ffffffffc02031c6:	16d71e63          	bne	a4,a3,ffffffffc0203342 <_clock_check_swap+0x1dc>
    assert(pgfault_num==5);
ffffffffc02031ca:	4394                	lw	a3,0(a5)
ffffffffc02031cc:	2681                	sext.w	a3,a3
ffffffffc02031ce:	14e69a63          	bne	a3,a4,ffffffffc0203322 <_clock_check_swap+0x1bc>
    assert(pgfault_num==5);
ffffffffc02031d2:	4398                	lw	a4,0(a5)
ffffffffc02031d4:	2701                	sext.w	a4,a4
ffffffffc02031d6:	12d71663          	bne	a4,a3,ffffffffc0203302 <_clock_check_swap+0x19c>
    assert(pgfault_num==5);
ffffffffc02031da:	4394                	lw	a3,0(a5)
ffffffffc02031dc:	2681                	sext.w	a3,a3
ffffffffc02031de:	10e69263          	bne	a3,a4,ffffffffc02032e2 <_clock_check_swap+0x17c>
    assert(pgfault_num==5);
ffffffffc02031e2:	4398                	lw	a4,0(a5)
ffffffffc02031e4:	2701                	sext.w	a4,a4
ffffffffc02031e6:	0cd71e63          	bne	a4,a3,ffffffffc02032c2 <_clock_check_swap+0x15c>
    assert(pgfault_num==5);
ffffffffc02031ea:	4394                	lw	a3,0(a5)
ffffffffc02031ec:	2681                	sext.w	a3,a3
ffffffffc02031ee:	0ae69a63          	bne	a3,a4,ffffffffc02032a2 <_clock_check_swap+0x13c>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02031f2:	6715                	lui	a4,0x5
ffffffffc02031f4:	46b9                	li	a3,14
ffffffffc02031f6:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc02031fa:	4398                	lw	a4,0(a5)
ffffffffc02031fc:	4695                	li	a3,5
ffffffffc02031fe:	2701                	sext.w	a4,a4
ffffffffc0203200:	08d71163          	bne	a4,a3,ffffffffc0203282 <_clock_check_swap+0x11c>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203204:	6705                	lui	a4,0x1
ffffffffc0203206:	00074683          	lbu	a3,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020320a:	4729                	li	a4,10
ffffffffc020320c:	04e69b63          	bne	a3,a4,ffffffffc0203262 <_clock_check_swap+0xfc>
    assert(pgfault_num==6);
ffffffffc0203210:	439c                	lw	a5,0(a5)
ffffffffc0203212:	4719                	li	a4,6
ffffffffc0203214:	2781                	sext.w	a5,a5
ffffffffc0203216:	02e79663          	bne	a5,a4,ffffffffc0203242 <_clock_check_swap+0xdc>
}
ffffffffc020321a:	60a2                	ld	ra,8(sp)
ffffffffc020321c:	4501                	li	a0,0
ffffffffc020321e:	0141                	addi	sp,sp,16
ffffffffc0203220:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0203222:	00002697          	auipc	a3,0x2
<<<<<<< HEAD
ffffffffc0203226:	7ee68693          	addi	a3,a3,2030 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc020322a:	00002617          	auipc	a2,0x2
ffffffffc020322e:	bc660613          	addi	a2,a2,-1082 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203232:	0a300593          	li	a1,163
ffffffffc0203236:	00003517          	auipc	a0,0x3
ffffffffc020323a:	98a50513          	addi	a0,a0,-1654 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020323e:	93cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==6);
ffffffffc0203242:	00003697          	auipc	a3,0x3
ffffffffc0203246:	9ce68693          	addi	a3,a3,-1586 # ffffffffc0205c10 <default_pmm_manager+0xa70>
ffffffffc020324a:	00002617          	auipc	a2,0x2
ffffffffc020324e:	ba660613          	addi	a2,a2,-1114 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203252:	0ba00593          	li	a1,186
ffffffffc0203256:	00003517          	auipc	a0,0x3
ffffffffc020325a:	96a50513          	addi	a0,a0,-1686 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020325e:	91cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203262:	00003697          	auipc	a3,0x3
ffffffffc0203266:	98668693          	addi	a3,a3,-1658 # ffffffffc0205be8 <default_pmm_manager+0xa48>
ffffffffc020326a:	00002617          	auipc	a2,0x2
ffffffffc020326e:	b8660613          	addi	a2,a2,-1146 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203272:	0b800593          	li	a1,184
ffffffffc0203276:	00003517          	auipc	a0,0x3
ffffffffc020327a:	94a50513          	addi	a0,a0,-1718 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020327e:	8fcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203282:	00003697          	auipc	a3,0x3
ffffffffc0203286:	95668693          	addi	a3,a3,-1706 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc020328a:	00002617          	auipc	a2,0x2
ffffffffc020328e:	b6660613          	addi	a2,a2,-1178 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203292:	0b700593          	li	a1,183
ffffffffc0203296:	00003517          	auipc	a0,0x3
ffffffffc020329a:	92a50513          	addi	a0,a0,-1750 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020329e:	8dcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032a2:	00003697          	auipc	a3,0x3
ffffffffc02032a6:	93668693          	addi	a3,a3,-1738 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc02032aa:	00002617          	auipc	a2,0x2
ffffffffc02032ae:	b4660613          	addi	a2,a2,-1210 # ffffffffc0204df0 <commands+0x780>
ffffffffc02032b2:	0b500593          	li	a1,181
ffffffffc02032b6:	00003517          	auipc	a0,0x3
ffffffffc02032ba:	90a50513          	addi	a0,a0,-1782 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc02032be:	8bcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032c2:	00003697          	auipc	a3,0x3
ffffffffc02032c6:	91668693          	addi	a3,a3,-1770 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc02032ca:	00002617          	auipc	a2,0x2
ffffffffc02032ce:	b2660613          	addi	a2,a2,-1242 # ffffffffc0204df0 <commands+0x780>
ffffffffc02032d2:	0b300593          	li	a1,179
ffffffffc02032d6:	00003517          	auipc	a0,0x3
ffffffffc02032da:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc02032de:	89cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032e2:	00003697          	auipc	a3,0x3
ffffffffc02032e6:	8f668693          	addi	a3,a3,-1802 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc02032ea:	00002617          	auipc	a2,0x2
ffffffffc02032ee:	b0660613          	addi	a2,a2,-1274 # ffffffffc0204df0 <commands+0x780>
ffffffffc02032f2:	0b100593          	li	a1,177
ffffffffc02032f6:	00003517          	auipc	a0,0x3
ffffffffc02032fa:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc02032fe:	87cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203302:	00003697          	auipc	a3,0x3
ffffffffc0203306:	8d668693          	addi	a3,a3,-1834 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc020330a:	00002617          	auipc	a2,0x2
ffffffffc020330e:	ae660613          	addi	a2,a2,-1306 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203312:	0af00593          	li	a1,175
ffffffffc0203316:	00003517          	auipc	a0,0x3
ffffffffc020331a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020331e:	85cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203322:	00003697          	auipc	a3,0x3
ffffffffc0203326:	8b668693          	addi	a3,a3,-1866 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc020332a:	00002617          	auipc	a2,0x2
ffffffffc020332e:	ac660613          	addi	a2,a2,-1338 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203332:	0ad00593          	li	a1,173
ffffffffc0203336:	00003517          	auipc	a0,0x3
ffffffffc020333a:	88a50513          	addi	a0,a0,-1910 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020333e:	83cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203342:	00003697          	auipc	a3,0x3
ffffffffc0203346:	89668693          	addi	a3,a3,-1898 # ffffffffc0205bd8 <default_pmm_manager+0xa38>
ffffffffc020334a:	00002617          	auipc	a2,0x2
ffffffffc020334e:	aa660613          	addi	a2,a2,-1370 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203352:	0ab00593          	li	a1,171
ffffffffc0203356:	00003517          	auipc	a0,0x3
ffffffffc020335a:	86a50513          	addi	a0,a0,-1942 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020335e:	81cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc0203362:	00002697          	auipc	a3,0x2
ffffffffc0203366:	6ae68693          	addi	a3,a3,1710 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc020336a:	00002617          	auipc	a2,0x2
ffffffffc020336e:	a8660613          	addi	a2,a2,-1402 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203372:	0a900593          	li	a1,169
ffffffffc0203376:	00003517          	auipc	a0,0x3
ffffffffc020337a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020337e:	ffdfc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc0203382:	00002697          	auipc	a3,0x2
ffffffffc0203386:	68e68693          	addi	a3,a3,1678 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc020338a:	00002617          	auipc	a2,0x2
ffffffffc020338e:	a6660613          	addi	a2,a2,-1434 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203392:	0a700593          	li	a1,167
ffffffffc0203396:	00003517          	auipc	a0,0x3
ffffffffc020339a:	82a50513          	addi	a0,a0,-2006 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc020339e:	fddfc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc02033a2:	00002697          	auipc	a3,0x2
ffffffffc02033a6:	66e68693          	addi	a3,a3,1646 # ffffffffc0205a10 <default_pmm_manager+0x870>
ffffffffc02033aa:	00002617          	auipc	a2,0x2
ffffffffc02033ae:	a4660613          	addi	a2,a2,-1466 # ffffffffc0204df0 <commands+0x780>
ffffffffc02033b2:	0a500593          	li	a1,165
ffffffffc02033b6:	00003517          	auipc	a0,0x3
ffffffffc02033ba:	80a50513          	addi	a0,a0,-2038 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
=======
ffffffffc0203226:	7d668693          	addi	a3,a3,2006 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc020322a:	00002617          	auipc	a2,0x2
ffffffffc020322e:	bae60613          	addi	a2,a2,-1106 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203232:	0a200593          	li	a1,162
ffffffffc0203236:	00003517          	auipc	a0,0x3
ffffffffc020323a:	97250513          	addi	a0,a0,-1678 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020323e:	93cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==6);
ffffffffc0203242:	00003697          	auipc	a3,0x3
ffffffffc0203246:	9b668693          	addi	a3,a3,-1610 # ffffffffc0205bf8 <default_pmm_manager+0xa70>
ffffffffc020324a:	00002617          	auipc	a2,0x2
ffffffffc020324e:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203252:	0b900593          	li	a1,185
ffffffffc0203256:	00003517          	auipc	a0,0x3
ffffffffc020325a:	95250513          	addi	a0,a0,-1710 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020325e:	91cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203262:	00003697          	auipc	a3,0x3
ffffffffc0203266:	96e68693          	addi	a3,a3,-1682 # ffffffffc0205bd0 <default_pmm_manager+0xa48>
ffffffffc020326a:	00002617          	auipc	a2,0x2
ffffffffc020326e:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203272:	0b700593          	li	a1,183
ffffffffc0203276:	00003517          	auipc	a0,0x3
ffffffffc020327a:	93250513          	addi	a0,a0,-1742 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020327e:	8fcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203282:	00003697          	auipc	a3,0x3
ffffffffc0203286:	93e68693          	addi	a3,a3,-1730 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc020328a:	00002617          	auipc	a2,0x2
ffffffffc020328e:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203292:	0b600593          	li	a1,182
ffffffffc0203296:	00003517          	auipc	a0,0x3
ffffffffc020329a:	91250513          	addi	a0,a0,-1774 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020329e:	8dcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032a2:	00003697          	auipc	a3,0x3
ffffffffc02032a6:	91e68693          	addi	a3,a3,-1762 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc02032aa:	00002617          	auipc	a2,0x2
ffffffffc02032ae:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02032b2:	0b400593          	li	a1,180
ffffffffc02032b6:	00003517          	auipc	a0,0x3
ffffffffc02032ba:	8f250513          	addi	a0,a0,-1806 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc02032be:	8bcfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032c2:	00003697          	auipc	a3,0x3
ffffffffc02032c6:	8fe68693          	addi	a3,a3,-1794 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc02032ca:	00002617          	auipc	a2,0x2
ffffffffc02032ce:	b0e60613          	addi	a2,a2,-1266 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02032d2:	0b200593          	li	a1,178
ffffffffc02032d6:	00003517          	auipc	a0,0x3
ffffffffc02032da:	8d250513          	addi	a0,a0,-1838 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc02032de:	89cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc02032e2:	00003697          	auipc	a3,0x3
ffffffffc02032e6:	8de68693          	addi	a3,a3,-1826 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc02032ea:	00002617          	auipc	a2,0x2
ffffffffc02032ee:	aee60613          	addi	a2,a2,-1298 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02032f2:	0b000593          	li	a1,176
ffffffffc02032f6:	00003517          	auipc	a0,0x3
ffffffffc02032fa:	8b250513          	addi	a0,a0,-1870 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc02032fe:	87cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203302:	00003697          	auipc	a3,0x3
ffffffffc0203306:	8be68693          	addi	a3,a3,-1858 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc020330a:	00002617          	auipc	a2,0x2
ffffffffc020330e:	ace60613          	addi	a2,a2,-1330 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203312:	0ae00593          	li	a1,174
ffffffffc0203316:	00003517          	auipc	a0,0x3
ffffffffc020331a:	89250513          	addi	a0,a0,-1902 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020331e:	85cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203322:	00003697          	auipc	a3,0x3
ffffffffc0203326:	89e68693          	addi	a3,a3,-1890 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc020332a:	00002617          	auipc	a2,0x2
ffffffffc020332e:	aae60613          	addi	a2,a2,-1362 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203332:	0ac00593          	li	a1,172
ffffffffc0203336:	00003517          	auipc	a0,0x3
ffffffffc020333a:	87250513          	addi	a0,a0,-1934 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020333e:	83cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==5);
ffffffffc0203342:	00003697          	auipc	a3,0x3
ffffffffc0203346:	87e68693          	addi	a3,a3,-1922 # ffffffffc0205bc0 <default_pmm_manager+0xa38>
ffffffffc020334a:	00002617          	auipc	a2,0x2
ffffffffc020334e:	a8e60613          	addi	a2,a2,-1394 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203352:	0aa00593          	li	a1,170
ffffffffc0203356:	00003517          	auipc	a0,0x3
ffffffffc020335a:	85250513          	addi	a0,a0,-1966 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020335e:	81cfd0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc0203362:	00002697          	auipc	a3,0x2
ffffffffc0203366:	69668693          	addi	a3,a3,1686 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc020336a:	00002617          	auipc	a2,0x2
ffffffffc020336e:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203372:	0a800593          	li	a1,168
ffffffffc0203376:	00003517          	auipc	a0,0x3
ffffffffc020337a:	83250513          	addi	a0,a0,-1998 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020337e:	ffdfc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc0203382:	00002697          	auipc	a3,0x2
ffffffffc0203386:	67668693          	addi	a3,a3,1654 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc020338a:	00002617          	auipc	a2,0x2
ffffffffc020338e:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203392:	0a600593          	li	a1,166
ffffffffc0203396:	00003517          	auipc	a0,0x3
ffffffffc020339a:	81250513          	addi	a0,a0,-2030 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc020339e:	fddfc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgfault_num==4);
ffffffffc02033a2:	00002697          	auipc	a3,0x2
ffffffffc02033a6:	65668693          	addi	a3,a3,1622 # ffffffffc02059f8 <default_pmm_manager+0x870>
ffffffffc02033aa:	00002617          	auipc	a2,0x2
ffffffffc02033ae:	a2e60613          	addi	a2,a2,-1490 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02033b2:	0a400593          	li	a1,164
ffffffffc02033b6:	00002517          	auipc	a0,0x2
ffffffffc02033ba:	7f250513          	addi	a0,a0,2034 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
>>>>>>> 747620b (lab2)
ffffffffc02033be:	fbdfc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02033c2 <_clock_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
<<<<<<< HEAD
ffffffffc02033c2:	7518                	ld	a4,40(a0)
{
ffffffffc02033c4:	1101                	addi	sp,sp,-32
ffffffffc02033c6:	ec06                	sd	ra,24(sp)
ffffffffc02033c8:	e822                	sd	s0,16(sp)
ffffffffc02033ca:	e426                	sd	s1,8(sp)
         assert(head != NULL);
ffffffffc02033cc:	cf39                	beqz	a4,ffffffffc020342a <_clock_swap_out_victim+0x68>
     assert(in_tick==0);
ffffffffc02033ce:	ee35                	bnez	a2,ffffffffc020344a <_clock_swap_out_victim+0x88>
ffffffffc02033d0:	0000e497          	auipc	s1,0xe
ffffffffc02033d4:	18848493          	addi	s1,s1,392 # ffffffffc0211558 <curr_ptr>
ffffffffc02033d8:	609c                	ld	a5,0(s1)
ffffffffc02033da:	86ae                	mv	a3,a1
ffffffffc02033dc:	678c                	ld	a1,8(a5)
ffffffffc02033de:	a039                	j	ffffffffc02033ec <_clock_swap_out_victim+0x2a>
        if (page->visited == 0) {
ffffffffc02033e0:	fe05b783          	ld	a5,-32(a1) # fe0 <kern_entry-0xffffffffc01ff020>
ffffffffc02033e4:	cf81                	beqz	a5,ffffffffc02033fc <_clock_swap_out_victim+0x3a>
            page->visited = 0;
ffffffffc02033e6:	fe05b023          	sd	zero,-32(a1)
    while (1) {
ffffffffc02033ea:	85a2                	mv	a1,s0
ffffffffc02033ec:	6580                	ld	s0,8(a1)
        if (curr_ptr == head) {
ffffffffc02033ee:	feb719e3          	bne	a4,a1,ffffffffc02033e0 <_clock_swap_out_victim+0x1e>
ffffffffc02033f2:	85a2                	mv	a1,s0
        if (page->visited == 0) {
ffffffffc02033f4:	fe05b783          	ld	a5,-32(a1)
ffffffffc02033f8:	6400                	ld	s0,8(s0)
ffffffffc02033fa:	f7f5                	bnez	a5,ffffffffc02033e6 <_clock_swap_out_victim+0x24>
        struct Page *page = le2page(curr_ptr, pra_page_link);
ffffffffc02033fc:	fd058793          	addi	a5,a1,-48
            *ptr_page = page;
ffffffffc0203400:	e29c                	sd	a5,0(a3)
            cprintf("curr_ptr %p\n", curr_ptr);
ffffffffc0203402:	00003517          	auipc	a0,0x3
ffffffffc0203406:	83e50513          	addi	a0,a0,-1986 # ffffffffc0205c40 <default_pmm_manager+0xaa0>
ffffffffc020340a:	e08c                	sd	a1,0(s1)
ffffffffc020340c:	cb5fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
            list_del(curr_ptr);
ffffffffc0203410:	609c                	ld	a5,0(s1)
}
ffffffffc0203412:	60e2                	ld	ra,24(sp)
ffffffffc0203414:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0203416:	6398                	ld	a4,0(a5)
ffffffffc0203418:	679c                	ld	a5,8(a5)
    prev->next = next;
ffffffffc020341a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020341c:	e398                	sd	a4,0(a5)
            curr_ptr = list_prev(next);  
ffffffffc020341e:	601c                	ld	a5,0(s0)
}
ffffffffc0203420:	6442                	ld	s0,16(sp)
            curr_ptr = list_prev(next);  
ffffffffc0203422:	e09c                	sd	a5,0(s1)
}
ffffffffc0203424:	64a2                	ld	s1,8(sp)
ffffffffc0203426:	6105                	addi	sp,sp,32
ffffffffc0203428:	8082                	ret
         assert(head != NULL);
ffffffffc020342a:	00002697          	auipc	a3,0x2
ffffffffc020342e:	7f668693          	addi	a3,a3,2038 # ffffffffc0205c20 <default_pmm_manager+0xa80>
ffffffffc0203432:	00002617          	auipc	a2,0x2
ffffffffc0203436:	9be60613          	addi	a2,a2,-1602 # ffffffffc0204df0 <commands+0x780>
ffffffffc020343a:	04f00593          	li	a1,79
ffffffffc020343e:	00002517          	auipc	a0,0x2
ffffffffc0203442:	78250513          	addi	a0,a0,1922 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc0203446:	f35fc0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(in_tick==0);
ffffffffc020344a:	00002697          	auipc	a3,0x2
ffffffffc020344e:	7e668693          	addi	a3,a3,2022 # ffffffffc0205c30 <default_pmm_manager+0xa90>
ffffffffc0203452:	00002617          	auipc	a2,0x2
ffffffffc0203456:	99e60613          	addi	a2,a2,-1634 # ffffffffc0204df0 <commands+0x780>
ffffffffc020345a:	05000593          	li	a1,80
ffffffffc020345e:	00002517          	auipc	a0,0x2
ffffffffc0203462:	76250513          	addi	a0,a0,1890 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
ffffffffc0203466:	f15fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020346a <_clock_init_mm>:
{     
ffffffffc020346a:	1141                	addi	sp,sp,-16
ffffffffc020346c:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020346e:	0000e597          	auipc	a1,0xe
ffffffffc0203472:	c7a58593          	addi	a1,a1,-902 # ffffffffc02110e8 <pra_list_head>
    mm->sm_priv = &pra_list_head;
ffffffffc0203476:	f50c                	sd	a1,40(a0)
    cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
ffffffffc0203478:	00002517          	auipc	a0,0x2
ffffffffc020347c:	7d850513          	addi	a0,a0,2008 # ffffffffc0205c50 <default_pmm_manager+0xab0>
ffffffffc0203480:	e58c                	sd	a1,8(a1)
ffffffffc0203482:	e18c                	sd	a1,0(a1)
    curr_ptr = &pra_list_head;
ffffffffc0203484:	0000e797          	auipc	a5,0xe
ffffffffc0203488:	0cb7ba23          	sd	a1,212(a5) # ffffffffc0211558 <curr_ptr>
    cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
ffffffffc020348c:	c35fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
}
ffffffffc0203490:	60a2                	ld	ra,8(sp)
ffffffffc0203492:	4501                	li	a0,0
ffffffffc0203494:	0141                	addi	sp,sp,16
ffffffffc0203496:	8082                	ret

ffffffffc0203498 <_clock_map_swappable>:
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0203498:	0000e797          	auipc	a5,0xe
ffffffffc020349c:	0c07b783          	ld	a5,192(a5) # ffffffffc0211558 <curr_ptr>
ffffffffc02034a0:	cf89                	beqz	a5,ffffffffc02034ba <_clock_map_swappable+0x22>
    list_entry_t* head = (list_entry_t*)mm->sm_priv;
ffffffffc02034a2:	751c                	ld	a5,40(a0)
ffffffffc02034a4:	03060713          	addi	a4,a2,48
}
ffffffffc02034a8:	4501                	li	a0,0
    __list_add(elm, listelm->prev, listelm);
ffffffffc02034aa:	6394                	ld	a3,0(a5)
    prev->next = next->prev = elm;
ffffffffc02034ac:	e398                	sd	a4,0(a5)
ffffffffc02034ae:	e698                	sd	a4,8(a3)
    elm->next = next;
ffffffffc02034b0:	fe1c                	sd	a5,56(a2)
    page->visited = 1;
ffffffffc02034b2:	4785                	li	a5,1
    elm->prev = prev;
ffffffffc02034b4:	fa14                	sd	a3,48(a2)
ffffffffc02034b6:	ea1c                	sd	a5,16(a2)
}
ffffffffc02034b8:	8082                	ret
{
ffffffffc02034ba:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02034bc:	00002697          	auipc	a3,0x2
ffffffffc02034c0:	7bc68693          	addi	a3,a3,1980 # ffffffffc0205c78 <default_pmm_manager+0xad8>
ffffffffc02034c4:	00002617          	auipc	a2,0x2
ffffffffc02034c8:	92c60613          	addi	a2,a2,-1748 # ffffffffc0204df0 <commands+0x780>
ffffffffc02034cc:	03900593          	li	a1,57
ffffffffc02034d0:	00002517          	auipc	a0,0x2
ffffffffc02034d4:	6f050513          	addi	a0,a0,1776 # ffffffffc0205bc0 <default_pmm_manager+0xa20>
{
ffffffffc02034d8:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02034da:	ea1fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02034de <check_vma_overlap.part.0>:
=======
ffffffffc02033c2:	7508                	ld	a0,40(a0)
{
ffffffffc02033c4:	1141                	addi	sp,sp,-16
ffffffffc02033c6:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc02033c8:	c131                	beqz	a0,ffffffffc020340c <_clock_swap_out_victim+0x4a>
     assert(in_tick==0);
ffffffffc02033ca:	e22d                	bnez	a2,ffffffffc020342c <_clock_swap_out_victim+0x6a>
ffffffffc02033cc:	0000e617          	auipc	a2,0xe
ffffffffc02033d0:	18c60613          	addi	a2,a2,396 # ffffffffc0211558 <curr_ptr>
ffffffffc02033d4:	621c                	ld	a5,0(a2)
ffffffffc02033d6:	679c                	ld	a5,8(a5)
ffffffffc02033d8:	a039                	j	ffffffffc02033e6 <_clock_swap_out_victim+0x24>
        if (page->visited == 0) {
ffffffffc02033da:	fe07b683          	ld	a3,-32(a5)
ffffffffc02033de:	ce81                	beqz	a3,ffffffffc02033f6 <_clock_swap_out_victim+0x34>
            page->visited = 0;
ffffffffc02033e0:	fe07b023          	sd	zero,-32(a5)
    while (1) {
ffffffffc02033e4:	87ba                	mv	a5,a4
ffffffffc02033e6:	6798                	ld	a4,8(a5)
        if (curr_ptr == head) {
ffffffffc02033e8:	fef519e3          	bne	a0,a5,ffffffffc02033da <_clock_swap_out_victim+0x18>
ffffffffc02033ec:	87ba                	mv	a5,a4
        if (page->visited == 0) {
ffffffffc02033ee:	fe07b683          	ld	a3,-32(a5)
ffffffffc02033f2:	6718                	ld	a4,8(a4)
ffffffffc02033f4:	f6f5                	bnez	a3,ffffffffc02033e0 <_clock_swap_out_victim+0x1e>
    __list_del(listelm->prev, listelm->next);
ffffffffc02033f6:	6394                	ld	a3,0(a5)
        struct Page *page = le2page(curr_ptr, pra_page_link);
ffffffffc02033f8:	fd078793          	addi	a5,a5,-48
            *ptr_page = page;
ffffffffc02033fc:	e19c                	sd	a5,0(a1)
}
ffffffffc02033fe:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0203400:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0203402:	e314                	sd	a3,0(a4)
            curr_ptr = list_prev(next);  
ffffffffc0203404:	e214                	sd	a3,0(a2)
}
ffffffffc0203406:	4501                	li	a0,0
ffffffffc0203408:	0141                	addi	sp,sp,16
ffffffffc020340a:	8082                	ret
         assert(head != NULL);
ffffffffc020340c:	00002697          	auipc	a3,0x2
ffffffffc0203410:	7fc68693          	addi	a3,a3,2044 # ffffffffc0205c08 <default_pmm_manager+0xa80>
ffffffffc0203414:	00002617          	auipc	a2,0x2
ffffffffc0203418:	9c460613          	addi	a2,a2,-1596 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020341c:	04f00593          	li	a1,79
ffffffffc0203420:	00002517          	auipc	a0,0x2
ffffffffc0203424:	78850513          	addi	a0,a0,1928 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc0203428:	f53fc0ef          	jal	ra,ffffffffc020037a <__panic>
     assert(in_tick==0);
ffffffffc020342c:	00002697          	auipc	a3,0x2
ffffffffc0203430:	7ec68693          	addi	a3,a3,2028 # ffffffffc0205c18 <default_pmm_manager+0xa90>
ffffffffc0203434:	00002617          	auipc	a2,0x2
ffffffffc0203438:	9a460613          	addi	a2,a2,-1628 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020343c:	05000593          	li	a1,80
ffffffffc0203440:	00002517          	auipc	a0,0x2
ffffffffc0203444:	76850513          	addi	a0,a0,1896 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
ffffffffc0203448:	f33fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020344c <_clock_init_mm>:
{     
ffffffffc020344c:	1141                	addi	sp,sp,-16
ffffffffc020344e:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0203450:	0000e597          	auipc	a1,0xe
ffffffffc0203454:	c9858593          	addi	a1,a1,-872 # ffffffffc02110e8 <pra_list_head>
    mm->sm_priv = &pra_list_head;
ffffffffc0203458:	f50c                	sd	a1,40(a0)
    cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
ffffffffc020345a:	00002517          	auipc	a0,0x2
ffffffffc020345e:	7ce50513          	addi	a0,a0,1998 # ffffffffc0205c28 <default_pmm_manager+0xaa0>
ffffffffc0203462:	e58c                	sd	a1,8(a1)
ffffffffc0203464:	e18c                	sd	a1,0(a1)
    curr_ptr = &pra_list_head;
ffffffffc0203466:	0000e797          	auipc	a5,0xe
ffffffffc020346a:	0eb7b923          	sd	a1,242(a5) # ffffffffc0211558 <curr_ptr>
    cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
ffffffffc020346e:	c53fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
}
ffffffffc0203472:	60a2                	ld	ra,8(sp)
ffffffffc0203474:	4501                	li	a0,0
ffffffffc0203476:	0141                	addi	sp,sp,16
ffffffffc0203478:	8082                	ret

ffffffffc020347a <_clock_map_swappable>:
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc020347a:	0000e797          	auipc	a5,0xe
ffffffffc020347e:	0de7b783          	ld	a5,222(a5) # ffffffffc0211558 <curr_ptr>
ffffffffc0203482:	cf89                	beqz	a5,ffffffffc020349c <_clock_map_swappable+0x22>
    list_entry_t* head = (list_entry_t*)mm->sm_priv;
ffffffffc0203484:	751c                	ld	a5,40(a0)
ffffffffc0203486:	03060713          	addi	a4,a2,48
}
ffffffffc020348a:	4501                	li	a0,0
    __list_add(elm, listelm->prev, listelm);
ffffffffc020348c:	6394                	ld	a3,0(a5)
    prev->next = next->prev = elm;
ffffffffc020348e:	e398                	sd	a4,0(a5)
ffffffffc0203490:	e698                	sd	a4,8(a3)
    elm->next = next;
ffffffffc0203492:	fe1c                	sd	a5,56(a2)
    page->visited = 1;
ffffffffc0203494:	4785                	li	a5,1
    elm->prev = prev;
ffffffffc0203496:	fa14                	sd	a3,48(a2)
ffffffffc0203498:	ea1c                	sd	a5,16(a2)
}
ffffffffc020349a:	8082                	ret
{
ffffffffc020349c:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc020349e:	00002697          	auipc	a3,0x2
ffffffffc02034a2:	7b268693          	addi	a3,a3,1970 # ffffffffc0205c50 <default_pmm_manager+0xac8>
ffffffffc02034a6:	00002617          	auipc	a2,0x2
ffffffffc02034aa:	93260613          	addi	a2,a2,-1742 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02034ae:	03900593          	li	a1,57
ffffffffc02034b2:	00002517          	auipc	a0,0x2
ffffffffc02034b6:	6f650513          	addi	a0,a0,1782 # ffffffffc0205ba8 <default_pmm_manager+0xa20>
{
ffffffffc02034ba:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02034bc:	ebffc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02034c0 <check_vma_overlap.part.0>:
>>>>>>> 747620b (lab2)
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
<<<<<<< HEAD
ffffffffc02034de:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02034e0:	00002697          	auipc	a3,0x2
ffffffffc02034e4:	7d868693          	addi	a3,a3,2008 # ffffffffc0205cb8 <default_pmm_manager+0xb18>
ffffffffc02034e8:	00002617          	auipc	a2,0x2
ffffffffc02034ec:	90860613          	addi	a2,a2,-1784 # ffffffffc0204df0 <commands+0x780>
ffffffffc02034f0:	07d00593          	li	a1,125
ffffffffc02034f4:	00002517          	auipc	a0,0x2
ffffffffc02034f8:	7e450513          	addi	a0,a0,2020 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02034fc:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02034fe:	e7dfc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203502 <mm_create>:
mm_create(void) {
ffffffffc0203502:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203504:	03000513          	li	a0,48
mm_create(void) {
ffffffffc0203508:	e022                	sd	s0,0(sp)
ffffffffc020350a:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020350c:	a9cff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc0203510:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0203512:	c105                	beqz	a0,ffffffffc0203532 <mm_create+0x30>
    elm->prev = elm->next = elm;
ffffffffc0203514:	e408                	sd	a0,8(s0)
ffffffffc0203516:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0203518:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020351c:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203520:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203524:	0000e797          	auipc	a5,0xe
ffffffffc0203528:	02c7a783          	lw	a5,44(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc020352c:	eb81                	bnez	a5,ffffffffc020353c <mm_create+0x3a>
        else mm->sm_priv = NULL;
ffffffffc020352e:	02053423          	sd	zero,40(a0)
}
ffffffffc0203532:	60a2                	ld	ra,8(sp)
ffffffffc0203534:	8522                	mv	a0,s0
ffffffffc0203536:	6402                	ld	s0,0(sp)
ffffffffc0203538:	0141                	addi	sp,sp,16
ffffffffc020353a:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc020353c:	a79ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
}
ffffffffc0203540:	60a2                	ld	ra,8(sp)
ffffffffc0203542:	8522                	mv	a0,s0
ffffffffc0203544:	6402                	ld	s0,0(sp)
ffffffffc0203546:	0141                	addi	sp,sp,16
ffffffffc0203548:	8082                	ret

ffffffffc020354a <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc020354a:	1101                	addi	sp,sp,-32
ffffffffc020354c:	e04a                	sd	s2,0(sp)
ffffffffc020354e:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203550:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0203554:	e822                	sd	s0,16(sp)
ffffffffc0203556:	e426                	sd	s1,8(sp)
ffffffffc0203558:	ec06                	sd	ra,24(sp)
ffffffffc020355a:	84ae                	mv	s1,a1
ffffffffc020355c:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020355e:	a4aff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
    if (vma != NULL) {
ffffffffc0203562:	c509                	beqz	a0,ffffffffc020356c <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0203564:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203568:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020356a:	ed00                	sd	s0,24(a0)
}
ffffffffc020356c:	60e2                	ld	ra,24(sp)
ffffffffc020356e:	6442                	ld	s0,16(sp)
ffffffffc0203570:	64a2                	ld	s1,8(sp)
ffffffffc0203572:	6902                	ld	s2,0(sp)
ffffffffc0203574:	6105                	addi	sp,sp,32
ffffffffc0203576:	8082                	ret

ffffffffc0203578 <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0203578:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc020357a:	c505                	beqz	a0,ffffffffc02035a2 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc020357c:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc020357e:	c501                	beqz	a0,ffffffffc0203586 <find_vma+0xe>
ffffffffc0203580:	651c                	ld	a5,8(a0)
ffffffffc0203582:	02f5f263          	bgeu	a1,a5,ffffffffc02035a6 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203586:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0203588:	00f68d63          	beq	a3,a5,ffffffffc02035a2 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc020358c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203590:	00e5e663          	bltu	a1,a4,ffffffffc020359c <find_vma+0x24>
ffffffffc0203594:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203598:	00e5ec63          	bltu	a1,a4,ffffffffc02035b0 <find_vma+0x38>
ffffffffc020359c:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc020359e:	fef697e3          	bne	a3,a5,ffffffffc020358c <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc02035a2:	4501                	li	a0,0
}
ffffffffc02035a4:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc02035a6:	691c                	ld	a5,16(a0)
ffffffffc02035a8:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203586 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc02035ac:	ea88                	sd	a0,16(a3)
ffffffffc02035ae:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc02035b0:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc02035b4:	ea88                	sd	a0,16(a3)
ffffffffc02035b6:	8082                	ret

ffffffffc02035b8 <insert_vma_struct>:
=======
ffffffffc02034c0:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02034c2:	00002697          	auipc	a3,0x2
ffffffffc02034c6:	7ce68693          	addi	a3,a3,1998 # ffffffffc0205c90 <default_pmm_manager+0xb08>
ffffffffc02034ca:	00002617          	auipc	a2,0x2
ffffffffc02034ce:	90e60613          	addi	a2,a2,-1778 # ffffffffc0204dd8 <commands+0x780>
ffffffffc02034d2:	07d00593          	li	a1,125
ffffffffc02034d6:	00002517          	auipc	a0,0x2
ffffffffc02034da:	7da50513          	addi	a0,a0,2010 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02034de:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02034e0:	e9bfc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc02034e4 <mm_create>:
mm_create(void) {
ffffffffc02034e4:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02034e6:	03000513          	li	a0,48
mm_create(void) {
ffffffffc02034ea:	e022                	sd	s0,0(sp)
ffffffffc02034ec:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02034ee:	abaff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc02034f2:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc02034f4:	c105                	beqz	a0,ffffffffc0203514 <mm_create+0x30>
    elm->prev = elm->next = elm;
ffffffffc02034f6:	e408                	sd	a0,8(s0)
ffffffffc02034f8:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc02034fa:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02034fe:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203502:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203506:	0000e797          	auipc	a5,0xe
ffffffffc020350a:	04a7a783          	lw	a5,74(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc020350e:	eb81                	bnez	a5,ffffffffc020351e <mm_create+0x3a>
        else mm->sm_priv = NULL;
ffffffffc0203510:	02053423          	sd	zero,40(a0)
}
ffffffffc0203514:	60a2                	ld	ra,8(sp)
ffffffffc0203516:	8522                	mv	a0,s0
ffffffffc0203518:	6402                	ld	s0,0(sp)
ffffffffc020351a:	0141                	addi	sp,sp,16
ffffffffc020351c:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc020351e:	a97ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
}
ffffffffc0203522:	60a2                	ld	ra,8(sp)
ffffffffc0203524:	8522                	mv	a0,s0
ffffffffc0203526:	6402                	ld	s0,0(sp)
ffffffffc0203528:	0141                	addi	sp,sp,16
ffffffffc020352a:	8082                	ret

ffffffffc020352c <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc020352c:	1101                	addi	sp,sp,-32
ffffffffc020352e:	e04a                	sd	s2,0(sp)
ffffffffc0203530:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203532:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0203536:	e822                	sd	s0,16(sp)
ffffffffc0203538:	e426                	sd	s1,8(sp)
ffffffffc020353a:	ec06                	sd	ra,24(sp)
ffffffffc020353c:	84ae                	mv	s1,a1
ffffffffc020353e:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203540:	a68ff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
    if (vma != NULL) {
ffffffffc0203544:	c509                	beqz	a0,ffffffffc020354e <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0203546:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc020354a:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020354c:	ed00                	sd	s0,24(a0)
}
ffffffffc020354e:	60e2                	ld	ra,24(sp)
ffffffffc0203550:	6442                	ld	s0,16(sp)
ffffffffc0203552:	64a2                	ld	s1,8(sp)
ffffffffc0203554:	6902                	ld	s2,0(sp)
ffffffffc0203556:	6105                	addi	sp,sp,32
ffffffffc0203558:	8082                	ret

ffffffffc020355a <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc020355a:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc020355c:	c505                	beqz	a0,ffffffffc0203584 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc020355e:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0203560:	c501                	beqz	a0,ffffffffc0203568 <find_vma+0xe>
ffffffffc0203562:	651c                	ld	a5,8(a0)
ffffffffc0203564:	02f5f263          	bgeu	a1,a5,ffffffffc0203588 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203568:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc020356a:	00f68d63          	beq	a3,a5,ffffffffc0203584 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc020356e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203572:	00e5e663          	bltu	a1,a4,ffffffffc020357e <find_vma+0x24>
ffffffffc0203576:	ff07b703          	ld	a4,-16(a5)
ffffffffc020357a:	00e5ec63          	bltu	a1,a4,ffffffffc0203592 <find_vma+0x38>
ffffffffc020357e:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0203580:	fef697e3          	bne	a3,a5,ffffffffc020356e <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203584:	4501                	li	a0,0
}
ffffffffc0203586:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0203588:	691c                	ld	a5,16(a0)
ffffffffc020358a:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203568 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020358e:	ea88                	sd	a0,16(a3)
ffffffffc0203590:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0203592:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203596:	ea88                	sd	a0,16(a3)
ffffffffc0203598:	8082                	ret

ffffffffc020359a <insert_vma_struct>:
>>>>>>> 747620b (lab2)


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
<<<<<<< HEAD
ffffffffc02035b8:	6590                	ld	a2,8(a1)
ffffffffc02035ba:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc02035be:	1141                	addi	sp,sp,-16
ffffffffc02035c0:	e406                	sd	ra,8(sp)
ffffffffc02035c2:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02035c4:	01066763          	bltu	a2,a6,ffffffffc02035d2 <insert_vma_struct+0x1a>
ffffffffc02035c8:	a085                	j	ffffffffc0203628 <insert_vma_struct+0x70>
=======
ffffffffc020359a:	6590                	ld	a2,8(a1)
ffffffffc020359c:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc02035a0:	1141                	addi	sp,sp,-16
ffffffffc02035a2:	e406                	sd	ra,8(sp)
ffffffffc02035a4:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02035a6:	01066763          	bltu	a2,a6,ffffffffc02035b4 <insert_vma_struct+0x1a>
ffffffffc02035aa:	a085                	j	ffffffffc020360a <insert_vma_struct+0x70>
>>>>>>> 747620b (lab2)
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
<<<<<<< HEAD
ffffffffc02035ca:	fe87b703          	ld	a4,-24(a5)
ffffffffc02035ce:	04e66863          	bltu	a2,a4,ffffffffc020361e <insert_vma_struct+0x66>
ffffffffc02035d2:	86be                	mv	a3,a5
ffffffffc02035d4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02035d6:	fef51ae3          	bne	a0,a5,ffffffffc02035ca <insert_vma_struct+0x12>
=======
ffffffffc02035ac:	fe87b703          	ld	a4,-24(a5)
ffffffffc02035b0:	04e66863          	bltu	a2,a4,ffffffffc0203600 <insert_vma_struct+0x66>
ffffffffc02035b4:	86be                	mv	a3,a5
ffffffffc02035b6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02035b8:	fef51ae3          	bne	a0,a5,ffffffffc02035ac <insert_vma_struct+0x12>
>>>>>>> 747620b (lab2)
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
<<<<<<< HEAD
ffffffffc02035da:	02a68463          	beq	a3,a0,ffffffffc0203602 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02035de:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02035e2:	fe86b883          	ld	a7,-24(a3)
ffffffffc02035e6:	08e8f163          	bgeu	a7,a4,ffffffffc0203668 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02035ea:	04e66f63          	bltu	a2,a4,ffffffffc0203648 <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc02035ee:	00f50a63          	beq	a0,a5,ffffffffc0203602 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc02035f2:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02035f6:	05076963          	bltu	a4,a6,ffffffffc0203648 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02035fa:	ff07b603          	ld	a2,-16(a5)
ffffffffc02035fe:	02c77363          	bgeu	a4,a2,ffffffffc0203624 <insert_vma_struct+0x6c>
=======
ffffffffc02035bc:	02a68463          	beq	a3,a0,ffffffffc02035e4 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02035c0:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02035c4:	fe86b883          	ld	a7,-24(a3)
ffffffffc02035c8:	08e8f163          	bgeu	a7,a4,ffffffffc020364a <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02035cc:	04e66f63          	bltu	a2,a4,ffffffffc020362a <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc02035d0:	00f50a63          	beq	a0,a5,ffffffffc02035e4 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc02035d4:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02035d8:	05076963          	bltu	a4,a6,ffffffffc020362a <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02035dc:	ff07b603          	ld	a2,-16(a5)
ffffffffc02035e0:	02c77363          	bgeu	a4,a2,ffffffffc0203606 <insert_vma_struct+0x6c>
>>>>>>> 747620b (lab2)
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
<<<<<<< HEAD
ffffffffc0203602:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203604:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203606:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020360a:	e390                	sd	a2,0(a5)
ffffffffc020360c:	e690                	sd	a2,8(a3)
}
ffffffffc020360e:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203610:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203612:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0203614:	0017079b          	addiw	a5,a4,1
ffffffffc0203618:	d11c                	sw	a5,32(a0)
}
ffffffffc020361a:	0141                	addi	sp,sp,16
ffffffffc020361c:	8082                	ret
    if (le_prev != list) {
ffffffffc020361e:	fca690e3          	bne	a3,a0,ffffffffc02035de <insert_vma_struct+0x26>
ffffffffc0203622:	bfd1                	j	ffffffffc02035f6 <insert_vma_struct+0x3e>
ffffffffc0203624:	ebbff0ef          	jal	ra,ffffffffc02034de <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203628:	00002697          	auipc	a3,0x2
ffffffffc020362c:	6c068693          	addi	a3,a3,1728 # ffffffffc0205ce8 <default_pmm_manager+0xb48>
ffffffffc0203630:	00001617          	auipc	a2,0x1
ffffffffc0203634:	7c060613          	addi	a2,a2,1984 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203638:	08400593          	li	a1,132
ffffffffc020363c:	00002517          	auipc	a0,0x2
ffffffffc0203640:	69c50513          	addi	a0,a0,1692 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203644:	d37fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203648:	00002697          	auipc	a3,0x2
ffffffffc020364c:	6e068693          	addi	a3,a3,1760 # ffffffffc0205d28 <default_pmm_manager+0xb88>
ffffffffc0203650:	00001617          	auipc	a2,0x1
ffffffffc0203654:	7a060613          	addi	a2,a2,1952 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203658:	07c00593          	li	a1,124
ffffffffc020365c:	00002517          	auipc	a0,0x2
ffffffffc0203660:	67c50513          	addi	a0,a0,1660 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203664:	d17fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203668:	00002697          	auipc	a3,0x2
ffffffffc020366c:	6a068693          	addi	a3,a3,1696 # ffffffffc0205d08 <default_pmm_manager+0xb68>
ffffffffc0203670:	00001617          	auipc	a2,0x1
ffffffffc0203674:	78060613          	addi	a2,a2,1920 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203678:	07b00593          	li	a1,123
ffffffffc020367c:	00002517          	auipc	a0,0x2
ffffffffc0203680:	65c50513          	addi	a0,a0,1628 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203684:	cf7fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203688 <mm_destroy>:
=======
ffffffffc02035e4:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02035e6:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02035e8:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02035ec:	e390                	sd	a2,0(a5)
ffffffffc02035ee:	e690                	sd	a2,8(a3)
}
ffffffffc02035f0:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02035f2:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02035f4:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc02035f6:	0017079b          	addiw	a5,a4,1
ffffffffc02035fa:	d11c                	sw	a5,32(a0)
}
ffffffffc02035fc:	0141                	addi	sp,sp,16
ffffffffc02035fe:	8082                	ret
    if (le_prev != list) {
ffffffffc0203600:	fca690e3          	bne	a3,a0,ffffffffc02035c0 <insert_vma_struct+0x26>
ffffffffc0203604:	bfd1                	j	ffffffffc02035d8 <insert_vma_struct+0x3e>
ffffffffc0203606:	ebbff0ef          	jal	ra,ffffffffc02034c0 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020360a:	00002697          	auipc	a3,0x2
ffffffffc020360e:	6b668693          	addi	a3,a3,1718 # ffffffffc0205cc0 <default_pmm_manager+0xb38>
ffffffffc0203612:	00001617          	auipc	a2,0x1
ffffffffc0203616:	7c660613          	addi	a2,a2,1990 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020361a:	08400593          	li	a1,132
ffffffffc020361e:	00002517          	auipc	a0,0x2
ffffffffc0203622:	69250513          	addi	a0,a0,1682 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203626:	d55fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020362a:	00002697          	auipc	a3,0x2
ffffffffc020362e:	6d668693          	addi	a3,a3,1750 # ffffffffc0205d00 <default_pmm_manager+0xb78>
ffffffffc0203632:	00001617          	auipc	a2,0x1
ffffffffc0203636:	7a660613          	addi	a2,a2,1958 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020363a:	07c00593          	li	a1,124
ffffffffc020363e:	00002517          	auipc	a0,0x2
ffffffffc0203642:	67250513          	addi	a0,a0,1650 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203646:	d35fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020364a:	00002697          	auipc	a3,0x2
ffffffffc020364e:	69668693          	addi	a3,a3,1686 # ffffffffc0205ce0 <default_pmm_manager+0xb58>
ffffffffc0203652:	00001617          	auipc	a2,0x1
ffffffffc0203656:	78660613          	addi	a2,a2,1926 # ffffffffc0204dd8 <commands+0x780>
ffffffffc020365a:	07b00593          	li	a1,123
ffffffffc020365e:	00002517          	auipc	a0,0x2
ffffffffc0203662:	65250513          	addi	a0,a0,1618 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203666:	d15fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc020366a <mm_destroy>:
>>>>>>> 747620b (lab2)

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
<<<<<<< HEAD
ffffffffc0203688:	1141                	addi	sp,sp,-16
ffffffffc020368a:	e022                	sd	s0,0(sp)
ffffffffc020368c:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020368e:	6508                	ld	a0,8(a0)
ffffffffc0203690:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0203692:	00a40e63          	beq	s0,a0,ffffffffc02036ae <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203696:	6118                	ld	a4,0(a0)
ffffffffc0203698:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc020369a:	03000593          	li	a1,48
ffffffffc020369e:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02036a0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02036a2:	e398                	sd	a4,0(a5)
ffffffffc02036a4:	9beff0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc02036a8:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02036aa:	fea416e3          	bne	s0,a0,ffffffffc0203696 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02036ae:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc02036b0:	6402                	ld	s0,0(sp)
ffffffffc02036b2:	60a2                	ld	ra,8(sp)
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02036b4:	03000593          	li	a1,48
}
ffffffffc02036b8:	0141                	addi	sp,sp,16
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02036ba:	9a8ff06f          	j	ffffffffc0202862 <kfree>

ffffffffc02036be <vmm_init>:
=======
ffffffffc020366a:	1141                	addi	sp,sp,-16
ffffffffc020366c:	e022                	sd	s0,0(sp)
ffffffffc020366e:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203670:	6508                	ld	a0,8(a0)
ffffffffc0203672:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0203674:	00a40e63          	beq	s0,a0,ffffffffc0203690 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203678:	6118                	ld	a4,0(a0)
ffffffffc020367a:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc020367c:	03000593          	li	a1,48
ffffffffc0203680:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203682:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203684:	e398                	sd	a4,0(a5)
ffffffffc0203686:	9dcff0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc020368a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc020368c:	fea416e3          	bne	s0,a0,ffffffffc0203678 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0203690:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0203692:	6402                	ld	s0,0(sp)
ffffffffc0203694:	60a2                	ld	ra,8(sp)
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0203696:	03000593          	li	a1,48
}
ffffffffc020369a:	0141                	addi	sp,sp,16
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc020369c:	9c6ff06f          	j	ffffffffc0202862 <kfree>

ffffffffc02036a0 <vmm_init>:
>>>>>>> 747620b (lab2)

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
<<<<<<< HEAD
ffffffffc02036be:	715d                	addi	sp,sp,-80
ffffffffc02036c0:	e486                	sd	ra,72(sp)
ffffffffc02036c2:	f44e                	sd	s3,40(sp)
ffffffffc02036c4:	f052                	sd	s4,32(sp)
ffffffffc02036c6:	e0a2                	sd	s0,64(sp)
ffffffffc02036c8:	fc26                	sd	s1,56(sp)
ffffffffc02036ca:	f84a                	sd	s2,48(sp)
ffffffffc02036cc:	ec56                	sd	s5,24(sp)
ffffffffc02036ce:	e85a                	sd	s6,16(sp)
ffffffffc02036d0:	e45e                	sd	s7,8(sp)
=======
ffffffffc02036a0:	715d                	addi	sp,sp,-80
ffffffffc02036a2:	e486                	sd	ra,72(sp)
ffffffffc02036a4:	f44e                	sd	s3,40(sp)
ffffffffc02036a6:	f052                	sd	s4,32(sp)
ffffffffc02036a8:	e0a2                	sd	s0,64(sp)
ffffffffc02036aa:	fc26                	sd	s1,56(sp)
ffffffffc02036ac:	f84a                	sd	s2,48(sp)
ffffffffc02036ae:	ec56                	sd	s5,24(sp)
ffffffffc02036b0:	e85a                	sd	s6,16(sp)
ffffffffc02036b2:	e45e                	sd	s7,8(sp)
>>>>>>> 747620b (lab2)
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
<<<<<<< HEAD
ffffffffc02036d2:	ff1fd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02036d6:	89aa                	mv	s3,a0
=======
ffffffffc02036b4:	80efe0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02036b8:	89aa                	mv	s3,a0
>>>>>>> 747620b (lab2)
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();
<<<<<<< HEAD
ffffffffc02036d8:	febfd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02036dc:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036de:	03000513          	li	a0,48
ffffffffc02036e2:	8c6ff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
    if (mm != NULL) {
ffffffffc02036e6:	56050863          	beqz	a0,ffffffffc0203c56 <vmm_init+0x598>
    elm->prev = elm->next = elm;
ffffffffc02036ea:	e508                	sd	a0,8(a0)
ffffffffc02036ec:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036ee:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036f2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036f6:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02036fa:	0000e797          	auipc	a5,0xe
ffffffffc02036fe:	e567a783          	lw	a5,-426(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0203702:	84aa                	mv	s1,a0
ffffffffc0203704:	e7b9                	bnez	a5,ffffffffc0203752 <vmm_init+0x94>
        else mm->sm_priv = NULL;
ffffffffc0203706:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc020370a:	03200413          	li	s0,50
ffffffffc020370e:	a811                	j	ffffffffc0203722 <vmm_init+0x64>
        vma->vm_start = vm_start;
ffffffffc0203710:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203712:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203714:	00053c23          	sd	zero,24(a0)
=======
ffffffffc02036ba:	808fe0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02036be:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036c0:	03000513          	li	a0,48
ffffffffc02036c4:	8e4ff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
    if (mm != NULL) {
ffffffffc02036c8:	56050863          	beqz	a0,ffffffffc0203c38 <vmm_init+0x598>
    elm->prev = elm->next = elm;
ffffffffc02036cc:	e508                	sd	a0,8(a0)
ffffffffc02036ce:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036d0:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036d4:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036d8:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02036dc:	0000e797          	auipc	a5,0xe
ffffffffc02036e0:	e747a783          	lw	a5,-396(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc02036e4:	84aa                	mv	s1,a0
ffffffffc02036e6:	e7b9                	bnez	a5,ffffffffc0203734 <vmm_init+0x94>
        else mm->sm_priv = NULL;
ffffffffc02036e8:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc02036ec:	03200413          	li	s0,50
ffffffffc02036f0:	a811                	j	ffffffffc0203704 <vmm_init+0x64>
        vma->vm_start = vm_start;
ffffffffc02036f2:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02036f4:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02036f6:	00053c23          	sd	zero,24(a0)
>>>>>>> 747620b (lab2)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
<<<<<<< HEAD
ffffffffc0203718:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020371a:	8526                	mv	a0,s1
ffffffffc020371c:	e9dff0ef          	jal	ra,ffffffffc02035b8 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0203720:	cc05                	beqz	s0,ffffffffc0203758 <vmm_init+0x9a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203722:	03000513          	li	a0,48
ffffffffc0203726:	882ff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc020372a:	85aa                	mv	a1,a0
ffffffffc020372c:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203730:	f165                	bnez	a0,ffffffffc0203710 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0203732:	00002697          	auipc	a3,0x2
ffffffffc0203736:	19e68693          	addi	a3,a3,414 # ffffffffc02058d0 <default_pmm_manager+0x730>
ffffffffc020373a:	00001617          	auipc	a2,0x1
ffffffffc020373e:	6b660613          	addi	a2,a2,1718 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203742:	0ce00593          	li	a1,206
ffffffffc0203746:	00002517          	auipc	a0,0x2
ffffffffc020374a:	59250513          	addi	a0,a0,1426 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc020374e:	c2dfc0ef          	jal	ra,ffffffffc020037a <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203752:	863ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
ffffffffc0203756:	bf55                	j	ffffffffc020370a <vmm_init+0x4c>
ffffffffc0203758:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc020375c:	1f900913          	li	s2,505
ffffffffc0203760:	a819                	j	ffffffffc0203776 <vmm_init+0xb8>
        vma->vm_start = vm_start;
ffffffffc0203762:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203764:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203766:	00053c23          	sd	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc020376a:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020376c:	8526                	mv	a0,s1
ffffffffc020376e:	e4bff0ef          	jal	ra,ffffffffc02035b8 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0203772:	03240a63          	beq	s0,s2,ffffffffc02037a6 <vmm_init+0xe8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203776:	03000513          	li	a0,48
ffffffffc020377a:	82eff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc020377e:	85aa                	mv	a1,a0
ffffffffc0203780:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203784:	fd79                	bnez	a0,ffffffffc0203762 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0203786:	00002697          	auipc	a3,0x2
ffffffffc020378a:	14a68693          	addi	a3,a3,330 # ffffffffc02058d0 <default_pmm_manager+0x730>
ffffffffc020378e:	00001617          	auipc	a2,0x1
ffffffffc0203792:	66260613          	addi	a2,a2,1634 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203796:	0d400593          	li	a1,212
ffffffffc020379a:	00002517          	auipc	a0,0x2
ffffffffc020379e:	53e50513          	addi	a0,a0,1342 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc02037a2:	bd9fc0ef          	jal	ra,ffffffffc020037a <__panic>
    return listelm->next;
ffffffffc02037a6:	649c                	ld	a5,8(s1)
ffffffffc02037a8:	471d                	li	a4,7
=======
ffffffffc02036fa:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02036fc:	8526                	mv	a0,s1
ffffffffc02036fe:	e9dff0ef          	jal	ra,ffffffffc020359a <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0203702:	cc05                	beqz	s0,ffffffffc020373a <vmm_init+0x9a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203704:	03000513          	li	a0,48
ffffffffc0203708:	8a0ff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc020370c:	85aa                	mv	a1,a0
ffffffffc020370e:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203712:	f165                	bnez	a0,ffffffffc02036f2 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0203714:	00002697          	auipc	a3,0x2
ffffffffc0203718:	1a468693          	addi	a3,a3,420 # ffffffffc02058b8 <default_pmm_manager+0x730>
ffffffffc020371c:	00001617          	auipc	a2,0x1
ffffffffc0203720:	6bc60613          	addi	a2,a2,1724 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203724:	0ce00593          	li	a1,206
ffffffffc0203728:	00002517          	auipc	a0,0x2
ffffffffc020372c:	58850513          	addi	a0,a0,1416 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203730:	c4bfc0ef          	jal	ra,ffffffffc020037a <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203734:	881ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
ffffffffc0203738:	bf55                	j	ffffffffc02036ec <vmm_init+0x4c>
ffffffffc020373a:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc020373e:	1f900913          	li	s2,505
ffffffffc0203742:	a819                	j	ffffffffc0203758 <vmm_init+0xb8>
        vma->vm_start = vm_start;
ffffffffc0203744:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203746:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203748:	00053c23          	sd	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc020374c:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020374e:	8526                	mv	a0,s1
ffffffffc0203750:	e4bff0ef          	jal	ra,ffffffffc020359a <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0203754:	03240a63          	beq	s0,s2,ffffffffc0203788 <vmm_init+0xe8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203758:	03000513          	li	a0,48
ffffffffc020375c:	84cff0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc0203760:	85aa                	mv	a1,a0
ffffffffc0203762:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203766:	fd79                	bnez	a0,ffffffffc0203744 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0203768:	00002697          	auipc	a3,0x2
ffffffffc020376c:	15068693          	addi	a3,a3,336 # ffffffffc02058b8 <default_pmm_manager+0x730>
ffffffffc0203770:	00001617          	auipc	a2,0x1
ffffffffc0203774:	66860613          	addi	a2,a2,1640 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203778:	0d400593          	li	a1,212
ffffffffc020377c:	00002517          	auipc	a0,0x2
ffffffffc0203780:	53450513          	addi	a0,a0,1332 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203784:	bf7fc0ef          	jal	ra,ffffffffc020037a <__panic>
    return listelm->next;
ffffffffc0203788:	649c                	ld	a5,8(s1)
ffffffffc020378a:	471d                	li	a4,7
>>>>>>> 747620b (lab2)
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
<<<<<<< HEAD
ffffffffc02037aa:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc02037ae:	2ef48463          	beq	s1,a5,ffffffffc0203a96 <vmm_init+0x3d8>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02037b2:	fe87b603          	ld	a2,-24(a5)
ffffffffc02037b6:	ffe70693          	addi	a3,a4,-2
ffffffffc02037ba:	26d61e63          	bne	a2,a3,ffffffffc0203a36 <vmm_init+0x378>
ffffffffc02037be:	ff07b683          	ld	a3,-16(a5)
ffffffffc02037c2:	26e69a63          	bne	a3,a4,ffffffffc0203a36 <vmm_init+0x378>
    for (i = 1; i <= step2; i ++) {
ffffffffc02037c6:	0715                	addi	a4,a4,5
ffffffffc02037c8:	679c                	ld	a5,8(a5)
ffffffffc02037ca:	feb712e3          	bne	a4,a1,ffffffffc02037ae <vmm_init+0xf0>
ffffffffc02037ce:	4b1d                	li	s6,7
ffffffffc02037d0:	4415                	li	s0,5
=======
ffffffffc020378c:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0203790:	2ef48463          	beq	s1,a5,ffffffffc0203a78 <vmm_init+0x3d8>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203794:	fe87b603          	ld	a2,-24(a5)
ffffffffc0203798:	ffe70693          	addi	a3,a4,-2
ffffffffc020379c:	26d61e63          	bne	a2,a3,ffffffffc0203a18 <vmm_init+0x378>
ffffffffc02037a0:	ff07b683          	ld	a3,-16(a5)
ffffffffc02037a4:	26e69a63          	bne	a3,a4,ffffffffc0203a18 <vmm_init+0x378>
    for (i = 1; i <= step2; i ++) {
ffffffffc02037a8:	0715                	addi	a4,a4,5
ffffffffc02037aa:	679c                	ld	a5,8(a5)
ffffffffc02037ac:	feb712e3          	bne	a4,a1,ffffffffc0203790 <vmm_init+0xf0>
ffffffffc02037b0:	4b1d                	li	s6,7
ffffffffc02037b2:	4415                	li	s0,5
>>>>>>> 747620b (lab2)
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
<<<<<<< HEAD
ffffffffc02037d2:	1f900b93          	li	s7,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02037d6:	85a2                	mv	a1,s0
ffffffffc02037d8:	8526                	mv	a0,s1
ffffffffc02037da:	d9fff0ef          	jal	ra,ffffffffc0203578 <find_vma>
ffffffffc02037de:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc02037e0:	2c050b63          	beqz	a0,ffffffffc0203ab6 <vmm_init+0x3f8>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc02037e4:	00140593          	addi	a1,s0,1
ffffffffc02037e8:	8526                	mv	a0,s1
ffffffffc02037ea:	d8fff0ef          	jal	ra,ffffffffc0203578 <find_vma>
ffffffffc02037ee:	8aaa                	mv	s5,a0
        assert(vma2 != NULL);
ffffffffc02037f0:	2e050363          	beqz	a0,ffffffffc0203ad6 <vmm_init+0x418>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc02037f4:	85da                	mv	a1,s6
ffffffffc02037f6:	8526                	mv	a0,s1
ffffffffc02037f8:	d81ff0ef          	jal	ra,ffffffffc0203578 <find_vma>
        assert(vma3 == NULL);
ffffffffc02037fc:	2e051d63          	bnez	a0,ffffffffc0203af6 <vmm_init+0x438>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0203800:	00340593          	addi	a1,s0,3
ffffffffc0203804:	8526                	mv	a0,s1
ffffffffc0203806:	d73ff0ef          	jal	ra,ffffffffc0203578 <find_vma>
        assert(vma4 == NULL);
ffffffffc020380a:	30051663          	bnez	a0,ffffffffc0203b16 <vmm_init+0x458>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc020380e:	00440593          	addi	a1,s0,4
ffffffffc0203812:	8526                	mv	a0,s1
ffffffffc0203814:	d65ff0ef          	jal	ra,ffffffffc0203578 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203818:	30051f63          	bnez	a0,ffffffffc0203b36 <vmm_init+0x478>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc020381c:	00893783          	ld	a5,8(s2)
ffffffffc0203820:	24879b63          	bne	a5,s0,ffffffffc0203a76 <vmm_init+0x3b8>
ffffffffc0203824:	01093783          	ld	a5,16(s2)
ffffffffc0203828:	25679763          	bne	a5,s6,ffffffffc0203a76 <vmm_init+0x3b8>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc020382c:	008ab783          	ld	a5,8(s5)
ffffffffc0203830:	22879363          	bne	a5,s0,ffffffffc0203a56 <vmm_init+0x398>
ffffffffc0203834:	010ab783          	ld	a5,16(s5)
ffffffffc0203838:	21679f63          	bne	a5,s6,ffffffffc0203a56 <vmm_init+0x398>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc020383c:	0415                	addi	s0,s0,5
ffffffffc020383e:	0b15                	addi	s6,s6,5
ffffffffc0203840:	f9741be3          	bne	s0,s7,ffffffffc02037d6 <vmm_init+0x118>
ffffffffc0203844:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0203846:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0203848:	85a2                	mv	a1,s0
ffffffffc020384a:	8526                	mv	a0,s1
ffffffffc020384c:	d2dff0ef          	jal	ra,ffffffffc0203578 <find_vma>
ffffffffc0203850:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0203854:	c90d                	beqz	a0,ffffffffc0203886 <vmm_init+0x1c8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0203856:	6914                	ld	a3,16(a0)
ffffffffc0203858:	6510                	ld	a2,8(a0)
ffffffffc020385a:	00002517          	auipc	a0,0x2
ffffffffc020385e:	5ee50513          	addi	a0,a0,1518 # ffffffffc0205e48 <default_pmm_manager+0xca8>
ffffffffc0203862:	85ffc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203866:	00002697          	auipc	a3,0x2
ffffffffc020386a:	60a68693          	addi	a3,a3,1546 # ffffffffc0205e70 <default_pmm_manager+0xcd0>
ffffffffc020386e:	00001617          	auipc	a2,0x1
ffffffffc0203872:	58260613          	addi	a2,a2,1410 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203876:	0f600593          	li	a1,246
ffffffffc020387a:	00002517          	auipc	a0,0x2
ffffffffc020387e:	45e50513          	addi	a0,a0,1118 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203882:	af9fc0ef          	jal	ra,ffffffffc020037a <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0203886:	147d                	addi	s0,s0,-1
ffffffffc0203888:	fd2410e3          	bne	s0,s2,ffffffffc0203848 <vmm_init+0x18a>
ffffffffc020388c:	a811                	j	ffffffffc02038a0 <vmm_init+0x1e2>
    __list_del(listelm->prev, listelm->next);
ffffffffc020388e:	6118                	ld	a4,0(a0)
ffffffffc0203890:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0203892:	03000593          	li	a1,48
ffffffffc0203896:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203898:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020389a:	e398                	sd	a4,0(a5)
ffffffffc020389c:	fc7fe0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc02038a0:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc02038a2:	fea496e3          	bne	s1,a0,ffffffffc020388e <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02038a6:	03000593          	li	a1,48
ffffffffc02038aa:	8526                	mv	a0,s1
ffffffffc02038ac:	fb7fe0ef          	jal	ra,ffffffffc0202862 <kfree>
=======
ffffffffc02037b4:	1f900b93          	li	s7,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02037b8:	85a2                	mv	a1,s0
ffffffffc02037ba:	8526                	mv	a0,s1
ffffffffc02037bc:	d9fff0ef          	jal	ra,ffffffffc020355a <find_vma>
ffffffffc02037c0:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc02037c2:	2c050b63          	beqz	a0,ffffffffc0203a98 <vmm_init+0x3f8>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc02037c6:	00140593          	addi	a1,s0,1
ffffffffc02037ca:	8526                	mv	a0,s1
ffffffffc02037cc:	d8fff0ef          	jal	ra,ffffffffc020355a <find_vma>
ffffffffc02037d0:	8aaa                	mv	s5,a0
        assert(vma2 != NULL);
ffffffffc02037d2:	2e050363          	beqz	a0,ffffffffc0203ab8 <vmm_init+0x418>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc02037d6:	85da                	mv	a1,s6
ffffffffc02037d8:	8526                	mv	a0,s1
ffffffffc02037da:	d81ff0ef          	jal	ra,ffffffffc020355a <find_vma>
        assert(vma3 == NULL);
ffffffffc02037de:	2e051d63          	bnez	a0,ffffffffc0203ad8 <vmm_init+0x438>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc02037e2:	00340593          	addi	a1,s0,3
ffffffffc02037e6:	8526                	mv	a0,s1
ffffffffc02037e8:	d73ff0ef          	jal	ra,ffffffffc020355a <find_vma>
        assert(vma4 == NULL);
ffffffffc02037ec:	30051663          	bnez	a0,ffffffffc0203af8 <vmm_init+0x458>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc02037f0:	00440593          	addi	a1,s0,4
ffffffffc02037f4:	8526                	mv	a0,s1
ffffffffc02037f6:	d65ff0ef          	jal	ra,ffffffffc020355a <find_vma>
        assert(vma5 == NULL);
ffffffffc02037fa:	30051f63          	bnez	a0,ffffffffc0203b18 <vmm_init+0x478>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc02037fe:	00893783          	ld	a5,8(s2)
ffffffffc0203802:	24879b63          	bne	a5,s0,ffffffffc0203a58 <vmm_init+0x3b8>
ffffffffc0203806:	01093783          	ld	a5,16(s2)
ffffffffc020380a:	25679763          	bne	a5,s6,ffffffffc0203a58 <vmm_init+0x3b8>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc020380e:	008ab783          	ld	a5,8(s5)
ffffffffc0203812:	22879363          	bne	a5,s0,ffffffffc0203a38 <vmm_init+0x398>
ffffffffc0203816:	010ab783          	ld	a5,16(s5)
ffffffffc020381a:	21679f63          	bne	a5,s6,ffffffffc0203a38 <vmm_init+0x398>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc020381e:	0415                	addi	s0,s0,5
ffffffffc0203820:	0b15                	addi	s6,s6,5
ffffffffc0203822:	f9741be3          	bne	s0,s7,ffffffffc02037b8 <vmm_init+0x118>
ffffffffc0203826:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0203828:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc020382a:	85a2                	mv	a1,s0
ffffffffc020382c:	8526                	mv	a0,s1
ffffffffc020382e:	d2dff0ef          	jal	ra,ffffffffc020355a <find_vma>
ffffffffc0203832:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0203836:	c90d                	beqz	a0,ffffffffc0203868 <vmm_init+0x1c8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0203838:	6914                	ld	a3,16(a0)
ffffffffc020383a:	6510                	ld	a2,8(a0)
ffffffffc020383c:	00002517          	auipc	a0,0x2
ffffffffc0203840:	5e450513          	addi	a0,a0,1508 # ffffffffc0205e20 <default_pmm_manager+0xc98>
ffffffffc0203844:	87dfc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203848:	00002697          	auipc	a3,0x2
ffffffffc020384c:	60068693          	addi	a3,a3,1536 # ffffffffc0205e48 <default_pmm_manager+0xcc0>
ffffffffc0203850:	00001617          	auipc	a2,0x1
ffffffffc0203854:	58860613          	addi	a2,a2,1416 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203858:	0f600593          	li	a1,246
ffffffffc020385c:	00002517          	auipc	a0,0x2
ffffffffc0203860:	45450513          	addi	a0,a0,1108 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203864:	b17fc0ef          	jal	ra,ffffffffc020037a <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0203868:	147d                	addi	s0,s0,-1
ffffffffc020386a:	fd2410e3          	bne	s0,s2,ffffffffc020382a <vmm_init+0x18a>
ffffffffc020386e:	a811                	j	ffffffffc0203882 <vmm_init+0x1e2>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203870:	6118                	ld	a4,0(a0)
ffffffffc0203872:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0203874:	03000593          	li	a1,48
ffffffffc0203878:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc020387a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020387c:	e398                	sd	a4,0(a5)
ffffffffc020387e:	fe5fe0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc0203882:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0203884:	fea496e3          	bne	s1,a0,ffffffffc0203870 <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0203888:	03000593          	li	a1,48
ffffffffc020388c:	8526                	mv	a0,s1
ffffffffc020388e:	fd5fe0ef          	jal	ra,ffffffffc0202862 <kfree>
>>>>>>> 747620b (lab2)
    }

    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());
<<<<<<< HEAD
ffffffffc02038b0:	e13fd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02038b4:	3caa1163          	bne	s4,a0,ffffffffc0203c76 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02038b8:	00002517          	auipc	a0,0x2
ffffffffc02038bc:	5f850513          	addi	a0,a0,1528 # ffffffffc0205eb0 <default_pmm_manager+0xd10>
ffffffffc02038c0:	801fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
=======
ffffffffc0203892:	e31fd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc0203896:	3caa1163          	bne	s4,a0,ffffffffc0203c58 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020389a:	00002517          	auipc	a0,0x2
ffffffffc020389e:	5ee50513          	addi	a0,a0,1518 # ffffffffc0205e88 <default_pmm_manager+0xd00>
ffffffffc02038a2:	81ffc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
>>>>>>> 747620b (lab2)

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
<<<<<<< HEAD
ffffffffc02038c4:	dfffd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02038c8:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038ca:	03000513          	li	a0,48
ffffffffc02038ce:	edbfe0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc02038d2:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc02038d4:	2a050163          	beqz	a0,ffffffffc0203b76 <vmm_init+0x4b8>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02038d8:	0000e797          	auipc	a5,0xe
ffffffffc02038dc:	c787a783          	lw	a5,-904(a5) # ffffffffc0211550 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc02038e0:	e508                	sd	a0,8(a0)
ffffffffc02038e2:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02038e4:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02038e8:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02038ec:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02038f0:	14079063          	bnez	a5,ffffffffc0203a30 <vmm_init+0x372>
        else mm->sm_priv = NULL;
ffffffffc02038f4:	02053423          	sd	zero,40(a0)
=======
ffffffffc02038a6:	e1dfd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02038aa:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038ac:	03000513          	li	a0,48
ffffffffc02038b0:	ef9fe0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc02038b4:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc02038b6:	2a050163          	beqz	a0,ffffffffc0203b58 <vmm_init+0x4b8>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02038ba:	0000e797          	auipc	a5,0xe
ffffffffc02038be:	c967a783          	lw	a5,-874(a5) # ffffffffc0211550 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc02038c2:	e508                	sd	a0,8(a0)
ffffffffc02038c4:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02038c6:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02038ca:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02038ce:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02038d2:	14079063          	bnez	a5,ffffffffc0203a12 <vmm_init+0x372>
        else mm->sm_priv = NULL;
ffffffffc02038d6:	02053423          	sd	zero,40(a0)
>>>>>>> 747620b (lab2)

    check_mm_struct = mm_create();

    assert(check_mm_struct != NULL);
    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
<<<<<<< HEAD
ffffffffc02038f8:	0000e917          	auipc	s2,0xe
ffffffffc02038fc:	c2093903          	ld	s2,-992(s2) # ffffffffc0211518 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0203900:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc0203904:	0000e717          	auipc	a4,0xe
ffffffffc0203908:	c4873e23          	sd	s0,-932(a4) # ffffffffc0211560 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc020390c:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc0203910:	24079363          	bnez	a5,ffffffffc0203b56 <vmm_init+0x498>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203914:	03000513          	li	a0,48
ffffffffc0203918:	e91fe0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc020391c:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc020391e:	28050063          	beqz	a0,ffffffffc0203b9e <vmm_init+0x4e0>
        vma->vm_end = vm_end;
ffffffffc0203922:	002007b7          	lui	a5,0x200
ffffffffc0203926:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc020392a:	4789                	li	a5,2
=======
ffffffffc02038da:	0000e917          	auipc	s2,0xe
ffffffffc02038de:	c3e93903          	ld	s2,-962(s2) # ffffffffc0211518 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc02038e2:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc02038e6:	0000e717          	auipc	a4,0xe
ffffffffc02038ea:	c6873d23          	sd	s0,-902(a4) # ffffffffc0211560 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02038ee:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc02038f2:	24079363          	bnez	a5,ffffffffc0203b38 <vmm_init+0x498>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038f6:	03000513          	li	a0,48
ffffffffc02038fa:	eaffe0ef          	jal	ra,ffffffffc02027a8 <kmalloc>
ffffffffc02038fe:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc0203900:	28050063          	beqz	a0,ffffffffc0203b80 <vmm_init+0x4e0>
        vma->vm_end = vm_end;
ffffffffc0203904:	002007b7          	lui	a5,0x200
ffffffffc0203908:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc020390c:	4789                	li	a5,2
>>>>>>> 747620b (lab2)

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);

    assert(vma != NULL);

    insert_vma_struct(mm, vma);
<<<<<<< HEAD
ffffffffc020392c:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc020392e:	00fa3c23          	sd	a5,24(s4)
    insert_vma_struct(mm, vma);
ffffffffc0203932:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0203934:	000a3423          	sd	zero,8(s4)
    insert_vma_struct(mm, vma);
ffffffffc0203938:	c81ff0ef          	jal	ra,ffffffffc02035b8 <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc020393c:	10000593          	li	a1,256
ffffffffc0203940:	8522                	mv	a0,s0
ffffffffc0203942:	c37ff0ef          	jal	ra,ffffffffc0203578 <find_vma>
ffffffffc0203946:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc020394a:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc020394e:	26aa1863          	bne	s4,a0,ffffffffc0203bbe <vmm_init+0x500>
        *(char *)(addr + i) = i;
ffffffffc0203952:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc0203956:	0785                	addi	a5,a5,1
ffffffffc0203958:	fee79de3          	bne	a5,a4,ffffffffc0203952 <vmm_init+0x294>
        sum += i;
ffffffffc020395c:	6705                	lui	a4,0x1
ffffffffc020395e:	10000793          	li	a5,256
ffffffffc0203962:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0203966:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc020396a:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc020396e:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc0203970:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0203972:	fec79ce3          	bne	a5,a2,ffffffffc020396a <vmm_init+0x2ac>
    }
    assert(sum == 0);
ffffffffc0203976:	26071463          	bnez	a4,ffffffffc0203bde <vmm_init+0x520>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc020397a:	4581                	li	a1,0
ffffffffc020397c:	854a                	mv	a0,s2
ffffffffc020397e:	fcffd0ef          	jal	ra,ffffffffc020194c <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203982:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203986:	0000e717          	auipc	a4,0xe
ffffffffc020398a:	b9a73703          	ld	a4,-1126(a4) # ffffffffc0211520 <npage>
    return pa2page(PDE_ADDR(pde));
ffffffffc020398e:	078a                	slli	a5,a5,0x2
ffffffffc0203990:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203992:	26e7f663          	bgeu	a5,a4,ffffffffc0203bfe <vmm_init+0x540>
    return &pages[PPN(pa) - nbase];
ffffffffc0203996:	00003717          	auipc	a4,0x3
ffffffffc020399a:	8e273703          	ld	a4,-1822(a4) # ffffffffc0206278 <nbase>
ffffffffc020399e:	8f99                	sub	a5,a5,a4
ffffffffc02039a0:	00379713          	slli	a4,a5,0x3
ffffffffc02039a4:	97ba                	add	a5,a5,a4
ffffffffc02039a6:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc02039a8:	0000e517          	auipc	a0,0xe
ffffffffc02039ac:	b8053503          	ld	a0,-1152(a0) # ffffffffc0211528 <pages>
ffffffffc02039b0:	953e                	add	a0,a0,a5
ffffffffc02039b2:	4585                	li	a1,1
ffffffffc02039b4:	ccffd0ef          	jal	ra,ffffffffc0201682 <free_pages>
    return listelm->next;
ffffffffc02039b8:	6408                	ld	a0,8(s0)

    pgdir[0] = 0;
ffffffffc02039ba:	00093023          	sd	zero,0(s2)

    mm->pgdir = NULL;
ffffffffc02039be:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02039c2:	00a40e63          	beq	s0,a0,ffffffffc02039de <vmm_init+0x320>
    __list_del(listelm->prev, listelm->next);
ffffffffc02039c6:	6118                	ld	a4,0(a0)
ffffffffc02039c8:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc02039ca:	03000593          	li	a1,48
ffffffffc02039ce:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02039d0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02039d2:	e398                	sd	a4,0(a5)
ffffffffc02039d4:	e8ffe0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc02039d8:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02039da:	fea416e3          	bne	s0,a0,ffffffffc02039c6 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02039de:	03000593          	li	a1,48
ffffffffc02039e2:	8522                	mv	a0,s0
ffffffffc02039e4:	e7ffe0ef          	jal	ra,ffffffffc0202862 <kfree>
=======
ffffffffc020390e:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0203910:	00fa3c23          	sd	a5,24(s4)
    insert_vma_struct(mm, vma);
ffffffffc0203914:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0203916:	000a3423          	sd	zero,8(s4)
    insert_vma_struct(mm, vma);
ffffffffc020391a:	c81ff0ef          	jal	ra,ffffffffc020359a <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc020391e:	10000593          	li	a1,256
ffffffffc0203922:	8522                	mv	a0,s0
ffffffffc0203924:	c37ff0ef          	jal	ra,ffffffffc020355a <find_vma>
ffffffffc0203928:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc020392c:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc0203930:	26aa1863          	bne	s4,a0,ffffffffc0203ba0 <vmm_init+0x500>
        *(char *)(addr + i) = i;
ffffffffc0203934:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc0203938:	0785                	addi	a5,a5,1
ffffffffc020393a:	fee79de3          	bne	a5,a4,ffffffffc0203934 <vmm_init+0x294>
        sum += i;
ffffffffc020393e:	6705                	lui	a4,0x1
ffffffffc0203940:	10000793          	li	a5,256
ffffffffc0203944:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0203948:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc020394c:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc0203950:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc0203952:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0203954:	fec79ce3          	bne	a5,a2,ffffffffc020394c <vmm_init+0x2ac>
    }
    assert(sum == 0);
ffffffffc0203958:	26071463          	bnez	a4,ffffffffc0203bc0 <vmm_init+0x520>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc020395c:	4581                	li	a1,0
ffffffffc020395e:	854a                	mv	a0,s2
ffffffffc0203960:	fedfd0ef          	jal	ra,ffffffffc020194c <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203964:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203968:	0000e717          	auipc	a4,0xe
ffffffffc020396c:	bb873703          	ld	a4,-1096(a4) # ffffffffc0211520 <npage>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203970:	078a                	slli	a5,a5,0x2
ffffffffc0203972:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203974:	26e7f663          	bgeu	a5,a4,ffffffffc0203be0 <vmm_init+0x540>
    return &pages[PPN(pa) - nbase];
ffffffffc0203978:	00003717          	auipc	a4,0x3
ffffffffc020397c:	8d873703          	ld	a4,-1832(a4) # ffffffffc0206250 <nbase>
ffffffffc0203980:	8f99                	sub	a5,a5,a4
ffffffffc0203982:	00379713          	slli	a4,a5,0x3
ffffffffc0203986:	97ba                	add	a5,a5,a4
ffffffffc0203988:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc020398a:	0000e517          	auipc	a0,0xe
ffffffffc020398e:	b9e53503          	ld	a0,-1122(a0) # ffffffffc0211528 <pages>
ffffffffc0203992:	953e                	add	a0,a0,a5
ffffffffc0203994:	4585                	li	a1,1
ffffffffc0203996:	cedfd0ef          	jal	ra,ffffffffc0201682 <free_pages>
    return listelm->next;
ffffffffc020399a:	6408                	ld	a0,8(s0)

    pgdir[0] = 0;
ffffffffc020399c:	00093023          	sd	zero,0(s2)

    mm->pgdir = NULL;
ffffffffc02039a0:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02039a4:	00a40e63          	beq	s0,a0,ffffffffc02039c0 <vmm_init+0x320>
    __list_del(listelm->prev, listelm->next);
ffffffffc02039a8:	6118                	ld	a4,0(a0)
ffffffffc02039aa:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc02039ac:	03000593          	li	a1,48
ffffffffc02039b0:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02039b2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02039b4:	e398                	sd	a4,0(a5)
ffffffffc02039b6:	eadfe0ef          	jal	ra,ffffffffc0202862 <kfree>
    return listelm->next;
ffffffffc02039ba:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02039bc:	fea416e3          	bne	s0,a0,ffffffffc02039a8 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc02039c0:	03000593          	li	a1,48
ffffffffc02039c4:	8522                	mv	a0,s0
ffffffffc02039c6:	e9dfe0ef          	jal	ra,ffffffffc0202862 <kfree>
>>>>>>> 747620b (lab2)
    mm_destroy(mm);

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
<<<<<<< HEAD
ffffffffc02039e8:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc02039ea:	0000e797          	auipc	a5,0xe
ffffffffc02039ee:	b607bb23          	sd	zero,-1162(a5) # ffffffffc0211560 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02039f2:	cd1fd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02039f6:	22a49063          	bne	s1,a0,ffffffffc0203c16 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc02039fa:	00002517          	auipc	a0,0x2
ffffffffc02039fe:	50650513          	addi	a0,a0,1286 # ffffffffc0205f00 <default_pmm_manager+0xd60>
ffffffffc0203a02:	ebefc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203a06:	cbdfd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
    nr_free_pages_store--;	// szx : Sv39三级页表多占一个内存页，所以执行此操作
ffffffffc0203a0a:	19fd                	addi	s3,s3,-1
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203a0c:	22a99563          	bne	s3,a0,ffffffffc0203c36 <vmm_init+0x578>
}
ffffffffc0203a10:	6406                	ld	s0,64(sp)
ffffffffc0203a12:	60a6                	ld	ra,72(sp)
ffffffffc0203a14:	74e2                	ld	s1,56(sp)
ffffffffc0203a16:	7942                	ld	s2,48(sp)
ffffffffc0203a18:	79a2                	ld	s3,40(sp)
ffffffffc0203a1a:	7a02                	ld	s4,32(sp)
ffffffffc0203a1c:	6ae2                	ld	s5,24(sp)
ffffffffc0203a1e:	6b42                	ld	s6,16(sp)
ffffffffc0203a20:	6ba2                	ld	s7,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a22:	00002517          	auipc	a0,0x2
ffffffffc0203a26:	4fe50513          	addi	a0,a0,1278 # ffffffffc0205f20 <default_pmm_manager+0xd80>
}
ffffffffc0203a2a:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a2c:	e94fc06f          	j	ffffffffc02000c0 <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203a30:	d84ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
ffffffffc0203a34:	b5d1                	j	ffffffffc02038f8 <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203a36:	00002697          	auipc	a3,0x2
ffffffffc0203a3a:	32a68693          	addi	a3,a3,810 # ffffffffc0205d60 <default_pmm_manager+0xbc0>
ffffffffc0203a3e:	00001617          	auipc	a2,0x1
ffffffffc0203a42:	3b260613          	addi	a2,a2,946 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203a46:	0dd00593          	li	a1,221
ffffffffc0203a4a:	00002517          	auipc	a0,0x2
ffffffffc0203a4e:	28e50513          	addi	a0,a0,654 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203a52:	929fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0203a56:	00002697          	auipc	a3,0x2
ffffffffc0203a5a:	3c268693          	addi	a3,a3,962 # ffffffffc0205e18 <default_pmm_manager+0xc78>
ffffffffc0203a5e:	00001617          	auipc	a2,0x1
ffffffffc0203a62:	39260613          	addi	a2,a2,914 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203a66:	0ee00593          	li	a1,238
ffffffffc0203a6a:	00002517          	auipc	a0,0x2
ffffffffc0203a6e:	26e50513          	addi	a0,a0,622 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203a72:	909fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0203a76:	00002697          	auipc	a3,0x2
ffffffffc0203a7a:	37268693          	addi	a3,a3,882 # ffffffffc0205de8 <default_pmm_manager+0xc48>
ffffffffc0203a7e:	00001617          	auipc	a2,0x1
ffffffffc0203a82:	37260613          	addi	a2,a2,882 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203a86:	0ed00593          	li	a1,237
ffffffffc0203a8a:	00002517          	auipc	a0,0x2
ffffffffc0203a8e:	24e50513          	addi	a0,a0,590 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203a92:	8e9fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203a96:	00002697          	auipc	a3,0x2
ffffffffc0203a9a:	2b268693          	addi	a3,a3,690 # ffffffffc0205d48 <default_pmm_manager+0xba8>
ffffffffc0203a9e:	00001617          	auipc	a2,0x1
ffffffffc0203aa2:	35260613          	addi	a2,a2,850 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203aa6:	0db00593          	li	a1,219
ffffffffc0203aaa:	00002517          	auipc	a0,0x2
ffffffffc0203aae:	22e50513          	addi	a0,a0,558 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203ab2:	8c9fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma1 != NULL);
ffffffffc0203ab6:	00002697          	auipc	a3,0x2
ffffffffc0203aba:	2e268693          	addi	a3,a3,738 # ffffffffc0205d98 <default_pmm_manager+0xbf8>
ffffffffc0203abe:	00001617          	auipc	a2,0x1
ffffffffc0203ac2:	33260613          	addi	a2,a2,818 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203ac6:	0e300593          	li	a1,227
ffffffffc0203aca:	00002517          	auipc	a0,0x2
ffffffffc0203ace:	20e50513          	addi	a0,a0,526 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203ad2:	8a9fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma2 != NULL);
ffffffffc0203ad6:	00002697          	auipc	a3,0x2
ffffffffc0203ada:	2d268693          	addi	a3,a3,722 # ffffffffc0205da8 <default_pmm_manager+0xc08>
ffffffffc0203ade:	00001617          	auipc	a2,0x1
ffffffffc0203ae2:	31260613          	addi	a2,a2,786 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203ae6:	0e500593          	li	a1,229
ffffffffc0203aea:	00002517          	auipc	a0,0x2
ffffffffc0203aee:	1ee50513          	addi	a0,a0,494 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203af2:	889fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma3 == NULL);
ffffffffc0203af6:	00002697          	auipc	a3,0x2
ffffffffc0203afa:	2c268693          	addi	a3,a3,706 # ffffffffc0205db8 <default_pmm_manager+0xc18>
ffffffffc0203afe:	00001617          	auipc	a2,0x1
ffffffffc0203b02:	2f260613          	addi	a2,a2,754 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203b06:	0e700593          	li	a1,231
ffffffffc0203b0a:	00002517          	auipc	a0,0x2
ffffffffc0203b0e:	1ce50513          	addi	a0,a0,462 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203b12:	869fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma4 == NULL);
ffffffffc0203b16:	00002697          	auipc	a3,0x2
ffffffffc0203b1a:	2b268693          	addi	a3,a3,690 # ffffffffc0205dc8 <default_pmm_manager+0xc28>
ffffffffc0203b1e:	00001617          	auipc	a2,0x1
ffffffffc0203b22:	2d260613          	addi	a2,a2,722 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203b26:	0e900593          	li	a1,233
ffffffffc0203b2a:	00002517          	auipc	a0,0x2
ffffffffc0203b2e:	1ae50513          	addi	a0,a0,430 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203b32:	849fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma5 == NULL);
ffffffffc0203b36:	00002697          	auipc	a3,0x2
ffffffffc0203b3a:	2a268693          	addi	a3,a3,674 # ffffffffc0205dd8 <default_pmm_manager+0xc38>
ffffffffc0203b3e:	00001617          	auipc	a2,0x1
ffffffffc0203b42:	2b260613          	addi	a2,a2,690 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203b46:	0eb00593          	li	a1,235
ffffffffc0203b4a:	00002517          	auipc	a0,0x2
ffffffffc0203b4e:	18e50513          	addi	a0,a0,398 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203b52:	829fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgdir[0] == 0);
ffffffffc0203b56:	00002697          	auipc	a3,0x2
ffffffffc0203b5a:	d6a68693          	addi	a3,a3,-662 # ffffffffc02058c0 <default_pmm_manager+0x720>
ffffffffc0203b5e:	00001617          	auipc	a2,0x1
ffffffffc0203b62:	29260613          	addi	a2,a2,658 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203b66:	10d00593          	li	a1,269
ffffffffc0203b6a:	00002517          	auipc	a0,0x2
ffffffffc0203b6e:	16e50513          	addi	a0,a0,366 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203b72:	809fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0203b76:	00002697          	auipc	a3,0x2
ffffffffc0203b7a:	3c268693          	addi	a3,a3,962 # ffffffffc0205f38 <default_pmm_manager+0xd98>
ffffffffc0203b7e:	00001617          	auipc	a2,0x1
ffffffffc0203b82:	27260613          	addi	a2,a2,626 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203b86:	10a00593          	li	a1,266
ffffffffc0203b8a:	00002517          	auipc	a0,0x2
ffffffffc0203b8e:	14e50513          	addi	a0,a0,334 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
    check_mm_struct = mm_create();
ffffffffc0203b92:	0000e797          	auipc	a5,0xe
ffffffffc0203b96:	9c07b723          	sd	zero,-1586(a5) # ffffffffc0211560 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc0203b9a:	fe0fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(vma != NULL);
ffffffffc0203b9e:	00002697          	auipc	a3,0x2
ffffffffc0203ba2:	d3268693          	addi	a3,a3,-718 # ffffffffc02058d0 <default_pmm_manager+0x730>
ffffffffc0203ba6:	00001617          	auipc	a2,0x1
ffffffffc0203baa:	24a60613          	addi	a2,a2,586 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203bae:	11100593          	li	a1,273
ffffffffc0203bb2:	00002517          	auipc	a0,0x2
ffffffffc0203bb6:	12650513          	addi	a0,a0,294 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203bba:	fc0fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0203bbe:	00002697          	auipc	a3,0x2
ffffffffc0203bc2:	31268693          	addi	a3,a3,786 # ffffffffc0205ed0 <default_pmm_manager+0xd30>
ffffffffc0203bc6:	00001617          	auipc	a2,0x1
ffffffffc0203bca:	22a60613          	addi	a2,a2,554 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203bce:	11600593          	li	a1,278
ffffffffc0203bd2:	00002517          	auipc	a0,0x2
ffffffffc0203bd6:	10650513          	addi	a0,a0,262 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203bda:	fa0fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(sum == 0);
ffffffffc0203bde:	00002697          	auipc	a3,0x2
ffffffffc0203be2:	31268693          	addi	a3,a3,786 # ffffffffc0205ef0 <default_pmm_manager+0xd50>
ffffffffc0203be6:	00001617          	auipc	a2,0x1
ffffffffc0203bea:	20a60613          	addi	a2,a2,522 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203bee:	12000593          	li	a1,288
ffffffffc0203bf2:	00002517          	auipc	a0,0x2
ffffffffc0203bf6:	0e650513          	addi	a0,a0,230 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203bfa:	f80fc0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203bfe:	00001617          	auipc	a2,0x1
ffffffffc0203c02:	5da60613          	addi	a2,a2,1498 # ffffffffc02051d8 <default_pmm_manager+0x38>
ffffffffc0203c06:	06500593          	li	a1,101
ffffffffc0203c0a:	00001517          	auipc	a0,0x1
ffffffffc0203c0e:	5ee50513          	addi	a0,a0,1518 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0203c12:	f68fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203c16:	00002697          	auipc	a3,0x2
ffffffffc0203c1a:	27268693          	addi	a3,a3,626 # ffffffffc0205e88 <default_pmm_manager+0xce8>
ffffffffc0203c1e:	00001617          	auipc	a2,0x1
ffffffffc0203c22:	1d260613          	addi	a2,a2,466 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203c26:	12e00593          	li	a1,302
ffffffffc0203c2a:	00002517          	auipc	a0,0x2
ffffffffc0203c2e:	0ae50513          	addi	a0,a0,174 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203c32:	f48fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203c36:	00002697          	auipc	a3,0x2
ffffffffc0203c3a:	25268693          	addi	a3,a3,594 # ffffffffc0205e88 <default_pmm_manager+0xce8>
ffffffffc0203c3e:	00001617          	auipc	a2,0x1
ffffffffc0203c42:	1b260613          	addi	a2,a2,434 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203c46:	0bd00593          	li	a1,189
ffffffffc0203c4a:	00002517          	auipc	a0,0x2
ffffffffc0203c4e:	08e50513          	addi	a0,a0,142 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203c52:	f28fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(mm != NULL);
ffffffffc0203c56:	00002697          	auipc	a3,0x2
ffffffffc0203c5a:	c4268693          	addi	a3,a3,-958 # ffffffffc0205898 <default_pmm_manager+0x6f8>
ffffffffc0203c5e:	00001617          	auipc	a2,0x1
ffffffffc0203c62:	19260613          	addi	a2,a2,402 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203c66:	0c700593          	li	a1,199
ffffffffc0203c6a:	00002517          	auipc	a0,0x2
ffffffffc0203c6e:	06e50513          	addi	a0,a0,110 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203c72:	f08fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203c76:	00002697          	auipc	a3,0x2
ffffffffc0203c7a:	21268693          	addi	a3,a3,530 # ffffffffc0205e88 <default_pmm_manager+0xce8>
ffffffffc0203c7e:	00001617          	auipc	a2,0x1
ffffffffc0203c82:	17260613          	addi	a2,a2,370 # ffffffffc0204df0 <commands+0x780>
ffffffffc0203c86:	0fb00593          	li	a1,251
ffffffffc0203c8a:	00002517          	auipc	a0,0x2
ffffffffc0203c8e:	04e50513          	addi	a0,a0,78 # ffffffffc0205cd8 <default_pmm_manager+0xb38>
ffffffffc0203c92:	ee8fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203c96 <do_pgfault>:
=======
ffffffffc02039ca:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc02039cc:	0000e797          	auipc	a5,0xe
ffffffffc02039d0:	b807ba23          	sd	zero,-1132(a5) # ffffffffc0211560 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02039d4:	ceffd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
ffffffffc02039d8:	22a49063          	bne	s1,a0,ffffffffc0203bf8 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc02039dc:	00002517          	auipc	a0,0x2
ffffffffc02039e0:	4fc50513          	addi	a0,a0,1276 # ffffffffc0205ed8 <default_pmm_manager+0xd50>
ffffffffc02039e4:	edcfc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02039e8:	cdbfd0ef          	jal	ra,ffffffffc02016c2 <nr_free_pages>
    nr_free_pages_store--;	// szx : Sv39三级页表多占一个内存页，所以执行此操作
ffffffffc02039ec:	19fd                	addi	s3,s3,-1
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02039ee:	22a99563          	bne	s3,a0,ffffffffc0203c18 <vmm_init+0x578>
}
ffffffffc02039f2:	6406                	ld	s0,64(sp)
ffffffffc02039f4:	60a6                	ld	ra,72(sp)
ffffffffc02039f6:	74e2                	ld	s1,56(sp)
ffffffffc02039f8:	7942                	ld	s2,48(sp)
ffffffffc02039fa:	79a2                	ld	s3,40(sp)
ffffffffc02039fc:	7a02                	ld	s4,32(sp)
ffffffffc02039fe:	6ae2                	ld	s5,24(sp)
ffffffffc0203a00:	6b42                	ld	s6,16(sp)
ffffffffc0203a02:	6ba2                	ld	s7,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a04:	00002517          	auipc	a0,0x2
ffffffffc0203a08:	4f450513          	addi	a0,a0,1268 # ffffffffc0205ef8 <default_pmm_manager+0xd70>
}
ffffffffc0203a0c:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203a0e:	eb2fc06f          	j	ffffffffc02000c0 <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203a12:	da2ff0ef          	jal	ra,ffffffffc0202fb4 <swap_init_mm>
ffffffffc0203a16:	b5d1                	j	ffffffffc02038da <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203a18:	00002697          	auipc	a3,0x2
ffffffffc0203a1c:	32068693          	addi	a3,a3,800 # ffffffffc0205d38 <default_pmm_manager+0xbb0>
ffffffffc0203a20:	00001617          	auipc	a2,0x1
ffffffffc0203a24:	3b860613          	addi	a2,a2,952 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203a28:	0dd00593          	li	a1,221
ffffffffc0203a2c:	00002517          	auipc	a0,0x2
ffffffffc0203a30:	28450513          	addi	a0,a0,644 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203a34:	947fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0203a38:	00002697          	auipc	a3,0x2
ffffffffc0203a3c:	3b868693          	addi	a3,a3,952 # ffffffffc0205df0 <default_pmm_manager+0xc68>
ffffffffc0203a40:	00001617          	auipc	a2,0x1
ffffffffc0203a44:	39860613          	addi	a2,a2,920 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203a48:	0ee00593          	li	a1,238
ffffffffc0203a4c:	00002517          	auipc	a0,0x2
ffffffffc0203a50:	26450513          	addi	a0,a0,612 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203a54:	927fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0203a58:	00002697          	auipc	a3,0x2
ffffffffc0203a5c:	36868693          	addi	a3,a3,872 # ffffffffc0205dc0 <default_pmm_manager+0xc38>
ffffffffc0203a60:	00001617          	auipc	a2,0x1
ffffffffc0203a64:	37860613          	addi	a2,a2,888 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203a68:	0ed00593          	li	a1,237
ffffffffc0203a6c:	00002517          	auipc	a0,0x2
ffffffffc0203a70:	24450513          	addi	a0,a0,580 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203a74:	907fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203a78:	00002697          	auipc	a3,0x2
ffffffffc0203a7c:	2a868693          	addi	a3,a3,680 # ffffffffc0205d20 <default_pmm_manager+0xb98>
ffffffffc0203a80:	00001617          	auipc	a2,0x1
ffffffffc0203a84:	35860613          	addi	a2,a2,856 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203a88:	0db00593          	li	a1,219
ffffffffc0203a8c:	00002517          	auipc	a0,0x2
ffffffffc0203a90:	22450513          	addi	a0,a0,548 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203a94:	8e7fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma1 != NULL);
ffffffffc0203a98:	00002697          	auipc	a3,0x2
ffffffffc0203a9c:	2d868693          	addi	a3,a3,728 # ffffffffc0205d70 <default_pmm_manager+0xbe8>
ffffffffc0203aa0:	00001617          	auipc	a2,0x1
ffffffffc0203aa4:	33860613          	addi	a2,a2,824 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203aa8:	0e300593          	li	a1,227
ffffffffc0203aac:	00002517          	auipc	a0,0x2
ffffffffc0203ab0:	20450513          	addi	a0,a0,516 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203ab4:	8c7fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma2 != NULL);
ffffffffc0203ab8:	00002697          	auipc	a3,0x2
ffffffffc0203abc:	2c868693          	addi	a3,a3,712 # ffffffffc0205d80 <default_pmm_manager+0xbf8>
ffffffffc0203ac0:	00001617          	auipc	a2,0x1
ffffffffc0203ac4:	31860613          	addi	a2,a2,792 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203ac8:	0e500593          	li	a1,229
ffffffffc0203acc:	00002517          	auipc	a0,0x2
ffffffffc0203ad0:	1e450513          	addi	a0,a0,484 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203ad4:	8a7fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma3 == NULL);
ffffffffc0203ad8:	00002697          	auipc	a3,0x2
ffffffffc0203adc:	2b868693          	addi	a3,a3,696 # ffffffffc0205d90 <default_pmm_manager+0xc08>
ffffffffc0203ae0:	00001617          	auipc	a2,0x1
ffffffffc0203ae4:	2f860613          	addi	a2,a2,760 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203ae8:	0e700593          	li	a1,231
ffffffffc0203aec:	00002517          	auipc	a0,0x2
ffffffffc0203af0:	1c450513          	addi	a0,a0,452 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203af4:	887fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma4 == NULL);
ffffffffc0203af8:	00002697          	auipc	a3,0x2
ffffffffc0203afc:	2a868693          	addi	a3,a3,680 # ffffffffc0205da0 <default_pmm_manager+0xc18>
ffffffffc0203b00:	00001617          	auipc	a2,0x1
ffffffffc0203b04:	2d860613          	addi	a2,a2,728 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203b08:	0e900593          	li	a1,233
ffffffffc0203b0c:	00002517          	auipc	a0,0x2
ffffffffc0203b10:	1a450513          	addi	a0,a0,420 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203b14:	867fc0ef          	jal	ra,ffffffffc020037a <__panic>
        assert(vma5 == NULL);
ffffffffc0203b18:	00002697          	auipc	a3,0x2
ffffffffc0203b1c:	29868693          	addi	a3,a3,664 # ffffffffc0205db0 <default_pmm_manager+0xc28>
ffffffffc0203b20:	00001617          	auipc	a2,0x1
ffffffffc0203b24:	2b860613          	addi	a2,a2,696 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203b28:	0eb00593          	li	a1,235
ffffffffc0203b2c:	00002517          	auipc	a0,0x2
ffffffffc0203b30:	18450513          	addi	a0,a0,388 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203b34:	847fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(pgdir[0] == 0);
ffffffffc0203b38:	00002697          	auipc	a3,0x2
ffffffffc0203b3c:	d7068693          	addi	a3,a3,-656 # ffffffffc02058a8 <default_pmm_manager+0x720>
ffffffffc0203b40:	00001617          	auipc	a2,0x1
ffffffffc0203b44:	29860613          	addi	a2,a2,664 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203b48:	10d00593          	li	a1,269
ffffffffc0203b4c:	00002517          	auipc	a0,0x2
ffffffffc0203b50:	16450513          	addi	a0,a0,356 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203b54:	827fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0203b58:	00002697          	auipc	a3,0x2
ffffffffc0203b5c:	3b868693          	addi	a3,a3,952 # ffffffffc0205f10 <default_pmm_manager+0xd88>
ffffffffc0203b60:	00001617          	auipc	a2,0x1
ffffffffc0203b64:	27860613          	addi	a2,a2,632 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203b68:	10a00593          	li	a1,266
ffffffffc0203b6c:	00002517          	auipc	a0,0x2
ffffffffc0203b70:	14450513          	addi	a0,a0,324 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
    check_mm_struct = mm_create();
ffffffffc0203b74:	0000e797          	auipc	a5,0xe
ffffffffc0203b78:	9e07b623          	sd	zero,-1556(a5) # ffffffffc0211560 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc0203b7c:	ffefc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(vma != NULL);
ffffffffc0203b80:	00002697          	auipc	a3,0x2
ffffffffc0203b84:	d3868693          	addi	a3,a3,-712 # ffffffffc02058b8 <default_pmm_manager+0x730>
ffffffffc0203b88:	00001617          	auipc	a2,0x1
ffffffffc0203b8c:	25060613          	addi	a2,a2,592 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203b90:	11100593          	li	a1,273
ffffffffc0203b94:	00002517          	auipc	a0,0x2
ffffffffc0203b98:	11c50513          	addi	a0,a0,284 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203b9c:	fdefc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0203ba0:	00002697          	auipc	a3,0x2
ffffffffc0203ba4:	30868693          	addi	a3,a3,776 # ffffffffc0205ea8 <default_pmm_manager+0xd20>
ffffffffc0203ba8:	00001617          	auipc	a2,0x1
ffffffffc0203bac:	23060613          	addi	a2,a2,560 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203bb0:	11600593          	li	a1,278
ffffffffc0203bb4:	00002517          	auipc	a0,0x2
ffffffffc0203bb8:	0fc50513          	addi	a0,a0,252 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203bbc:	fbefc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(sum == 0);
ffffffffc0203bc0:	00002697          	auipc	a3,0x2
ffffffffc0203bc4:	30868693          	addi	a3,a3,776 # ffffffffc0205ec8 <default_pmm_manager+0xd40>
ffffffffc0203bc8:	00001617          	auipc	a2,0x1
ffffffffc0203bcc:	21060613          	addi	a2,a2,528 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203bd0:	12000593          	li	a1,288
ffffffffc0203bd4:	00002517          	auipc	a0,0x2
ffffffffc0203bd8:	0dc50513          	addi	a0,a0,220 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203bdc:	f9efc0ef          	jal	ra,ffffffffc020037a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203be0:	00001617          	auipc	a2,0x1
ffffffffc0203be4:	5e060613          	addi	a2,a2,1504 # ffffffffc02051c0 <default_pmm_manager+0x38>
ffffffffc0203be8:	06500593          	li	a1,101
ffffffffc0203bec:	00001517          	auipc	a0,0x1
ffffffffc0203bf0:	5f450513          	addi	a0,a0,1524 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0203bf4:	f86fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203bf8:	00002697          	auipc	a3,0x2
ffffffffc0203bfc:	26868693          	addi	a3,a3,616 # ffffffffc0205e60 <default_pmm_manager+0xcd8>
ffffffffc0203c00:	00001617          	auipc	a2,0x1
ffffffffc0203c04:	1d860613          	addi	a2,a2,472 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203c08:	12e00593          	li	a1,302
ffffffffc0203c0c:	00002517          	auipc	a0,0x2
ffffffffc0203c10:	0a450513          	addi	a0,a0,164 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203c14:	f66fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203c18:	00002697          	auipc	a3,0x2
ffffffffc0203c1c:	24868693          	addi	a3,a3,584 # ffffffffc0205e60 <default_pmm_manager+0xcd8>
ffffffffc0203c20:	00001617          	auipc	a2,0x1
ffffffffc0203c24:	1b860613          	addi	a2,a2,440 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203c28:	0bd00593          	li	a1,189
ffffffffc0203c2c:	00002517          	auipc	a0,0x2
ffffffffc0203c30:	08450513          	addi	a0,a0,132 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203c34:	f46fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(mm != NULL);
ffffffffc0203c38:	00002697          	auipc	a3,0x2
ffffffffc0203c3c:	c4868693          	addi	a3,a3,-952 # ffffffffc0205880 <default_pmm_manager+0x6f8>
ffffffffc0203c40:	00001617          	auipc	a2,0x1
ffffffffc0203c44:	19860613          	addi	a2,a2,408 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203c48:	0c700593          	li	a1,199
ffffffffc0203c4c:	00002517          	auipc	a0,0x2
ffffffffc0203c50:	06450513          	addi	a0,a0,100 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203c54:	f26fc0ef          	jal	ra,ffffffffc020037a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203c58:	00002697          	auipc	a3,0x2
ffffffffc0203c5c:	20868693          	addi	a3,a3,520 # ffffffffc0205e60 <default_pmm_manager+0xcd8>
ffffffffc0203c60:	00001617          	auipc	a2,0x1
ffffffffc0203c64:	17860613          	addi	a2,a2,376 # ffffffffc0204dd8 <commands+0x780>
ffffffffc0203c68:	0fb00593          	li	a1,251
ffffffffc0203c6c:	00002517          	auipc	a0,0x2
ffffffffc0203c70:	04450513          	addi	a0,a0,68 # ffffffffc0205cb0 <default_pmm_manager+0xb28>
ffffffffc0203c74:	f06fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203c78 <do_pgfault>:
>>>>>>> 747620b (lab2)
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
<<<<<<< HEAD
ffffffffc0203c96:	7179                	addi	sp,sp,-48
=======
ffffffffc0203c78:	7179                	addi	sp,sp,-48
>>>>>>> 747620b (lab2)
    int ret = -E_INVAL;
    //try to find a vma which include addr
    // 在mm中，找到包含addr的vma
    struct vma_struct *vma = find_vma(mm, addr);
<<<<<<< HEAD
ffffffffc0203c98:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0203c9a:	f022                	sd	s0,32(sp)
ffffffffc0203c9c:	ec26                	sd	s1,24(sp)
ffffffffc0203c9e:	f406                	sd	ra,40(sp)
ffffffffc0203ca0:	e84a                	sd	s2,16(sp)
ffffffffc0203ca2:	8432                	mv	s0,a2
ffffffffc0203ca4:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203ca6:	8d3ff0ef          	jal	ra,ffffffffc0203578 <find_vma>

    pgfault_num++;  // 增加故障页面计数
ffffffffc0203caa:	0000e797          	auipc	a5,0xe
ffffffffc0203cae:	8be7a783          	lw	a5,-1858(a5) # ffffffffc0211568 <pgfault_num>
ffffffffc0203cb2:	2785                	addiw	a5,a5,1
ffffffffc0203cb4:	0000e717          	auipc	a4,0xe
ffffffffc0203cb8:	8af72a23          	sw	a5,-1868(a4) # ffffffffc0211568 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {  // 检查addr是否在vma范围内
ffffffffc0203cbc:	c159                	beqz	a0,ffffffffc0203d42 <do_pgfault+0xac>
ffffffffc0203cbe:	651c                	ld	a5,8(a0)
ffffffffc0203cc0:	08f46163          	bltu	s0,a5,ffffffffc0203d42 <do_pgfault+0xac>
=======
ffffffffc0203c7a:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0203c7c:	f022                	sd	s0,32(sp)
ffffffffc0203c7e:	ec26                	sd	s1,24(sp)
ffffffffc0203c80:	f406                	sd	ra,40(sp)
ffffffffc0203c82:	e84a                	sd	s2,16(sp)
ffffffffc0203c84:	8432                	mv	s0,a2
ffffffffc0203c86:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203c88:	8d3ff0ef          	jal	ra,ffffffffc020355a <find_vma>

    pgfault_num++;  // 增加故障页面计数
ffffffffc0203c8c:	0000e797          	auipc	a5,0xe
ffffffffc0203c90:	8dc7a783          	lw	a5,-1828(a5) # ffffffffc0211568 <pgfault_num>
ffffffffc0203c94:	2785                	addiw	a5,a5,1
ffffffffc0203c96:	0000e717          	auipc	a4,0xe
ffffffffc0203c9a:	8cf72923          	sw	a5,-1838(a4) # ffffffffc0211568 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {  // 检查addr是否在vma范围内
ffffffffc0203c9e:	c159                	beqz	a0,ffffffffc0203d24 <do_pgfault+0xac>
ffffffffc0203ca0:	651c                	ld	a5,8(a0)
ffffffffc0203ca2:	08f46163          	bltu	s0,a5,ffffffffc0203d24 <do_pgfault+0xac>
>>>>>>> 747620b (lab2)
     * THEN
     *    continue process
     */
    // 确定权限
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) { // vm_flags: 权限位，
<<<<<<< HEAD
ffffffffc0203cc4:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0203cc6:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) { // vm_flags: 权限位，
ffffffffc0203cc8:	8b89                	andi	a5,a5,2
ffffffffc0203cca:	ebb1                	bnez	a5,ffffffffc0203d1e <do_pgfault+0x88>
=======
ffffffffc0203ca6:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0203ca8:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) { // vm_flags: 权限位，
ffffffffc0203caa:	8b89                	andi	a5,a5,2
ffffffffc0203cac:	ebb1                	bnez	a5,ffffffffc0203d00 <do_pgfault+0x88>
>>>>>>> 747620b (lab2)
        // If vma->vm_flags & VM_WRITE == 1/0, then the vma is writable/non writable
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);
<<<<<<< HEAD
ffffffffc0203ccc:	75fd                	lui	a1,0xfffff
=======
ffffffffc0203cae:	75fd                	lui	a1,0xfffff
>>>>>>> 747620b (lab2)
    *
    */

   // 从mm的页目录里获取页表项，返回一个pte_t的指针，页表项用于与物理地址的映射
   // 三个参数为：指向我想查找的页表的指针，我想查找的虚拟地址，是否要创建
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
<<<<<<< HEAD
ffffffffc0203cce:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203cd0:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0203cd2:	85a2                	mv	a1,s0
ffffffffc0203cd4:	4605                	li	a2,1
ffffffffc0203cd6:	a27fd0ef          	jal	ra,ffffffffc02016fc <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {   // 没有找到页表项
ffffffffc0203cda:	610c                	ld	a1,0(a0)
ffffffffc0203cdc:	c1b9                	beqz	a1,ffffffffc0203d22 <do_pgfault+0x8c>
=======
ffffffffc0203cb0:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203cb2:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0203cb4:	85a2                	mv	a1,s0
ffffffffc0203cb6:	4605                	li	a2,1
ffffffffc0203cb8:	a45fd0ef          	jal	ra,ffffffffc02016fc <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {   // 没有找到页表项
ffffffffc0203cbc:	610c                	ld	a1,0(a0)
ffffffffc0203cbe:	c1b9                	beqz	a1,ffffffffc0203d04 <do_pgfault+0x8c>
>>>>>>> 747620b (lab2)
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
<<<<<<< HEAD
ffffffffc0203cde:	0000e797          	auipc	a5,0xe
ffffffffc0203ce2:	8727a783          	lw	a5,-1934(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0203ce6:	c7bd                	beqz	a5,ffffffffc0203d54 <do_pgfault+0xbe>
=======
ffffffffc0203cc0:	0000e797          	auipc	a5,0xe
ffffffffc0203cc4:	8907a783          	lw	a5,-1904(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0203cc8:	c7bd                	beqz	a5,ffffffffc0203d36 <do_pgfault+0xbe>
>>>>>>> 747620b (lab2)
            struct Page *page = NULL;
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            swap_in(mm, addr, &page);
<<<<<<< HEAD
ffffffffc0203ce8:	85a2                	mv	a1,s0
ffffffffc0203cea:	0030                	addi	a2,sp,8
ffffffffc0203cec:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0203cee:	e402                	sd	zero,8(sp)
            swap_in(mm, addr, &page);
ffffffffc0203cf0:	bf0ff0ef          	jal	ra,ffffffffc02030e0 <swap_in>
=======
ffffffffc0203cca:	85a2                	mv	a1,s0
ffffffffc0203ccc:	0030                	addi	a2,sp,8
ffffffffc0203cce:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0203cd0:	e402                	sd	zero,8(sp)
            swap_in(mm, addr, &page);
ffffffffc0203cd2:	c0eff0ef          	jal	ra,ffffffffc02030e0 <swap_in>
>>>>>>> 747620b (lab2)
            
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            page_insert(mm->pgdir, page, addr, perm);
<<<<<<< HEAD
ffffffffc0203cf4:	65a2                	ld	a1,8(sp)
ffffffffc0203cf6:	6c88                	ld	a0,24(s1)
ffffffffc0203cf8:	86ca                	mv	a3,s2
ffffffffc0203cfa:	8622                	mv	a2,s0
ffffffffc0203cfc:	cebfd0ef          	jal	ra,ffffffffc02019e6 <page_insert>

            //(3) make the page swappable. 换入后的初始化
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0203d00:	6622                	ld	a2,8(sp)
ffffffffc0203d02:	4685                	li	a3,1
ffffffffc0203d04:	85a2                	mv	a1,s0
ffffffffc0203d06:	8526                	mv	a0,s1
ffffffffc0203d08:	ab8ff0ef          	jal	ra,ffffffffc0202fc0 <swap_map_swappable>

            page->pra_vaddr = addr;
ffffffffc0203d0c:	67a2                	ld	a5,8(sp)
=======
ffffffffc0203cd6:	65a2                	ld	a1,8(sp)
ffffffffc0203cd8:	6c88                	ld	a0,24(s1)
ffffffffc0203cda:	86ca                	mv	a3,s2
ffffffffc0203cdc:	8622                	mv	a2,s0
ffffffffc0203cde:	d09fd0ef          	jal	ra,ffffffffc02019e6 <page_insert>

            //(3) make the page swappable. 换入后的初始化
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0203ce2:	6622                	ld	a2,8(sp)
ffffffffc0203ce4:	4685                	li	a3,1
ffffffffc0203ce6:	85a2                	mv	a1,s0
ffffffffc0203ce8:	8526                	mv	a0,s1
ffffffffc0203cea:	ad6ff0ef          	jal	ra,ffffffffc0202fc0 <swap_map_swappable>

            page->pra_vaddr = addr;
ffffffffc0203cee:	67a2                	ld	a5,8(sp)
>>>>>>> 747620b (lab2)
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
            goto failed;
        }
   }

   ret = 0;
<<<<<<< HEAD
ffffffffc0203d0e:	4501                	li	a0,0
            page->pra_vaddr = addr;
ffffffffc0203d10:	e3a0                	sd	s0,64(a5)
failed:
    return ret;
}
ffffffffc0203d12:	70a2                	ld	ra,40(sp)
ffffffffc0203d14:	7402                	ld	s0,32(sp)
ffffffffc0203d16:	64e2                	ld	s1,24(sp)
ffffffffc0203d18:	6942                	ld	s2,16(sp)
ffffffffc0203d1a:	6145                	addi	sp,sp,48
ffffffffc0203d1c:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc0203d1e:	4959                	li	s2,22
ffffffffc0203d20:	b775                	j	ffffffffc0203ccc <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203d22:	6c88                	ld	a0,24(s1)
ffffffffc0203d24:	864a                	mv	a2,s2
ffffffffc0203d26:	85a2                	mv	a1,s0
ffffffffc0203d28:	9c9fe0ef          	jal	ra,ffffffffc02026f0 <pgdir_alloc_page>
ffffffffc0203d2c:	87aa                	mv	a5,a0
   ret = 0;
ffffffffc0203d2e:	4501                	li	a0,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203d30:	f3ed                	bnez	a5,ffffffffc0203d12 <do_pgfault+0x7c>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0203d32:	00002517          	auipc	a0,0x2
ffffffffc0203d36:	24e50513          	addi	a0,a0,590 # ffffffffc0205f80 <default_pmm_manager+0xde0>
ffffffffc0203d3a:	b86fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203d3e:	5571                	li	a0,-4
            goto failed;
ffffffffc0203d40:	bfc9                	j	ffffffffc0203d12 <do_pgfault+0x7c>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0203d42:	85a2                	mv	a1,s0
ffffffffc0203d44:	00002517          	auipc	a0,0x2
ffffffffc0203d48:	20c50513          	addi	a0,a0,524 # ffffffffc0205f50 <default_pmm_manager+0xdb0>
ffffffffc0203d4c:	b74fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203d50:	5575                	li	a0,-3
        goto failed;
ffffffffc0203d52:	b7c1                	j	ffffffffc0203d12 <do_pgfault+0x7c>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc0203d54:	00002517          	auipc	a0,0x2
ffffffffc0203d58:	25450513          	addi	a0,a0,596 # ffffffffc0205fa8 <default_pmm_manager+0xe08>
ffffffffc0203d5c:	b64fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203d60:	5571                	li	a0,-4
            goto failed;
ffffffffc0203d62:	bf45                	j	ffffffffc0203d12 <do_pgfault+0x7c>

ffffffffc0203d64 <swapfs_init>:
=======
ffffffffc0203cf0:	4501                	li	a0,0
            page->pra_vaddr = addr;
ffffffffc0203cf2:	e3a0                	sd	s0,64(a5)
failed:
    return ret;
}
ffffffffc0203cf4:	70a2                	ld	ra,40(sp)
ffffffffc0203cf6:	7402                	ld	s0,32(sp)
ffffffffc0203cf8:	64e2                	ld	s1,24(sp)
ffffffffc0203cfa:	6942                	ld	s2,16(sp)
ffffffffc0203cfc:	6145                	addi	sp,sp,48
ffffffffc0203cfe:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc0203d00:	4959                	li	s2,22
ffffffffc0203d02:	b775                	j	ffffffffc0203cae <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203d04:	6c88                	ld	a0,24(s1)
ffffffffc0203d06:	864a                	mv	a2,s2
ffffffffc0203d08:	85a2                	mv	a1,s0
ffffffffc0203d0a:	9e7fe0ef          	jal	ra,ffffffffc02026f0 <pgdir_alloc_page>
ffffffffc0203d0e:	87aa                	mv	a5,a0
   ret = 0;
ffffffffc0203d10:	4501                	li	a0,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203d12:	f3ed                	bnez	a5,ffffffffc0203cf4 <do_pgfault+0x7c>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0203d14:	00002517          	auipc	a0,0x2
ffffffffc0203d18:	24450513          	addi	a0,a0,580 # ffffffffc0205f58 <default_pmm_manager+0xdd0>
ffffffffc0203d1c:	ba4fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203d20:	5571                	li	a0,-4
            goto failed;
ffffffffc0203d22:	bfc9                	j	ffffffffc0203cf4 <do_pgfault+0x7c>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0203d24:	85a2                	mv	a1,s0
ffffffffc0203d26:	00002517          	auipc	a0,0x2
ffffffffc0203d2a:	20250513          	addi	a0,a0,514 # ffffffffc0205f28 <default_pmm_manager+0xda0>
ffffffffc0203d2e:	b92fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203d32:	5575                	li	a0,-3
        goto failed;
ffffffffc0203d34:	b7c1                	j	ffffffffc0203cf4 <do_pgfault+0x7c>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc0203d36:	00002517          	auipc	a0,0x2
ffffffffc0203d3a:	24a50513          	addi	a0,a0,586 # ffffffffc0205f80 <default_pmm_manager+0xdf8>
ffffffffc0203d3e:	b82fc0ef          	jal	ra,ffffffffc02000c0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203d42:	5571                	li	a0,-4
            goto failed;
ffffffffc0203d44:	bf45                	j	ffffffffc0203cf4 <do_pgfault+0x7c>

ffffffffc0203d46 <swapfs_init>:
>>>>>>> 747620b (lab2)
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
<<<<<<< HEAD
ffffffffc0203d64:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d66:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203d68:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d6a:	f30fc0ef          	jal	ra,ffffffffc020049a <ide_device_valid>
ffffffffc0203d6e:	cd01                	beqz	a0,ffffffffc0203d86 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d70:	4505                	li	a0,1
ffffffffc0203d72:	f2efc0ef          	jal	ra,ffffffffc02004a0 <ide_device_size>
}
ffffffffc0203d76:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d78:	810d                	srli	a0,a0,0x3
ffffffffc0203d7a:	0000d797          	auipc	a5,0xd
ffffffffc0203d7e:	7ca7b323          	sd	a0,1990(a5) # ffffffffc0211540 <max_swap_offset>
}
ffffffffc0203d82:	0141                	addi	sp,sp,16
ffffffffc0203d84:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203d86:	00002617          	auipc	a2,0x2
ffffffffc0203d8a:	24a60613          	addi	a2,a2,586 # ffffffffc0205fd0 <default_pmm_manager+0xe30>
ffffffffc0203d8e:	45b5                	li	a1,13
ffffffffc0203d90:	00002517          	auipc	a0,0x2
ffffffffc0203d94:	26050513          	addi	a0,a0,608 # ffffffffc0205ff0 <default_pmm_manager+0xe50>
ffffffffc0203d98:	de2fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203d9c <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203d9c:	1141                	addi	sp,sp,-16
ffffffffc0203d9e:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203da0:	00855793          	srli	a5,a0,0x8
ffffffffc0203da4:	c3a5                	beqz	a5,ffffffffc0203e04 <swapfs_read+0x68>
ffffffffc0203da6:	0000d717          	auipc	a4,0xd
ffffffffc0203daa:	79a73703          	ld	a4,1946(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc0203dae:	04e7fb63          	bgeu	a5,a4,ffffffffc0203e04 <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203db2:	0000d617          	auipc	a2,0xd
ffffffffc0203db6:	77663603          	ld	a2,1910(a2) # ffffffffc0211528 <pages>
ffffffffc0203dba:	8d91                	sub	a1,a1,a2
ffffffffc0203dbc:	4035d613          	srai	a2,a1,0x3
ffffffffc0203dc0:	00002597          	auipc	a1,0x2
ffffffffc0203dc4:	4b05b583          	ld	a1,1200(a1) # ffffffffc0206270 <error_string+0x38>
ffffffffc0203dc8:	02b60633          	mul	a2,a2,a1
ffffffffc0203dcc:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203dd0:	00002797          	auipc	a5,0x2
ffffffffc0203dd4:	4a87b783          	ld	a5,1192(a5) # ffffffffc0206278 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dd8:	0000d717          	auipc	a4,0xd
ffffffffc0203ddc:	74873703          	ld	a4,1864(a4) # ffffffffc0211520 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203de0:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203de2:	00c61793          	slli	a5,a2,0xc
ffffffffc0203de6:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203de8:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dea:	02e7f963          	bgeu	a5,a4,ffffffffc0203e1c <swapfs_read+0x80>
}
ffffffffc0203dee:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203df0:	0000d797          	auipc	a5,0xd
ffffffffc0203df4:	7487b783          	ld	a5,1864(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0203df8:	46a1                	li	a3,8
ffffffffc0203dfa:	963e                	add	a2,a2,a5
ffffffffc0203dfc:	4505                	li	a0,1
}
ffffffffc0203dfe:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e00:	ea6fc06f          	j	ffffffffc02004a6 <ide_read_secs>
ffffffffc0203e04:	86aa                	mv	a3,a0
ffffffffc0203e06:	00002617          	auipc	a2,0x2
ffffffffc0203e0a:	20260613          	addi	a2,a2,514 # ffffffffc0206008 <default_pmm_manager+0xe68>
ffffffffc0203e0e:	45d1                	li	a1,20
ffffffffc0203e10:	00002517          	auipc	a0,0x2
ffffffffc0203e14:	1e050513          	addi	a0,a0,480 # ffffffffc0205ff0 <default_pmm_manager+0xe50>
ffffffffc0203e18:	d62fc0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0203e1c:	86b2                	mv	a3,a2
ffffffffc0203e1e:	06a00593          	li	a1,106
ffffffffc0203e22:	00001617          	auipc	a2,0x1
ffffffffc0203e26:	40e60613          	addi	a2,a2,1038 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0203e2a:	00001517          	auipc	a0,0x1
ffffffffc0203e2e:	3ce50513          	addi	a0,a0,974 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0203e32:	d48fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203e36 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203e36:	1141                	addi	sp,sp,-16
ffffffffc0203e38:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e3a:	00855793          	srli	a5,a0,0x8
ffffffffc0203e3e:	c3a5                	beqz	a5,ffffffffc0203e9e <swapfs_write+0x68>
ffffffffc0203e40:	0000d717          	auipc	a4,0xd
ffffffffc0203e44:	70073703          	ld	a4,1792(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc0203e48:	04e7fb63          	bgeu	a5,a4,ffffffffc0203e9e <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e4c:	0000d617          	auipc	a2,0xd
ffffffffc0203e50:	6dc63603          	ld	a2,1756(a2) # ffffffffc0211528 <pages>
ffffffffc0203e54:	8d91                	sub	a1,a1,a2
ffffffffc0203e56:	4035d613          	srai	a2,a1,0x3
ffffffffc0203e5a:	00002597          	auipc	a1,0x2
ffffffffc0203e5e:	4165b583          	ld	a1,1046(a1) # ffffffffc0206270 <error_string+0x38>
ffffffffc0203e62:	02b60633          	mul	a2,a2,a1
ffffffffc0203e66:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203e6a:	00002797          	auipc	a5,0x2
ffffffffc0203e6e:	40e7b783          	ld	a5,1038(a5) # ffffffffc0206278 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e72:	0000d717          	auipc	a4,0xd
ffffffffc0203e76:	6ae73703          	ld	a4,1710(a4) # ffffffffc0211520 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e7a:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e7c:	00c61793          	slli	a5,a2,0xc
ffffffffc0203e80:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203e82:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e84:	02e7f963          	bgeu	a5,a4,ffffffffc0203eb6 <swapfs_write+0x80>
}
ffffffffc0203e88:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e8a:	0000d797          	auipc	a5,0xd
ffffffffc0203e8e:	6ae7b783          	ld	a5,1710(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0203e92:	46a1                	li	a3,8
ffffffffc0203e94:	963e                	add	a2,a2,a5
ffffffffc0203e96:	4505                	li	a0,1
}
ffffffffc0203e98:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e9a:	e30fc06f          	j	ffffffffc02004ca <ide_write_secs>
ffffffffc0203e9e:	86aa                	mv	a3,a0
ffffffffc0203ea0:	00002617          	auipc	a2,0x2
ffffffffc0203ea4:	16860613          	addi	a2,a2,360 # ffffffffc0206008 <default_pmm_manager+0xe68>
ffffffffc0203ea8:	45e5                	li	a1,25
ffffffffc0203eaa:	00002517          	auipc	a0,0x2
ffffffffc0203eae:	14650513          	addi	a0,a0,326 # ffffffffc0205ff0 <default_pmm_manager+0xe50>
ffffffffc0203eb2:	cc8fc0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0203eb6:	86b2                	mv	a3,a2
ffffffffc0203eb8:	06a00593          	li	a1,106
ffffffffc0203ebc:	00001617          	auipc	a2,0x1
ffffffffc0203ec0:	37460613          	addi	a2,a2,884 # ffffffffc0205230 <default_pmm_manager+0x90>
ffffffffc0203ec4:	00001517          	auipc	a0,0x1
ffffffffc0203ec8:	33450513          	addi	a0,a0,820 # ffffffffc02051f8 <default_pmm_manager+0x58>
ffffffffc0203ecc:	caefc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203ed0 <printnum>:
=======
ffffffffc0203d46:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d48:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203d4a:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d4c:	f4efc0ef          	jal	ra,ffffffffc020049a <ide_device_valid>
ffffffffc0203d50:	cd01                	beqz	a0,ffffffffc0203d68 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d52:	4505                	li	a0,1
ffffffffc0203d54:	f4cfc0ef          	jal	ra,ffffffffc02004a0 <ide_device_size>
}
ffffffffc0203d58:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d5a:	810d                	srli	a0,a0,0x3
ffffffffc0203d5c:	0000d797          	auipc	a5,0xd
ffffffffc0203d60:	7ea7b223          	sd	a0,2020(a5) # ffffffffc0211540 <max_swap_offset>
}
ffffffffc0203d64:	0141                	addi	sp,sp,16
ffffffffc0203d66:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203d68:	00002617          	auipc	a2,0x2
ffffffffc0203d6c:	24060613          	addi	a2,a2,576 # ffffffffc0205fa8 <default_pmm_manager+0xe20>
ffffffffc0203d70:	45b5                	li	a1,13
ffffffffc0203d72:	00002517          	auipc	a0,0x2
ffffffffc0203d76:	25650513          	addi	a0,a0,598 # ffffffffc0205fc8 <default_pmm_manager+0xe40>
ffffffffc0203d7a:	e00fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203d7e <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203d7e:	1141                	addi	sp,sp,-16
ffffffffc0203d80:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203d82:	00855793          	srli	a5,a0,0x8
ffffffffc0203d86:	c3a5                	beqz	a5,ffffffffc0203de6 <swapfs_read+0x68>
ffffffffc0203d88:	0000d717          	auipc	a4,0xd
ffffffffc0203d8c:	7b873703          	ld	a4,1976(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc0203d90:	04e7fb63          	bgeu	a5,a4,ffffffffc0203de6 <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203d94:	0000d617          	auipc	a2,0xd
ffffffffc0203d98:	79463603          	ld	a2,1940(a2) # ffffffffc0211528 <pages>
ffffffffc0203d9c:	8d91                	sub	a1,a1,a2
ffffffffc0203d9e:	4035d613          	srai	a2,a1,0x3
ffffffffc0203da2:	00002597          	auipc	a1,0x2
ffffffffc0203da6:	4a65b583          	ld	a1,1190(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0203daa:	02b60633          	mul	a2,a2,a1
ffffffffc0203dae:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203db2:	00002797          	auipc	a5,0x2
ffffffffc0203db6:	49e7b783          	ld	a5,1182(a5) # ffffffffc0206250 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dba:	0000d717          	auipc	a4,0xd
ffffffffc0203dbe:	76673703          	ld	a4,1894(a4) # ffffffffc0211520 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203dc2:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dc4:	00c61793          	slli	a5,a2,0xc
ffffffffc0203dc8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203dca:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dcc:	02e7f963          	bgeu	a5,a4,ffffffffc0203dfe <swapfs_read+0x80>
}
ffffffffc0203dd0:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203dd2:	0000d797          	auipc	a5,0xd
ffffffffc0203dd6:	7667b783          	ld	a5,1894(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0203dda:	46a1                	li	a3,8
ffffffffc0203ddc:	963e                	add	a2,a2,a5
ffffffffc0203dde:	4505                	li	a0,1
}
ffffffffc0203de0:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203de2:	ec4fc06f          	j	ffffffffc02004a6 <ide_read_secs>
ffffffffc0203de6:	86aa                	mv	a3,a0
ffffffffc0203de8:	00002617          	auipc	a2,0x2
ffffffffc0203dec:	1f860613          	addi	a2,a2,504 # ffffffffc0205fe0 <default_pmm_manager+0xe58>
ffffffffc0203df0:	45d1                	li	a1,20
ffffffffc0203df2:	00002517          	auipc	a0,0x2
ffffffffc0203df6:	1d650513          	addi	a0,a0,470 # ffffffffc0205fc8 <default_pmm_manager+0xe40>
ffffffffc0203dfa:	d80fc0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0203dfe:	86b2                	mv	a3,a2
ffffffffc0203e00:	06a00593          	li	a1,106
ffffffffc0203e04:	00001617          	auipc	a2,0x1
ffffffffc0203e08:	41460613          	addi	a2,a2,1044 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0203e0c:	00001517          	auipc	a0,0x1
ffffffffc0203e10:	3d450513          	addi	a0,a0,980 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0203e14:	d66fc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203e18 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203e18:	1141                	addi	sp,sp,-16
ffffffffc0203e1a:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e1c:	00855793          	srli	a5,a0,0x8
ffffffffc0203e20:	c3a5                	beqz	a5,ffffffffc0203e80 <swapfs_write+0x68>
ffffffffc0203e22:	0000d717          	auipc	a4,0xd
ffffffffc0203e26:	71e73703          	ld	a4,1822(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc0203e2a:	04e7fb63          	bgeu	a5,a4,ffffffffc0203e80 <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e2e:	0000d617          	auipc	a2,0xd
ffffffffc0203e32:	6fa63603          	ld	a2,1786(a2) # ffffffffc0211528 <pages>
ffffffffc0203e36:	8d91                	sub	a1,a1,a2
ffffffffc0203e38:	4035d613          	srai	a2,a1,0x3
ffffffffc0203e3c:	00002597          	auipc	a1,0x2
ffffffffc0203e40:	40c5b583          	ld	a1,1036(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0203e44:	02b60633          	mul	a2,a2,a1
ffffffffc0203e48:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203e4c:	00002797          	auipc	a5,0x2
ffffffffc0203e50:	4047b783          	ld	a5,1028(a5) # ffffffffc0206250 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e54:	0000d717          	auipc	a4,0xd
ffffffffc0203e58:	6cc73703          	ld	a4,1740(a4) # ffffffffc0211520 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e5c:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e5e:	00c61793          	slli	a5,a2,0xc
ffffffffc0203e62:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203e64:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e66:	02e7f963          	bgeu	a5,a4,ffffffffc0203e98 <swapfs_write+0x80>
}
ffffffffc0203e6a:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e6c:	0000d797          	auipc	a5,0xd
ffffffffc0203e70:	6cc7b783          	ld	a5,1740(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0203e74:	46a1                	li	a3,8
ffffffffc0203e76:	963e                	add	a2,a2,a5
ffffffffc0203e78:	4505                	li	a0,1
}
ffffffffc0203e7a:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e7c:	e4efc06f          	j	ffffffffc02004ca <ide_write_secs>
ffffffffc0203e80:	86aa                	mv	a3,a0
ffffffffc0203e82:	00002617          	auipc	a2,0x2
ffffffffc0203e86:	15e60613          	addi	a2,a2,350 # ffffffffc0205fe0 <default_pmm_manager+0xe58>
ffffffffc0203e8a:	45e5                	li	a1,25
ffffffffc0203e8c:	00002517          	auipc	a0,0x2
ffffffffc0203e90:	13c50513          	addi	a0,a0,316 # ffffffffc0205fc8 <default_pmm_manager+0xe40>
ffffffffc0203e94:	ce6fc0ef          	jal	ra,ffffffffc020037a <__panic>
ffffffffc0203e98:	86b2                	mv	a3,a2
ffffffffc0203e9a:	06a00593          	li	a1,106
ffffffffc0203e9e:	00001617          	auipc	a2,0x1
ffffffffc0203ea2:	37a60613          	addi	a2,a2,890 # ffffffffc0205218 <default_pmm_manager+0x90>
ffffffffc0203ea6:	00001517          	auipc	a0,0x1
ffffffffc0203eaa:	33a50513          	addi	a0,a0,826 # ffffffffc02051e0 <default_pmm_manager+0x58>
ffffffffc0203eae:	cccfc0ef          	jal	ra,ffffffffc020037a <__panic>

ffffffffc0203eb2 <printnum>:
>>>>>>> 747620b (lab2)
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
<<<<<<< HEAD
ffffffffc0203ed0:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ed4:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203ed6:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203eda:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203edc:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ee0:	f022                	sd	s0,32(sp)
ffffffffc0203ee2:	ec26                	sd	s1,24(sp)
ffffffffc0203ee4:	e84a                	sd	s2,16(sp)
ffffffffc0203ee6:	f406                	sd	ra,40(sp)
ffffffffc0203ee8:	e44e                	sd	s3,8(sp)
ffffffffc0203eea:	84aa                	mv	s1,a0
ffffffffc0203eec:	892e                	mv	s2,a1
=======
ffffffffc0203eb2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203eb6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203eb8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ebc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203ebe:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ec2:	f022                	sd	s0,32(sp)
ffffffffc0203ec4:	ec26                	sd	s1,24(sp)
ffffffffc0203ec6:	e84a                	sd	s2,16(sp)
ffffffffc0203ec8:	f406                	sd	ra,40(sp)
ffffffffc0203eca:	e44e                	sd	s3,8(sp)
ffffffffc0203ecc:	84aa                	mv	s1,a0
ffffffffc0203ece:	892e                	mv	s2,a1
>>>>>>> 747620b (lab2)
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
<<<<<<< HEAD
ffffffffc0203eee:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203ef2:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203ef4:	03067e63          	bgeu	a2,a6,ffffffffc0203f30 <printnum+0x60>
ffffffffc0203ef8:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203efa:	00805763          	blez	s0,ffffffffc0203f08 <printnum+0x38>
ffffffffc0203efe:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203f00:	85ca                	mv	a1,s2
ffffffffc0203f02:	854e                	mv	a0,s3
ffffffffc0203f04:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203f06:	fc65                	bnez	s0,ffffffffc0203efe <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f08:	1a02                	slli	s4,s4,0x20
ffffffffc0203f0a:	00002797          	auipc	a5,0x2
ffffffffc0203f0e:	11e78793          	addi	a5,a5,286 # ffffffffc0206028 <default_pmm_manager+0xe88>
ffffffffc0203f12:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203f16:	9a3e                	add	s4,s4,a5
}
ffffffffc0203f18:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f1a:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203f1e:	70a2                	ld	ra,40(sp)
ffffffffc0203f20:	69a2                	ld	s3,8(sp)
ffffffffc0203f22:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f24:	85ca                	mv	a1,s2
ffffffffc0203f26:	87a6                	mv	a5,s1
}
ffffffffc0203f28:	6942                	ld	s2,16(sp)
ffffffffc0203f2a:	64e2                	ld	s1,24(sp)
ffffffffc0203f2c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f2e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203f30:	03065633          	divu	a2,a2,a6
ffffffffc0203f34:	8722                	mv	a4,s0
ffffffffc0203f36:	f9bff0ef          	jal	ra,ffffffffc0203ed0 <printnum>
ffffffffc0203f3a:	b7f9                	j	ffffffffc0203f08 <printnum+0x38>

ffffffffc0203f3c <vprintfmt>:
=======
ffffffffc0203ed0:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203ed4:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203ed6:	03067e63          	bgeu	a2,a6,ffffffffc0203f12 <printnum+0x60>
ffffffffc0203eda:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203edc:	00805763          	blez	s0,ffffffffc0203eea <printnum+0x38>
ffffffffc0203ee0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203ee2:	85ca                	mv	a1,s2
ffffffffc0203ee4:	854e                	mv	a0,s3
ffffffffc0203ee6:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203ee8:	fc65                	bnez	s0,ffffffffc0203ee0 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203eea:	1a02                	slli	s4,s4,0x20
ffffffffc0203eec:	00002797          	auipc	a5,0x2
ffffffffc0203ef0:	11478793          	addi	a5,a5,276 # ffffffffc0206000 <default_pmm_manager+0xe78>
ffffffffc0203ef4:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203ef8:	9a3e                	add	s4,s4,a5
}
ffffffffc0203efa:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203efc:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203f00:	70a2                	ld	ra,40(sp)
ffffffffc0203f02:	69a2                	ld	s3,8(sp)
ffffffffc0203f04:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f06:	85ca                	mv	a1,s2
ffffffffc0203f08:	87a6                	mv	a5,s1
}
ffffffffc0203f0a:	6942                	ld	s2,16(sp)
ffffffffc0203f0c:	64e2                	ld	s1,24(sp)
ffffffffc0203f0e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203f10:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203f12:	03065633          	divu	a2,a2,a6
ffffffffc0203f16:	8722                	mv	a4,s0
ffffffffc0203f18:	f9bff0ef          	jal	ra,ffffffffc0203eb2 <printnum>
ffffffffc0203f1c:	b7f9                	j	ffffffffc0203eea <printnum+0x38>

ffffffffc0203f1e <vprintfmt>:
>>>>>>> 747620b (lab2)
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
<<<<<<< HEAD
ffffffffc0203f3c:	7119                	addi	sp,sp,-128
ffffffffc0203f3e:	f4a6                	sd	s1,104(sp)
ffffffffc0203f40:	f0ca                	sd	s2,96(sp)
ffffffffc0203f42:	ecce                	sd	s3,88(sp)
ffffffffc0203f44:	e8d2                	sd	s4,80(sp)
ffffffffc0203f46:	e4d6                	sd	s5,72(sp)
ffffffffc0203f48:	e0da                	sd	s6,64(sp)
ffffffffc0203f4a:	fc5e                	sd	s7,56(sp)
ffffffffc0203f4c:	f06a                	sd	s10,32(sp)
ffffffffc0203f4e:	fc86                	sd	ra,120(sp)
ffffffffc0203f50:	f8a2                	sd	s0,112(sp)
ffffffffc0203f52:	f862                	sd	s8,48(sp)
ffffffffc0203f54:	f466                	sd	s9,40(sp)
ffffffffc0203f56:	ec6e                	sd	s11,24(sp)
ffffffffc0203f58:	892a                	mv	s2,a0
ffffffffc0203f5a:	84ae                	mv	s1,a1
ffffffffc0203f5c:	8d32                	mv	s10,a2
ffffffffc0203f5e:	8a36                	mv	s4,a3
=======
ffffffffc0203f1e:	7119                	addi	sp,sp,-128
ffffffffc0203f20:	f4a6                	sd	s1,104(sp)
ffffffffc0203f22:	f0ca                	sd	s2,96(sp)
ffffffffc0203f24:	ecce                	sd	s3,88(sp)
ffffffffc0203f26:	e8d2                	sd	s4,80(sp)
ffffffffc0203f28:	e4d6                	sd	s5,72(sp)
ffffffffc0203f2a:	e0da                	sd	s6,64(sp)
ffffffffc0203f2c:	fc5e                	sd	s7,56(sp)
ffffffffc0203f2e:	f06a                	sd	s10,32(sp)
ffffffffc0203f30:	fc86                	sd	ra,120(sp)
ffffffffc0203f32:	f8a2                	sd	s0,112(sp)
ffffffffc0203f34:	f862                	sd	s8,48(sp)
ffffffffc0203f36:	f466                	sd	s9,40(sp)
ffffffffc0203f38:	ec6e                	sd	s11,24(sp)
ffffffffc0203f3a:	892a                	mv	s2,a0
ffffffffc0203f3c:	84ae                	mv	s1,a1
ffffffffc0203f3e:	8d32                	mv	s10,a2
ffffffffc0203f40:	8a36                	mv	s4,a3
>>>>>>> 747620b (lab2)
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
<<<<<<< HEAD
ffffffffc0203f60:	02500993          	li	s3,37
=======
ffffffffc0203f42:	02500993          	li	s3,37
>>>>>>> 747620b (lab2)
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
<<<<<<< HEAD
ffffffffc0203f64:	5b7d                	li	s6,-1
ffffffffc0203f66:	00002a97          	auipc	s5,0x2
ffffffffc0203f6a:	0f6a8a93          	addi	s5,s5,246 # ffffffffc020605c <default_pmm_manager+0xebc>
=======
ffffffffc0203f46:	5b7d                	li	s6,-1
ffffffffc0203f48:	00002a97          	auipc	s5,0x2
ffffffffc0203f4c:	0eca8a93          	addi	s5,s5,236 # ffffffffc0206034 <default_pmm_manager+0xeac>
>>>>>>> 747620b (lab2)
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
<<<<<<< HEAD
ffffffffc0203f6e:	00002b97          	auipc	s7,0x2
ffffffffc0203f72:	2cab8b93          	addi	s7,s7,714 # ffffffffc0206238 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f76:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0203f7a:	001d0413          	addi	s0,s10,1
ffffffffc0203f7e:	01350a63          	beq	a0,s3,ffffffffc0203f92 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203f82:	c121                	beqz	a0,ffffffffc0203fc2 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203f84:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f86:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203f88:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f8a:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203f8e:	ff351ae3          	bne	a0,s3,ffffffffc0203f82 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f92:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203f96:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203f9a:	4c81                	li	s9,0
ffffffffc0203f9c:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203f9e:	5c7d                	li	s8,-1
ffffffffc0203fa0:	5dfd                	li	s11,-1
ffffffffc0203fa2:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203fa6:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203fa8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203fac:	0ff5f593          	zext.b	a1,a1
ffffffffc0203fb0:	00140d13          	addi	s10,s0,1
ffffffffc0203fb4:	04b56263          	bltu	a0,a1,ffffffffc0203ff8 <vprintfmt+0xbc>
ffffffffc0203fb8:	058a                	slli	a1,a1,0x2
ffffffffc0203fba:	95d6                	add	a1,a1,s5
ffffffffc0203fbc:	4194                	lw	a3,0(a1)
ffffffffc0203fbe:	96d6                	add	a3,a3,s5
ffffffffc0203fc0:	8682                	jr	a3
=======
ffffffffc0203f50:	00002b97          	auipc	s7,0x2
ffffffffc0203f54:	2c0b8b93          	addi	s7,s7,704 # ffffffffc0206210 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f58:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0203f5c:	001d0413          	addi	s0,s10,1
ffffffffc0203f60:	01350a63          	beq	a0,s3,ffffffffc0203f74 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203f64:	c121                	beqz	a0,ffffffffc0203fa4 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203f66:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f68:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203f6a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203f6c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203f70:	ff351ae3          	bne	a0,s3,ffffffffc0203f64 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f74:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203f78:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203f7c:	4c81                	li	s9,0
ffffffffc0203f7e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203f80:	5c7d                	li	s8,-1
ffffffffc0203f82:	5dfd                	li	s11,-1
ffffffffc0203f84:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203f88:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f8a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203f8e:	0ff5f593          	zext.b	a1,a1
ffffffffc0203f92:	00140d13          	addi	s10,s0,1
ffffffffc0203f96:	04b56263          	bltu	a0,a1,ffffffffc0203fda <vprintfmt+0xbc>
ffffffffc0203f9a:	058a                	slli	a1,a1,0x2
ffffffffc0203f9c:	95d6                	add	a1,a1,s5
ffffffffc0203f9e:	4194                	lw	a3,0(a1)
ffffffffc0203fa0:	96d6                	add	a3,a3,s5
ffffffffc0203fa2:	8682                	jr	a3
>>>>>>> 747620b (lab2)
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
<<<<<<< HEAD
ffffffffc0203fc2:	70e6                	ld	ra,120(sp)
ffffffffc0203fc4:	7446                	ld	s0,112(sp)
ffffffffc0203fc6:	74a6                	ld	s1,104(sp)
ffffffffc0203fc8:	7906                	ld	s2,96(sp)
ffffffffc0203fca:	69e6                	ld	s3,88(sp)
ffffffffc0203fcc:	6a46                	ld	s4,80(sp)
ffffffffc0203fce:	6aa6                	ld	s5,72(sp)
ffffffffc0203fd0:	6b06                	ld	s6,64(sp)
ffffffffc0203fd2:	7be2                	ld	s7,56(sp)
ffffffffc0203fd4:	7c42                	ld	s8,48(sp)
ffffffffc0203fd6:	7ca2                	ld	s9,40(sp)
ffffffffc0203fd8:	7d02                	ld	s10,32(sp)
ffffffffc0203fda:	6de2                	ld	s11,24(sp)
ffffffffc0203fdc:	6109                	addi	sp,sp,128
ffffffffc0203fde:	8082                	ret
            padc = '0';
ffffffffc0203fe0:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203fe2:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203fe6:	846a                	mv	s0,s10
ffffffffc0203fe8:	00140d13          	addi	s10,s0,1
ffffffffc0203fec:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203ff0:	0ff5f593          	zext.b	a1,a1
ffffffffc0203ff4:	fcb572e3          	bgeu	a0,a1,ffffffffc0203fb8 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203ff8:	85a6                	mv	a1,s1
ffffffffc0203ffa:	02500513          	li	a0,37
ffffffffc0203ffe:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0204000:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204004:	8d22                	mv	s10,s0
ffffffffc0204006:	f73788e3          	beq	a5,s3,ffffffffc0203f76 <vprintfmt+0x3a>
ffffffffc020400a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020400e:	1d7d                	addi	s10,s10,-1
ffffffffc0204010:	ff379de3          	bne	a5,s3,ffffffffc020400a <vprintfmt+0xce>
ffffffffc0204014:	b78d                	j	ffffffffc0203f76 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0204016:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020401a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020401e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0204020:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0204024:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204028:	02d86463          	bltu	a6,a3,ffffffffc0204050 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020402c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204030:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204034:	0186873b          	addw	a4,a3,s8
ffffffffc0204038:	0017171b          	slliw	a4,a4,0x1
ffffffffc020403c:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020403e:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0204042:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204044:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0204048:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020404c:	fed870e3          	bgeu	a6,a3,ffffffffc020402c <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0204050:	f40ddce3          	bgez	s11,ffffffffc0203fa8 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0204054:	8de2                	mv	s11,s8
ffffffffc0204056:	5c7d                	li	s8,-1
ffffffffc0204058:	bf81                	j	ffffffffc0203fa8 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020405a:	fffdc693          	not	a3,s11
ffffffffc020405e:	96fd                	srai	a3,a3,0x3f
ffffffffc0204060:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204064:	00144603          	lbu	a2,1(s0)
ffffffffc0204068:	2d81                	sext.w	s11,s11
ffffffffc020406a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020406c:	bf35                	j	ffffffffc0203fa8 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc020406e:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204072:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204076:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204078:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020407a:	bfd9                	j	ffffffffc0204050 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020407c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020407e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204082:	01174463          	blt	a4,a7,ffffffffc020408a <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204086:	1a088e63          	beqz	a7,ffffffffc0204242 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020408a:	000a3603          	ld	a2,0(s4)
ffffffffc020408e:	46c1                	li	a3,16
ffffffffc0204090:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204092:	2781                	sext.w	a5,a5
ffffffffc0204094:	876e                	mv	a4,s11
ffffffffc0204096:	85a6                	mv	a1,s1
ffffffffc0204098:	854a                	mv	a0,s2
ffffffffc020409a:	e37ff0ef          	jal	ra,ffffffffc0203ed0 <printnum>
            break;
ffffffffc020409e:	bde1                	j	ffffffffc0203f76 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02040a0:	000a2503          	lw	a0,0(s4)
ffffffffc02040a4:	85a6                	mv	a1,s1
ffffffffc02040a6:	0a21                	addi	s4,s4,8
ffffffffc02040a8:	9902                	jalr	s2
            break;
ffffffffc02040aa:	b5f1                	j	ffffffffc0203f76 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02040ac:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02040ae:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02040b2:	01174463          	blt	a4,a7,ffffffffc02040ba <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02040b6:	18088163          	beqz	a7,ffffffffc0204238 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02040ba:	000a3603          	ld	a2,0(s4)
ffffffffc02040be:	46a9                	li	a3,10
ffffffffc02040c0:	8a2e                	mv	s4,a1
ffffffffc02040c2:	bfc1                	j	ffffffffc0204092 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040c4:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02040c8:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040ca:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02040cc:	bdf1                	j	ffffffffc0203fa8 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02040ce:	85a6                	mv	a1,s1
ffffffffc02040d0:	02500513          	li	a0,37
ffffffffc02040d4:	9902                	jalr	s2
            break;
ffffffffc02040d6:	b545                	j	ffffffffc0203f76 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040d8:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02040dc:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040de:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02040e0:	b5e1                	j	ffffffffc0203fa8 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02040e2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02040e4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02040e8:	01174463          	blt	a4,a7,ffffffffc02040f0 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02040ec:	14088163          	beqz	a7,ffffffffc020422e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02040f0:	000a3603          	ld	a2,0(s4)
ffffffffc02040f4:	46a1                	li	a3,8
ffffffffc02040f6:	8a2e                	mv	s4,a1
ffffffffc02040f8:	bf69                	j	ffffffffc0204092 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02040fa:	03000513          	li	a0,48
ffffffffc02040fe:	85a6                	mv	a1,s1
ffffffffc0204100:	e03e                	sd	a5,0(sp)
ffffffffc0204102:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204104:	85a6                	mv	a1,s1
ffffffffc0204106:	07800513          	li	a0,120
ffffffffc020410a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020410c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020410e:	6782                	ld	a5,0(sp)
ffffffffc0204110:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204112:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0204116:	bfb5                	j	ffffffffc0204092 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204118:	000a3403          	ld	s0,0(s4)
ffffffffc020411c:	008a0713          	addi	a4,s4,8
ffffffffc0204120:	e03a                	sd	a4,0(sp)
ffffffffc0204122:	14040263          	beqz	s0,ffffffffc0204266 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0204126:	0fb05763          	blez	s11,ffffffffc0204214 <vprintfmt+0x2d8>
ffffffffc020412a:	02d00693          	li	a3,45
ffffffffc020412e:	0cd79163          	bne	a5,a3,ffffffffc02041f0 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204132:	00044783          	lbu	a5,0(s0)
ffffffffc0204136:	0007851b          	sext.w	a0,a5
ffffffffc020413a:	cf85                	beqz	a5,ffffffffc0204172 <vprintfmt+0x236>
ffffffffc020413c:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204140:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204144:	000c4563          	bltz	s8,ffffffffc020414e <vprintfmt+0x212>
ffffffffc0204148:	3c7d                	addiw	s8,s8,-1
ffffffffc020414a:	036c0263          	beq	s8,s6,ffffffffc020416e <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc020414e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204150:	0e0c8e63          	beqz	s9,ffffffffc020424c <vprintfmt+0x310>
ffffffffc0204154:	3781                	addiw	a5,a5,-32
ffffffffc0204156:	0ef47b63          	bgeu	s0,a5,ffffffffc020424c <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020415a:	03f00513          	li	a0,63
ffffffffc020415e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204160:	000a4783          	lbu	a5,0(s4)
ffffffffc0204164:	3dfd                	addiw	s11,s11,-1
ffffffffc0204166:	0a05                	addi	s4,s4,1
ffffffffc0204168:	0007851b          	sext.w	a0,a5
ffffffffc020416c:	ffe1                	bnez	a5,ffffffffc0204144 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc020416e:	01b05963          	blez	s11,ffffffffc0204180 <vprintfmt+0x244>
ffffffffc0204172:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204174:	85a6                	mv	a1,s1
ffffffffc0204176:	02000513          	li	a0,32
ffffffffc020417a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020417c:	fe0d9be3          	bnez	s11,ffffffffc0204172 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204180:	6a02                	ld	s4,0(sp)
ffffffffc0204182:	bbd5                	j	ffffffffc0203f76 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204184:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204186:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020418a:	01174463          	blt	a4,a7,ffffffffc0204192 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020418e:	08088d63          	beqz	a7,ffffffffc0204228 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204192:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204196:	0a044d63          	bltz	s0,ffffffffc0204250 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020419a:	8622                	mv	a2,s0
ffffffffc020419c:	8a66                	mv	s4,s9
ffffffffc020419e:	46a9                	li	a3,10
ffffffffc02041a0:	bdcd                	j	ffffffffc0204092 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02041a2:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02041a6:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02041a8:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02041aa:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02041ae:	8fb5                	xor	a5,a5,a3
ffffffffc02041b0:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02041b4:	02d74163          	blt	a4,a3,ffffffffc02041d6 <vprintfmt+0x29a>
ffffffffc02041b8:	00369793          	slli	a5,a3,0x3
ffffffffc02041bc:	97de                	add	a5,a5,s7
ffffffffc02041be:	639c                	ld	a5,0(a5)
ffffffffc02041c0:	cb99                	beqz	a5,ffffffffc02041d6 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02041c2:	86be                	mv	a3,a5
ffffffffc02041c4:	00002617          	auipc	a2,0x2
ffffffffc02041c8:	e9460613          	addi	a2,a2,-364 # ffffffffc0206058 <default_pmm_manager+0xeb8>
ffffffffc02041cc:	85a6                	mv	a1,s1
ffffffffc02041ce:	854a                	mv	a0,s2
ffffffffc02041d0:	0ce000ef          	jal	ra,ffffffffc020429e <printfmt>
ffffffffc02041d4:	b34d                	j	ffffffffc0203f76 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02041d6:	00002617          	auipc	a2,0x2
ffffffffc02041da:	e7260613          	addi	a2,a2,-398 # ffffffffc0206048 <default_pmm_manager+0xea8>
ffffffffc02041de:	85a6                	mv	a1,s1
ffffffffc02041e0:	854a                	mv	a0,s2
ffffffffc02041e2:	0bc000ef          	jal	ra,ffffffffc020429e <printfmt>
ffffffffc02041e6:	bb41                	j	ffffffffc0203f76 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02041e8:	00002417          	auipc	s0,0x2
ffffffffc02041ec:	e5840413          	addi	s0,s0,-424 # ffffffffc0206040 <default_pmm_manager+0xea0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02041f0:	85e2                	mv	a1,s8
ffffffffc02041f2:	8522                	mv	a0,s0
ffffffffc02041f4:	e43e                	sd	a5,8(sp)
ffffffffc02041f6:	196000ef          	jal	ra,ffffffffc020438c <strnlen>
ffffffffc02041fa:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02041fe:	01b05b63          	blez	s11,ffffffffc0204214 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0204202:	67a2                	ld	a5,8(sp)
ffffffffc0204204:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204208:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020420a:	85a6                	mv	a1,s1
ffffffffc020420c:	8552                	mv	a0,s4
ffffffffc020420e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204210:	fe0d9ce3          	bnez	s11,ffffffffc0204208 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204214:	00044783          	lbu	a5,0(s0)
ffffffffc0204218:	00140a13          	addi	s4,s0,1
ffffffffc020421c:	0007851b          	sext.w	a0,a5
ffffffffc0204220:	d3a5                	beqz	a5,ffffffffc0204180 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204222:	05e00413          	li	s0,94
ffffffffc0204226:	bf39                	j	ffffffffc0204144 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0204228:	000a2403          	lw	s0,0(s4)
ffffffffc020422c:	b7ad                	j	ffffffffc0204196 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020422e:	000a6603          	lwu	a2,0(s4)
ffffffffc0204232:	46a1                	li	a3,8
ffffffffc0204234:	8a2e                	mv	s4,a1
ffffffffc0204236:	bdb1                	j	ffffffffc0204092 <vprintfmt+0x156>
ffffffffc0204238:	000a6603          	lwu	a2,0(s4)
ffffffffc020423c:	46a9                	li	a3,10
ffffffffc020423e:	8a2e                	mv	s4,a1
ffffffffc0204240:	bd89                	j	ffffffffc0204092 <vprintfmt+0x156>
ffffffffc0204242:	000a6603          	lwu	a2,0(s4)
ffffffffc0204246:	46c1                	li	a3,16
ffffffffc0204248:	8a2e                	mv	s4,a1
ffffffffc020424a:	b5a1                	j	ffffffffc0204092 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020424c:	9902                	jalr	s2
ffffffffc020424e:	bf09                	j	ffffffffc0204160 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204250:	85a6                	mv	a1,s1
ffffffffc0204252:	02d00513          	li	a0,45
ffffffffc0204256:	e03e                	sd	a5,0(sp)
ffffffffc0204258:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020425a:	6782                	ld	a5,0(sp)
ffffffffc020425c:	8a66                	mv	s4,s9
ffffffffc020425e:	40800633          	neg	a2,s0
ffffffffc0204262:	46a9                	li	a3,10
ffffffffc0204264:	b53d                	j	ffffffffc0204092 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0204266:	03b05163          	blez	s11,ffffffffc0204288 <vprintfmt+0x34c>
ffffffffc020426a:	02d00693          	li	a3,45
ffffffffc020426e:	f6d79de3          	bne	a5,a3,ffffffffc02041e8 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204272:	00002417          	auipc	s0,0x2
ffffffffc0204276:	dce40413          	addi	s0,s0,-562 # ffffffffc0206040 <default_pmm_manager+0xea0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020427a:	02800793          	li	a5,40
ffffffffc020427e:	02800513          	li	a0,40
ffffffffc0204282:	00140a13          	addi	s4,s0,1
ffffffffc0204286:	bd6d                	j	ffffffffc0204140 <vprintfmt+0x204>
ffffffffc0204288:	00002a17          	auipc	s4,0x2
ffffffffc020428c:	db9a0a13          	addi	s4,s4,-583 # ffffffffc0206041 <default_pmm_manager+0xea1>
ffffffffc0204290:	02800513          	li	a0,40
ffffffffc0204294:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204298:	05e00413          	li	s0,94
ffffffffc020429c:	b565                	j	ffffffffc0204144 <vprintfmt+0x208>

ffffffffc020429e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020429e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02042a0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02042a4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02042a6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02042a8:	ec06                	sd	ra,24(sp)
ffffffffc02042aa:	f83a                	sd	a4,48(sp)
ffffffffc02042ac:	fc3e                	sd	a5,56(sp)
ffffffffc02042ae:	e0c2                	sd	a6,64(sp)
ffffffffc02042b0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02042b2:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02042b4:	c89ff0ef          	jal	ra,ffffffffc0203f3c <vprintfmt>
}
ffffffffc02042b8:	60e2                	ld	ra,24(sp)
ffffffffc02042ba:	6161                	addi	sp,sp,80
ffffffffc02042bc:	8082                	ret

ffffffffc02042be <readline>:
=======
ffffffffc0203fa4:	70e6                	ld	ra,120(sp)
ffffffffc0203fa6:	7446                	ld	s0,112(sp)
ffffffffc0203fa8:	74a6                	ld	s1,104(sp)
ffffffffc0203faa:	7906                	ld	s2,96(sp)
ffffffffc0203fac:	69e6                	ld	s3,88(sp)
ffffffffc0203fae:	6a46                	ld	s4,80(sp)
ffffffffc0203fb0:	6aa6                	ld	s5,72(sp)
ffffffffc0203fb2:	6b06                	ld	s6,64(sp)
ffffffffc0203fb4:	7be2                	ld	s7,56(sp)
ffffffffc0203fb6:	7c42                	ld	s8,48(sp)
ffffffffc0203fb8:	7ca2                	ld	s9,40(sp)
ffffffffc0203fba:	7d02                	ld	s10,32(sp)
ffffffffc0203fbc:	6de2                	ld	s11,24(sp)
ffffffffc0203fbe:	6109                	addi	sp,sp,128
ffffffffc0203fc0:	8082                	ret
            padc = '0';
ffffffffc0203fc2:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203fc4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203fc8:	846a                	mv	s0,s10
ffffffffc0203fca:	00140d13          	addi	s10,s0,1
ffffffffc0203fce:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203fd2:	0ff5f593          	zext.b	a1,a1
ffffffffc0203fd6:	fcb572e3          	bgeu	a0,a1,ffffffffc0203f9a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203fda:	85a6                	mv	a1,s1
ffffffffc0203fdc:	02500513          	li	a0,37
ffffffffc0203fe0:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203fe2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203fe6:	8d22                	mv	s10,s0
ffffffffc0203fe8:	f73788e3          	beq	a5,s3,ffffffffc0203f58 <vprintfmt+0x3a>
ffffffffc0203fec:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203ff0:	1d7d                	addi	s10,s10,-1
ffffffffc0203ff2:	ff379de3          	bne	a5,s3,ffffffffc0203fec <vprintfmt+0xce>
ffffffffc0203ff6:	b78d                	j	ffffffffc0203f58 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203ff8:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203ffc:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204000:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0204002:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0204006:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020400a:	02d86463          	bltu	a6,a3,ffffffffc0204032 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020400e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204012:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204016:	0186873b          	addw	a4,a3,s8
ffffffffc020401a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020401e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0204020:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0204024:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204026:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020402a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020402e:	fed870e3          	bgeu	a6,a3,ffffffffc020400e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0204032:	f40ddce3          	bgez	s11,ffffffffc0203f8a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0204036:	8de2                	mv	s11,s8
ffffffffc0204038:	5c7d                	li	s8,-1
ffffffffc020403a:	bf81                	j	ffffffffc0203f8a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020403c:	fffdc693          	not	a3,s11
ffffffffc0204040:	96fd                	srai	a3,a3,0x3f
ffffffffc0204042:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204046:	00144603          	lbu	a2,1(s0)
ffffffffc020404a:	2d81                	sext.w	s11,s11
ffffffffc020404c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020404e:	bf35                	j	ffffffffc0203f8a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0204050:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204054:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204058:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020405a:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020405c:	bfd9                	j	ffffffffc0204032 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020405e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204060:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204064:	01174463          	blt	a4,a7,ffffffffc020406c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204068:	1a088e63          	beqz	a7,ffffffffc0204224 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020406c:	000a3603          	ld	a2,0(s4)
ffffffffc0204070:	46c1                	li	a3,16
ffffffffc0204072:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204074:	2781                	sext.w	a5,a5
ffffffffc0204076:	876e                	mv	a4,s11
ffffffffc0204078:	85a6                	mv	a1,s1
ffffffffc020407a:	854a                	mv	a0,s2
ffffffffc020407c:	e37ff0ef          	jal	ra,ffffffffc0203eb2 <printnum>
            break;
ffffffffc0204080:	bde1                	j	ffffffffc0203f58 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0204082:	000a2503          	lw	a0,0(s4)
ffffffffc0204086:	85a6                	mv	a1,s1
ffffffffc0204088:	0a21                	addi	s4,s4,8
ffffffffc020408a:	9902                	jalr	s2
            break;
ffffffffc020408c:	b5f1                	j	ffffffffc0203f58 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020408e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204090:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204094:	01174463          	blt	a4,a7,ffffffffc020409c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0204098:	18088163          	beqz	a7,ffffffffc020421a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020409c:	000a3603          	ld	a2,0(s4)
ffffffffc02040a0:	46a9                	li	a3,10
ffffffffc02040a2:	8a2e                	mv	s4,a1
ffffffffc02040a4:	bfc1                	j	ffffffffc0204074 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040a6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02040aa:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040ac:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02040ae:	bdf1                	j	ffffffffc0203f8a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02040b0:	85a6                	mv	a1,s1
ffffffffc02040b2:	02500513          	li	a0,37
ffffffffc02040b6:	9902                	jalr	s2
            break;
ffffffffc02040b8:	b545                	j	ffffffffc0203f58 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040ba:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02040be:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040c0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02040c2:	b5e1                	j	ffffffffc0203f8a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02040c4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02040c6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02040ca:	01174463          	blt	a4,a7,ffffffffc02040d2 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02040ce:	14088163          	beqz	a7,ffffffffc0204210 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02040d2:	000a3603          	ld	a2,0(s4)
ffffffffc02040d6:	46a1                	li	a3,8
ffffffffc02040d8:	8a2e                	mv	s4,a1
ffffffffc02040da:	bf69                	j	ffffffffc0204074 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02040dc:	03000513          	li	a0,48
ffffffffc02040e0:	85a6                	mv	a1,s1
ffffffffc02040e2:	e03e                	sd	a5,0(sp)
ffffffffc02040e4:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02040e6:	85a6                	mv	a1,s1
ffffffffc02040e8:	07800513          	li	a0,120
ffffffffc02040ec:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02040ee:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02040f0:	6782                	ld	a5,0(sp)
ffffffffc02040f2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02040f4:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02040f8:	bfb5                	j	ffffffffc0204074 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02040fa:	000a3403          	ld	s0,0(s4)
ffffffffc02040fe:	008a0713          	addi	a4,s4,8
ffffffffc0204102:	e03a                	sd	a4,0(sp)
ffffffffc0204104:	14040263          	beqz	s0,ffffffffc0204248 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0204108:	0fb05763          	blez	s11,ffffffffc02041f6 <vprintfmt+0x2d8>
ffffffffc020410c:	02d00693          	li	a3,45
ffffffffc0204110:	0cd79163          	bne	a5,a3,ffffffffc02041d2 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204114:	00044783          	lbu	a5,0(s0)
ffffffffc0204118:	0007851b          	sext.w	a0,a5
ffffffffc020411c:	cf85                	beqz	a5,ffffffffc0204154 <vprintfmt+0x236>
ffffffffc020411e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204122:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204126:	000c4563          	bltz	s8,ffffffffc0204130 <vprintfmt+0x212>
ffffffffc020412a:	3c7d                	addiw	s8,s8,-1
ffffffffc020412c:	036c0263          	beq	s8,s6,ffffffffc0204150 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0204130:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204132:	0e0c8e63          	beqz	s9,ffffffffc020422e <vprintfmt+0x310>
ffffffffc0204136:	3781                	addiw	a5,a5,-32
ffffffffc0204138:	0ef47b63          	bgeu	s0,a5,ffffffffc020422e <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020413c:	03f00513          	li	a0,63
ffffffffc0204140:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204142:	000a4783          	lbu	a5,0(s4)
ffffffffc0204146:	3dfd                	addiw	s11,s11,-1
ffffffffc0204148:	0a05                	addi	s4,s4,1
ffffffffc020414a:	0007851b          	sext.w	a0,a5
ffffffffc020414e:	ffe1                	bnez	a5,ffffffffc0204126 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0204150:	01b05963          	blez	s11,ffffffffc0204162 <vprintfmt+0x244>
ffffffffc0204154:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204156:	85a6                	mv	a1,s1
ffffffffc0204158:	02000513          	li	a0,32
ffffffffc020415c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020415e:	fe0d9be3          	bnez	s11,ffffffffc0204154 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204162:	6a02                	ld	s4,0(sp)
ffffffffc0204164:	bbd5                	j	ffffffffc0203f58 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204166:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204168:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020416c:	01174463          	blt	a4,a7,ffffffffc0204174 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0204170:	08088d63          	beqz	a7,ffffffffc020420a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204174:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204178:	0a044d63          	bltz	s0,ffffffffc0204232 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020417c:	8622                	mv	a2,s0
ffffffffc020417e:	8a66                	mv	s4,s9
ffffffffc0204180:	46a9                	li	a3,10
ffffffffc0204182:	bdcd                	j	ffffffffc0204074 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204184:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204188:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc020418a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020418c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204190:	8fb5                	xor	a5,a5,a3
ffffffffc0204192:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204196:	02d74163          	blt	a4,a3,ffffffffc02041b8 <vprintfmt+0x29a>
ffffffffc020419a:	00369793          	slli	a5,a3,0x3
ffffffffc020419e:	97de                	add	a5,a5,s7
ffffffffc02041a0:	639c                	ld	a5,0(a5)
ffffffffc02041a2:	cb99                	beqz	a5,ffffffffc02041b8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02041a4:	86be                	mv	a3,a5
ffffffffc02041a6:	00002617          	auipc	a2,0x2
ffffffffc02041aa:	e8a60613          	addi	a2,a2,-374 # ffffffffc0206030 <default_pmm_manager+0xea8>
ffffffffc02041ae:	85a6                	mv	a1,s1
ffffffffc02041b0:	854a                	mv	a0,s2
ffffffffc02041b2:	0ce000ef          	jal	ra,ffffffffc0204280 <printfmt>
ffffffffc02041b6:	b34d                	j	ffffffffc0203f58 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02041b8:	00002617          	auipc	a2,0x2
ffffffffc02041bc:	e6860613          	addi	a2,a2,-408 # ffffffffc0206020 <default_pmm_manager+0xe98>
ffffffffc02041c0:	85a6                	mv	a1,s1
ffffffffc02041c2:	854a                	mv	a0,s2
ffffffffc02041c4:	0bc000ef          	jal	ra,ffffffffc0204280 <printfmt>
ffffffffc02041c8:	bb41                	j	ffffffffc0203f58 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02041ca:	00002417          	auipc	s0,0x2
ffffffffc02041ce:	e4e40413          	addi	s0,s0,-434 # ffffffffc0206018 <default_pmm_manager+0xe90>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02041d2:	85e2                	mv	a1,s8
ffffffffc02041d4:	8522                	mv	a0,s0
ffffffffc02041d6:	e43e                	sd	a5,8(sp)
ffffffffc02041d8:	196000ef          	jal	ra,ffffffffc020436e <strnlen>
ffffffffc02041dc:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02041e0:	01b05b63          	blez	s11,ffffffffc02041f6 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02041e4:	67a2                	ld	a5,8(sp)
ffffffffc02041e6:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02041ea:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02041ec:	85a6                	mv	a1,s1
ffffffffc02041ee:	8552                	mv	a0,s4
ffffffffc02041f0:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02041f2:	fe0d9ce3          	bnez	s11,ffffffffc02041ea <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02041f6:	00044783          	lbu	a5,0(s0)
ffffffffc02041fa:	00140a13          	addi	s4,s0,1
ffffffffc02041fe:	0007851b          	sext.w	a0,a5
ffffffffc0204202:	d3a5                	beqz	a5,ffffffffc0204162 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204204:	05e00413          	li	s0,94
ffffffffc0204208:	bf39                	j	ffffffffc0204126 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020420a:	000a2403          	lw	s0,0(s4)
ffffffffc020420e:	b7ad                	j	ffffffffc0204178 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0204210:	000a6603          	lwu	a2,0(s4)
ffffffffc0204214:	46a1                	li	a3,8
ffffffffc0204216:	8a2e                	mv	s4,a1
ffffffffc0204218:	bdb1                	j	ffffffffc0204074 <vprintfmt+0x156>
ffffffffc020421a:	000a6603          	lwu	a2,0(s4)
ffffffffc020421e:	46a9                	li	a3,10
ffffffffc0204220:	8a2e                	mv	s4,a1
ffffffffc0204222:	bd89                	j	ffffffffc0204074 <vprintfmt+0x156>
ffffffffc0204224:	000a6603          	lwu	a2,0(s4)
ffffffffc0204228:	46c1                	li	a3,16
ffffffffc020422a:	8a2e                	mv	s4,a1
ffffffffc020422c:	b5a1                	j	ffffffffc0204074 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020422e:	9902                	jalr	s2
ffffffffc0204230:	bf09                	j	ffffffffc0204142 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204232:	85a6                	mv	a1,s1
ffffffffc0204234:	02d00513          	li	a0,45
ffffffffc0204238:	e03e                	sd	a5,0(sp)
ffffffffc020423a:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020423c:	6782                	ld	a5,0(sp)
ffffffffc020423e:	8a66                	mv	s4,s9
ffffffffc0204240:	40800633          	neg	a2,s0
ffffffffc0204244:	46a9                	li	a3,10
ffffffffc0204246:	b53d                	j	ffffffffc0204074 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0204248:	03b05163          	blez	s11,ffffffffc020426a <vprintfmt+0x34c>
ffffffffc020424c:	02d00693          	li	a3,45
ffffffffc0204250:	f6d79de3          	bne	a5,a3,ffffffffc02041ca <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204254:	00002417          	auipc	s0,0x2
ffffffffc0204258:	dc440413          	addi	s0,s0,-572 # ffffffffc0206018 <default_pmm_manager+0xe90>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020425c:	02800793          	li	a5,40
ffffffffc0204260:	02800513          	li	a0,40
ffffffffc0204264:	00140a13          	addi	s4,s0,1
ffffffffc0204268:	bd6d                	j	ffffffffc0204122 <vprintfmt+0x204>
ffffffffc020426a:	00002a17          	auipc	s4,0x2
ffffffffc020426e:	dafa0a13          	addi	s4,s4,-593 # ffffffffc0206019 <default_pmm_manager+0xe91>
ffffffffc0204272:	02800513          	li	a0,40
ffffffffc0204276:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020427a:	05e00413          	li	s0,94
ffffffffc020427e:	b565                	j	ffffffffc0204126 <vprintfmt+0x208>

ffffffffc0204280 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204280:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204282:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204286:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204288:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020428a:	ec06                	sd	ra,24(sp)
ffffffffc020428c:	f83a                	sd	a4,48(sp)
ffffffffc020428e:	fc3e                	sd	a5,56(sp)
ffffffffc0204290:	e0c2                	sd	a6,64(sp)
ffffffffc0204292:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204294:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204296:	c89ff0ef          	jal	ra,ffffffffc0203f1e <vprintfmt>
}
ffffffffc020429a:	60e2                	ld	ra,24(sp)
ffffffffc020429c:	6161                	addi	sp,sp,80
ffffffffc020429e:	8082                	ret

ffffffffc02042a0 <readline>:
>>>>>>> 747620b (lab2)
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
<<<<<<< HEAD
ffffffffc02042be:	715d                	addi	sp,sp,-80
ffffffffc02042c0:	e486                	sd	ra,72(sp)
ffffffffc02042c2:	e0a6                	sd	s1,64(sp)
ffffffffc02042c4:	fc4a                	sd	s2,56(sp)
ffffffffc02042c6:	f84e                	sd	s3,48(sp)
ffffffffc02042c8:	f452                	sd	s4,40(sp)
ffffffffc02042ca:	f056                	sd	s5,32(sp)
ffffffffc02042cc:	ec5a                	sd	s6,24(sp)
ffffffffc02042ce:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02042d0:	c901                	beqz	a0,ffffffffc02042e0 <readline+0x22>
ffffffffc02042d2:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02042d4:	00002517          	auipc	a0,0x2
ffffffffc02042d8:	d8450513          	addi	a0,a0,-636 # ffffffffc0206058 <default_pmm_manager+0xeb8>
ffffffffc02042dc:	de5fb0ef          	jal	ra,ffffffffc02000c0 <cprintf>
readline(const char *prompt) {
ffffffffc02042e0:	4481                	li	s1,0
=======
ffffffffc02042a0:	715d                	addi	sp,sp,-80
ffffffffc02042a2:	e486                	sd	ra,72(sp)
ffffffffc02042a4:	e0a6                	sd	s1,64(sp)
ffffffffc02042a6:	fc4a                	sd	s2,56(sp)
ffffffffc02042a8:	f84e                	sd	s3,48(sp)
ffffffffc02042aa:	f452                	sd	s4,40(sp)
ffffffffc02042ac:	f056                	sd	s5,32(sp)
ffffffffc02042ae:	ec5a                	sd	s6,24(sp)
ffffffffc02042b0:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02042b2:	c901                	beqz	a0,ffffffffc02042c2 <readline+0x22>
ffffffffc02042b4:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02042b6:	00002517          	auipc	a0,0x2
ffffffffc02042ba:	d7a50513          	addi	a0,a0,-646 # ffffffffc0206030 <default_pmm_manager+0xea8>
ffffffffc02042be:	e03fb0ef          	jal	ra,ffffffffc02000c0 <cprintf>
readline(const char *prompt) {
ffffffffc02042c2:	4481                	li	s1,0
>>>>>>> 747620b (lab2)
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
<<<<<<< HEAD
ffffffffc02042e2:	497d                	li	s2,31
=======
ffffffffc02042c4:	497d                	li	s2,31
>>>>>>> 747620b (lab2)
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
<<<<<<< HEAD
ffffffffc02042e4:	49a1                	li	s3,8
=======
ffffffffc02042c6:	49a1                	li	s3,8
>>>>>>> 747620b (lab2)
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
<<<<<<< HEAD
ffffffffc02042e6:	4aa9                	li	s5,10
ffffffffc02042e8:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02042ea:	0000db97          	auipc	s7,0xd
ffffffffc02042ee:	e0eb8b93          	addi	s7,s7,-498 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02042f2:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02042f6:	e03fb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc02042fa:	00054a63          	bltz	a0,ffffffffc020430e <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02042fe:	00a95a63          	bge	s2,a0,ffffffffc0204312 <readline+0x54>
ffffffffc0204302:	029a5263          	bge	s4,s1,ffffffffc0204326 <readline+0x68>
        c = getchar();
ffffffffc0204306:	df3fb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc020430a:	fe055ae3          	bgez	a0,ffffffffc02042fe <readline+0x40>
            return NULL;
ffffffffc020430e:	4501                	li	a0,0
ffffffffc0204310:	a091                	j	ffffffffc0204354 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0204312:	03351463          	bne	a0,s3,ffffffffc020433a <readline+0x7c>
ffffffffc0204316:	e8a9                	bnez	s1,ffffffffc0204368 <readline+0xaa>
        c = getchar();
ffffffffc0204318:	de1fb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc020431c:	fe0549e3          	bltz	a0,ffffffffc020430e <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204320:	fea959e3          	bge	s2,a0,ffffffffc0204312 <readline+0x54>
ffffffffc0204324:	4481                	li	s1,0
            cputchar(c);
ffffffffc0204326:	e42a                	sd	a0,8(sp)
ffffffffc0204328:	dcffb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            buf[i ++] = c;
ffffffffc020432c:	6522                	ld	a0,8(sp)
ffffffffc020432e:	009b87b3          	add	a5,s7,s1
ffffffffc0204332:	2485                	addiw	s1,s1,1
ffffffffc0204334:	00a78023          	sb	a0,0(a5)
ffffffffc0204338:	bf7d                	j	ffffffffc02042f6 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020433a:	01550463          	beq	a0,s5,ffffffffc0204342 <readline+0x84>
ffffffffc020433e:	fb651ce3          	bne	a0,s6,ffffffffc02042f6 <readline+0x38>
            cputchar(c);
ffffffffc0204342:	db5fb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            buf[i] = '\0';
ffffffffc0204346:	0000d517          	auipc	a0,0xd
ffffffffc020434a:	db250513          	addi	a0,a0,-590 # ffffffffc02110f8 <buf>
ffffffffc020434e:	94aa                	add	s1,s1,a0
ffffffffc0204350:	00048023          	sb	zero,0(s1)
=======
ffffffffc02042c8:	4aa9                	li	s5,10
ffffffffc02042ca:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02042cc:	0000db97          	auipc	s7,0xd
ffffffffc02042d0:	e2cb8b93          	addi	s7,s7,-468 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02042d4:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02042d8:	e21fb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc02042dc:	00054a63          	bltz	a0,ffffffffc02042f0 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02042e0:	00a95a63          	bge	s2,a0,ffffffffc02042f4 <readline+0x54>
ffffffffc02042e4:	029a5263          	bge	s4,s1,ffffffffc0204308 <readline+0x68>
        c = getchar();
ffffffffc02042e8:	e11fb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc02042ec:	fe055ae3          	bgez	a0,ffffffffc02042e0 <readline+0x40>
            return NULL;
ffffffffc02042f0:	4501                	li	a0,0
ffffffffc02042f2:	a091                	j	ffffffffc0204336 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02042f4:	03351463          	bne	a0,s3,ffffffffc020431c <readline+0x7c>
ffffffffc02042f8:	e8a9                	bnez	s1,ffffffffc020434a <readline+0xaa>
        c = getchar();
ffffffffc02042fa:	dfffb0ef          	jal	ra,ffffffffc02000f8 <getchar>
        if (c < 0) {
ffffffffc02042fe:	fe0549e3          	bltz	a0,ffffffffc02042f0 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204302:	fea959e3          	bge	s2,a0,ffffffffc02042f4 <readline+0x54>
ffffffffc0204306:	4481                	li	s1,0
            cputchar(c);
ffffffffc0204308:	e42a                	sd	a0,8(sp)
ffffffffc020430a:	dedfb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            buf[i ++] = c;
ffffffffc020430e:	6522                	ld	a0,8(sp)
ffffffffc0204310:	009b87b3          	add	a5,s7,s1
ffffffffc0204314:	2485                	addiw	s1,s1,1
ffffffffc0204316:	00a78023          	sb	a0,0(a5)
ffffffffc020431a:	bf7d                	j	ffffffffc02042d8 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020431c:	01550463          	beq	a0,s5,ffffffffc0204324 <readline+0x84>
ffffffffc0204320:	fb651ce3          	bne	a0,s6,ffffffffc02042d8 <readline+0x38>
            cputchar(c);
ffffffffc0204324:	dd3fb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            buf[i] = '\0';
ffffffffc0204328:	0000d517          	auipc	a0,0xd
ffffffffc020432c:	dd050513          	addi	a0,a0,-560 # ffffffffc02110f8 <buf>
ffffffffc0204330:	94aa                	add	s1,s1,a0
ffffffffc0204332:	00048023          	sb	zero,0(s1)
>>>>>>> 747620b (lab2)
            return buf;
        }
    }
}
<<<<<<< HEAD
ffffffffc0204354:	60a6                	ld	ra,72(sp)
ffffffffc0204356:	6486                	ld	s1,64(sp)
ffffffffc0204358:	7962                	ld	s2,56(sp)
ffffffffc020435a:	79c2                	ld	s3,48(sp)
ffffffffc020435c:	7a22                	ld	s4,40(sp)
ffffffffc020435e:	7a82                	ld	s5,32(sp)
ffffffffc0204360:	6b62                	ld	s6,24(sp)
ffffffffc0204362:	6bc2                	ld	s7,16(sp)
ffffffffc0204364:	6161                	addi	sp,sp,80
ffffffffc0204366:	8082                	ret
            cputchar(c);
ffffffffc0204368:	4521                	li	a0,8
ffffffffc020436a:	d8dfb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            i --;
ffffffffc020436e:	34fd                	addiw	s1,s1,-1
ffffffffc0204370:	b759                	j	ffffffffc02042f6 <readline+0x38>

ffffffffc0204372 <strlen>:
=======
ffffffffc0204336:	60a6                	ld	ra,72(sp)
ffffffffc0204338:	6486                	ld	s1,64(sp)
ffffffffc020433a:	7962                	ld	s2,56(sp)
ffffffffc020433c:	79c2                	ld	s3,48(sp)
ffffffffc020433e:	7a22                	ld	s4,40(sp)
ffffffffc0204340:	7a82                	ld	s5,32(sp)
ffffffffc0204342:	6b62                	ld	s6,24(sp)
ffffffffc0204344:	6bc2                	ld	s7,16(sp)
ffffffffc0204346:	6161                	addi	sp,sp,80
ffffffffc0204348:	8082                	ret
            cputchar(c);
ffffffffc020434a:	4521                	li	a0,8
ffffffffc020434c:	dabfb0ef          	jal	ra,ffffffffc02000f6 <cputchar>
            i --;
ffffffffc0204350:	34fd                	addiw	s1,s1,-1
ffffffffc0204352:	b759                	j	ffffffffc02042d8 <readline+0x38>

ffffffffc0204354 <strlen>:
>>>>>>> 747620b (lab2)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
<<<<<<< HEAD
ffffffffc0204372:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0204376:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0204378:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020437a:	cb81                	beqz	a5,ffffffffc020438a <strlen+0x18>
        cnt ++;
ffffffffc020437c:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020437e:	00a707b3          	add	a5,a4,a0
ffffffffc0204382:	0007c783          	lbu	a5,0(a5)
ffffffffc0204386:	fbfd                	bnez	a5,ffffffffc020437c <strlen+0xa>
ffffffffc0204388:	8082                	ret
    }
    return cnt;
}
ffffffffc020438a:	8082                	ret

ffffffffc020438c <strnlen>:
=======
ffffffffc0204354:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0204358:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020435a:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020435c:	cb81                	beqz	a5,ffffffffc020436c <strlen+0x18>
        cnt ++;
ffffffffc020435e:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0204360:	00a707b3          	add	a5,a4,a0
ffffffffc0204364:	0007c783          	lbu	a5,0(a5)
ffffffffc0204368:	fbfd                	bnez	a5,ffffffffc020435e <strlen+0xa>
ffffffffc020436a:	8082                	ret
    }
    return cnt;
}
ffffffffc020436c:	8082                	ret

ffffffffc020436e <strnlen>:
>>>>>>> 747620b (lab2)
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
<<<<<<< HEAD
ffffffffc020438c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020438e:	e589                	bnez	a1,ffffffffc0204398 <strnlen+0xc>
ffffffffc0204390:	a811                	j	ffffffffc02043a4 <strnlen+0x18>
        cnt ++;
ffffffffc0204392:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204394:	00f58863          	beq	a1,a5,ffffffffc02043a4 <strnlen+0x18>
ffffffffc0204398:	00f50733          	add	a4,a0,a5
ffffffffc020439c:	00074703          	lbu	a4,0(a4)
ffffffffc02043a0:	fb6d                	bnez	a4,ffffffffc0204392 <strnlen+0x6>
ffffffffc02043a2:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02043a4:	852e                	mv	a0,a1
ffffffffc02043a6:	8082                	ret

ffffffffc02043a8 <strcpy>:
=======
ffffffffc020436e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204370:	e589                	bnez	a1,ffffffffc020437a <strnlen+0xc>
ffffffffc0204372:	a811                	j	ffffffffc0204386 <strnlen+0x18>
        cnt ++;
ffffffffc0204374:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204376:	00f58863          	beq	a1,a5,ffffffffc0204386 <strnlen+0x18>
ffffffffc020437a:	00f50733          	add	a4,a0,a5
ffffffffc020437e:	00074703          	lbu	a4,0(a4)
ffffffffc0204382:	fb6d                	bnez	a4,ffffffffc0204374 <strnlen+0x6>
ffffffffc0204384:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0204386:	852e                	mv	a0,a1
ffffffffc0204388:	8082                	ret

ffffffffc020438a <strcpy>:
>>>>>>> 747620b (lab2)
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
<<<<<<< HEAD
ffffffffc02043a8:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02043aa:	0005c703          	lbu	a4,0(a1)
ffffffffc02043ae:	0785                	addi	a5,a5,1
ffffffffc02043b0:	0585                	addi	a1,a1,1
ffffffffc02043b2:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02043b6:	fb75                	bnez	a4,ffffffffc02043aa <strcpy+0x2>
=======
ffffffffc020438a:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020438c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204390:	0785                	addi	a5,a5,1
ffffffffc0204392:	0585                	addi	a1,a1,1
ffffffffc0204394:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204398:	fb75                	bnez	a4,ffffffffc020438c <strcpy+0x2>
>>>>>>> 747620b (lab2)
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
<<<<<<< HEAD
ffffffffc02043b8:	8082                	ret

ffffffffc02043ba <strcmp>:
=======
ffffffffc020439a:	8082                	ret

ffffffffc020439c <strcmp>:
>>>>>>> 747620b (lab2)
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
<<<<<<< HEAD
ffffffffc02043ba:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02043be:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02043c2:	cb89                	beqz	a5,ffffffffc02043d4 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02043c4:	0505                	addi	a0,a0,1
ffffffffc02043c6:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02043c8:	fee789e3          	beq	a5,a4,ffffffffc02043ba <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02043cc:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02043d0:	9d19                	subw	a0,a0,a4
ffffffffc02043d2:	8082                	ret
ffffffffc02043d4:	4501                	li	a0,0
ffffffffc02043d6:	bfed                	j	ffffffffc02043d0 <strcmp+0x16>

ffffffffc02043d8 <strchr>:
=======
ffffffffc020439c:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02043a0:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02043a4:	cb89                	beqz	a5,ffffffffc02043b6 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02043a6:	0505                	addi	a0,a0,1
ffffffffc02043a8:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02043aa:	fee789e3          	beq	a5,a4,ffffffffc020439c <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02043ae:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02043b2:	9d19                	subw	a0,a0,a4
ffffffffc02043b4:	8082                	ret
ffffffffc02043b6:	4501                	li	a0,0
ffffffffc02043b8:	bfed                	j	ffffffffc02043b2 <strcmp+0x16>

ffffffffc02043ba <strchr>:
>>>>>>> 747620b (lab2)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
<<<<<<< HEAD
ffffffffc02043d8:	00054783          	lbu	a5,0(a0)
ffffffffc02043dc:	c799                	beqz	a5,ffffffffc02043ea <strchr+0x12>
        if (*s == c) {
ffffffffc02043de:	00f58763          	beq	a1,a5,ffffffffc02043ec <strchr+0x14>
    while (*s != '\0') {
ffffffffc02043e2:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02043e6:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02043e8:	fbfd                	bnez	a5,ffffffffc02043de <strchr+0x6>
    }
    return NULL;
ffffffffc02043ea:	4501                	li	a0,0
}
ffffffffc02043ec:	8082                	ret

ffffffffc02043ee <memset>:
=======
ffffffffc02043ba:	00054783          	lbu	a5,0(a0)
ffffffffc02043be:	c799                	beqz	a5,ffffffffc02043cc <strchr+0x12>
        if (*s == c) {
ffffffffc02043c0:	00f58763          	beq	a1,a5,ffffffffc02043ce <strchr+0x14>
    while (*s != '\0') {
ffffffffc02043c4:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02043c8:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02043ca:	fbfd                	bnez	a5,ffffffffc02043c0 <strchr+0x6>
    }
    return NULL;
ffffffffc02043cc:	4501                	li	a0,0
}
ffffffffc02043ce:	8082                	ret

ffffffffc02043d0 <memset>:
>>>>>>> 747620b (lab2)
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
<<<<<<< HEAD
ffffffffc02043ee:	ca01                	beqz	a2,ffffffffc02043fe <memset+0x10>
ffffffffc02043f0:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02043f2:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02043f4:	0785                	addi	a5,a5,1
ffffffffc02043f6:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02043fa:	fec79de3          	bne	a5,a2,ffffffffc02043f4 <memset+0x6>
=======
ffffffffc02043d0:	ca01                	beqz	a2,ffffffffc02043e0 <memset+0x10>
ffffffffc02043d2:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02043d4:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02043d6:	0785                	addi	a5,a5,1
ffffffffc02043d8:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02043dc:	fec79de3          	bne	a5,a2,ffffffffc02043d6 <memset+0x6>
>>>>>>> 747620b (lab2)
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
<<<<<<< HEAD
ffffffffc02043fe:	8082                	ret

ffffffffc0204400 <memcpy>:
=======
ffffffffc02043e0:	8082                	ret

ffffffffc02043e2 <memcpy>:
>>>>>>> 747620b (lab2)
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
<<<<<<< HEAD
ffffffffc0204400:	ca19                	beqz	a2,ffffffffc0204416 <memcpy+0x16>
ffffffffc0204402:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204404:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204406:	0005c703          	lbu	a4,0(a1)
ffffffffc020440a:	0585                	addi	a1,a1,1
ffffffffc020440c:	0785                	addi	a5,a5,1
ffffffffc020440e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204412:	fec59ae3          	bne	a1,a2,ffffffffc0204406 <memcpy+0x6>
=======
ffffffffc02043e2:	ca19                	beqz	a2,ffffffffc02043f8 <memcpy+0x16>
ffffffffc02043e4:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02043e6:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02043e8:	0005c703          	lbu	a4,0(a1)
ffffffffc02043ec:	0585                	addi	a1,a1,1
ffffffffc02043ee:	0785                	addi	a5,a5,1
ffffffffc02043f0:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02043f4:	fec59ae3          	bne	a1,a2,ffffffffc02043e8 <memcpy+0x6>
>>>>>>> 747620b (lab2)
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
<<<<<<< HEAD
ffffffffc0204416:	8082                	ret
=======
ffffffffc02043f8:	8082                	ret
>>>>>>> 747620b (lab2)
