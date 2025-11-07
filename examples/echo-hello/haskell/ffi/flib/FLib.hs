{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FLib (haskellGdextensionInit) where

import Foreign.Ptr (Ptr)

data GDExtensionInterfaceGetProcAddress_

data GDExtensionClassLibraryPtr_

data GDExtensionInitialization_

type GDExtensionInterfaceGetProcAddress = Ptr GDExtensionInterfaceGetProcAddress_

type GDExtensionClassLibraryPtr = Ptr GDExtensionClassLibraryPtr_

type GDExtensionInitialization = Ptr GDExtensionInitialization_

haskellGdextensionInit ::
  GDExtensionInterfaceGetProcAddress ->
  GDExtensionClassLibraryPtr ->
  GDExtensionInitialization ->
  IO ()
haskellGdextensionInit p_get_proc_address p_library r_initialization = do
  putStrLn "[HASKELL] 'haskellGdextensionInit' CALLED! The FFI bridge is working."
  return ()

foreign export ccall "haskell_gdextension_init"
  haskellGdextensionInit ::
    GDExtensionInterfaceGetProcAddress ->
    GDExtensionClassLibraryPtr ->
    GDExtensionInitialization ->
    IO ()
