{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Main (main) where

-- import qualified Graphics.UI.Webviewhs as WHS
import qualified Graphics.Vega.VegaLite.View   as Plt
import qualified Graphics.Vega.VegaLite.Simple as Plt

main :: IO ()
main = do
    Plt.show' $ Plt.barChart xLabel yLabel columns freqs
  where
    xLabel  = "foo"
    yLabel  = "bar"
    columns = ["cat", "dog", "horse"]
    freqs   = [0.4, 0.8, 0.5]

-- main :: IO ()
-- main = do
--     putStrLn "BEFORE"
--     WHS.createWindowAndBlock params
--     putStrLn "AFTER"
--   where
--     params = WHS.WindowParams { WHS.windowParamsTitle      = "PLOT"
--                               , WHS.windowParamsUri        = "https://augustunderground.github.io/vegaview"
--                               , WHS.windowParamsWidth      = 800
--                               , WHS.windowParamsHeight     = 600
--                               , WHS.windowParamsResizable  = True
--                               , WHS.windowParamsDebuggable = True }
