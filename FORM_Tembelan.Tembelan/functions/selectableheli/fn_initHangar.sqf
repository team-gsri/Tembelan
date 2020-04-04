params["_hangar"];

if(isServer) then {
	// Add airfield tug
	_tug = "rksla3_aircraft_tug_blufor" createVehicle (_hangar modelToWorld [12.6,13.4,-2.7]);
	_tug animateSource ["option_cabin_hide_source", 0, true];
	_tug setDir (getDir _hangar + 180);

	// Close doors
	_hangar animateSource ["Door_2_sound_source", 0, true];
	_hangar animateSource ["Door_3_sound_source", 0, true];
};

// Add handle and actions
_handle = "Land_Tablet_02_black_F" createVehicleLocal getPos _hangar;
_handle attachTo [_hangar, [10.17,16.15,-1.26]];
_handle setVectorDirAndUp [[0,0,-1],[0,-1,0]];

// Heli actions
_types = ["B_Heli_Transport_01_F", "B_Heli_Attack_01_dynamicLoadout_F", "B_Heli_Light_01_dynamicLoadout_F", "B_Heli_Light_01_F", "B_T_UAV_03_dynamicLoadout_F","MELB_AH6M","MELB_MH6M","UK3CB_BAF_Apache_AH1_DynamicLoadoutUnlimited"];
_hangar setVariable ["GSRI_selectable_heli_list", _types];
{
	if(isClass (configFile >> "CfgVehicles" >> _x)) then {
		_display = [_x] call GSRI_fnc_heliMinifyName;
		_modifier = {
			params ["_target", "_player", "_args", "_actionData"];
			_args params ["_hangar", "_newType"];
			_heli = [_hangar] call GSRI_fnc_heliRetrieveCurrent;
			_displayName = [localize "STR_GSRI_selectable_heliReplace", localize "STR_GSRI_selectable_heliGet"] select (isNull _heli);
			_actionData set [1, format [_displayName, [_heli] call GSRI_fnc_heliMinifyName, [_newType] call GSRI_fnc_heliMinifyName]];
		};
		_condition = {
			params["_target", "_player", "_args"];
			_args params ["_hangar", "_newType"];
			_heli = [_hangar] call GSRI_fnc_heliRetrieveCurrent;
			(([_newType] call GSRI_fnc_heliMinifyName) != ([_heli] call GSRI_fnc_heliMinifyName))
		};
		_action = [format["action%1", _display],_display,"",GSRI_fnc_heliSpawn,_condition,{},[_hangar, _x],"",2,[false, false, false, false, false], _modifier] call ace_interact_menu_fnc_createAction;
		[_handle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	};
} forEach _types;

// Hangar cleaning action
_modifier = {
    params ["_target", "_player", "_args", "_actionData"];
	_args params ["_hangar"];
	_heli = [_hangar] call GSRI_fnc_heliRetrieveCurrent;
    _actionData set [1, format [localize "STR_GSRI_selectable_heliRemove", [_heli] call GSRI_fnc_heliMinifyName]];
};
_condition = {
	params ["_target", "_player", "_args"];
	_args params ["_hangar"];
	!isNull ([_hangar] call GSRI_fnc_heliRetrieveCurrent)
};
_action = ["actionClear","Supprimer","",GSRI_fnc_heliRemove,_condition,{},[_hangar],"",2,[false, false, false, false, false], _modifier] call ace_interact_menu_fnc_createAction;
[_handle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// FRIES mounting action
_condition = {
	params ["_target", "_player", "_args"];
	_args params ["_hangar"];
	_heli = [_hangar] call GSRI_fnc_heliRetrieveCurrent;
	(isNumber (configFile >> "CfgVehicles" >> typeOf _heli >> "ace_fastroping_enabled") && isNull (_heli getVariable ["ace_fastroping_FRIES", objNull]));
};
_action = ["actionFRIES",localize "STR_GSRI_selectable_heliEquipFRIES","",GSRI_fnc_heliEquipFRIES,_condition,{},[_hangar]] call ace_interact_menu_fnc_createAction;
[_handle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;