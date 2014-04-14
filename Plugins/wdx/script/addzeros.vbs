'Script for Script Content Plugin
'(c)Lev Freidin, 2005
'http://www.totalcmd.net/plugring/script_wdx.html
'http://wincmd.ru/plugring/script_wdx.html

'Add Zeros to filenames for better sorting
'file1.txt   -> file001.txt
'file11.txt  -> file011.txt
'file111.txt -> file111.txt

set re=new regexp

content=filename

re.Pattern="(\D)(\d\.)"
b="$100$2"
If re.test(filename) then content = re.Replace(filename,b)

re.Pattern="(\D)(\d{2}\.)"
b="$10$2"
If re.test(filename) then content = re.Replace(filename,b)