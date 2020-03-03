new Handle:p_Notify = INVALID_HANDLE;   // https://forums.alliedmods.net/showthread.php?t=154094
 
public OnPluginStart()
{
	p_Notify = CreateConVar("sm_core_notify", "sv_gravity, sv_airaccelerate, sv_wateraccelerate, sv_alltalk, mp_limitteams, sv_cheats, god, director_afk_timeout, sv_spectatoridletime", "Setting: List of cvars, comma limited, to strip notifications from.");
}
 
public OnConfigsExecuted()
{
	StripNotifyCvars();
}
 
StripNotifyCvars()
{
	decl String:cvars[1024], String:ncvars[16][64];
	GetConVarString(p_Notify, cvars, sizeof(cvars));

	if(strcmp(cvars, "", false) != 0)
	{
		new Handle:cvar;
		new flags;
		new cvarc = ExplodeString(cvars, ", ", ncvars, sizeof(ncvars), sizeof(ncvars[]));  
		
		for(new i = 0; i < cvarc; i++)
		{
			TrimString(ncvars[i]);
			cvar = FindConVar(ncvars[i]);
			
			if(cvar == INVALID_HANDLE)
				continue; // ignore if ConVar isn't exists 

			flags = GetConVarFlags(cvar);
			flags &= ~FCVAR_NOTIFY;
			SetConVarFlags(cvar, flags);
		}
	}
} 