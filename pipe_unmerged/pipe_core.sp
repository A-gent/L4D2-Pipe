////////////////////////////////////////
// BHOP STUFF
#include <sdktools>

#define MAXCLIENTS 32
#pragma semicolon 1
////////////////////////////////////////
//============================================================
//
#include <sourcemod>

//#define PLUGIN_VERSION          "0x01"
#define PLUGIN_VERSION          "0.008.791a"
// #define PLUGIN_VER "0.008.997a"

#define FCVAR_VERSION           FCVAR_NOTIFY|FCVAR_DONTRECORD|FCVAR_CHEAT

//
//============================================================
//
////////////////////////////////////////

////////////////////////////////////////
// BHOP STUFF
new bool:g_AutoBhop[MAXCLIENTS + 1];
////////////////////////////////////////

////////////////////////////////////////
// SM_RESTARTMAP STUFF
static String:szCurrentmap[99];
////////////////////////////////////////

////////////////////////////////////////
// PAUSE STUFF
static	g_iYesCount = 0,
		g_iNoCount = 0,
		g_iVoters = 0,

		bool:g_bIsPause = false,
		bool:g_bAdminPause = false,
		bool:g_bAllowPause = false,
		bool:g_bAllVoted = false,
		bool:g_bToggleAllTalk = true,
		g_iFlags[MAXPLAYERS+1],
		
		String:g_CurrentURL[192],

		Handle:g_hTimout,
		Handle:g_hForcePauseOnly,
		Handle:g_hPauseAllTalk,
		Handle:g_hRadioEnabled,
		Handle:g_hRadioURL,
		Handle:g_hRadioLoadingURL,
		Handle:g_hSbStop, 
		Handle:g_hNbStop, 
		Handle:g_hSvPausable, 
		Handle:g_hFloodTime, 
		Handle:g_hAllTalk;
////////////////////////////////////////

public Plugin myinfo =
{
	name = "Pipe",
	author = "Jake",
	description = "Custom L4D2 Sourcemod ConVars and Config Pipe",
	version = "0.008.791a",
	url = "https://github.com/A-gent/L4D2-Pipe/"
};
 //
 //
 //
 //
 //////////////////////////////
 // ON PLUGIN START (AUTOEXEC)
 //////////////////////////////
 //  -Build command names, tie them to command names from the FUNCTIONS section below.
 //  -Perform actions when the Plugin loads fully.
 //
