OUTPUT_ARCH(%ARCH%)

ENTRY(_start)

/* from kmem crate */
INCLUDE memory.x

SECTIONS
{
    . = __kernel_load_vma;
    
    BootText : {
        KEEP(*(.text.boot.header))
        KEEP(*pie_boot-*.o(.text*))
    } 
    BootData : ALIGN(4K) {
        *pie_boot-*.o(.rodata* .got* .data* .sdata* .bss* .sbss* COMMON)
    } 

    text : ALIGN(4K) {
        *any_uart-*.o(.text*)
        *page_table_generic-*.o(.text*)
        *fdt-parser-*.o(.text*)
        *(.text .text.*)
    } 

    rodata : ALIGN(4K) {
        *(.rodata .rodata.*)
        *(.got .got.*)
    } 
    
    .data : ALIGN(4K) {
        __srwdata = .;
        *(.data*)
        . = ALIGN(4K);
        __global_pointer$ = . + 0x800;
        *(.sdata.*)
    }

    .init_array : ALIGN(0x10) {
        __init_array_start = .;
        *(.init_array .init_array.*)
        __init_array_end = .;
    }

    percpu : ALIGN(4K) {
        __kernel_load_size = . - __start_BootText;
        __erwdata = .;

        *(.percpu*)
    } 

    bss (NOLOAD) : ALIGN(4K)  {
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        *(COMMON)
        . = ALIGN(4K);

        __boot_stack_bottom = .;
    } 


	/DISCARD/ : {
        *(.comment) *(.gnu*) *(.note*) *(.eh_frame*)
    }
} 

SECTIONS {
    linkme_IRQ : { *(linkme_IRQ) }
    linkm2_IRQ : { *(linkm2_IRQ) }
    linkme_PAGE_FAULT : { *(linkme_PAGE_FAULT) }
    linkm2_PAGE_FAULT : { *(linkm2_PAGE_FAULT) }
    linkme_SYSCALL : { *(linkme_SYSCALL) }
    linkm2_SYSCALL : { *(linkm2_SYSCALL) }
    axns_resource : { *(axns_resource) }
}
INSERT AFTER .init_array