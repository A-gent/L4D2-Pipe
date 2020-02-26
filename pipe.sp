public Plugin myinfo =
{
	name = "Pipe",
	author = "Jake",
	description = "Custom L4D2 Sourcemod ConVars and Config Pipe",
	version = "0.008.721a",
	url = "https://github.com/A-gent/L4D2-Pipe/"
};


public void OnPluginStart()
{
	RegConsoleCmd("testpipe", Command_TestPipe, "- Start the server_4_thursday config");
}
 
 public Action:Command_TestPipe(client, args)
{
		//ServerCommand("sv_cheats 1");
		ServerCommand("clamp_ai");
		//PrintToServer("Test Command Has Fired");
		PrintToChat(client, "Test Command Has Fired");
		//PrintToChat("Test Command Has Fired");
		return Plugin_Handled;
}