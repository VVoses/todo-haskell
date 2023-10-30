-- RateLimit.hs
module RateLimit where

import Web.Scotty
import Data.IORef
import Data.Time.Clock
import Control.Monad.IO.Class

rateLimitMiddleware :: IORef [(UTCTime, IP)] -> Middleware
rateLimitMiddleware ref app = do
  appWithRef <- liftIO $ newRateLimitRef ref
  rateLimitedApp <- ratelimitApp ref appWithRef
  return rateLimitedApp

newRateLimitRef :: IORef [(UTCTime, IP)] -> IO Application
newRateLimitRef ref = do
  return $ \req respond ->
    app req respond $ \res ->
      logRequest ref (getRequestIP req) >> return res

ratelimitApp :: IORef [(UTCTime, IP)] -> Application -> IO Application
ratelimitApp ref app = do
  return $ \req respond ->
    ratelimit ref req >> app req respond

logRequest :: IORef [(UTCTime, IP)] -> IP -> IO ()
logRequest ref ip = do
  now <- getCurrentTime
  atomicModifyIORef' ref (\reqList -> ((now, ip) : reqList, ()))

ratelimit :: IORef [(UTCTime, IP)] -> Request -> IO ()
ratelimit ref req = do
  reqList <- readIORef ref
  let recentReqs = takeWhile (\(time, _) -> diffUTCTime (getCurrentTime) time <= 900) reqList
  if length recentReqs >= 250
    then do
      let headers = [("Content-Type", "application/json")]
      let errorMsg = "{\"error\": \"Rate limit exceeded. Too many requests.\"}"
      respond (responseLBS status429 headers (fromString errorMsg))
    else return ()