{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

-- | Simple Plot functions for convenience
module Graphics.Vega.VegaLite.Simple ( heatmap
                                     , barChart
                                     , barChartErr
                                     , densityPlot
                                     ) where

import           Graphics.Vega.VegaLite as VL
import           Data.Aeson                     (object)
import qualified Data.Text              as TXT

-- | Heatmap with given x and y columns.
heatmap ::  ([DataColumn] -> [DataColumn]) -> TXT.Text -> TXT.Text -> TXT.Text
        -> [Double] -> VegaLite
heatmap colIds xAx yAx zAx grd = toVegaLite [ dat [] , enc [] , cfg [] , mrk [] ]
  where
    dat = dataFromColumns [] . colIds . dataColumn zAx (Numbers   grd)
    cfg = configure . configuration (Axis [Grid True, TickBand BExtent])
    enc = encoding . position X [ PName xAx, PmType Nominal ] 
                   . position Y [ PName yAx, PmType Ordinal ]
                   . color      [ MName zAx, MAggregate Mean ]
    mrk = mark Rect

-- | Draw a bar chart
barChart :: TXT.Text -> TXT.Text -> [TXT.Text] -> [Double] -> VegaLite
barChart xLabel yLabel cols vec = toVegaLite [ dat [], enc [], cfg [], mrk [] ]
  where
    dat = dataFromColumns [] . dataColumn xLabel (Strings cols) 
                             . dataColumn yLabel (Numbers vec)
    enc = encoding . position X [ PName xLabel, PmType Nominal ] 
                   . position Y [ PName yLabel, PmType Quantitative ]
    cfg = configure . configuration (Axis [ Grid True
                                          , TickBand BExtent
                                          , LabelAngle 270.0
                                          ])
    mrk = mark Bar

-- | Draw a bar chart with error bar
barChartErr :: TXT.Text -> TXT.Text -> [TXT.Text] -> [Double] -> Double -> VegaLite
barChartErr xLabel yLabel cols vec err = toVegaLite [ layers ]
  where
    dat    = dataFromColumns [] . dataColumn xLabel (Strings cols)
                                . dataColumn "Value" (Numbers vec)
    enc    = encoding . position X [ PName xLabel, PmType Ordinal ]
                      . position Y [ PName "Value", PmType Quantitative ]
    expr   = TXT.append "datum.Value >= " (TXT.pack . show $ err)
    enc'   = encoding . position X  [ PName xLabel, PmType Ordinal ]
                      . position Y  [ PName "baseline", PmType Quantitative
                                    , PTitle yLabel ]
                      . position Y2 [ PName "Value" ]
                      . color       [ MString "#e45755" ]
    trf    = transform . VL.filter (FExpr expr)
                       . calculateAs (TXT.pack . show $ err) "baseline"
    mrk    = mark Bar
    lay    = layer [ asSpec [ mrk [], enc [] ]
                   , asSpec [ mrk [], trf [], enc' [] ] ]
    jsn    = object []
    dat'   = dataFromJson jsn
    enc''  = encoding . position Y  [ PDatum (Number err) ]
    mrk'   = mark Rule
    mrk''  = mark Text
    lay'   = layer [ asSpec [ mrk' [] ]
                   , asSpec [ mrk'' [ MAlign AlignRight
                                    , MBaseline AlignBottom
                                    , MText "Critical"
                                    , MdX (-2.0)
                                    , MdY (-2.0)
                                    , MXWidth
                                    ] ] ]
    layers = layer [ asSpec [ dat [], lay ]
                   , asSpec [ dat' [], enc'' [], lay' ] ]

-- | Draw Density Plot
densityPlot :: TXT.Text -> [Double] -> VegaLite
densityPlot xLabel vec = toVegaLite [ dat [], trf [], enc [], mrk [] ]
  where
    dat = dataFromColumns [] . dataColumn xLabel (Strings [xLabel])
                             . dataColumn "value" (Numbers vec)
    trf = transform . density "value" [ DnBandwidth 0.3 ]
    enc = encoding . position X [ PName "value", PTitle xLabel
                                , PmType Quantitative ]
                   . position Y [ PName "density", PmType Quantitative ]
    mrk = mark Area
