-- Config.hs
module Config where

data AppConfig = AppConfig
  { port :: Int
  , dbConnectionString :: String
  }

defaultConfig :: AppConfig
defaultConfig = AppConfig
  { port = 3000
  , dbConnectionString = "localhost:5432/mydatabase"
  }
