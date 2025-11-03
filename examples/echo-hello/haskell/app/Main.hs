module Main (main) where

import Foreign.C.String (CString, newCString)
import Foreign.C.Types (CChar (..))

foreign import ccall "stdio.h printf"
  c_printf :: CString -> IO ()

main :: IO ()
main = do
  message <- newCString "Hello"
  c_printf message
