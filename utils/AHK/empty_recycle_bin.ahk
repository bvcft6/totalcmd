Msgbox,52,Bitte bestätigen,Soll der Papierkorb wirklich geleert werden?
Ifmsgbox No
  ExitApp
Else
  FileRecycleEmpty

If %ErrorLevel%
    Msgbox,,,something went wrong
    
ExitApp
