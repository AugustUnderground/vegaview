# vegaview

A [webviewhs](https://github.com/lettier/webviewhs) based plot viewer for
[hvega](https://github.com/DougBurke/hvega).

## Example

```haskell
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
```
