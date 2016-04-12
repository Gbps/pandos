global WRAP_keyboard_handler
extern keyboard_handler

section .text
align 4

; Keyboard Interrupt (IRQ1)
WRAP_keyboard_handler:
    pushad

    xor eax, eax
    in al, 0x60

    push eax
    call keyboard_handler
    add esp, 4

    mov al, 0x20
    out 0x20, al

    popad
    iret