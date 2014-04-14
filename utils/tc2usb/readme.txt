tc2usb v1.13

This tool can be used to copy an existing installation
of Total Commander to a standard USB stick. Please run
this tool from _within_ a currently running, locally
installed Total Commander, by double clicking on
tc2usb.exe inside of Total Commander!

You can choose to copy your settings and selected plugins
to the stick too. Paths to plugins and other files will
be changed to be relative to the Total Commander directory
on the stick. Please note that the RedirectSection option
in wincmd.ini will NOT be taken into account.

Christian Ghisler
http://www.ghisler.com

History:
20091215 Release version 1.13
20091215 Fixed: The new files TCMDLZMA.DLL and TCMDX64.EXE were not copied to the stick
20080718 Release version 1.12
20080718 Fixed: Suggest the highest drive letter which is accessible and either contains PortableApps folder, or is removable, or both
20080718 Fixed: Suppress operating system error when no card in card reader
20080718 Release version 1.11
20080718 Added: Also used on disks of type DRIVE_FIXED (e.g. USB harddisks) for PortableApps folder
20080718 Added: Also copy wciconex.dll and wciconex.inc
20080718 Fixed: Could not create folders multi-levels deep
20080315 Release version 1.1 beta
20080715 Added: Support for PortableApps.com menu - TC will be installed to x:\PortableApps\Total Commander\totalcmd
20080312 Release version 1.0
20080312 Fixed: Remove fake items from content plugin section
20080312 Added: Use new icon from TC 7.0
20080312 Added: Also copy new files from TC 7.0: tcmadmin.exe, wcmicons.inc
20051103 Release 0.93 beta
20051103 Added: Small icon to dialog box title+taskbar
20051103 Fixed: Minor UI fixes like removing "back" button on first page, increasing width of size fields
20051103 Fixed: Calculation of total space taken by selected plugins: If two entries reference the same directory, then count them only once
20051101 Release 0.92 beta
20051101 Added: Offer to install ini files located in the same directory as wincmd.ini (where plugins should normally store their settings)
20051101 Added: Complete redesign of interface, now using Wizard interface
20051028 Release 0.91 beta
20051028 Added: Installer will now create program starttc.exe in the root which will run Total Commander
20051028 Added: Detect if TC was already installed, and offer to reinstall or just add new plugins
20051028 Added: Install plugins which were in the same dir again in the same dir on the stick. First plugin determines location
20051027 Initial release 0.9 beta
