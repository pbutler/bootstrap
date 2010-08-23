import XMonad

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


main = xmonad defaultConfig 
        { --modMask = mod4Mask -- Use Super instead of Alt
        terminal = "xterm",
	keys     = newKeys
        -- more changes
       }

newKeys x  = M.union (keys defaultConfig x) (M.fromList (myKeys x))

myKeys conf@(XConfig {XMonad.modMask = modm}) =
     [ ((modm, xK_quoteleft), windows W.focusDown)
     ]

