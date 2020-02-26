public void OnClientPutInServer(int client)    // When client has fully connected to the server,
{
    PrintToChat(client, "Hello, %N", client);  // Display client-only message to newly connected client.
} 