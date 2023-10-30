-- Logger.hs
module Logger where

import Control.Monad.IO.Class (MonadIO, liftIO)

logInfo :: MonadIO m => String -> m ()
logInfo message = liftIO $ putStrLn $ "[INFO] " ++ message

logError :: MonadIO m => String -> m ()
logError message = liftIO $ putStrLn $ "[ERROR] " ++ message
