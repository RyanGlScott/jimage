{-# LANGUAGE ForeignFunctionInterface #-}
module Bindings.JImage
  ( -- * @libjimage@ bindings
    c_JIMAGE_Close
  , c_JIMAGE_FindResource
  , c_JIMAGE_GetResource
  , c_JIMAGE_Open

    -- * @libjimage@-specific types
  , JImageFile
  , JImageLocationRef

    -- * JNI types
  , JBoolean
  , JByte
  , JChar
  , JDouble
  , JFloat
  , JInt
  , JLong
  , JShort
  ) where

import Data.Int (Int16, Int32, Int64)
import Data.Word (Word8, Word16)
import Foreign.C.String (CString)
import Foreign.C.Types (CChar)
import Foreign.Ptr (Ptr)

-- JNI primitive types
type JBoolean = Word8
type JByte    = CChar
type JChar    = Word16
type JDouble  = Double
type JFloat   = Float
type JInt     = Int32
type JLong    = Int64
type JShort   = Int16

data JImageFile
type JImageLocationRef = JLong

foreign import ccall unsafe "JIMAGE_Open"
  c_JIMAGE_Open :: CString -> Ptr JInt -> IO (Ptr JImageFile)
foreign import ccall unsafe "JIMAGE_Close"
  c_JIMAGE_Close :: Ptr JImageFile -> IO ()
foreign import ccall unsafe "JIMAGE_FindResource"
  c_JIMAGE_FindResource :: Ptr JImageFile -> CString -> CString -> CString -> Ptr JLong -> IO JImageLocationRef
foreign import ccall unsafe "JIMAGE_GetResource"
  c_JIMAGE_GetResource :: Ptr JImageFile -> JImageLocationRef -> CString -> JLong -> IO JLong
