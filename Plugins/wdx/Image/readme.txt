Image content plugin
--------------------

Version 1.10

Use this plugin to compare images by content in synchronize directories. In addition fields for image dimensions are provided.


Field descriptions
------------------
Width             Image width in pixels
Height            Image height in pixels
Dimensions        Image dimensions in the following format: Width x Height 
Content           Compares an image (only available in synchronize directories)


System requirements
-------------------
Total Commander 6.5 is required for this plugin. To use the image compare function Total Commander 7.55 is required. 


Usage
-----
Use this plugin to compare images in synchronize directories. This can be useful if you have images in various locations which seem to be identical when looking at them directly but they differ in size or when using the normal compare by content function in synchronize directories. This plugin can help you to ensure that all pixels are actually identical.

Please note: It's not guaranteed that the two compared files are byte-identical even if the image data is identical. Contained metadata can still differ.

Here is how it works:
1. Select the directories to compare
2. Open synchronize directories
3. Make sure the option "by content" is checked
4. Click on the small button in the same line
5. A dialog pops up. Here you can add a filetype which should be compared by the plugin just like in colors by filetype.
6. Another dialog is displayed. Click the + button to add the following field definition: [=image.Bitmaps]
7. Confirm all open dialogs.
8. Press "Compare" button. Now all images included in the defined filetype and supported by the plugin will be checked. All images where the actual image data is identical will be marked with a special "images equal" icon.


Supported filetypes
-------------------
The plugin uses graphic functions provided by Microsoft Windows. The supported image formats may differ between Windows versions. Here on my Windows 7 system the following formats and extensions are supported:

- BMP
- DIB
- RLE
- JPG
- JPEG
- JPE
- JFIF
- GIF
- EMF
- WMF
- TIF
- TIFF
- PNG
- ICO
 

Contact
-------
There is a thread in the Total Commander forum which can be used to discuss problems, bug and suggestions:
http://www.ghisler.ch/board/viewtopic.php?t=25768


7. License and liability
------------------------
Any liability for damage of any sort is hereby denied.
All rights reserved. This Total Commander plug-in is copyrighted free ware.