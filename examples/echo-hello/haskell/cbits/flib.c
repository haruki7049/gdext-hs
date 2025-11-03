#include "gdextension_interface.h" // Cabal が gdextension/ から見つけます
#include <stdio.h>

extern void haskell_gdextension_init(
    GDExtensionInterfaceGetProcAddress p_get_proc_address,
    GDExtensionClassLibraryPtr p_library,
    GDExtensionInitialization *r_initialization
);


GDExtensionBool GDE_EXPORT godot_haskell_entry(
    GDExtensionInterfaceGetProcAddress p_get_proc_address,
    GDExtensionClassLibraryPtr p_library,
    GDExtensionInitialization *r_initialization) 
{
    printf("[C STUB] Godot engine called 'godot_haskell_entry'.\n");
    printf("[C STUB] Handing control over to Haskell...\n");

    haskell_gdextension_init(p_get_proc_address, p_library, r_initialization);

    printf("[C STUB] Returned from Haskell.\n");

    return 1;
}
