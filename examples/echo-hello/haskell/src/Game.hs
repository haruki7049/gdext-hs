module Game
  ( initialize,
    deinitialize,
  )
where

initialize :: Int -> IO ()
initialize level = do
  putStrLn $ "[Game Library] Logic initialized! Level: " ++ show level

deinitialize :: Int -> IO ()
deinitialize level = do
  putStrLn $ "[Game Library] Logic de-initialized. Level: " ++ show level
