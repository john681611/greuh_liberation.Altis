iconed_groups = [];
_ticks = 0;

setGroupIconsVisible [true,false];

while { true } do {
	{
		if ((_x != group player) && ((side _x == WEST))) then {
			if ( (_x in iconed_groups) && (
				(count units _x == 0) ||  (side _x == WEST && (((leader _x) distance (getmarkerpos "respawn_west") < 100) || ((leader _x) distance lhd < 500))))) then {
				clearGroupIcons _x;
				iconed_groups = iconed_groups - [_x];
			};
			
			if ( !(_x in iconed_groups) && (
				(count units _x > 0) &&  (side _x == WEST && (((leader _x) distance (getmarkerpos "respawn_west") > 100) && ((leader _x) distance lhd > 500))))) then {
				clearGroupIcons _x;
				_localgroup = _x;	
				_grouptype = [_localgroup] call F_getGroupType;
				_groupicon = "";
				switch (_grouptype) do {
					case "infantry": { _groupicon = "b_inf" };
					case "light": { _groupicon = "b_motor_inf" };
					case "heavy": { _groupicon = "b_armor" };
					case "air": { _groupicon = "b_air" };
					case "support": { _groupicon = "b_maint" };
					case "static": { _groupicon = "b_mortar" };
					case "uav": { _groupicon = "b_uav" };
					default {  };
				};
				
				_localgroup addGroupIcon [ _groupicon, [ 0,0 ] ];
				
				if ( side _localgroup == WEST ) then {
					_groupiconsize = "group_0";
					_groupsize = (count (units _localgroup));
					if ( _groupsize >= 2 ) then { _groupiconsize = "group_1" };
					if ( _groupsize >= 6 ) then { _groupiconsize = "group_2" };
					if ( _groupsize >= 10 ) then { _groupiconsize = "group_3" };
					
					_localgroup addGroupIcon [ _groupiconsize, [ 0,0 ] ];
				};
				
				iconed_groups = iconed_groups + [_x];
			};
		};
	} foreach allGroups;
	
	{
		_color = [];
		if ( isplayer leader _x ) then {
			_color = [0.8,0.8,0,1];
		} else {
			_color = [0,0.3,0.8,1];
		};
		_x setGroupIconParams [_color,"",1,true];
	} foreach iconed_groups;
	
	_ticks = _ticks + 1;
	if ( _ticks >= 15 ) then {
		_ticks = 0;
		iconed_groups = [];
	};
	
	sleep 1.04;
};