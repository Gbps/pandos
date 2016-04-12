#include "interrupts.h"
#include <stdint.h>
#include "stddef.h"
#include "inline.c"
#include "terminal.h"

#define IDT_SIZE 1024

#define PIC1_CMD 0x20
#define PIC2_CMD 0xA0
#define PIC1_DATA 0x21
#define PIC2_DATA 0xA1

#define ICW_BEGIN_INIT 0x11
#define ICW_PICMAP_LOW 0x20
#define ICW_PICMAP_HIGH 0x28
#define ICW_NONE 0x00
#define ICW_ENVINFO 0x01
#define ICW4 0x01
#define ICW_MASK_ALL 0xFF

#define KERNEL_CODE_SEGMENT_OFFSET 0x08

#define INTERRUPT_GATE 0x8E

struct IDT_entry
{
    unsigned short int offset_lowerbits;
    unsigned short int selector;
    unsigned char zero;
    unsigned char type_attr;
    unsigned short int offset_higherbits;
};

struct IDT_entry IDT[IDT_SIZE];


struct interrupt_frame
{
    uint32_t ip;
    uint32_t cs;
    uint32_t flags;
    uint32_t sp;
    uint32_t ss;
};


void keyboard_handler(uint8_t scancode)
{
    terminal_writestring("Got keypress!\n");
}

void idt_init(void)
{
    unsigned long keyboard_address;
    unsigned long idt_addr;
    unsigned long idt_ptr[2];

    keyboard_address = (unsigned long)&WRAP_keyboard_handler;
    IDT[0x21].offset_lowerbits = keyboard_address & 0xFFFF;
    IDT[0x21].selector = KERNEL_CODE_SEGMENT_OFFSET; /* KERNEL_CODE_SEGMENT_OFFSET from GRUB~! */
    IDT[0x21].zero = 0;
    IDT[0x21].type_attr = 0x8E; /* INTERRUPT_GATE */
    IDT[0x21].offset_higherbits = (keyboard_address & 0xFFFF0000) >> 16;

    /*      Ports
    *        PIC1   PIC2
    *Command 0x20   0xA0
    *Data    0x21   0xA1
    */

    /* ICW1 - begin initialization */
    outb(PIC1_CMD, ICW_BEGIN_INIT);
    outb(PIC2_CMD, ICW_BEGIN_INIT);

    /* ICW2 - remap offset address of IDT */
    /*
    * In x86 protected mode, we have to remap the PICs beyond 0x20 because
    * Intel have designated the first 32 interrupts as "reserved" for cpu exceptions
    */
    outb(PIC1_DATA, ICW_PICMAP_LOW);
    outb(PIC2_DATA, ICW_PICMAP_HIGH);

    /* ICW3 - setup cascading */
    outb(PIC1_DATA , ICW_NONE);  
    outb(PIC2_DATA , ICW_NONE);  

    /* ICW4 - environment info */
    outb(PIC1_DATA , ICW_ENVINFO);
    outb(PIC2_DATA , ICW_ENVINFO);

    /* Initialization finished */

    /* Mask Interrupts */
    /* Disable all IRQs for now */
    outb(PIC1_DATA , ICW_MASK_ALL);
    outb(PIC2_DATA , ICW_MASK_ALL);

    /* Fill the IDT descriptor */
    //idt_address = (unsigned long)IDT ;
    //idt_ptr[0] = (sizeof (struct IDT_entry) * IDT_SIZE) + ((idt_address & 0xffff) << 16);
    //idt_ptr[1] = idt_address >> 16 ;

    // load_idt(idt_ptr);

    // Load IDT with LIDT
    //lidt((void*) (((uint32_t)IDT) & 0x00FFFFFF), (uint16_t) IDT_SIZE);
     lidt((void*)IDT, (uint16_t) IDT_SIZE);
    // Enable kerboard IRQ
    kb_init();

    asm("sti");

}

void kb_init(void)
{
    /* 0xFD is 11111101 - enables only IRQ1 (keyboard)*/
    outb(PIC1_DATA, 0xFD);
}