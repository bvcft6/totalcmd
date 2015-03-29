-------------------------------------------------------------------------------
  TConsole 2.2
-------------------------------------------------------------------------------

TConsole is FS-plugin to run console in the built-in console window in TC.  

-------------------------------------------------------------------------------
  Requirements
-------------------------------------------------------------------------------
Total Commander 7.5 or higher
Windows XP or higher

-------------------------------------------------------------------------------
  Changes History
-------------------------------------------------------------------------------

Version 2.2
- Added 64 bit support
- Added TC 7.5/8.x support

Version 2.1
- Fixed bug with dynamic console layout.
- Added scrolling console window by mouse wheel.
- Added mouse wheel sensitivity setting.
- Fixed bug with "Shift" key state.
- Added QuickEdit Mode. When some text is selected right mouse button copies 
  selected text to the clipboard and resets selection. Otherwise text from 
  clipboard is pasted. In QuickEdit mode Options dialog is displayed on "long" 
  right click (more then 0.5 sec).
- Added "Quick Copy&Paste" by right mouse button while left button still pressed.
- Added "Change Console Width" option to change automatically console width 
  to Comments view width.
- Added "Brief View on Hide" option to set automatically TC panel 
  to Full view or Brief view width when console window is closed.

Version 2.0
- "Secure input mode" renamed to "Direct mode" as opposite to "Command input mode"
- Added hotkeys for all menu items
- Added scrolling in Direct mode with RightShift+Arrows keys
- Added sound scheme support
- Removed Autodetach option
- Changed Option dialog behavior. Now it doesn't prevent console input/output.
- Detached console placed to foreground.
- Added user-definable hotkeys to be forwarded to TC in "Standard mode".
  Hotkey definition contains key and optional modifier(s).

Keys are letters, digits, F1-F24, NUM_0-NUM_9 and the following words:

BACK,
TAB,
ENTER,
ESCAPE,
SPACE,
PAGEUP,	
PAGEDOWN,	
END,	
HOME,	
LEFT,	
UP,	
RIGHT,	
DOWN,
INSERT,	 
DELETE,
NUM_MULTIPLY,
NUM_ADD,
NUM_SUBTRACT,
NUM_DECIMAL,
NUM_DIVIDE,
PLUS, 
COMMA.

Modifiers are Alt, Ctrl, Shift. Modifiers can be prefixed by L or R (i.e. LAlt+F1)	


Version 1.9
- Version for TC 6.0

Version 1.8
- Fixed bug related to totalcmd.ini file location

Version 1.7
- Fixed memory leaking bug
- Fixed bug with focus losing after Alt+Left/Right
- Fixed bug with selection in Far East languages

Version 1.6
- Added DBCS support
- Added Copy&Paste as single action (Ctrl+Shift+Insert)
- Fixed bug with plugin rename
- Fixed bug with focus losing after Alt+Left/Right

Version 1.5
- Added Windows NT support
- Added partially Select & Copy to clipboard
- Added Paste from clipboard (simulate keyboard input)
- Added support Ctrl+C, Ctrl+Break (send Break signal to the console) 
- Added hotkeys Ctrl/Shift+Insert (Copy/Paste) 
- Added hotkey to return back to TC panel (Alt+Ctl+4, optionally Alt+Left/Right)
- Fixed bug with 'Numpad Enter' key
- Fixed bug with saving of settings
- Fixed bug with vertical panels location

Version 1.4
- Added option "Close on Hide".
- Added hotkeys to switch on/off secure mode (Alt+Ctrl+1/2)
- Added option "Start in secure mode"
- Added blinking cursor to console window when focus belong to console
- Improved keyboard handling
- Fixed bug with big screen buffer size
- Fixed bug with translation extended ASCII symbols.
- Fixed bug with autodetach feature.

-------------------------------------------------------------------------------
FS plugin key features:
-------------------------------------------------------------------------------
- Run both 32 and 16-bit console applications
- Allow to set custom command processor.
- Detach current console and run a new console instance.
- Allow avoid storing some strings in TC history by switching into "secure" mode 
  (Alt+Ctrl+1/2/3). 
  Alt+Ctrl+1/2 switch secure mode on/off
  Alt+Ctrl+3 switch to secure mode until ENTER or ESC key pressed.
- Set (sync) console current directory to directory from other panel.
- "Close on Hide" option. When this option unchecked hiding console windows doesn't cause closing console itself, so you can leave program running in the console and return back later.

-------------------------------------------------------------------------------
  Installation
-------------------------------------------------------------------------------
  In TC menu Configuration/Options|Operation|FS-Plugins button

-------------------------------------------------------------------------------
  Usage
-------------------------------------------------------------------------------
  Assigne command "cd \\\TConsole" to button or shortcut
or  
  Choose [TConsole] folder in TC "Network Neighborhood"

-------------------------------------------------------------------------------
Author: MGP Software Ltd. & maximdw  
Email: tconsole@gmx.com