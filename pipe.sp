public Plugin myinfo =
{
	name = "Pipe",
	author = "Jake",
	description = "Custom L4D2 Sourcemod ConVars and Config Pipe",
	version = "0.008.829a",
	url = "https://github.com/A-gent/L4D2-Pipe/"
};


public void OnPluginStart()
{
	// Turn AI OFF ALIASES
	RegConsoleCmd("pause_director", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("warroom", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("warroom_on", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_off", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("off_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_disable", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("disable_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_clamp", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("clamp_ai", Command_ClampAI, "- Disable Localized AI");
	// Turn AI ON ALIASES
	RegConsoleCmd("resume_director", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("warroom_off", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("ai_on", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("on_ai", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("ai_enable", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("enable_ai", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("ai_unclamp", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("unclamp_ai", Command_UnclampAI, "- Enable Localized AI");
	//
	// Cheat MODULE ALIASES
	RegConsoleCmd("cheat", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("cheats", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("yescheats", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("cheats1", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("cheat1", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("cheats_on", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("cheatson", Command_CheatsOn, "- Enable Server Cheats");
	RegConsoleCmd("enablecheats", Command_CheatsOn, "- Enable Server Cheats");
	//
	RegConsoleCmd("disablecheats", Command_CheatsOff, "- Disable Server Cheats");
	RegConsoleCmd("cheats_off", Command_CheatsOff, "- Disable Server Cheats");
	RegConsoleCmd("cheatsoff", Command_CheatsOff, "- Disable Server Cheats");
	RegConsoleCmd("nocheats", Command_CheatsOff, "- Disable Server Cheats");
	RegConsoleCmd("cheats0", Command_CheatsOff, "- Disable Server Cheats");
	RegConsoleCmd("cheat0", Command_CheatsOff, "- Disable Server Cheats");
	//
	//  TEST
	RegConsoleCmd("testglobal", Command_TestGlobalPrint, "- Prints a global message from the server to all clients");
	//RegConsoleCmd("testglobalsnd", Command_TestGlobalSound, "- Uses Playgamesound command through the CfgPipe CVar Forcer on all active clients");
}
 //  AI
 public Action:Command_ClampAI(client, args)
{
		//ServerCommand("sv_cheats 1");
		ServerCommand("pipe_ai_locked");  //  Play sound on AI disable
		ServerCommand("clamp_ai");
		ServerCommand("director_afk_timeout 9999999999999");   // Humans idle longer than this many seconds will be forced to spectator mode
		ServerCommand("sv_spectatoridletime 9999999999999");   // Humans idle longer than this many seconds will be forced to spectator mode
		ServerCommand("allow_all_bot_survivor_team 1");   // Allow bot team
		//PrintToServer("Test Command Has Fired");
		PrintToChat(client, "\x05 [Pipe]:  \x03 AI \x04 Clamped");
		//PrintToChat("Test Command Has Fired");
		return Plugin_Handled;
}

 public Action:Command_UnclampAI(client, args)
{
		//ServerCommand("sv_cheats 1");
		ServerCommand("pipe_ai_unlocked");  //  Play sound on AI enable
		ServerCommand("declamp_ai");
		ServerCommand("director_afk_timeout 45");         // Humans idle longer than this many seconds will be forced to spectator mode
		ServerCommand("sv_spectatoridletime 3");          // Humans idle longer than this many seconds will be forced to spectator mode
		//ServerCommand("allow_all_bot_survivor_team 0"); // Deny bot-only survivor team scenario
		//PrintToServer("Test Command Has Fired");
		PrintToChat(client, "\x05 [Pipe]:  \x03 AI \x04 Unclamped");
		//PrintToChat("Test Command Has Fired");
		return Plugin_Handled;
}
//  CHEATS
 public Action:Command_CheatsOn(client, args)
{
		PrintToChat(client, "\x05 [Pipe]:  \x03 CHEATS \x04 ENABLED");
		ServerCommand("sv_cheats 1");
		return Plugin_Handled;
}

 public Action:Command_CheatsOff(client, args)
{
		PrintToChat(client, "\x05 [Pipe]:  \x03 CHEATS \x04 DISABLED");
		ServerCommand("sv_cheats 0");
		return Plugin_Handled;
}

 public Action:Command_TestGlobalPrint(client, args)
{
		//PrintToServer("[CFGPIPE]:  THIS IS A GLOBAL STRINGPRINT");
		PrintToChatAll ("\x05 [Pipe]:  \x03 THIS IS A \x04 GLOBAL STRINGPRINT");  // Though the actual colors will vary depending on the mod, you can add color to any chat message using the characters 0x01 to 0x08.
		//PrintToChatAll ("\x01 1 .. \x02 2 .. \x03 3 .. \x04 4 .. \x05 5 .. \x06 6 .. \x07 7 .. \x08 8");  // Though the actual colors will vary depending on the mod, you can add color to any chat message using the characters 0x01 to 0x08.
		return Plugin_Handled;
}