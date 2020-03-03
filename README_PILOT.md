# PIPE [L4D2]
ADDENDUM
```
Custom L4D2 Sourcemod ConVars and Config Pipe
```
***
COMPLETION
- [x] Basic Shell
- [x] 'clamp_ai' alias integration
- [x] Strip Notification Prints off 'clamp_ai' ConVars
- [x] Add colored server message print responses on execution of custom Pipe ConVars

***

COMMAND - ALIAS | DESCRIPTION
------------ | -------------
ai_on - (unclamp_ai, ai_enable, enable_ai, etc) | Enables AI (stops the war-room state)
ai_off - (clamp_ai, ai_disable, disable_ai, etc) | Disables AI (starts the war-room state)
cheats1 - (cheat, cheat1, cheats_on, enablecheats, etc) | Enables Cheats
cheats0 - (cheat0, cheats_off, disablecheats, etc) | Disables Cheats
sm_restartmap - (restartmap, remap) | Restarts the current map
sm_bhop (autobhop, bhop) | Enables client-side automated bhop
testglobal - (;) | Test Print Global Server-wide ChatPrint
test_offlinevs_on - (;) | Executes COOP Local Versus match
test_offlinevs_off - (;) | Unexecutes COOP Local Versus match