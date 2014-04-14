TCMediaInfo 0.61 plugin for Total Commander
=========================================================

Plugin description
------------------
TCMediaInfo - is content plugin that allow to retreive info about many video and audio formats. Plugin use MediaInfo library, and support all formats that MediaInfo library have support for. Full list of formats you can find here:

http://mediainfo.sourceforge.net/Support/Formats

Prerequisites
-------------
This plugin has been tested with Total Commander 7.x and Total Commander 7.55 under Microsoft Windows XP Professional SP3 (x86), Vista SP1 and Windows 7 RTM.

Installation
------------
Just open wdx_tcmediainfo_xxx.zip in Total Commander, this will install the plugin automatically. 

Usage
-----
Since MediaInfo library can retreive a LOT information from file, plugin is fully customizable and allow to wrap any MediaInfo library's field. By default some most useful fields already configured and you can instantly start use plugun. Please refer Total Commander documentation on how to configure columns.

Configuration
-------------
If you need additional information that not configured by default, you have to edit TCMediaInfo.xml file, where all plugin settings are set. Refer allprops.txt file for full list of library properties. If you update library MediaInfo.dll to new version, run saveprops.bat for creating newer version of this file.

In configurtion file you can see four main xml nodes.


Settings node:
<options>
  <Formats>AVI,MKV,...</Formats>
  <MultiSeparator> / </MultiSeparator>
  <BasePath>base.db</BasePath>
  <UseBase>True</UseBase>
  <SqlitePath>Sqlite3.dll</SqlitePath>
</options>

Formats - here you set a list of all extensions supported by plugin, separated by comma.

MultiSeparator - here you set string, that will separate multiple results (for example list of sound languages).

BasePath - path to database file. Environment variables are allowed. 

UseBase - set to True if yiu want to use database.

SqlitePath - here you can set the custom path of Sqlite3.dll. By default plugin searching the library in it's folder. Environment variables are allowed.

Sources node:
<sources>
  <source name="SourceName" field="MediaLibraryField" context="MediaLibraryFieldContext" stream="StreamNumber"/>
</sources>

Here you define the "sources" - info that will be retrieved from library and (optionally) saved to database. Each <source> node can have attributes:

name="SourceName" - name of source. It can be only latin alphanumeric plus underscore. Defined name will become a database field name, and as variable in the scripts.

field="MediaLibraryField" - the MediaLibrary field name (refer to allprops.txt)

context="MediaLibraryFieldContext" (optional) - since many library fields with the same name return different info for different kinds of objects (container, video, audio etc), and some work only in certain context, you can to set it. Context can be one of General, Video, Audio, Text, Chapters, Image, Menu. If this attribute omitted, will be retreived General context (usually container or just common properties).

stream="StreamNumber" (optional) - number of stream, for which info will be retreived. If instead number will be "*" - info about all available streams of this kind will be collected (they will be separated with string, defined in MultiSeparator parameter).

Columns node:
<columns>
  <column name="ColumnName" coltype="ColumnOutputType">SourceName</column>
  <column name="ColumnName" type="template">SourceName1, SourceName2</column>
  <column name="ColumnName" type="list" list="ListName">SourceName</column>
  <column name="ColumnName" type="script">begin {script content here} end.</column>
  <column name="ColumnName" type="script">
  <![CDATA[
    begin 
      {script content here} 
    end.
  ]]>  
  </column>
</columns>

Here you define the columns, as they are will be appeared in Total Commander. 

Each <column> node can have attributes:

name="ColumnName" - name (usually english) of column, as this will be appeared in Total Commander. 

type="<single|template|list|script>" - defining, how to treat the node text. This can be "single" - the node text is name of source itself, "template" - source names in this text will be replaced by their values, "list" - value of source will be searched in list and replaced by some value, if foun (refer to lists section), "script" - the script (refer to scripting section). If attribute omitted, text will treated as "single".

Text of node can be wrapped to CDATA section, though this is useful only for multiline scripts.

<column> node also can contain <unit> subnodes. They are handling the same as columns and can have the same attributes. Don't use any "type" attribute in <column> node if you use units.

"coltype" (optional) - type of column's output value, it's need mostly for date/time format: ft_string, ft_numeric_32,  ft_numeric_32, ft_datetime. Default is ft_string.

Also, you can place <separator/> node between columns, this will appear as separator in Total Commander's menu.

Lists node:
<lists>
  <list name="ListName">
    <line name="SearchText">ReplaceText</line>
  </list>
  <list name="ListName" type="ini" file="{path to file, environment variables allowed}" section="{load from}"/>
</lists>

In this node you can define lists of terms that need to be replaced.

name="ListName" - name of list. It can be only non-latin alphanumeric plus underscore. Defined name can be used in columns of "list" type, or called by that name from script.

name="SearchText" - search text

ReplaceText - search text will be replaced by that text

type="ini" - list can be loaded from external ini-file. The name of file should be in "file" attribute (environment variables allowed). Also you should set in "section" attribute name of ini-file section. Ini can be ANSI or UTF-8 encoded.

Scripting

Scripting is allow you to visualize information in any kind.

In scripts you can use all names, defined for "sources", and special variable "Output" that will be displayed. All input variables and "Output" variable are have Variant type. This mean in many cases you can use it's value without additional conversions. Note, that when variant is string, it's actually UTF-8 stream.

You can use many Pascal functions in scripts. {will be updated}

Also defined special function for working with lists:

GetListValue(List: string; ID: string; Default: string): string;

List - name of list
ID - text that will be searched
Default - default value that will be used in case text not found

Translation
-----------
For translation of fields you can use standard TC's mechanism. Look to TCMediaInfo.lng file, it's content is obvious.


Version history
---------------
Version 0.6.2 (2011-02-06)
- Fixed appearing unneeded message on empty database
+ Readded ANSI-version
- Version info was not visible under Windows 7
+ Now possible to set custom database path

Version 0.6.1 (2010-09-14)
- Almost fixed shared DB access
+ Option to have in-memory (session) only database

Version 0.6 (2010-08-22)
* Plugin fully rewritten
* Pascal Script as scripting engine
* XML for store definitions and options
+ Column value can be constructed from multiple sources
+ Database for speedup loading (Sqlite3)
- Fixed non-working latest releases of library

Version 0.51 (unreleased)
+ Substitutions lists support
+ Now plugin not use detect string, it checks extension list that set in config
+ Added default config, so working one will not rewritten by installer

Version 0.50 (2009-09-07)
  First release.


Credits
-------
Christian Ghisler - for infinitely powerful tool.
MediaInfo team - for great library.


License
-------
Copyright (c) 2009-2010 Dmitry Yudin

This plugin is freeware.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
