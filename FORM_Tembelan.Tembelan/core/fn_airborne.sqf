_case = _this select 0;
_height  = param [1,3000,[0]];
_speed  = param [2,200,[0]];
_class   = param[3,"B_T_VTOL_01_Infantry_F",[""]];

switch (_case) do
{
	case "init":
	{
		openMap true;
		hint "Position de départ de l'avion";
		onMapSingleClick "missionNamespace setVariable ['planePosStart', _pos,true];";
		waitUntil { count (missionNamespace getVariable ["planePosStart",[]]) != 0};
		hint "Position de fin de l'avion";
		onMapSingleClick "missionNamespace setVariable ['planePosStop', _pos,true];";
		waitUntil { count (missionNamespace getVariable ["planePosStop",[]]) != 0};
		openMap false;
	};


	case "addWaiting":
	{
		_wait = missionNamespace getVariable ["planeWaiting", []];
		if (player in _wait) then {
			hint "Vous êtes déjà dans la liste d'embarquement de l'avion.";
		} else {
			_wait pushBack player;
			missionNamespace setVariable  ["planeWaiting", _wait,true];
			hint "Vous avez été ajouté à la liste d'embarquement de l'avion.";
		};
	};

	case "removeWaiting":
	{
		_wait = missionNamespace getVariable ["planeWaiting", []];
		if (player in _wait) then {
			_pos = _wait find player;
			_wait deleteAt _pos;
			missionNamespace setVariable  ["planeWaiting", _wait,true];
			hint "Vous n'êtes plus dans la liste d'embarquement de l'avion.";
		} else {
			hint "Vous n'êtes pas dans la liste d'embarquement de l'avion.";
		};
	};

	case "launchPlane":
	{
		_start   = missionnamespace getVariable ["planePosStart", []];
		_end   = missionnamespace getVariable ["planePosStop", []];
		_side  = WEST;
		_list = missionNamespace getVariable ["planeWaiting",[]];

		if (count _start == 3 && count _end == 3 && count _list != 0) then { [2, _height];
			_start set [2,_height];
			_end set [2, _height];

			_direction = [_start, _end] call BIS_fnc_dirTo;

			_vehicleContainer = [_start, _direction, _class, _side] call BIS_fnc_spawnVehicle;
			_vehicle   = _vehicleContainer select 0;
			_vehicleCrew  = _vehicleContainer select 1;
			_vehicleGroup  = _vehicleContainer select 2;

			_vehicle disableAi "TARGET";
			_vehicle disableAi "AUTOTARGET";
			_vehicleGroup allowFleeing 0;

			_vehicle flyInHeight _height;

			_waypoint = _vehicleGroup addWaypoint [_end, 0];

			_waypoint setWaypointType "MOVE";
			_waypoint setWaypointBehaviour "CARELESS";
			_waypoint setWaypointCombatMode "BLUE";
			_vehicle limitspeed _speed;

			_waypoint setWaypointStatements [
			 "true",
			 "private ['_group', '_vehicle']; _group = group this; _vehicle = vehicle this; { deleteVehicle _x } forEach units _group; deleteVehicle _vehicle; deleteGroup _group;"
			];

			{
				_x moveInAny _vehicle;
			} foreach _list;
			missionnamespace setVariable ["planePosStart", []];
			missionnamespace setVariable ["planePosStop", []];
			missionNamespace setVariable ["planeWaiting",[]];
		} else {
			if (count _start != 3 && count _end != 3) then
			{
				hint "L'itinéraire de l'avion n'a pas été défini.";
			};

			if (count _list == 0) then
			{
				hint "Personne dans la liste d'embarquement";
			};
		};
	};
};





