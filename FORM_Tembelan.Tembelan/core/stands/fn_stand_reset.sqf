_stand = _this select 0;

_chrono = format ["%1_chrono",_stand];
_start = format ["%1_start",_stand];
_playerObject = format ["%1_player",_stand];
_playername = format ["%1_playerName",_stand];
_ennemiesTargets = format ["%1_ennemies",_stand];
_civilianTargets = format ["%1_civilians",_stand];
_ennemiesFired = format ["%1_ennemiesFired",_stand];
_civilianFired = format ["%1_civiliansFired",_stand];

_targetList = missionNamespace getVariable [_ennemiesTargets,[]];
_civilianList = missionNamespace getVariable [_civilianTargets,[]];
_targets = [];
_targets = _targetList + _civilianList;
{
	deleteVehicle _x;
} foreach _targets;

missionnamespace setvariable [_ennemiesTargets,[],true];
missionnamespace setvariable [_civilianTargets,[],true];
missionnamespace setvariable [_ennemiesFired,0,true];
missionnamespace setvariable [_civilianFired,0,true];
missionnamespace setvariable [_chrono,0,true];
missionnamespace setvariable [_playerObject,objnull,true];
missionnamespace setvariable [_playername,"",true];
missionnamespace setvariable [_playerObject,objNull,true];


_phrase = format ["Le stand %1 a été réinitiélisé.",_stand];
[player,_phrase] remoteexec ["sidechat",0];