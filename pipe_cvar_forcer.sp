/*
 * ma_cexec equivalent for sourcemod
 *
 * Coded by dubbeh - www.yegods.net
 *
 */

#include <sourcemod>

#pragma semicolon 1
#define PLUGIN_VERSION "0.0.8.512.013p"
    //  https://forums.alliedmods.net/showthread.php?t=58982
public Plugin:myinfo =
{
    name = "CVar Forcer",
    author = "Jake",
    description = "Execute client-side commands on connected clients",
    version = PLUGIN_VERSION,
    url = "https://a-gent.github.io/L4D2-Pipe/"
};


public OnPluginStart ()
{
    CreateConVar ("sm_pipeforce_version", PLUGIN_VERSION, "CfgPipe CVar Forcer version", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
    /* register the sm_pipe console command */
    RegAdminCmd ("sm_pipe", ClientExec, ADMFLAG_RCON);
	RegConsoleCmd("pipe", ClientExec, "- Pipe ");
}

public Action:ClientExec (client, args)
{
    decl String:szClient[MAX_NAME_LENGTH] = "";
    decl String:szCommand[80] = "";
    static iClient = -1, iMaxClients = 0;

    iMaxClients = GetMaxClients ();

    if (args == 2)
    {
        GetCmdArg (1, szClient, sizeof (szClient));
        GetCmdArg (2, szCommand, sizeof (szCommand));

        if (!strcmp (szClient, "#all", false))
        {
            for (iClient = 1; iClient <= iMaxClients; iClient++)
            {
                if (IsClientConnected (iClient) && IsClientInGame (iClient))
                {
                    if (IsFakeClient (iClient))
                        FakeClientCommand (iClient, szCommand);
                    else
                        ClientCommand (iClient, szCommand);
                }
            }
        }
        else if (!strcmp (szClient, "#bots", false))
        {
            for (iClient = 1; iClient <= iMaxClients; iClient++)
            {
                if (IsClientConnected (iClient) && IsClientInGame (iClient) && IsFakeClient (iClient))
                    FakeClientCommand (iClient, szCommand);
            }
        }
        else if ((iClient = FindTarget (client, szClient, false, true)) != -1)
        {
            if (IsFakeClient (iClient))
                FakeClientCommand (iClient, szCommand);
            else
                ClientCommand (iClient, szCommand);
        }
    }
    else
    {
        ReplyToCommand (client, "sm_pipe invalid format");
        ReplyToCommand (client, "Usage: sm_pipe \"<user>\" \"<command>\"");
    }

    return Plugin_Handled;
}

