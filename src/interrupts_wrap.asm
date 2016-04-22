global WRAP_keyboard_handler
global WRAP_catchall
extern keyboard_handler

section .text
align 4

; Keyboard Interrupt (IRQ1)
WRAP_keyboard_handler:
    pushad

    xor eax, eax
    in al, 0x60

    cmp al, 0xE0
    je escape

    noescape:
    push 0
    push eax
    call keyboard_handler
    add esp, 8
    jmp keyboard_handler_end

    escape:
    push 1
    in al, 0x60
    push eax
    call keyboard_handler
    add esp, 8
    keyboard_handler_end:

    mov al, 0x20
    out 0x20, al

    popad
    iret

WRAP_catchall:
    push eax
    mov al, 0x20
    out 0xA0, al
    out 0x20, al
    pop eax
    iret