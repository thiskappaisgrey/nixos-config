module MyXMonad.AppPrompt where

import System.Directory
import System.FilePath
import Control.Monad 

-- parse desktop files
import Text.Parsec

import Text.Parsec.Language (emptyDef)
import qualified Text.Parsec.Token as P

-- TODO Rewrite using 
import Text.Parsec.String 

-- HashMap is more efficeint, but I'm too lazy to expose it as a dependency
import qualified  Data.Map.Strict as M

desktopFiles :: IO [FilePath]
desktopFiles = do
  dirs <- getXdgDirectoryList XdgDataDirs
  appDirs <- filterM doesDirectoryExist $ map (</> "applications") dirs
  deskFiles <- mapM ( listDirectory  >=> return . filter (isExtensionOf "desktop")) appDirs 
  return $ concat deskFiles
-- Parse each desktop file
-- data DesktopFile = DesktopFile {
--   d_name :: String
--   , d_exec :: String
--   -- TODO For now, I'll only support application, but later maybe also show more stuff?
--   -- , d_type :: String
--   -- , d_categories :: [String]
--  } deriving Show

-- A map where keys are pretty printed string of the app
-- and values are the "exec" strings
-- TODO Exec strings can also have specifications too, so maybe you can do something with it?
type DesktopFiles = M.Map String String



-- TODO maybe try to not use parsec to parse the desktop files?
-- If I do want to contribute, then it would add a dependency which is not ideal...
-- but I can prob write a version without using parsec
-- TODO Not sure if I can add icons, but it would probably 


-- deskDef = emptyDef {
  
--   P.commentStart = "#"
--   , P.reservedOpNames = ["="]
--   , P.opLetter = oneOf "=;"
--                    }
-- lexer = P.makeTokenParser deskDef
-- whiteSpace = P.whiteSpace lexer
-- lexeme = P.lexeme lexer
-- reservedOp = P.reservedOp lexer
-- identifier = P.identifier lexer



-- parseItem :: Parser (String, String)
-- parseItem = lexeme $
--   do
--   id <- manyTill anyChar (try (reservedOp "="))
--   id1 <- manyTill anyChar (try $ void  (oneOf "\n\t") <|> eof)
--   return (id, id1)
--   -- return $ M.singleton id id1
-- -- I just need a couple of keys: "Type" "Exec" and "Name"
-- parseDesktopFile :: Parser DesktopFile
-- parseDesktopFile = do
--   whiteSpace
--   void $ string "[Desktop Entry]"
--   whiteSpace
   
  
--   -- m <- chainl parseItem (return M.union) M.empty
--   -- let a = pure DesktopFile <*> M.lookup "Name" m <*> M.lookup "Exec" m
--   -- case a of
--   --   Nothing -> fail "Missing either Name or Exec"
--   --   Just d -> return d
  
-- -- TODO Now that I have a list of desktop files, I can parse them into a list!
-- processDesktopFiles :: [FilePath] -> IO [DesktopFile]
-- processDesktopFiles files = undefined


-- -- TODO Finally, create the list of completions
-- -- and make a prompt!
printDataDirs :: IO ()
printDataDirs = do
  d <- desktopFiles
  mapM_ putStrLn d
