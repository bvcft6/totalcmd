
  ------------------------------------------------------------------------
   About anytag.wlx 0.97
  ------------------------------------------------------------------------

    anytag.wlx is a lister plugin for Total Commander which displays
    metadata of audio files.

    It supports the following audio formats:

     * AAC  - Advanced Audio Coding
                Reading of ID3v1, APEv1, APEv2
     * APE  - Monkey's Audio
                Reading of ID3v1, APEv1, APEv2 
     * FLAC - Free Lossless Audio Codec
                Reading of Vorbis Comments
     * MP3  - MPEG Audio Layer 3
                Reading of ID3v1, ID3v2, APEv1, APEv2
     * MP4  - MPEG-4
                Reading of MP4/iTunes metadata
     * MPC  - Musepack
                Reading of ID3v1, APEv1, APEv2
     * OFR  - OptimFROG
                Reading of ID3v1, APEv1, APEv2
     * OFS  - OptimFROG DualStream
                Reading of ID3v1, APEv1, APEv2
     * OGG  - Ogg Vorbis
                Reading of Vorbis Comments
     * SPX  - Speex
                Reading of Vorbis Comments
     * TTA  - True Audio
                Reading of ID3v1, ID3v2, APEv1, APEv2
     * WMA  - Windows Media Audio 
                Reading of WMA Tag (only with Windows Media 9 Runtime installed)
     * WV   - WavPack
                Reading of ID3v1, APEv1, APEv2
                
     This plugin uses HTMLayout Component, copyright Terra Informatica 
     Software, Inc. (http://terrainformatica.com).    
    
  ------------------------------------------------------------------------
   Installation
  ------------------------------------------------------------------------
 
     * Just use the auto-install feature, if you use TC >= 6.50

     Otherwise:
     * Copy "anytag.wlx" and "anytag.any" to your Total Commander 
       directory (e.g. C:\Program Files\TotalCmd) or any other directory.
     * Lister -> Options -> Configure -> LS-Plugins -> Add -> Choose
       "anytag.wlx" from your Total Commander directory.
    

  ------------------------------------------------------------------------
   Configuration
  ------------------------------------------------------------------------

    The file "anytag.any" is a template file for the display of the audio
    file informations.
    You can modify this file and use any of the placeholders and internal
    functions offered by the plugin.

    If you have created a nice template, feel free to send me a copy of
    it. I would create a template archive for download, when there are a
    few templates.


  ------------------------------------------------------------------------
   Placeholders
  ------------------------------------------------------------------------

    Metadata:

      %artist%               Artist
      %album%                Album
      %comment%              Comment
      %genre%                Genre
      %title%                Title
      %track%                Track-Number
      %year%                 Year
      %fieldname%            Fieldname (any other fieldname)


    Technical info:

      %_bitrate%             Bitrate
      %_codec%               Codec
      %_length%              Length (formatted)
      %_length_seconds%      Length (in seconds)
      %_mode%                Mode
      %_samplerate%          Samplerate
      %_tag%                 Available tag types in file
      %_tag_read%            Displayed tag type
      %_tag_size%            Size of tags in bytes
      %_extra%               Some codec specific extra info


    File name / path info

      %_directory%           Directory name
      %_extension%           File extension without dot
      %_filename%            File name without extension
      %_filename_ext%        File name with extension
      %_filename_rel%        Relative file name
      %_path%                File name with path
      %_folderpath%          Path without file name


  ------------------------------------------------------------------------
   Internal functions
  ------------------------------------------------------------------------

     List of Metadata
       Command:    $list(pre, post, newline)
       Parameters: When evaluating this function, anytag.wlx will put
                   'pre' in front of, 'post' after the metadata field name
                   and 'newline' after the metadata value.
       Example:    $list( ,: <b>,</b><br />)
       This example uses bold font for metadata values.

     If
       Command:    $if(x,A,B)
       Parameters: If x is non-empty, output A, else B
       Example:    $if(%artist%,Artist: %artist%,)
       This example displays the Artist field if not empty

     Replace
       Command: $replace(string, from, to)
       Example: $replace(%artist%,_,-)
       This example replaces all underscores to dashes.
        
     Case conversion Normal
        Command: $caps(string)
        Example: $caps(%artist%)
        This example converts the given string to normal case.

     Case conversion UPPER
        Command: $upper(string)
        Example: $upper(%artist%)
        This example converts the given string to upper case.
        
     Case conversion lower
        Command: $lower(string)
        Example: $lower(%artist%)
        This example converts the given string to lower case.
        
     Pad decimal number with leading zeros
        Command: $num(x,y)
        Example: $num(%track%, 3)
        This example returns the tracknumber with three digits.

     Other functions
        $add(x,y)     adds y to x.
        $and(x,y)     returns true, if x and y are true (not 0 and not empty).
        $ansi(x)      returns the string x converted to the system codepage.
        $char(x)      returns ASCII-character no. x (0-255).
        $div(x,y)     divides x by y.
        $eql(x,y)     returns true, if x equals y.
        $fmtNum(x)    formats number x with seperator for thousands according to current locale settings.
        $geql(x,y)    returns true, if x is greater as or equal to y.
        $grtr(x,y)    returns true, if x is greater as y.
        $if(x,y,z)    if x is true, y is returned, otherwise z.
        $ifgreater(a,b,x,y) if number a is greater than number b, x is returned, otherwise y.
        $iflonger(a,b,x,y) if string a is longer than number b, x is returned, otherwise y.
        $isdigit(x)   returns true if character x is a decimal number.
        $left(x,n)    leftmost n characters of text x.
        $len(x)       returns the length of string x.
        $leql(x,y)    returns true, if x is lesser as or equal to y.
        $less(x,y)    returns true, if x is lesser as y.
        $mid(x,n,i)   first i characters of text x, starting at character n.
        $mod(x,y)     returns the remainder of x divided by y.
        $mul(x,y)     multiplies x by y.
        $neql(x,y)    returns true, if x not equal to y.
        $not(x)       returns true, if x is 0 or empty.
        $odd(x)       returns true, if x is odd.
        $or(x,y)      returns true, if x or y is true (not 0 and not empty).
        $rand()       returns a pseudorandom number >= 0.
        $right(x,n)   rightmost n characters of text x.
        $strchr(x,y)  finds the first occurrence of character y in string x.
        $strrchr(x,y) finds the last occurrence of character y in string x.
        $strstr(x,y)  finds the first occurrence of string y in string x.
        $sub(x,y)     substracts y from x.


  ------------------------------------------------------------------------
   Autor
  ------------------------------------------------------------------------
  
    Florian Heidenreich 
    http://www.mp3tag.de/en/tc.html


  ------------------------------------------------------------------------
   Version History
  ------------------------------------------------------------------------

    02.07.06 Release anytag.wlx 0.97
    30.06.06   Added: text selection 
    10.06.06   Changed: htmlayout.dll now in plugin folder
    
    05.06.06 Release anytag.wlx 0.96
    05.06.06   Changed: full support for ID3v2.4
    05.06.06   Changed: switched to HTML template files
    
    07.12.05 Release anytag.wlx 0.95
    07.12.05   Added: scripting function $ansi(x,y)
    07.12.05   Added: scripting function $ifgreater(a,b,x,y)
    07.12.05   Added: scripting function $iflonger(a,b,x,y)
    07.12.05   Added: scripting function $isdigit(x)
    07.12.05   Added: scripting function $len(x)
    07.12.05   Added: scripting function $rand()
    07.12.05   Added: scripting function $strchr(x,y)
    07.12.05   Added: scripting function $strrchr(x,y)
    07.12.05   Added: scripting function $strstr(x,y)
    30.11.05   Fixed: technical information for WavPack lossy wasn't displayed if there was no WavPack correction file.
    30.11.05   Added: support for DISCNUMBER, TOTALDISCS and CONTENTGROUP at MP4 tags.
    30.11.05   Changed: COMPLIATION now ITUNESCOMPILATION for MP4 tags.
    27.11.05   Fixed: WMA bitrate wasn't displayed correctly on some files.
    27.11.05   Changed: arithmetic scripting functions are using 64 bit ints now to prevent overflows. 
    24.11.05   Added: full support for Unicode ID3v2 tags.
    24.11.05   Added: scripting functions for use in anytag.any template file.
    24.11.05   Added: ansi setting to decode non-unicode ID3v2 tags with system codepage.
    24.11.05   Changed: format of the anytag.any template file (old format is not supported anymore).
    24.11.05   Changed: Windows 9x/ME are not supported anymore (anytag.wdx 0.92 is still available for download).
    24.11.05   Changed: removed UPX compression because there are issues with binaries build by Visual Studio 2005.
    
    19.01.05 Release anytag.wlx 0.94
    19.01.05   Fixed: plugin did not read tags of Windows Media Audio files

    31.10.04 Release anytag.wlx 0.93
    31.10.04   Added: scripting function $add(x,y)
    31.10.04   Added: scripting function $and(x,y)
    31.10.04   Added: scripting function $char(x)
    31.10.04   Added: scripting function $div(x,y)
    31.10.04   Added: scripting function $eql(x,y)
    31.10.04   Added: scripting function $fmtNum(x)
    31.10.04   Added: scripting function $geql(x,y)
    31.10.04   Added: scripting function $grtr(x,y)
    31.10.04   Added: scripting function $left(x,n)
    31.10.04   Added: scripting function $leql(x,y)
    31.10.04   Added: scripting function $less(x,y)
    31.10.04   Added: scripting function $meta(x)
    31.10.04   Added: scripting function $mid(x,n,i)
    31.10.04   Added: scripting function $mul(x,y)
    31.10.04   Added: scripting function $neql(x,y)
    31.10.04   Added: scripting function $not(x)
    31.10.04   Added: scripting function $odd(x)
    31.10.04   Added: scripting function $or(x,y)
    31.10.04   Added: scripting function $right(x,n)
    31.10.04   Added: scripting function $sub(x,y)
    02.08.04   Added: support for WavPack 4.0

    05.05.04 Release anytag.wlx 0.92
    05.05.04   Added: support for OptimFROG with ID3v1, APEv1, APEv2
    05.05.04   Added: support for OptimFROG DualStream with ID3v1, APEv1, APEv2
    01.05.04   Added: support for True Audio with ID3v1, ID3v2, APEv1, APEv2

    09.03.04 Release anytag.wlx 0.91
    09.03.04   Fixed: $list always shows data of first displayed audio file

    09.03.04 Release anytag.wlx 0.90

    
  ------------------------------------------------------------------------
   License
  ------------------------------------------------------------------------
  
    anytag.wlx - Copyright ©2004-2006 Florian Heidenreich

    anytag.wlx is designed for private use and commercial use without sale
    ("Freeware"), if the following rules are respected:

    The Author, Florian Heidenreich, has no responsibility if errors
    occures in direct or indirect relation with the software.

    anytag.wlx cannot be used in a military domain or in a similar domain 
    (weapon creation, armament, etc.).

    anytag.wlx can be distributed through non-commercial channels.

    anytag.wlx can be distributed through commercial channels if the 
    author, Florian Heidenreich, agrees this delivery.

  ------------------------------------------------------------------------
