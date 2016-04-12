
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "kernel.h"
#include "paging.h"
#include "mem.h"
#include "terminal.h"
#include "liballoc.h"
#include "interrupts.h"
#include "gdt.h"

void kernel_main() 
{
    asm("xchg %bx, %bx");

    gdt_init();

    idt_init();

    /* Initialize terminal interface */
    terminal_initialize();
 
    terminal_writestring("Hello, kernel World!\n");

    void* test_mem = kmalloc(10);
    void* test_mem_2 = kmalloc(10);

    kfree(test_mem);
    kfree(test_mem_2);

    test_mem = kmalloc(10);
    test_mem_2 = kmalloc(10);

    terminal_writestring((const char*)test_mem);

    while(true)
    {
        // Halt and wait for interrupts now that kernel is done.
        asm("hlt");
    }
}
