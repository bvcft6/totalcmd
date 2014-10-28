 PE Viewer version 2.0
=======================

PE Viewer is intended to view the information on PE executable format modules (EXE, DLL, OCX, etc.). Plug-in shows functions imported and exported by the module, the detailed information about sections and headers of the module, and also the contained resources.

http://www.totalcmd.net/plugring/peviewer.html



 Change Log:
=============

-----
 2.0
-----
[*] Fixed error when viewing 64-bit module under 32-bit Windows. Checked working under Win2000 SP4.

------------
 2.0 Beta 5
------------
[*] Fixed compiler determination bug.
[*] Improved working with correpted or compressed resources.
[*] Small GUI fixes.
[*] Added default file extension addition when saving resources.

------------
 2.0 Beta 4
------------
[*] Fixed AV on plugin opening.
[*] Fixed sort direction on lists headers.
[*] Fixed lists sorting.

------------
 2.0 Beta 3
------------
[+] Added plugin configuration reading from custom PEViewer_config.ini.
[+] Added support of the PEiD signatures.
[+] "Copy" popup menu item in lists splitted into "Copy Line" and "Copy Value".
[+] Added entry point icon into sections list.
[+] Added option to disable remembering last opened tab.
[+] Added option to choose plugin settings storage: lsplugin.ini (common for all plugins) or own plugin ini.
[*] Improved validity check displaying.
[*] improved delayed modules displaying.
[*] Added support of icon resources with PNG data.
[*] Fixed pseudo-button under text label with image info on tab buttons line.
[*] Fixed columns resize in lists.
[*] Widened extension list of the plugin used by default.
[*] Fixed some bugs in import and export reading, in compiler determination.
[*] Deleted column with ordinal function number in import list. Ordinal now displayed in the Name column.
[*] Automatic compiler determination now disabled by default, added option to turn it on.
