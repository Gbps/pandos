
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "paging.h"
#include "kernel.h"

#define KERNEL_PD BootPageDirectory;

int getpagesize()
{
    return 1024 * 1024; // 4MiB pages
}

static inline void invlpg(void* m)
{
    /* Clobber memory to avoid optimizer re-ordering access before invlpg, which may cause nasty bugs. */
    asm volatile ( "invlpg (%0)" : : "b"(m) : "memory" );
}

void* mmap( int length )
{
    page_dict_t* kpage_root = &BootPageDirectory;
    int start_entry = (0xC0000000>>22)-1;
    int n_pages = (length/getpagesize())+1;

    // Iterate over the table
    for( int j = start_entry; j < 1024; j++)
    {
        bool page_ok = true;
        // Try to find a continuous block to allocate the new pages
        for( int i = 0; i < n_pages; i++)
        {
            page_dict_t* entry = &kpage_root[j+i];
            if( entry->present )
            {
                page_ok = false;
                break;
            }
        }

        // Check if pages were ok
        if( page_ok )
        {
            // Returned location of new mapped memory
            uint32_t ret_addr = (j<<22);

            // Mark pages present
            for( int i = 0; i < n_pages; i++)
            {
                page_dict_t* entry = &kpage_root[j+i];
                entry->present = 1;
                entry->read_write = 1;
                entry->page_size = 1;
                entry->u32 |= ret_addr;
            }

            invlpg(ret_addr);

            // Return address of page
            return (void*)ret_addr;
        }
    }

    // Could not map the pages
    return NULL;
}

bool munmap( void* mmaped_addr, int length)
{
    if( mmaped_addr <= 0xC0000000 )
    {
        // Don't deallocate outside of kernel space
        return;
    }
    page_dict_t* kpage_root = &BootPageDirectory;
    int n_pages = (length/getpagesize())+1;
    int kpage_entry = (mmaped_addr>>22)-1;

    // Iterate over the table
    for( int j = kpage_entry; j < 1024; j++)
    {
        // Remove page info
        for( int i = 0; i < n_pages; i++)
        {
            page_dict_t* entry = &kpage_root[j+i];

            if( entry->present == 0 )
            {
                // Length was incorrect
                return 0;
            }

            // Clear the page able entry
            entry->u32 = 0;
        }

        invlpg(ret_addr);

        // Return address of page
        return 1;
    }

    // Could not unmap the pages
    return 0;
}