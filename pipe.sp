public Plugin myinfo =
{
	name = "Pipe",
	author = "Jake",
	description = "Custom L4D2 Sourcemod ConVars and Config Pipe",
	version = "0.008.821a",
	url = "https://github.com/A-gent/L4D2-Pipe/"
};


public void OnPluginStart()
{
	// Turn AI OFF ALIASES
	RegConsoleCmd("ai_off", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("off_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_disable", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("disable_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_clamp", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("clamp_ai", Command_ClampAI, "- Disable Localized AI");
	// Turn AI ON ALIASES
	RegConsoleCmd("ai_on", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("on_ai", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("ai_enable", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("enable_ai", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("ai_unclamp", Command_UnclampAI, "- Enable Localized AI");
	RegConsoleCmd("unclamp_ai", Command_UnclampAI, "- Enable Localized AI");
}
 
 public Action:Command_ClampAI(client, args)
{
		//ServerCommand("sv_cheats 1");
		ServerCommand("clamp_ai");
		//PrintToServer("Test Command Has Fired");
		PrintToChat(client, "[CFGPIPE]:  AI Clamped");
		//PrintToChat("Test Command Has Fired");
		return Plugin_Handled;
}

 public Action:Command_UnclampAI(client, args)
{
		//ServerCommand("sv_cheats 1");
		ServerCommand("declamp_ai");
		//PrintToServer("Test Command Has Fired");
		PrintToChat(client, "[CFGPIPE]:  AI Unclamped");
		//PrintToChat("Test Command Has Fired");
		return Plugin_Handled;
}