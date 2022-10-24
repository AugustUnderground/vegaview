{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

-- | VegaList Plot Viewer
module Graphics.Vega.VegaLite.View ( show'
                                   ) where

import           System.Directory          (removeFile)
import           System.IO.Temp            (emptySystemTempFile)
import           System.Posix.User         (getLoginName)
import qualified Graphics.UI.Webviewhs  as WHS
import           Graphics.Vega.VegaLite
import qualified Data.Text              as TXT

-- | Takes path to vega plot and opens it in webview
openPlotWindow :: FilePath -> IO ()
openPlotWindow path = WHS.createWindowAndBlock params
  where
    uri    = TXT.pack $ "file://" ++ path
    params = WHS.WindowParams { WHS.windowParamsTitle      = "VegaLite Viewer"
                              , WHS.windowParamsUri        = uri
                              , WHS.windowParamsWidth      = 800
                              , WHS.windowParamsHeight     = 600
                              , WHS.windowParamsResizable  = True
                              , WHS.windowParamsDebuggable = True }

-- | Plot VegaLite with given Title
show' :: VegaLite -> IO ()
show' plt = do
    usr <- getLoginName
    tmp <- emptySystemTempFile (usr ++ "-vega") 
    toHtmlFile tmp plt >> openPlotWindow tmp >> removeFile tmp
