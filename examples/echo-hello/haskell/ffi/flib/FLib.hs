{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FLib (haskellGDExtensionInit) where

import Foreign.Ptr (Ptr)

data GDExtensionInterfaceGetProcAddress_

data GDExtensionClassLibraryPtr_

data GDExtensionInitialization_

type GDExtensionInterfaceGetProcAddress = Ptr GDExtensionInterfaceGetProcAddress_

type GDExtensionClassLibraryPtr = Ptr GDExtensionClassLibraryPtr_

type GDExtensionInitialization = Ptr GDExtensionInitialization_

haskellGDExtensionInit ::
  GDExtensionInterfaceGetProcAddress ->
  GDExtensionClassLibraryPtr ->
  GDExtensionInitialization ->
  IO ()
haskellGDExtensionInit p_get_proc_address p_library r_initialization = do
  putStrLn "[HASKELL] 'haskellGDExtensionInit' CALLED! The FFI bridge is working."
  return ()

foreign export ccall
  haskellGDExtensionInit ::
    GDExtensionInterfaceGetProcAddress ->
    GDExtensionClassLibraryPtr ->
    GDExtensionInitialization ->
    IO ()
