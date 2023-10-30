-- Validation.hs
module Validation where

import Text.Regex.PCRE

validateEmail :: String -> Bool
validateEmail email = email =~ "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
