function OnRequestGame(IP: string; State: integer): integer;
begin
  Result := State;
  {
  IMPORTANT NOTE:
    If you modify Result, please take into consideration that the user
    may also be using another script which also modified the result...
    To avoid conflictions, PLEASE perform logical checks...
  }
end;

procedure OnWeaponChange(ID, PrimaryNum, SecondaryNum: byte);
begin
end;

procedure OnJoinGame(ID, Team: byte);
begin
  WriteConsole(ID,'This is a supercool server. Have fun',$EEFF0000);
end;

procedure OnJoinTeam(ID, Team: byte);
begin
end;

procedure OnLeaveGame(ID, Team: byte; Kicked: boolean);
begin
end;

procedure OnFlagGrab(ID, TeamFlag: byte; GrabbedInBase: boolean);
begin
end;

procedure OnFlagReturn(ID, TeamFlag: byte);
begin
end;

procedure OnFlagScore(ID, TeamFlag: byte);
begin
end;

procedure OnMapChange(NewMap: string);
begin
end;

procedure OnPlayerKill(Killer, Victim: byte; Weapon: string);
begin
end;

function OnPlayerDamage(Victim, Shooter: byte; Damage: integer): integer;
begin
  // Victim = Player Damaged // Shooter = Player doing the damage
  result := Damage;
end;

procedure OnPlayerRespawn(ID: byte);
begin
end;

procedure OnPlayerSpeak(ID: byte; Text: string);
begin
end;
