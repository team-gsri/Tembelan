params["_destroyer"];

// Submarine spawn
if(isServer) then {
	// Spawn and place sub
	_sub = "Submarine_01_F" createVehicle [0,0,0];
	_sub enableSimulation false;
	_destroyer setVariable ["submarine", _sub, true];
	_sub setPosASL [(getPosASL _destroyer select 0) + 100, (getPosASL _destroyer select 1) + 100, (getPosASL _destroyer select 2)-10];
	_sub setDir getDir _destroyer;

	// Add map marker
	_mk = createMarker ["marker_submarine", _sub];
	_mk setMarkerType "flag_France";
	_mk setMarkerText "S-625 Devigny";
};

// Adding position selection eventHandler
addMissionEventHandler ["MapSingleClick", GSRI_fnc_submarineSelectPos];

// Adding "abort selection" eventHandler
addMissionEventHandler ["Map", {
	params ["_opened", "_forced"];
	// Detect if map is closed but do not check if the event is linked to this module
	if!(_opened) then {
		player setVariable ["submarine_flag", false];
		if!(player getVariable ["submarine_hadMap",true]) then { player unlinkItem "ItemMap"; player setVariable ["submarine_hadMap", nil] };
	};
}];

// Clientside jobs
if!(isDedicated) then {
	// Create handle for sub movement
	_com = "Land_Battery_F" createVehicleLocal [0,0,0];
	_com enableSimulation false;
	_com attachTo [_destroyer, [-2.94995,-34.0001,20.6]];
	
	// Add actions with map selection
	_statement = {
		if!("ItemMap" in assignedItems player) then { player setVariable ["submarine_hadMap", false]; player linkItem "ItemMap" };
		// Open the map
		openMap true;

		// Set the "submarine flag" for the eventHandler to fire correctly
		player setVariable ["submarine_flag", true];

		// Help notification
		["SubmarineInfo"] call BIS_fnc_showNotification;
	};
	_action = ["submarineSelectPosition","Choisir une destination pour le sous-marin","",_statement,{!isNil{destroyer getVariable "submarine"}}] call ace_interact_menu_fnc_createAction;
	[_com, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

	// Create handle for TP to sub
	_tp = "Land_Battery_F" createVehicleLocal [0,0,0];
	_tp enableSimulation false;
	_tp attachTo [_destroyer,[-2.21198,13.976,7.537]];

	// Add teleport action
	_action = ["teleportToSubmarine", "Aller au sous-marin", "",{player setPosASL (call GSRI_fnc_submarineGetTeleportPos)},{!isNil{destroyer getVariable "submarine"}}] call ace_interact_menu_fnc_createAction;
	[_tp, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;
};