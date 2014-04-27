ExeFormat_64 content plugin 0.6c for TotalCmd


About
=====

This plugin can show information about executable file:
currently supported are MZ, NE, LE/LX, PE(PE32/PE32+).
The following information is shown:

MZ: Magic number, Bytes on last page of file, Pages in file,
    Relocations, Size of header in paragraphs, Minimum extra
    paragraphs needed, Maximum extra paragraphs needed,
    Initial (relative) SS value, Initial SP value, Checksum,
    Initial IP value, Initial (relative) CS value, File
    address of relocation table, Overlay number, OEM
    identifier (for e_oeminfo), OEM information, File
    address of new exe header;

NE: Magic number, Target Operating system, Expected
    Windows version, LinkerVersion, Checksum of whole file,
    Automatic Data Segment, Initial heap allocation, Initial
    stack allocation, Initial CSIP setting, Initial SSSP
    setting, Count of file segments, Entries in Module
    Reference Table, Size of non-resident name table,
    Offset of Segment Table, Offset of Resource Table,
    Offset of resident name table, Offset of Module
    Reference Table, Offset of Imported Names Table,
    Offset of Non-resident Names Table, Count of movable
    entries, Segment alignment shift count, Count of
    resource segments, Other .EXE flags, offset to
    return thunks, offset to segment ref. BYTEs, Minimum
    code swap area size;
    
LE/LX: Magic number, The CPU type, Target Operating
    system, Version Number, Flag word, Number of memory
    pages, Object for EIP, Extended instruction pointer
    (EIP), Object for ESP, Extended stack pointer (ESP),
    Page size, Last Page size, Fixup section size, Fixup
    section checksum, Loader section size, Loader
    section checksum, Object table offset, Number of
    objects in module, Object page map offset, Object
    iterated data map offset, Resource Table Offset,
    Number of resource entries, Resident name table
    Offset, Entry Table Offset, Module Directive Table
    Offset, Number of module directives, Fixup Page
    Table Offset, Fixup Record Table Offset, Import
    Module Name Table Offset, Number of entries in IMNT,
    Import Proc Name Table Offset, Per-Page Checksum
    Table Offset, Enumerated Data Pages Offset, umber
    of preload pages, Non-resident Names Table Offset,
    Size of NRNT, NRNT Checksum, Object # for automatic
    data object, Debugging information Offset, Length
    of the debugging info, Pages in preload section,
    Pages in demand-load section, Size of heap - for
    16-bit apps, Number of instance pages in preload
    section of VXD file, Number of instance pages in
    demand load section of VXD file, Device ID for VxD,
    DDK version for VxD
    
PE(PE32/PE32+): Machine, NumberOfSections, TimeDateStamp,
    PointerToSymbolTable, NumberOfSymbols, SizeOfOptionalHeader,
    Magic, LinkerVersion, SizeOfCode, SizeOfInitializedData,
    SizeOfUninitializedData, AddressOfEntryPoint, BaseOfCode,
    BaseOfData, ImageBase, SectionAlignment, FileAlignment,
    OperatingSystemVersion, ImageVersion, SubsystemVersion,
    Win32VersionValue, SizeOfImage, SizeOfHeaders, CheckSum,
    Subsystem, DllCharacteristics, SizeOfStackReserve,
    SizeOfStackCommit, SizeOfHeapReserve, SizeOfHeapCommit,
    LoaderFlags, NumberOfRvaAndSizes, EntryPoint (RAW), Compiler


License
=======

MIT

History
=======
0.6c /by Konstantin Vlasov/
[+] Added 64-bit version
[-] Fixed bug with detecting some architectures
[-] Fixed bug with not finding Signs.txt in some cases
[-] Fixed 64-bit fields cut off to 32 bits
[-] Some minor fixes

0.6b
[-] - Fixed DllMain

0.6a
[-] - Fixed detect string


0.6
[*] - Changed all call function on plugin
[+] - Add new signatures


0.5b
[-] - Fixed names of the fields
[*] - "NULL EntryPoint" -> "NULL"


0.5a
[-] - Fixed search EntryPoint (if EntryPoint == NULL)
[+] - Increased velocity of the plugin functioning
[+] - Add new signatures(Thanks to Maciej Adamczyk)


0.5
[*] - Plugin full rewritten
[-] - Fixed PE32+ support
[-] - Fixed NE support
[-] - Fixed LE support
[-] - Fixed search EntryPoint
[*] - Plugin size decreased
[+] - Add new signatures
[+] - Add "Magic" to IMAGE_OS2_HEADER and IMAGE_VXD_HEADER


0.2
[+] - Background processing
[*] - Increased velocity of the plugin functioning
[+] - New signatures (by NEOx)
[-] - Fix small bug


0.1b - First release


==================
Contact the author

Sergey Urbanovich (original developer)
e-mail: UrbS(at)yandex(dot)ru

Konstantin Vlasov (further improvements)
E-mail: support@flint-inc.ru
