
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "paging.h"
#include "kernel.h"
#include "bitmap.h"

#define KERNEL_PD BootPageDirectory;

uint32_t open_pages_map[32] = { 0 };

int getpagesize()
{
    return 1024 * 1024; // 4MiB pages
}

static inline void invlpg(void* m)
{
    /* Clobber memory to avoid optimizer re-ordering access before invlpg, which may cause nasty bugs. */
    asm volatile ( "invlpg (%0)" : : "b"(m) : "memory" );
}

// Map memory to kernel space
void* kmmap( int n_pages )
{
    return mmap(n_pages, (void*) 0xC0000000);
}

bool is_paddress_mapped( void* addr )
{
    uint32_t addr_u = (uint32_t) addr >> 22;
    return (bool)bm_get_bit(open_pages_map, addr_u);
}

void set_paddress_mapped( void* addr, bool mapped)
{
    uint32_t addr_u = (uint32_t) addr >> 22;
    if( mapped )
    {
        bm_set_bit(open_pages_map, addr_u);
    }
    else
    {
        bm_clear_bit(open_pages_map, addr_u);
    }
}

// Map memory to any base
void* mmap( int n_pages, void* addr_base)
{
    page_dict_t* kpage_root = &BootPageDirectory;

    int phys_page = 1; 
    bool page_ok = true;

    for( ; phys_page < 1024; phys_page++)
    {
        // Try to find a contigous block to allocate the new pages
        for( int i = 0; i < n_pages; i++)
        { 
            if(is_paddress_mapped((void*)(phys_page<<22)))
            {
                page_ok = false;
            }
        }  
        if( page_ok )
        {
            break;
        }
    }
    
    if( !page_ok )
    {
        // Could not find physical pages to map
        return NULL;
    }

    // Start entry in the PD
    uint32_t start_virt_entry = (uint32_t)addr_base>>22;

    // Returned location of new mapped memory
    uint32_t virt_base_addr = (uint32_t)addr_base;

    // Find continguous virtual pages
    for ( ; start_virt_entry < 1024; start_virt_entry++)
    {
        bool page_ok = true;
        for( int i = 0; i < n_pages; i++)
        {
            page_dict_t* entry = &kpage_root[start_virt_entry+i];
            if( entry->present )
            {
                page_ok = false;
            }
        }
        if( page_ok )
        {
            break;
        }
    }

    // Mark PDE pages present
    for( int i = 0; i < n_pages; i++)
    {
        // Calculate mapped address
        uint32_t phys_addr = ((phys_page+i)<<22);
        page_dict_t* entry = &kpage_root[start_virt_entry+i];
        entry->present = 1;
        entry->read_write = 1;
        entry->page_size = 1;
        entry->u32 |= phys_addr;

        // Invalidate page in the TLB
        invlpg((void*)phys_addr);
    }

    // Return address of the first page
    return (void*)(start_virt_entry<<22);
}

bool munmap( void* addr, int n_pages)
{
    uint32_t mmaped_addr = (uint32_t) addr;

    page_dict_t* kpage_root = &BootPageDirectory;
    int kpage_entry = (mmaped_addr>>22);

    // Remove page info
    for( int i = kpage_entry; i < kpage_entry+n_pages; i++)
    {
        page_dict_t* entry = &kpage_root[i];

        // Get the physical address of the page
        uint32_t phys_addr = (uint32_t)entry->phys_addr;

        // Allow the page to be remapped
        set_paddress_mapped((void*)phys_addr, 0);

        // Clear the page table entry
        entry->u32 = 0;
    }

    // Return success
    return true;
}