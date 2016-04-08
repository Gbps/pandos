 
#include <stdint.h>

typedef struct page_dict_t
{
    union
    {
        uint32_t u32;
        struct
        {
            uint32_t present : 1;
            uint32_t read_write : 1;
            uint32_t user_supervisor : 1;
            uint32_t writethrough : 1;
            uint32_t cachedisabled : 1;
            uint32_t accessed : 1;
            uint32_t _zero : 1;
            uint32_t page_size : 1;
            uint32_t _ignored : 1;
            uint32_t avail : 3 ;
            uint32_t phys_addr : 20;
        };
    };
} page_dict_t;

typedef struct page_table_t
{
    union
    {
        uint32_t u32;
        struct
        {
            uint32_t present : 1;
            uint32_t read_write : 1;
            uint32_t user_supervisor : 1;
            uint32_t writethrough : 1;
            uint32_t cachedisabled : 1;
            uint32_t accessed : 1;
            uint32_t dirty : 1;
            uint32_t global : 1;
            uint32_t avail : 3 ;
            uint32_t page_addr : 20;
        };
    };
} page_table_t;

void* mmap( int length, void* addr_base);

void* kmmap( int length );

bool munmap( void* mmaped_addr, int length);

extern page_dict_t BootPageDirectory;
#define KERNEL_PAGE_NUMBER (0xC0000000>>22)