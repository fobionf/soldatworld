{$VERSION 2.6.0}
const
//Teams
  ALPHA = 1;
  BRAVO = 2;
  CHARLIE = 3;
  DELTA = 4;
  SPECTATOR = 5;
//Game Modes
  DEATHMATCH = 0;
  POINTMATCH = 1;
  TEAMMATCH = 2;
  CTF = 3;
  RAMBO = 4;
  INF = 5;
  HTF = 6;
//Weapons
  DEAGLES = 1;
  HKMP5 = 2;
  AK74 = 3;
  STEYR = 4;
  SPAS = 5;
  RUGER = 6;
  M79 = 7;
  BARRET = 8;
  MINIMI = 9;
  MINIGUN = 10;
  FLAMER = 11;
  BOW = 12;
  FLAMEBOW = 13;
  SOCOM = 0;
  KNIFE = 14;
  CHAINSAW = 15;
  LAW = 16;
 
 
var newline : string;
 
procedure ActivateServer();
begin
  newline := chr(13) + chr(10)
end;
 
procedure AppOnIdle(Ticks: integer);
begin
end;
 
function OnCommand(ID: Byte; Text: string): boolean;
begin
  //NOTE: This function will be called when an admin types a / command.
  Result := false; // Return true if you want to ignore the command typed.
end;
 
var content,md5:string;
var target : array[1..32] of Byte;
var loggedIn : array[1..32] of Boolean;
var playername : array[1..32] of String;
var playerpass : array[1..32] of String;
var cmd,param1,param2: string;
var x,y: single;
var exp_needed : array[1..32] of array[1..16] of Integer;
var exp : array[1..32] of array[1..16] of Integer;

procedure get_experience(ID, Skill: Byte; Exp: Integer);
begin
  if exp[ID][Skill] > exp_needed[ID][Skill] -1 then begin
    WriteConsole(ID,'Level Up', $EE0000FF);
    exp_needed[ID][Skill] = exp_needed[ID][Skill] + exp_needed[ID][Skill]/10; 
    end; 
end;

procedure md5login(ID: Byte; name,pass:string);
begin
    if loggedIn[ID] then begin
      WriteConsole(ID,'You already Logged in, Idiot!',$EEFF0000);
    end else begin
      content := ReadFile('data/' + name);
      md5 := GetPiece(content,newline,0);
      if md5 = pass then begin
        WriteConsole(ID,'Login successful',$EEFFFF00);
        playername[ID] := name;
        playerpass[ID] := pass;
        loggedIn[ID] := True;
        x := strToFloat(GetPiece(content,newline,1));
        y := strToFloat(GetPiece(content,newline,2));
        MovePlayer(ID,x,y);
      end else begin
        WriteConsole(ID,'Login failed',$EEFF0000);
      end;
    end;
end;
 
procedure login(ID: Byte; name,pass:string);
begin
    md5login(ID, name, copy(MD5String(pass),0,32));
end;
 
procedure save(ID: Byte);
begin
  GetPlayerStat(ID: Byte; Stat: string): variant;
  content := '';
  content := content + inttostr(GetPlayerStat(1,'Deaths'));
  content := content + inttostr(GetPlayerStat(1,'Kills'));
  content := content + inttostr(GetPlayerStat(1,'Primary'));
  GetPlayerXY(ID,x,y);
  content := '';
  content := content + playerpass[ID] + newline;
  content := content + floattostr (x) + newline;
  content := content + floattostr (y) + newline;
  WriteFile('data/' + playername[ID], content);
  WriteConsole(ID, 'Save complete', $EE7CFC00)
end;
 
procedure create(ID: Byte; name, pass:string);
begin
    if FileExists('data/'+ name) then begin
      WriteConsole(ID,'Account ' + name + ' exists already',$EEFFFF00);
    end else begin
      playername[ID] := name;
      playerpass[ID] := copy(MD5String(pass),0,32);
      WriteConsole(ID,'Account ' + name + ' created',$EEFFFF00);
    end;
end;
 
function OnPlayerCommand(ID: Byte; Text: string): boolean;
begin
  cmd := GetPiece(Text,' ',0);
  param1 := GetPiece(Text,' ',1);
  param2 := GetPiece(Text,' ',2);
  if cmd = '/create' then begin
    create(ID,param1,param2);
    save(ID);
    login(ID,param1,param2);
  end else if cmd = '/login' then begin
    login(ID,param1,param2);
  end else if cmd = '/logout' then begin
    save(ID); 
    loggedIn[ID] := False;
  end else if cmd = '/save' then begin
    save(ID);
  end else if cmd = '/md5login' then begin
    md5login(ID,param1,param2);    
  end else if cmd = '/assassinate' then begin
    if target[ID]<>0 then begin
      GetPlayerXY(target[ID],x,y);
      MovePlayer(ID,x,y);
    end;
  end;
  //NOTE: This function will be called when [_ANY_] player types a / command.
  Result := false; //Return true if you want disable the command typed.
end;
 
procedure OnException(ErrorMessage: string);
begin
//  WriteFile('ErrorLog.txt', ErrorMessage);
end;
