{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FLib (haskellGDExtensionInit) where

-- Used to write values to the struct
import Foreign.C.Types (CInt (..))
import Foreign.Ptr (FunPtr, Ptr, nullPtr)
import Foreign.Storable (pokeByteOff)
import qualified Game as G

-- 1. Define Haskell types for the callback functions
-- Matches GDExtensionInitializeCallback signature in gdextension_interface.h
-- void (*)(void *p_userdata, GDExtensionInitializationLevel p_level);
type GDExtensionInitializeCallback = Ptr () -> CInt -> IO ()

type GDExtensionDeinitializeCallback = Ptr () -> CInt -> IO ()

-- 2. Implement the callback functions in Haskell (to be called by Godot)
initializeCallback :: Ptr () -> CInt -> IO ()
initializeCallback _userdata level = do
  putStrLn $ "[HASKELL] Initialize callback called for level: " ++ show level
  G.initialize (fromIntegral level)

deinitializeCallback :: Ptr () -> CInt -> IO ()
deinitializeCallback _userdata level = do
  putStrLn $ "[HASKELL] De-initialize callback called for level: " ++ show level
  G.deinitialize (fromIntegral level)

-- 3. 'foreign export' the Haskell functions to make them callable from C
foreign export ccall initializeCallback :: GDExtensionInitializeCallback

foreign export ccall deinitializeCallback :: GDExtensionDeinitializeCallback

-- 4. Wrappers to get the function pointer (FunPtr) of the exported functions
foreign import ccall "wrapper"
  mkInitCallback :: GDExtensionInitializeCallback -> IO (FunPtr GDExtensionInitializeCallback)

foreign import ccall "wrapper"
  mkDeinitCallback :: GDExtensionDeinitializeCallback -> IO (FunPtr GDExtensionDeinitializeCallback)

-- (Existing type definitions)
data GDExtensionInterfaceGetProcAddress_

data GDExtensionClassLibraryPtr_

data GDExtensionInitialization_ -- Type for Ptr GDExtensionInitialization_

type GDExtensionInterfaceGetProcAddress = Ptr GDExtensionInterfaceGetProcAddress_

type GDExtensionClassLibraryPtr = Ptr GDExtensionClassLibraryPtr_

type GDExtensionInitialization = Ptr GDExtensionInitialization_ -- Equivalent to C's GDExtensionInitialization*

-- 5. Modify the main initialization function
haskellGDExtensionInit ::
  GDExtensionInterfaceGetProcAddress ->
  GDExtensionClassLibraryPtr ->
  GDExtensionInitialization ->
  IO ()
haskellGDExtensionInit _p_get_proc_address _p_library r_initialization = do
  putStrLn "[HASKELL] 'haskellGDExtensionInit' CALLED! FFI bridge is working."

  -- Get the function pointers (FunPtr) to the Haskell callbacks
  initFunPtr <- mkInitCallback initializeCallback
  deinitFunPtr <- mkDeinitCallback deinitializeCallback

  -- Write values into the memory pointed to by 'r_initialization' (passed from C),
  -- following the layout of the GDExtensionInitialization struct.

  -- NOTE: Offsets are hardcoded assuming a 64-bit Linux environment.
  -- Layout: CInt (4 bytes), 4 bytes padding, Ptr (8 bytes), FunPtr (8 bytes), FunPtr (8 bytes)
  -- A proper Storable instance should be defined ideally, but using pokeByteOff for this minimal example.

  let offset_level = 0
  let offset_userdata = 8
  let offset_init = 16
  let offset_deinit = 24

  -- Field 1: minimum_initialization_level = GDEXTENSION_INITIALIZATION_CORE (0)
  pokeByteOff r_initialization offset_level (0 :: CInt)

  -- Field 2: userdata = NULL
  pokeByteOff r_initialization offset_userdata nullPtr

  -- Field 3: initialize = &initializeCallback
  pokeByteOff r_initialization offset_init initFunPtr

  -- Field 4: deinitialize = &deinitializeCallback
  pokeByteOff r_initialization offset_deinit deinitFunPtr

  putStrLn "[HASKELL] GDExtensionInitialization struct has been filled."
  return ()

-- 'foreign export' for the C stub (flib.c) to call
foreign export ccall
  haskellGDExtensionInit ::
    GDExtensionInterfaceGetProcAddress ->
    GDExtensionClassLibraryPtr ->
    GDExtensionInitialization ->
    IO ()
