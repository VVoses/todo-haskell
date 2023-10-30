-- main.hs
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Database
import Config
import Auth
import Routes.Todo -- Add this import

main :: IO ()
main = do
  let config = defaultConfig
  let database = emptyDatabase

  scotty (port config) $ do
    -- Serve the main.html file
    get "/" $ file "main.html"

    todoRoutes -- Change this line to 'todoRoutes' from 'get "/todos" $ ...'
