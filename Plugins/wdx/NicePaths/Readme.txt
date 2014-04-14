NicePaths 1.10
--------------

NicePaths is a content plug-in for Total Commander.


Plug-in description
-------------------

NicePaths can be used to increase the readability of paths in search results.


Field descriptions
------------------

Full Path		Full path to file
File Name		File name only
Directory Path		Full path to directory of the file


System requirements
-------------------

Total Commander 6.50 or newer is required for this plug-in.


Use
---

Displaying a shortened path mainly makes sense in custom column views which display a search result. The author recommends to add a new column to a custom column view and set the column width as desired. Afterwards assign the field "nicepaths.Directory Path" to the column. Pay attention to the field unit. It should match the column width. If the file list font doesn't match the system default font you'll have to adjust the unit later to fit the path into the column.

Basic instructions on how to work with custom column views can be found in the Total Commander help file.

General information on content plug-ins can be found in the Total Commander Wiki:
http://www.ghisler.ch/wiki/index.php/Content_plugins


Known bugs and limitations
--------------------------

It's planned to a custom algorithm for optimal path display. In this version a system function is used which is fast but doesn't lead to optimal results in all cases. File names larger than the column will not be shortened and the function fails. In this case the unshortened path is returned.


Author contact
--------------

Visit the Total Commander Forum ( http://www.ghisler.ch ). Copyright (C) 2006-2012 Lefteous.


License and Liability
---------------------

Any liability for damage of any sort is hereby denied.
All rights reserved. This Total Commander plugin is copyrighted freeware.