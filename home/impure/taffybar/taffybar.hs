{-# LANGUAGE OverloadedStrings #-}
import System.Taffybar
import System.Taffybar.Information.CPU
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.Graph
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Battery
import StatusNotifier.Tray

import System.Taffybar.Widget.Layout
import System.Taffybar.Widget.Weather

import Data.Text  (append)

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main = do
  
  let cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                  , graphLabel = Just "cpu"
                                  }

      wcfg = (defaultWeatherConfig "KSFO") { weatherTemplate = "$tempF$ F @ $humidity$ %" }
      weatherWidget = weatherNew wcfg 10
      clock = textClockNewWith defaultClockConfig
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      workspaces = workspacesNew (defaultWorkspacesConfig {
                                     -- getWindowIconPixbuf = scaledWindowIconPixbufGetter getWindowIconPixbufFromEWMH ,
                                     showWorkspaceFn = \w -> ((workspaceName w) /= "NSP" )} )
      -- los = layoutNew defaultLayoutConfig
      
      mytray = sniTrayNewFromParams defaultTrayParams { trayLeftClickAction = PopupMenu
                                                      , trayRightClickAction = Activate
                                                      }
      simpleConfig = defaultSimpleTaffyConfig
                       { startWidgets = [ workspaces
                                        -- ,  los
                                        , layoutNew (LayoutConfig (\t -> return (append "layout: "  t))) 
                                        ]
                       -- TODO Add more widgets maybe??
                       , centerWidgets = [ clock ]
                       , endWidgets = [ mytray , textBatteryNew "$percentage$%($time$)", batteryIconNew, weatherWidget, cpu  ]
                       }
  simpleTaffybar simpleConfig
