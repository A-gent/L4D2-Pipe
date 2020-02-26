new Handle:p_DevOnly = INVALID_HANDLE;   // https://forums.alliedmods.net/showthread.php?t=154094
 
public OnPluginStart()
{
	p_DevOnly = CreateConVar("sm_core_devonly", "cl_interp_npcs, host_framerate", "Setting: List of cvars, comma limited, to strip developmentonly flags from.");
}
 
public OnConfigsExecuted()
{
	StripDevOnlyCvars();
}
 
SStripDevOnlyCvars()()
{
	decl String:cvars[1024], String:ncvars[16][64];
	GetConVarString(p_DevOnly, cvars, sizeof(cvars));

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
			flags &= ~FCVAR_DEVELOPMENTONLY;
			SetConVarFlags(cvar, flags);
		}
	}
} 