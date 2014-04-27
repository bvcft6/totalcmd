@echo off
: parameters
: 1:  in file(chm)
: 2:  out file(html)
set t=%temp%\chm.tmp
set o=%2
:hh -decompile %t% %1
Unchmw e %1 %t%\ *.htm*
echo. > %o%
type %t%\*.html >> %o%
type %t%\*.htm >> %o%
echo y| del %t%\*.*
rmdir %t%

