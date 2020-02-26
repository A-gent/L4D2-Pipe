# L4D2-ConfigHandler-SourcePawn
ADDENDUM
```
Custom L4D2 Sourcemod ConVars and Config Pipe
```
***
CHECKLIST
- [x] Basic Shell
- [x] 'clamp_ai' alias integration
- [x] Strip Notification Prints off 'clamp_ai' ConVars
- [x] Add colored server message print responses on execution of custom Pipe ConVars
- [ ] Test Strip_DevOnly Module
- [ ] Add Piping Commands for ConfigHandler
- [ ] Incorporate the Auto Greeting Message from the 'pipe_test' example
- [ ] Make most client-side Print responses global using the example from the 'testglobal' ConVar

***

CONTROL | BUILD
------------ | -------------
-Established basic Shell                  (Pre-Pilot) | 0.008.721a
Created the pilot ConVar - sm_testpipe   (Pilot) | 0.008.721a
-The Strip_Notify plugin suppresses the chat print of the sv_cheats, god, and any other specified commands so they don't appear in chat when changed | 0.008.821a
The Strip_DevOnly plugin is experimental and untested, but it could strip FCVAR_DEVELOPMENTONLY flags from specified commands | 0.008.821a
-The Server Commands now outputs client-side messages, with color | 0.008.829a
The 'testglobal' ConVar outputs a global message to all connected clients, with color | 0.008.829a
The 'pipe_test.sp' plugin waits for newly connected clients to fully join the server, then it displays a client-side message to greet them | 0.008.829a
-The 'pipe_cvar_forcer' plugin forces all clients connected to execute the given CVars | 0.008.909a
The 'ai_on' and 'ai_off' now use the 'pipe_cvar_forcer' to play a sound for all connected clients when on/off state changed | 0.008.909a
