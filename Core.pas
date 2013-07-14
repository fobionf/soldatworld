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
procedure md5login(ID: Byte; name,pass:string);
begin
    content := ReadFile('data/' + name);
    md5 := GetPiece(content,newline,0);
    if md5 = pass then begin
      WriteConsole(ID,'Login successful',$EEFFFF00);
    end else begin
      WriteConsole(ID,'Login failed',$EEFF0000);
    end;
end;

procedure login(ID: Byte; name,pass:string);
begin
    md5login(ID,name,MD5String(pass));
end;



procedure create(ID: Byte; name,pass:string);
begin
    if FileExists('data/'+ name) then begin
      WriteConsole(ID,'Account ' + name + ' exists already',$EEFFFF00);
    end else begin
      content := '';
      content := content + MD5String(pass) + newline;
      WriteFile('data/' + name,content);
      WriteConsole(ID,'Account ' + name + ' created',$EEFFFF00);
    end;
end;
var cmd,param1,param2: string;
function OnPlayerCommand(ID: Byte; Text: string): boolean;
begin
  cmd := GetPiece(Text,' ',0);
  param1 := GetPiece(Text,' ',1);
  param2 := GetPiece(Text,' ',2);
  if cmd = '/create' then begin
    create(ID,param1,param2);
    login(ID,param1,param2);
  end else if cmd = '/login' then begin
     login(ID,param1,param2);
  end else if cmd = '/md5login' then begin
     md5login(ID,param1,param2);
  end;
  //NOTE: This function will be called when [_ANY_] player types a / command.
  Result := false; //Return true if you want disable the command typed.
end;

procedure OnException(ErrorMessage: string);
begin
//  WriteFile('ErrorLog.txt', ErrorMessage);
end;

