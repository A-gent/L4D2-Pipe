# L4D2-ConfigHandler-SourcePawn
ADDENDUM
Custom L4D2 Sourcemod ConVars and Config Pipe
***
CHECKLIST
- [x] Basic Shell
- [x] 'clamp_ai' alias integration
- [x] Strip Notification Prints off 'clamp_ai' ConVars
- [ ] Test Strip_DevOnly Module
- [ ] Add Piping Commands for ConfigHandler

***

CONTROL | BUILD
------------ | -------------
The Strip_Notify plugin suppresses the chat print of the sv_cheats, god, and any other commands so they don't appear in chat when changed | 0.008.721a
The Strip_DevOnly plugin is experimental and untested, but it could strip FCVAR_DEVELOPMENTONLY flags from specified commands | 