public void OnPluginStart()
{
	//
	// Turn AI OFF ALIASES
	//////////////////////////////////////////////////////////////////////////////////////////
	RegConsoleCmd("pause_director", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("warroom", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("warroom_on", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_off", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("off_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_disable", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("disable_ai", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("ai_clamp", Command_ClampAI, "- Disable Localized AI");
	RegConsoleCmd("clamp_ai", Command_ClampAI, "- Disable Localized AI");
	//
	// Turn AI ON ALIASES
	//////////////////////////////////////////////////////////////////////////////////////////
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
	//////////////////////////////////////////////////////////////////////////////////////////
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
	//  RESTART MAP
	//////////////////////////////////////////////////////////////////////////////////////////
	RegAdminCmd("pipe_restartmap", Cmd_MapRestart, ADMFLAG_CHANGEMAP);
	RegAdminCmd("sm_restartmap", Cmd_MapRestart, ADMFLAG_CHANGEMAP);
	RegAdminCmd("restartmap", Cmd_MapRestart, ADMFLAG_CHANGEMAP);
	RegAdminCmd("remap", Cmd_MapRestart, ADMFLAG_CHANGEMAP);
    //CreateConVar("pipe_restartmap_version", PLUGIN_VERSION, "Restart Map Version", FCVAR_VERSION);
	//  CLIENT VERSUS (OFFLINE)
	//////////////////////////////////////////////////////////////////////////////////////////
	RegConsoleCmd("test_offlinevs_on", Command_ClientVersusON, "- offline versus on");
	RegConsoleCmd("test_offlinevs_off", Command_ClientVersusOFF, "- offline versus off");
	//
	//  BHOP
	//////////////////////////////////////////////////////////////////////////////////////////
	RegConsoleCmd("sm_autobhop", Cmd_Autobhop);
	RegConsoleCmd("sm_autobhop_silent", Cmd_AutobhopSilent);
	RegConsoleCmd("sm_bhop", Cmd_Autobhop);
	RegConsoleCmd("sm_bhop_silent", Cmd_AutobhopSilent);
	//  PAUSE PLUGIN
	//////////////////////////////////////////////////////////////////////////////////////////
	g_hTimout = CreateConVar( "l4d2_pause_request_timout", "10.0", "How long the pause request should be visable", FCVAR_PLUGIN, true, 5.0, true, 30.0 );
	g_hForcePauseOnly = CreateConVar( "l4d2_pause_force_only", "0", "Only allow force pauses", FCVAR_PLUGIN );
	g_hPauseAllTalk = CreateConVar( "l4d2_pause_alltalk", "1", "Turns Alltalk on when paused", FCVAR_PLUGIN );
	g_hRadioEnabled = CreateConVar( "l4d2_pause_radio_enabled", "0", "Enable the playing of a radio station, whilst paused" );
	g_hRadioURL = CreateConVar( "l4d2_pause_radio_url", "www.radioparadise.com/flash_player.php", "The url of the streaming radio station to be used (do not include http://) e.g. www.mydomain/l4d2pauseradio.html" );
	g_hRadioLoadingURL = CreateConVar( "l4d2_pause_radio_loading_url",
	"www.valvesoftware.com", "The URL of the MOTD whilst the radio is loading e.g. www.mydomain/l4d2pauseradio-loading.html" );
	AutoExecConfig( true, "[L4D2]Pause" );

	if( (g_hSbStop = FindConVar("sb_stop")) == INVALID_HANDLE )
		SetFailState("Cannot find 'sb_stop' handle. Plugin will now unload.");
	if( (g_hNbStop = FindConVar("nb_stop")) == INVALID_HANDLE )
		SetFailState("Cannot find 'nb_stop' handle. Plugin will now unload.");
	if( (g_hSvPausable = FindConVar("sv_pausable")) == INVALID_HANDLE )
		SetFailState("Cannot find 'sv_pausable' handle. Plugin will now unload.");
	if( (g_hFloodTime = FindConVar("sm_flood_time")) == INVALID_HANDLE )
		SetFailState("Cannot find 'sm_flood_time' handle. Plugin will now unload.");
	if( (g_hAllTalk = FindConVar("sv_alltalk")) == INVALID_HANDLE )
		SetFailState("Cannot find 'sv_alltalk' handle. Plugin will now unload.");

	SetConVarBool( g_hSvPausable, false );
	
	RegConsoleCmd( "sm_votepause", Command_SMPause, "Pauses the game" );
	RegConsoleCmd( "sm_voteunpause", Command_SMUnpause, "Unpauses the game" );
	RegAdminCmd( "sm_forcepause", Command_SMForcePause, ADMFLAG_KICK, "Forces the game to pause" );
	RegAdminCmd( "sm_pause", Command_SMForcePause, ADMFLAG_KICK, "Forces the game to pause" );
	RegAdminCmd( "sm_forceunpause", Command_SMForceUnpause, ADMFLAG_KICK, "Forces the game to unpause" );
	RegAdminCmd( "sm_unpause", Command_SMForceUnpause, ADMFLAG_KICK, "Forces the game to unpause" );
	
	RegConsoleCmd( "sm_radio_on", Command_SMRadio, "Starts the radio" );
	RegConsoleCmd( "sm_radio_off", Command_SMRadioOff, "Stops the radio" );
		
	AddCommandListener( Command_Say, "say" );
	AddCommandListener( Command_SayTeam, "say_team" );
	AddCommandListener( Command_Real_Pause, "pause");
	AddCommandListener( Command_Real_Pause, "setpause");
	AddCommandListener( Command_Real_Pause, "unpause");
	
	HookEvent("player_team", Event_PlayerChangeTeam, EventHookMode_Pre);
	//
	//  TEST
	//////////////////////////////////////////////////////////////////////////////////////////
	RegConsoleCmd("testglobal", Command_TestGlobalPrint, "- Prints a global message from the server to all clients");
	//RegConsoleCmd("testglobalsnd", Command_TestGlobalSound, "- Uses Playgamesound command through the CfgPipe CVar Forcer on all active clients");
}
 //
 //
 //
 //
 //////////////////////////////
 //      WHEN MAP STARTS
 //////////////////////////////
 //  -Perform actions on map load.
 //
 //
public OnMapStart()
{
////////////////////////////////////////
// SM_RESTARTMAP STUFF
    GetCurrentMap(szCurrentmap, sizeof(szCurrentmap));
////////////////////////////////////////
}
 //
 //
 //
 //
 //
 //
 //
 //
 //
 //
 //
 //
 //////////////////////////////
 //     FUNCTIONS
 //////////////////////////////
 //  -Actions tied to command names build OnPluginLoad
 //
 //
 //
 //  AI
  //////////////////////////////////////////////////////////////////////////////////////////
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
 //////////////////////////////////////////////////////////////////////////////////////////
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
//  TURN ON OFFLINE VERSUS
 //////////////////////////////////////////////////////////////////////////////////////////
 public Action:Command_ClientVersusON(client, args)
{
		PrintToChatAll ("\x05 [Pipe]:  \x03 Offline Versus \x04 EXECUTED");
		ServerCommand("pipe_clientversus_on");
		return Plugin_Handled;
}
//  TURN OFF OFFLINE VERSUS
 //////////////////////////////////////////////////////////////////////////////////////////
 public Action:Command_ClientVersusOFF(client, args)
{
		PrintToChatAll ("\x05 [Pipe]:  \x03 Offline Versus \x04 REVERTED");
		ServerCommand("pipe_clientversus_off");
		return Plugin_Handled;
}
// SM_RESTARTMAP
 //////////////////////////////////////////////////////////////////////////////////////////
public Action:Cmd_MapRestart(iClient, iArgc)
{
    ForceChangeLevel(szCurrentmap, "[SM] Restarting the map.");
    return Plugin_Handled;
}
//  BHOP
 //////////////////////////////////////////////////////////////////////////////////////////
public Action:Cmd_Autobhop(client, args)
{
	if (client == 0)
	{
		if (!IsDedicatedServer() && IsClientInGame(1)) client = 1;
		else return Plugin_Handled;
	}
	if (g_AutoBhop[client]) PrintToChat(client, "[SM] AutoBhop ON");
	else PrintToChat(client, "[SM] AutoBhop OFF");
	g_AutoBhop[client] = !g_AutoBhop[client];
	return Plugin_Handled;
}

public Action:Cmd_AutobhopSilent(client, args)
{
	if (client == 0)
	{
		if (!IsDedicatedServer() && IsClientInGame(1)) client = 1;
		else return Plugin_Handled;
	}
	//if (g_AutoBhop[client]) PrintToChat(client, "[SM] AutoBhop ON");
	//else PrintToChat(client, "[SM] AutoBhop OFF");
	g_AutoBhop[client] = !g_AutoBhop[client];
	return Plugin_Handled;
}

public Action:OnPlayerRunCmd(int client, int &buttons)
{
	if (!g_AutoBhop[client] && IsPlayerAlive(client))
	{
		if (buttons & IN_JUMP)
		{
			if (GetEntPropEnt(client, Prop_Send, "m_hGroundEntity") == -1)
			{
				if (GetEntityMoveType(client) != MOVETYPE_LADDER)
				{
					buttons &= ~IN_JUMP;
				}
			}
		}
	}
	return Plugin_Continue;
}
//  L4D2 PAUSE PLUGIN
 //////////////////////////////////////////////////////////////////////////////////////////
public Action:Command_Say(client, const String:command[], argc) 
{
	if (g_bIsPause)
	{
		decl String:sText[256];
		GetCmdArgString(sText, sizeof(sText));
		StripQuotes(sText);
		if(client == 0) return Plugin_Continue;
		
		if( GetClientTeam(client) == 2 )PrintToChatAll("\x03%N\x01 : %s", client, sText);
		if( GetClientTeam(client) == 3 )PrintToChatAll("\x05%N\x01 : %s", client, sText);
		if( GetClientTeam(client) != 2 && GetClientTeam(client) != 3 )PrintToChatAll("\x02%N\x01 : %s", client, sText);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action:Command_SayTeam(client, const String:command[], argc) 
{
	if (g_bIsPause)
	{
		decl String:sText[256];
		GetCmdArgString(sText, sizeof(sText));
		StripQuotes(sText);
		if(client == 0) return Plugin_Continue;
		
		for( new i = 1; i <= MaxClients; i++ )
		{
			if( IsClientInGame(i) && !IsFakeClient(i) )
			{
				if( GetClientTeam(client) == GetClientTeam(i) )
				{
					if( GetClientTeam(client) == 2 ) PrintToChat( i, "\x01(Survivor) \x03%N\x01 : %s", client, sText);
					if( GetClientTeam(client) == 3 ) PrintToChat( i, "\x01(Infected) \x05%N\x01 : %s", client, sText);
					if( GetClientTeam(client) != 2 && GetClientTeam(client) != 3 ) PrintToChat( i, "\x01(Spec) \x02%N\x01 : %s", client, sText);
				}
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

stock GetValidClient()
{
	for (new target = 1; target <= MaxClients; target++)
	{
		if( IsClientInGame(target) && !IsFakeClient(target) ) return target;
	}
	return 0;
}

stock ChatFloodOn()
{
	new Flags = GetConVarFlags( g_hFloodTime );
	SetConVarFlags( g_hFloodTime, (Flags & ~FCVAR_NOTIFY) );
	ResetConVar( g_hFloodTime );
	SetConVarFlags( g_hFloodTime, Flags );
}

stock ChatFloodOff()
{
	new Flags = GetConVarFlags( g_hFloodTime );
	SetConVarFlags( g_hFloodTime, (Flags & ~FCVAR_NOTIFY) );
	SetConVarFloat( g_hFloodTime, 0.0 );
	SetConVarFlags( g_hFloodTime, Flags ); 
}

stock AllTalkOn()
{
	if( GetConVarBool( g_hPauseAllTalk ) )
	{
		if( GetConVarBool(g_hAllTalk) ) g_bToggleAllTalk = false;
		if( g_bToggleAllTalk )
		{
			new Flags = GetConVarFlags(g_hAllTalk);
			SetConVarFlags(g_hAllTalk, (Flags & ~FCVAR_NOTIFY)); 
			SetConVarInt(g_hAllTalk, 1);
			SetConVarFlags(g_hAllTalk, Flags); 
			PrintToChatAll( "\x05[Pipe]: \x01Alltalk has been \x04Enabled" );
		}
	}
}

stock AllTalkOff()
{
	if( GetConVarBool( g_hPauseAllTalk ) )
	{
		if( g_bToggleAllTalk )
		{
			new Flags = GetConVarFlags(g_hAllTalk);
			SetConVarFlags(g_hAllTalk, (Flags & ~FCVAR_NOTIFY)); 
			SetConVarInt(g_hAllTalk, 0);
			SetConVarFlags(g_hAllTalk, Flags); 
			PrintToChatAll( "\x05[Pipe]: \x01Alltalk has been \x04Disabled" );
		}
	}
}

ExecuteCheatCommand(const String:sCmdName[], const String:sValue[]="")
{
	new iFlags = GetCommandFlags(sCmdName);
	if( iFlags & FCVAR_CHEAT )
	{
			SetCommandFlags(sCmdName, iFlags &~ FCVAR_CHEAT); // Remove cheat flag
			ServerCommand("%s%s", sCmdName, sValue);
			SetCommandFlags(sCmdName, iFlags | FCVAR_CHEAT); // Restore cheat flag
	}
	else
	{
			ServerCommand("%s%s", sCmdName, sValue);
	}
}

public Action:SoundHook(	clients[64], 
							&numClients, 
							String:sample[PLATFORM_MAX_PATH], 
							&entity, 
							&channel, 
							&Float:volume, 
							&level, 
							&pitch, 
							&flags) 
{
	volume = 0.0;
	level = 0;
	return Plugin_Changed;
}

public Action:AmbientHook(	String:sample[PLATFORM_MAX_PATH], 
								&entity, 
								&Float:volume, 
								&level, 
								&pitch, 
								Float:pos[3], 
								&flags, 
								&Float:delay)
{
	volume = 0.0;
	level = 0;
	return Plugin_Changed;
}

PauseFreeze()
{
	AddNormalSoundHook(NormalSHook:SoundHook);
	AddAmbientSoundHook(AmbientSHook:AmbientHook);
			
	SetConVarInt(g_hSbStop, 1);
	SetConVarInt(g_hNbStop, 1);
	ExecuteCheatCommand("director_stop");
	for( new i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) )
		{
			SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
			SetEntityMoveType(i, MOVETYPE_NONE);
			g_iFlags[i] = GetEntProp(i, Prop_Send, "m_fFlags");
			SetEntProp(i, Prop_Send, "m_fFlags", 161);
		}
	}
}

PauseUnfreeze()
{
	RemoveNormalSoundHook(NormalSHook:SoundHook);
	RemoveAmbientSoundHook(AmbientSHook:AmbientHook);
	ExecuteCheatCommand("sv_soundemitter_flush");

	SetConVarInt(g_hSbStop, 0);
	SetConVarInt(g_hNbStop, 0);
	ExecuteCheatCommand("director_start");
	for( new i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) )
		{
			SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			SetEntityMoveType(i, MOVETYPE_WALK);
			SetEntProp(i, Prop_Send, "m_fFlags", FL_ONGROUND);
		}
	}
}

stock TurnRadioOn()
{
	if( GetConVarBool(g_hRadioEnabled) )
	{
		decl String:RadioURL[192];
		GetConVarString( g_hRadioURL, RadioURL, 192 );
		for( new client = 1; client < GetClientCount(false); client++ )
		{
			if( !IsFakeClient(client) )
			{
				PlayMOTDMusic( client, RadioURL );
				PrintToChat( client, "\x05[Pipe]: \x01Turning the radio on whilst you wait..." );
			}
		}
	}
}

stock TurnRadioOff()
{
	if( GetConVarBool(g_hRadioEnabled) )
	{
		for( new client = 1; client < GetClientCount(false); client++ )
		{
			if( !IsFakeClient(client) )
			{
				StopMOTDMusic( client );
			}
		}
	}
}

stock UnPauseGame()
{
	new client = GetValidClient();
	g_bAllowPause = true;
	SetConVarInt(g_hSvPausable, 1); 
	FakeClientCommand( client, "unpause" );
	SetConVarInt(g_hSvPausable, 0);
	g_bAllowPause = false;
	g_bIsPause = false;
}

stock PauseGame()
{
	ExecuteCheatCommand("soundscape_flush");
	
	new client = GetValidClient();
	g_bAllowPause = true;
	SetConVarInt(g_hSvPausable, 1); 
	FakeClientCommand( client, "setpause" );
	SetConVarInt(g_hSvPausable, 0);
	g_bAllowPause = false;
	g_bIsPause = true;
}

public PauseVoteHandler(Handle:menu, MenuAction:action, client, choice)
{
	if (action == MenuAction_Select)
	{
		if(choice == 1) //yes
		{
			g_iVoters--;
		}
		else //No
		{
			g_iNoCount++;
			g_iYesCount--;
			g_iVoters--;
		}
		if( g_iVoters == 0 ) //Everyone Has Voted
		{
			g_bAllVoted = true;
			if( g_iYesCount >= g_iNoCount )
			{
				PrintToChatAll( "\x05[Pipe]: \x01'Yes' was voted on pausing" );
				TurnRadioOn();
				ChatFloodOff();
				AllTalkOn();
				PauseFreeze();
				CreateTimer( 0.5, Timer_PauseGame );
			} else {
				PrintToChatAll( "\x05[Pipe]: \x01'No' was voted on pausing" );
			}
		}
	}
}

public UnPauseVoteHandler(Handle:menu, MenuAction:action, client, choice)
{
	if (action == MenuAction_Select)
	{
		if(choice == 1) //yes
		{
			g_iNoCount--;
			g_iYesCount++;
			g_iVoters--;
		}
		else //No
		{
			g_iVoters--;
		}
		if( g_iVoters == 0 ) //Everyone Has Voted
		{
			g_bAllVoted = true;
			if( g_iYesCount >= g_iNoCount )
			{
				PrintToChatAll( "\x05[Pipe]: \x01'Yes' was voted on unpausing" );
				PrintToChatAll( "\x05[Pipe]: \x01The game will continue in..." );
				TurnRadioOff();
				CreateTimer( 1.0, Timer_UnPauseGame, 5 );
			} else {
				PrintToChatAll( "\x05[Pipe]: \x01'No' was voted on unpausing" );
			}
		}
	}
}

public Action:Timer_VoteCheckPause(Handle:timer)
{
	if(!g_bAllVoted && !g_bIsPause)
	{
		g_bAllVoted = true;
		if( g_iYesCount >= g_iNoCount )
		{
			PrintToChatAll( "\x05[Pipe]: \x01'Yes' was voted on pausing" );
			TurnRadioOn();
			ChatFloodOff();
			AllTalkOn();	
			PauseFreeze();
			CreateTimer( 1.0, Timer_PauseGame );
		} else {
			PrintToChatAll( "\x05[Pipe]: \x01'No' was voted on pausing" );
		}
	}
}

public Action:Timer_VoteCheckUnpause(Handle:timer)
{
	if(!g_bAllVoted && g_bIsPause)
	{
		g_bAllVoted = true;
		if( g_iYesCount >= g_iNoCount )
		{
			PrintToChatAll( "\x05[Pipe]: \x01'Yes' was voted on unpausing" );
			PrintToChatAll( "\x05[Pipe]: \x01The game will continue in..." );
			TurnRadioOff();
			CreateTimer( 1.0, Timer_UnPauseGame, 5 );
		} else {
			PrintToChatAll( "\x05[Pipe]: \x01'No' was voted on unpausing" );
		}
	}
}

public Action:Timer_PauseGame(Handle:timer)
{
	PauseGame();
}

public Action:Timer_UnPauseGame(Handle:timer, any:time)
{
	if( time != 0 )
	{
		PrintToChatAll( "%d", time );
		CreateTimer( 1.0, Timer_UnPauseGame, --time );
	} 
	else
	{
		PrintToChatAll( "Game is live, Good Luck!" );
		UnPauseGame();
		ChatFloodOn();
		AllTalkOff();
		CreateTimer(1.0, tmrUnfreeze);
	}
}

public Action:tmrUnfreeze(Handle:timer)
	PauseUnfreeze();

public Action:Command_SMUnpause(client, args)
{
	if( g_bAdminPause )
	{
		PrintToChat( client, "\x05[Pipe]: \x01The game was paused by an admin, Only an admin may unpause" );
		return Plugin_Handled;
	}
	if( !g_bIsPause )
	{
		PrintToChat( client, "\x05[Pipe]: \x01The game isn't paused, use '!pause' to vote for the pausing of the game." );
		return Plugin_Handled;
	}
	if( GetConVarBool( g_hForcePauseOnly ) )
	{
		PrintToChat( client, "\x05[Pipe]: \x01Only admins can unpause the game, using !forceunpause" );
		return Plugin_Handled;
	}

	new Handle:panel = CreatePanel();
	SetPanelTitle( panel, "Unpause the Game?" );
	DrawPanelItem( panel, "Yes" );
	DrawPanelItem( panel, "No" );
	
	g_iYesCount = 0;
	g_iNoCount = 0;
	g_iVoters = 0;
	g_bAllVoted = false;
 
	UnPauseGame();
	for( new x = 1; x <= 16; x++ )
	{
		if( IsClientInGame( x ) && !IsFakeClient( x ) )
		{
			SendPanelToClient( panel, x, UnPauseVoteHandler, GetConVarInt( g_hTimout ) );
			g_iVoters++;
			g_iNoCount++;
		}
	}
	CreateTimer( 0.5, Timer_PauseGame );
	
	CreateTimer( GetConVarFloat( g_hTimout ) + 1.0, Timer_VoteCheckUnpause );
 
	CloseHandle(panel);
	return Plugin_Handled;
}

public Action:Command_SMPause(client, args)
{
	decl String:sReason[128];
	GetCmdArgString( sReason, 128 );
	
	if( g_bIsPause )
	{
		PrintToChat( client, "\x05[Pipe]: \x01The game is already paused, use '!unpause' to vote for the unpausing of the game." );
		return Plugin_Handled;
	}
	if( GetConVarBool( g_hForcePauseOnly ) )
	{
		PrintToChat( client, "\x05[Pipe]: \x01Only admins can pause the game, using !forcepause" );
		return Plugin_Handled;
	}
	
	if( strlen( sReason ) != 0 )	
		PrintToChatAll( "\x05[Pipe]: \x01%N wants to pause the game, because they %s", client, sReason );
	else
		PrintToChatAll( "\x05[Pipe]: \x01%N wants to pause the game", client );

	new Handle:panel = CreatePanel();
	SetPanelTitle( panel, "Pause the Game?" );
	DrawPanelItem( panel, "Yes" );
	DrawPanelItem( panel, "No" );
	
	g_iYesCount = 0;
	g_iNoCount = 0;
	g_iVoters = 0;
	g_bAllVoted = false;
 
	for( new x = 1; x <= 16; x++ )
	{
		if( IsClientInGame( x ) && !IsFakeClient( x ) )
		{
			SendPanelToClient( panel, x, PauseVoteHandler, GetConVarInt( g_hTimout ) );
			g_iVoters++;
			g_iYesCount++;
		}
	}
 
	CreateTimer( GetConVarFloat( g_hTimout ) + 1.0, Timer_VoteCheckPause );
 
	CloseHandle(panel);
	return Plugin_Handled;
}

public Action:Timer_HideMOTD(Handle:timer, any:client)
{
	new Handle:setup = CreateKeyValues("data");
	KvSetString(setup, "title", "GAME IS PAUSED");
	KvSetNum(setup, "type", MOTDPANEL_TYPE_URL);
	KvSetString(setup, "msg", g_CurrentURL);
	ShowVGUIPanel(client, "info", setup, false);
	CloseHandle(setup);	
}

public PlayMOTDMusic(client, String:url[192])
{
	Format( g_CurrentURL, 192, "%s", url );
	CreateTimer( 1.0, Timer_HideMOTD, client );
	
	decl String:LoadingURL[192];
	GetConVarString(g_hRadioLoadingURL, LoadingURL, 192);
	
	new Handle:setup = CreateKeyValues("data");
	KvSetString(setup, "title", "GAME IS PAUSED");
	KvSetNum(setup, "type", MOTDPANEL_TYPE_URL);
	KvSetString(setup, "msg", LoadingURL);
	ShowVGUIPanel(client, "info", setup, true);
	CloseHandle(setup);	
}

public StopMOTDMusic(client)
{
	new Handle:setup = CreateKeyValues("data");
	KvSetString(setup, "title", "GAME IS PAUSED");
	KvSetNum(setup, "type", MOTDPANEL_TYPE_URL);
	KvSetString(setup, "msg", "www.google.com");
	ShowVGUIPanel(client, "info", setup, false);
	CloseHandle(setup);	
}

public Action:Command_SMRadio(client, args)
{
	if( !GetConVarBool(g_hRadioEnabled) ) return Plugin_Handled;
	if( !g_bIsPause ) return Plugin_Handled;
	
	decl String:RadioURL[192];
	GetConVarString( g_hRadioURL, RadioURL, 192 );
	PlayMOTDMusic( client, RadioURL );
	PrintToChat( client, "\x05[Pipe]: \x01Turning the radio on whilst you wait..." );
		
	return Plugin_Handled;
}

public Action:Command_SMRadioOff(client, args)
{
	if( !GetConVarBool(g_hRadioEnabled) ) return Plugin_Handled;
	if( !g_bIsPause ) return Plugin_Handled;

	StopMOTDMusic( client );
	PrintToChat( client, "\x05[Pipe]: \x01Turning the radio off..." );
	
	return Plugin_Handled;
}

public Action:Command_SMForceUnpause(client, args)
{
	if( !g_bIsPause )
	{
		if( client != 0 )PrintToChat( client, "\x05[Pipe]: \x01The game isn't paused, use !forcepause to pause the game" );
		return Plugin_Handled;
	}
	PrintToChatAll( "\x05[Pipe]: \x01An admin has unpaused the game" );
	PrintToChatAll( "\x05[Pipe]: \x01The game will continue in..." );
	TurnRadioOff();
	CreateTimer( 1.0, Timer_UnPauseGame, 5 );	
	g_bAdminPause = false;
	return Plugin_Handled;
}

public Action:Command_SMForcePause(client, args)
{
	if( g_bIsPause )
	{
		if( client != 0 )PrintToChat( client, "\x05[Pipe]: \x01The game is already paused, use !forceunpause to unpause the game" );
		return Plugin_Handled;
	}
	PrintToChatAll( "\x05[Pipe]: \x01An admin has paused the game" );
	g_bAdminPause = true;
	TurnRadioOn();
	ChatFloodOff();
	AllTalkOn();
	PauseFreeze();
	CreateTimer( 1.0, Timer_PauseGame );
	return Plugin_Handled;
}

public OnClientDisconnect(client)
{
    if (g_bIsPause && !IsFakeClient(client))
    {
        UnPauseGame();
        CreateTimer(1.0, Timer_PauseGame);
    }
}

public OnClientPutInServer(client)
{
    if (g_bIsPause && !IsFakeClient(client))
    {
		PrintToChatAll( "\x05[Pipe]: \x01 %N is joining the game", client );
		UnPauseGame();
		CreateTimer(1.0, Timer_PauseGame);
	}
}

public OnClientConnected(client)
{
    if (g_bIsPause && !IsFakeClient(client))
    {
        UnPauseGame();
        CreateTimer(1.0, Timer_PauseGame);
    }
}

public Action:Event_PlayerChangeTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
    if (g_bIsPause)
    {
        UnPauseGame();
        CreateTimer(1.0, Timer_PauseGame);
    }
}

public Action:Command_Real_Pause(client, const String:command[], argc) 
{
	if( g_bAllowPause )return Plugin_Continue;
	return Plugin_Handled;
}
 //
 //
 //
 //
 //  ADD MORE PLUGIN FUNCTIONS HERE
 //////////////////////////////////////////////////////////////////////////////////////////
 //
 //
 //

 //
 //
 //
 //////////////////////////////////////////////////////////////////////////////////////////