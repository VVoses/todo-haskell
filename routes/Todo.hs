-- routes/Todo.hs
module Routes.Todo where

import Web.Scotty
import Database

todoRoutes :: ScottyM ()
todoRoutes = do
  get "/todos" $ do
    db <- liftAndCatchIO readDatabase
    json $ Map.elems db

  post "/todos" $ do
    todo <- jsonData :: ActionM String
    db <- liftAndCatchIO readDatabase
    let updatedDb = writeValue (generateKey db) todo db
    liftAndCatchIO $ writeDatabase updatedDb
    json ("Added: " ++ todo)

  put "/todos/:id" $ do
    id <- param "id"
    todo <- jsonData :: ActionM String
    db <- liftAndCatchIO readDatabase
    case updateValue id todo db of
      Just updatedDb -> do
        liftAndCatchIO $ writeDatabase updatedDb
        json ("Updated todo with id: " ++ id ++ " to: " ++ todo)
      Nothing ->
        raise "Todo not found"

  delete "/todos/:id" $ do
    id <- param "id"
    db <- liftAndCatchIO readDatabase
    case deleteValue id db of
      Just updatedDb -> do
        liftAndCatchIO $ writeDatabase updatedDb
        json ("Deleted todo with id: " ++ id)
      Nothing ->
        raise "Todo not found"

generateKey :: Database -> DBKey
generateKey db = "todo-" ++ show (Map.size db)

readDatabase :: IO Database
readDatabase = undefined -- Implement the logic to read the database from a file or another data source

writeDatabase :: Database -> IO ()
writeDatabase db = undefined -- Implement the logic to write the database to a file or another data source

updateValue :: DBKey -> DBValue -> Database -> Maybe Database
updateValue key value db =
  case readValue key db of
    Just _ -> Just $ writeValue key value db
    Nothing -> Nothing