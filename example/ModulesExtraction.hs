module Main (main) where

import Bindings.JImage
import Control.Monad
import Foreign
import Foreign.C.String

main :: IO ()
main =
  alloca $ \errorPtr ->
  alloca $ \sizePtr ->
  withCString "/usr/lib/jvm/java-11-openjdk-amd64/lib/modules" $ \jimageFileName ->
  withCString "java.base" $ \moduleName ->
  withCString "9.0" $ \versionStr ->
  withCString "java/lang/Object.class" $ \className -> do
    image <- c_JIMAGE_Open jimageFileName errorPtr
    when (image == nullPtr) $ do
      errorCode <- peek errorPtr
      fail $ "JImage failed to open: " ++ show errorCode

    location <- c_JIMAGE_FindResource image moduleName versionStr className sizePtr

    size <- peek sizePtr
    allocaArray (fromIntegral size) $ \buffer -> do
      actualSize <- c_JIMAGE_GetResource image location buffer size
      putStrLn $ "Predicated size: " ++ show size ++ ". Actual size: " ++ show actualSize
      -- TODO RGS
      c_JIMAGE_Close image
