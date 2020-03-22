// Return a suitable position where the player can be safely teleported

_pos = getPosASL (destroyer getVariable "submarine");
_z = _pos select 2;
_pos set [2, _z + 12];

_pos