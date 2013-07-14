{
 ////////////////////////////////////////////////
 //// Soldat Server TCP Socket Usage Example ////
 ////     by EnEsCe - http://enesce.com      ////
 ////  Please leave this message if you use  ////
 ////      any of these functions! <3 <3     ////
 ////////////////////////////////////////////////
}

{
 Usage: (Creates socket in a seperate thread)
  CreateSocket('127.0.0.1',23073);
 Use the OnDataReceived event below for any data parsing
}


var
SocketIndex: Integer;
SocketConnected: Array of Boolean;

procedure OnDataReceived(Index: Integer; Buffer: String);
begin
  if (Index = 0) or (SocketConnected[Index] = false) then exit; // Disconnected socket?
end;

procedure MainSocketLoop(Index: Integer);
  var Buff: String;
begin
  while SocketConnected[Index] do begin
    ReadLnSocket(Index,Buff);
    if Buff <> '' then OnDataReceived(Index,Buff);
    sleep(1);
  end;
end;

procedure OnConnected(Index: Integer);
begin
  SetArrayLength(SocketConnected,GetArrayLength(SocketConnected)+2);
  ThreadFunc([Index],'MainSocketLoop');
  SocketConnected[GetArrayLength(SocketConnected)-1] := true;
end;

procedure OnDisconnected(Index: Integer);
begin
  SocketConnected[GetArrayLength(SocketConnected)-1] := false;
end;

procedure ThreadedCreate(IP: String;Port: Integer;var IndexVar: Integer);
begin
  ConnectSocket(IP,Port,IndexVar);
  OnConnected(IndexVar);
end;

procedure CreateSocket(IP: String;Port: Integer);
begin
  ThreadFunc([IP,Port,SocketIndex],'ThreadedCreate');
end;