#include "HsFFI.h"
#include "gdextension_interface.h"
#include <stdio.h>

static void flib_init() __attribute__((constructor));
static void flib_init() {
  static char *argv[] = {"libecho-hello-plugin.so", "+RTS", "-N", 0},
              **argv_ = argv;
  static int argc = sizeof(argv) / sizeof(argv[0]) - 1;
  hs_init(&argc, &argv_);
}

static void flib_fini() __attribute__((destructor));
static void flib_fini() { hs_exit(); }

extern void
haskellGDExtensionInit(GDExtensionInterfaceGetProcAddress p_get_proc_address,
                         GDExtensionClassLibraryPtr p_library,
                         GDExtensionInitialization *r_initialization);

GDExtensionBool __attribute((visibility("default")))
godot_haskell_entry(GDExtensionInterfaceGetProcAddress p_get_proc_address,
                    GDExtensionClassLibraryPtr p_library,
                    GDExtensionInitialization *r_initialization) {
  printf("[C STUB] Godot engine called 'godot_haskell_entry'.\n");
  printf("[C STUB] Handing control over to Haskell...\n");

  haskellGDExtensionInit(p_get_proc_address, p_library, r_initialization);

  printf("[C STUB] Returned from Haskell.\n");

  return 1;
}
