Services2 file-system plugin for Total Commander


About
=====

Services2 is a file-system plugin that can list, control and manage the
services registered in the system.

General features:
- List services registered in the system
- Control service states
- Edit service properties
- Delete services from the system

System Requirements:
- Windows 2000 or later, both 32 and 64 bit
- Total Commander 7.50 or later, both 32 and 64 bit.

It is an alternative to the existing Services plugin (Version 2.4)
http://www.totalcmd.net/plugring/services.html
written by Serge Kandakov (KaSA).



Comparison with Services 2.4
============================

Services2 has some advantages over Services 2.4 but due to its early
development state it has some disadvantages, too. Note that some features
which Services 2.4 has will not be implemented in this plugin.


Advantages (things that Services 2.4 can't or doesn't do):
----------------------------------------------------------

- Show correct executable information in the file list of Total Commander (32 bit)
  on Windows 64 bit, i.e. file date/time and sizes. Services 2.4 always shows
  the information of the files in C:\Windows\SysWow64 instead of
  C:\Windows\system32.

- Unicode capable (I hope this is implemented correctly).

- 64 Bit version of this plugin to use in Total Commander x64.

- Translation to other languages possible.

- Support for custom columns, including default view.

- Show services in Total Commander's file list in all states,
  not just running, stopped and paused but all transitional states
  (pause/continue/start/stop pending) as well.

- Additional startup type "Automatic (Delayed)" on Vista and higher.

- Delete a service by pressing F8 or DEL in Total Commander's file list.
  This feature can be turned off. See section "Plugin settings".

- Show some additional information when pressing F3 on a service:
  - startup type
  - if a service is allowed to interact with the user's desktop
  - if a service uses a shared process or its own
  - name of the account that the service process will be logged on as

- Show driver services as such in the dependencies/dependents trees.

- Show load order groups in the dependencies tree (but not their members).

- Show warning if not all of the service's dependencies could be retrieved,
  e.g. when the user executing the plugin doesn't have administrative
  privileges that are necessary to get the dependents of some services.
  Namely these are DcomLaunch, RpcSs, RpcEptMapper and pla (on Windows 7/8),
  but there may be other services.
  Services 2.4 just shows "No dependencies found" in this case which isn't
  necessarily true.


Disadvantages (things this plugin can't do (and in some cases never will):
-------------------------------------------------------------------------

- No "Remote computer" management yet. This feature is on the todo list, though.

- "Log on as" management is available but may be not as stable as I want it to be.
  OK, the dialog's controls are more stable in this plugin as there isn't more than
  one radio button checked/marked simultaneously like in Services 2.4 ;).

- No feature to start or stop a service directly in TC's file panel with a hotkey
  like F5 or F6.
  Note: This feature never worked on the systems I tested Services 2.4 on.

- No "Recovery" tab in the service's properties. This will most probably
  never be implemented (too much effort for very little benefit).

- No feature to add any executable as service. It's not planned to implement this.



Plugin settings
===============

You can change all options in the plugin's settings dialog (Alt+Enter on the
"Services2" entry in TC's Network Neighborhood).

If you want to change any plugin settings manually you can use either
a) Services2.ini in the plugin's directory, or
b) fsplugin.ini in the directory where wincmd.ini is located.

Option a) is good for portable mode, option b) is useful on systems where
Total Commander is installed in a directory where users can't write to (like
%ProgramFiles%).

Important: If Services2.ini exists in the plugin's directory it is preferred
over fsplugin.ini!

See Services2.ini.sample for more information on the plugin's settings.



Known Issues
============

- If the option "Show service state in the extension column of TC's panel" is
  disabled and the state of any services changes (using this plugin or other means)
  the icon does not reflect the new state of the service.
  Fixing this would require a lot of work, so I'll leave it as it is for now.

  Update: This should be fixed as of version 0.4.2, except perhaps for services
          whose executable is not found/recognized by the plugin, so there isn't
          any information shown in TC's Date column.

- The feature "Configure" of TC Plugins Manager does not work with this plugin.
  This is a limitation of TC Plugins Manager. It calls only the ANSI functions
  exported by the plugins. Since Services2 is a Unicode only plugin (regarding
  the relevant functions) it does not work.

- The dialog asking for confirmation to grant a user account the SeServiceLogonRight
  is too wide on pre-Vista systems. I'm really not happy about this, but inserting
  manual line-breaks kind of breaks the dialog text on Vista+ systems...



FAQ
=====

Q) Why does the plugin load the custom columns view although the option
   "Load Custom Columns View upon entering the plugin" is disabled?
A) The option controls whether the plugin reports a default custom columns view to
   TC or not. In case the default custom columns view is changed by the user, TC
   switches to this custom columns view automatically when the plugin is entered,
   regardless of the plugin's setting, because the option "Switch to this view when
   entering the plugin" in TC's custom columns view is enabled by default.
   So, to really disable the loading of custom columns view the option "Switch to
   this view when entering the plugin" in TC's custom columns view must be disabled
   as well.



License
=======

The plugin's cog icon "Fatcow-Farm-Fresh-Cog":
(C) Fatcow Web Hosting  http://www.fatcow.com/free-icons
Licensed under CC Attribution 3.0
http://creativecommons.org/licenses/by/3.0/

All other icons (except the Delphi main icon) were made by my brother.


This software is provided "as is". No warranty provided. You use this program
at your own risk. The author will not be responsible for data loss,
damages, etc. while using or misusing this software.

The software must not be modified, you may not decompile or disassemble it.

This plugin is copyrighted freeware.



Thanks to
=========

- Christian Ghisler, the author of Total Commander, for developing this
  great program that I use every day
- Serge Kandakov (KaSA) for making the Services 2.4 plugin. It would have been
  much more work to make my own plugin without "the original".
- The authors of HTTP Browser and Uninstaller64 plugins. I adopted some of the
  ideas (but not any code) from their available source code.
- Ritsaert Hornstra @ StackOverflow for his unit ServiceManager
- Colin Wilson for his unit LsaApi



Contact the author
==================

If you have found a bug, have a suggestion, improvement, criticism, translation,
you can contact me, Dalai, in English or German, at:
Mail: dalai82(at)gmx(dot)net

Please put "Services2" somewhere in the subject.

There is a discussion thread in the offical TC forum which can be used, too:
http://ghisler.ch/board/viewtopic.php?t=40155
