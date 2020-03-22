_stand = _this select 0;
_probability = param [1,100,[0]];
_cprobability = param [2,10,[0]];


_targets = ["O_soldier_F","o_support_gmg_f"];
_targetsCiv = ["C_man_1","c_man_polo_1_f"];

////////// MISE EN PLACE DES VARIABLES //////////

_positions = [];

{
	if ((typeof _x) == "Land_PenBlack_F") then {
		_positions pushBack _x;
	};
} foreach (list _stand);
if (count _positions == 0) exitWith {hint format ["Veuillez placer au moins un stylo(noir) dans le trigger", _positions, list _stand]};
_chrono = format ["%1_chrono",_stand];
_start = format ["%1_start",_stand];
playerObject = format ["%1_player",_stand];
_playername = format ["%1_playerName",_stand];
_ennemiesTargets = format ["%1_ennemies",_stand];
_civilianTargets = format ["%1_civilians",_stand];
ennemiesFired = format ["%1_ennemiesFired",_stand];
civilianFired = format ["%1_civiliansFired",_stand];

if (missionNamespace getVariable [_playername,""] == "" ) then
{
	missionNamespace setVariable [_chrono,time, true];
	missionNamespace setVariable [_start, time, true];
	missionNamespace setVariable [_playername, name player, true];
	missionnamespace setvariable [_ennemiesTargets, [], true];
	missionnamespace setvariable [_civilianTargets, [], true];
	missionNamespace setVariable [playerObject, player, true];
	missionnamespace setvariable [ennemiesFired, 0, true];
	missionnamespace setvariable [civilianFired, 0, true];



	////////// MISE EN PLACE DES CIBLES //////////

	_targetsList = (missionNamespace getVariable [_ennemiesTargets,[]]) + (missionNamespace getVariable [_civilianTargets,[]]);

	if ((count _targetsList) != 0) then
	{
		{
			deleteVehicle _x;
		} foreach _targetsList;
		missionNamespace setVariable [_ennemiesTargets,[],true];
		missionNamespace setVariable [_civilianTargets,[],true];
	};
	_htargets = [];
	_civTarget = [];
	_targetsTotal = [];
		_t = [];


	{
		_prob = random 100;
		_t pushBack _prob;
		if (_prob <= _probability) then
		{
			if (_prob < _cprobability) then
			{
				_targetsTotal = _targetsCiv;
			} else {
				_targetsTotal = _targets;
			};
			_tgt = selectRandom _targetsTotal;
			_pos = getPosAtl _x;
			_dir = getDir _x - 180;
			_tgtObj = (createGroup EAST) createUnit [_tgt, _pos, [], 0, "FORM"];;
			_tgtObj setDir _dir;

			if (_tgt in _targets) then
			{
				_htargets pushBack _tgtObj;
				_tgtObj addEventHandler [
					"Killed",
					{
						if (_this select 1 == (missionNamespace getVariable [playerObject,objnull])) then {
							_t = missionnamespace getVariable [ennemiesFired,0];
							_t = _t + 1;
							missionnamespace setVariable [ennemiesFired,_t,true];
						}
					}
				];
			}
			else
			{
				_civTarget pushBack _tgtObj;
				_tgtObj addEventHandler [
					"Killed",
					{
						if (_this select 1 == (missionNamespace getVariable [playerObject,objnull])) then {
							_t = missionnamespace getVariable [civilianFired,0];
							_t = _t + 1;
							missionnamespace setVariable [civilianFired,_t,true];
						}
					}
				];
			};
		};
	}foreach _positions;

	hint format ["%1", _t];

	if ((count _htargets) == 0) then
	{
		_pos1 = selectRandom _positions;

		_targetsTotal = _targets;
		_tgt = selectRandom _targetsTotal;
		_pos = getPosAtl _pos1;
		_dir = getDir _pos1 - 180;
		_tgtObj = (createGroup EAST) createUnit [_tgt, _pos, [], 0, "FORM"];;
		_tgtObj setDir _dir;
		if (_tgt in _targets) then
		{
			_htargets pushBack _tgtObj;
			_tgtObj addEventHandler [
				"Killed",
				{
					if (_this select 1 == (missionNamespace getVariable [playerObject,objnull])) then {
						_t = missionnamespace getVariable [ennemiesFired,0];
						_t = _t + 1;
						missionnamespace setVariable [ennemiesFired,_t,true];
					}
				}
			];
		}
		else
		{
			_civTarget pushBack _tgtObj;
			_tgtObj addEventHandler [
			"Killed",
				{
					if (_this select 1 == (missionNamespace getVariable [playerObject,objnull])) then {
						_t = missionnamespace getVariable [civilianFired,0];
						_t = _t + 1;
						missionnamespace setVariable [civilianFired,_t,true];
					}
				}

			];
		};
	};

	missionNamespace setVariable [_ennemiesTargets,_htargets,true];
	missionNamespace setVariable [_civilianTargets,_civTarget,true];
} else
{
	hint format ["Le stand est en cours d'utilisation par %1", missionNamespace getVariable _playername];
};

