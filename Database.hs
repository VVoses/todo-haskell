-- Database.hs
module Database where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

type DBKey = String
type DBValue = String
type Database = Map DBKey DBValue

emptyDatabase :: Database
emptyDatabase = Map.empty

readValue :: DBKey -> Database -> Maybe DBValue
readValue key db = Map.lookup key db

writeValue :: DBKey -> DBValue -> Database -> Database
writeValue key value db = Map.insert key value db

deleteValue :: DBKey -> Database -> Database
deleteValue key db = Map.delete key db
