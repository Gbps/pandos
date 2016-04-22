#include <stdbool.h>
#include <stdarg.h>
#include <stdint.h>
#include "stddef.h"
/*#include "stdio.h"*/
#include "terminal.h"
#include "string.h"


void* memmove(void* dstptr, const void* srcptr, size_t size)
{
    unsigned char* dst = (unsigned char*) dstptr;
    const unsigned char* src = (const unsigned char*) srcptr;
    if ( dst < src )
        for ( size_t i = 0; i < size; i++ )
            dst[i] = src[i];
    else
        for ( size_t i = size; i != 0; i-- )
            dst[i-1] = src[i-1];
    return dstptr;
}

size_t strlen(const char* string)
{
    size_t result = 0;
    while ( string[result] )
        result++;
    return result;
}

int memcmp(const void* aptr, const void* bptr, size_t size)
{
    const unsigned char* a = (const unsigned char*) aptr;
    const unsigned char* b = (const unsigned char*) bptr;
    for ( size_t i = 0; i < size; i++ )
        if ( a[i] < b[i] )
            return -1;
        else if ( b[i] < a[i] )
            return 1;
    return 0;
}

void* memset(void* bufptr, int value, size_t size)
{
    unsigned char* buf = (unsigned char*) bufptr;
    for ( size_t i = 0; i < size; i++ )
        buf[i] = (unsigned char) value;
    return bufptr;
}

void* memcpy(void* restrict dstptr, const void* restrict srcptr, size_t size)
{
    unsigned char* dst = (unsigned char*) dstptr;
    const unsigned char* src = (const unsigned char*) srcptr;
    for ( size_t i = 0; i < size; i++ )
        dst[i] = src[i];
    return dstptr;
}

int puts(const char* string)
{
    return printf("%s\n", string);
}

int putchar(int ic)
{
    char c = (char) ic;
    terminal_putchar(c);
    return ic;
}

static void print(const char* data, size_t data_length)
{
    for ( size_t i = 0; i < data_length; i++ )
        putchar((int) ((const unsigned char*) data)[i]);
}
 
int printf(const char* restrict format, ...)
{
    va_list parameters;
    va_start(parameters, format);
 
    int written = 0;
    size_t amount;
    bool rejected_bad_specifier = false;
 
    #define TO_HEX(i) (i <= 9 ? '0' + i : 'A' - 10 + i)

    while ( *format != '\0' )
    {
        if ( *format != '%' )
        {
        print_c:
            amount = 1;
            while ( format[amount] && format[amount] != '%' )
                amount++;
            print(format, amount);
            format += amount;
            written += amount;
            continue;
        }
 
        const char* format_begun_at = format;
 
        if ( *(++format) == '%' )
            goto print_c;
 
        if ( rejected_bad_specifier )
        {
        incomprehensible_conversion:
            rejected_bad_specifier = true;
            format = format_begun_at;
            goto print_c;
        }
 
        if ( *format == 'c' )
        {
            format++;
            char c = (char) va_arg(parameters, int /* char promotes to int */);
            print(&c, sizeof(c));
        }
        else if ( *format == 's' )
        {
            format++;
            const char* s = va_arg(parameters, const char*);
            print(s, strlen(s));
        }
        else if ( *format == 'x' )
        {
            format++;
            int x = (int) va_arg(parameters, int);
            char res[5];

            if (x <= 0xFF)
            {
                res[0] = TO_HEX(((x & 0xF0) >> 4));
                res[1] = TO_HEX((x & 0xF));
                print(res, 2);
            }
            else if (x <= 0xFFFF)
            {
                res[0] = TO_HEX(((x & 0xF000) >> 12));   
                res[1] = TO_HEX(((x & 0x0F00) >> 8));
                res[2] = TO_HEX(((x & 0x00F0) >> 4));
                res[3] = TO_HEX((x & 0x000F));

                print(res, 4);
            }
        }
        else
        {
            goto incomprehensible_conversion;
        }
    }
 
    va_end(parameters);
 
    return written;
}
