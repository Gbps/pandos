#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "terminal.h"
#include "string.h"
#include "mem.h"
#include "keyboard.h"
#include "math.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define TERMINAL_BUFFER_ROWS 1000

/* Hardware text mode color constants. */

uint8_t make_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg << 4;
}
 
uint16_t make_vgaentry(char c, uint8_t color) {
    uint16_t c16 = c;
    uint16_t color16 = color;
    return c16 | color16 << 8;
}

 
int terminal_row;
int terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;
size_t terminal_maxcolumn = 0;
size_t terminal_maxrow = 0;

char terminal_strbuf[TERMINAL_BUFFER_ROWS][VGA_WIDTH+1] = {0};

size_t terminal_bufrow = 0;

void terminal_invalidateposition();

char* terminal_strbuf_getrow(size_t y)
{
    return terminal_strbuf[y];
}

uint8_t terminal_curlinelen()
{
    char* cur_row = terminal_strbuf_getrow(terminal_row);
    int len = strlen(cur_row);
    return len;
}

void terminal_goto_EOL()
{
    terminal_column = terminal_curlinelen();
}

void terminal_initialize() {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
    terminal_buffer = (uint16_t*) (0xC0000000 + 0xB8000); // Kernel VBASE+0xB8000
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = make_vgaentry(' ', terminal_color);
        }
    }
}

void terminal_strbuf_putchar(char c, size_t x, size_t y)
{
    terminal_strbuf[y][x] = c;
}

void terminal_scroll_up(size_t n)
{
    terminal_row -= n;
    terminal_invalidateposition();
}

void terminal_scroll_down(size_t n)
{
    terminal_row -= n;
    terminal_invalidateposition();
}

void terminal_scroll_left(size_t n)
{
    terminal_column -= n;
    terminal_invalidateposition();
}

void terminal_scroll_right(size_t n)
{
    terminal_column += n;
    terminal_invalidateposition();
}

void terminal_setcolor(uint8_t color) {
    terminal_color = color;
}

void terminal_drawcursor()
{
     const size_t index = (terminal_row-terminal_bufrow) * VGA_WIDTH + terminal_column;
     terminal_buffer[index] = make_vgaentry(' ', make_color(COLOR_WHITE, COLOR_WHITE));
}

void terminal_refresh()
{
    for( int x = 0; x < VGA_WIDTH; x++)
    {
        for( int y = 0; y < VGA_HEIGHT; y++)
        {
            char c = terminal_strbuf[y+terminal_bufrow][x];
            const size_t index = y * VGA_WIDTH + x;
            if( c == 0x00 )
            {
                terminal_buffer[index] = make_vgaentry(' ', terminal_color);
            }
            else
            {
                terminal_buffer[index] = make_vgaentry(c, terminal_color);
            }
        }
    }
    terminal_drawcursor();
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) 
{
    terminal_strbuf_putchar(c, x, y);
}


bool terminal_handlewhitespace(char c)
{
    switch( c )
    {
        case '\n':
            terminal_row += 1;
            terminal_column = 0;
            break;
        case '\r':
            terminal_column = 0;
            break;
        case '\t':
            terminal_putchar(' ');
            terminal_putchar(' ');
            terminal_putchar(' ');
            break;
        case '\b':
            terminal_column -= 1;
            terminal_putentryat(0x00, terminal_color, terminal_column, terminal_row);
            break;

        default:
            return false;
            break;
    }

    return true;

}

void terminal_invalidateposition()
{
    if( terminal_row >= TERMINAL_BUFFER_ROWS )
    {
        // Handle overflow better :/
        terminal_row = 0;
    }
    else if( terminal_row < 0 )
    {
        terminal_row = 0;
    }

    uint8_t linelen = terminal_curlinelen();

    if( terminal_column > linelen)
    {
        terminal_column = linelen;
    }

    if( terminal_column > VGA_WIDTH)
    {
        terminal_column = terminal_column - VGA_WIDTH;
        terminal_row += 1;
    }
    else if( terminal_column < 0 )
    {
        terminal_row -= 1;
        terminal_goto_EOL();
    }

    int diff = (terminal_row-terminal_bufrow);
    if( diff > VGA_HEIGHT-1 )
    {
        terminal_bufrow += diff-(VGA_HEIGHT-1);
    }

    if( diff < 0 )
    {
        terminal_bufrow -= 0-diff;
    }

    terminal_refresh();
}

void terminal_putchar(char c) 
{
    if (!terminal_handlewhitespace(c))
    {
        terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
        terminal_column += 1;
        terminal_maxcolumn = terminal_column;
    }

    terminal_invalidateposition();
}
 
void terminal_writestring(const char* data) {
    size_t datalen = strlen(data);
    for (size_t i = 0; i < datalen; i++)
        terminal_putchar(data[i]);
}

void terminal_ondirectionkey(uint8_t scancode)
{
    uint8_t linelen = terminal_curlinelen();
    switch(scancode)
    {
        case KEY_ARROW_UP:
            terminal_row -= 1;
            terminal_column = terminal_maxcolumn;
            terminal_invalidateposition();
        break;

        case KEY_ARROW_DOWN:
            terminal_row += 1;
            terminal_column = terminal_maxcolumn;
            terminal_invalidateposition();
        break;

        case KEY_ARROW_LEFT:
            terminal_column -= 1;
            terminal_invalidateposition();
            terminal_maxcolumn = terminal_column;
        break;

        case KEY_ARROW_RIGHT:

            if( terminal_column == linelen )
            {
                terminal_row += 1;
                terminal_column = 0;
                terminal_maxcolumn = 0;
                terminal_invalidateposition();
                return;
            }
            terminal_column += 1;
            terminal_invalidateposition();
            terminal_maxcolumn = terminal_column;
        break;
    }
}