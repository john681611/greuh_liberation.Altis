_cleanup_delay = 1200; 

_unit = _this select 0;
_killer = _this select 1;

if ( isServer ) then {

	please_recalculate = true;

	if ( isNil "infantry_weight" ) then { infantry_weight = 33 };
	if ( isNil "armor_weight" ) then { armor_weight = 33 };
	if ( isNil "air_weight" ) then { air_weight = 33 };

	if ( side _killer == WEST ) then {
		if ( _killer isKindOf "Man" ) then {
			infantry_weight = infantry_weight + 1;
			armor_weight = armor_weight - 0.5;
			air_weight = air_weight - 0.5;
		} else {
			if ( (typeof (vehicle _killer) ) in land_vehicles_classnames ) then  {
				infantry_weight = infantry_weight - 0.5;
				armor_weight = armor_weight + 1;
				air_weight = air_weight - 0.5;
			};
			if ( (typeof (vehicle _killer) ) in air_vehicles_classnames ) then  {
				infantry_weight = infantry_weight - 0.5;
				armor_weight = armor_weight - 0.5;
				air_weight = air_weight + 1;
			};
		};
		
		if ( infantry_weight > 100 ) then { infantry_weight = 100 };
		if ( armor_weight > 100 ) then { armor_weight = 100 };
		if ( air_weight > 100 ) then { air_weight = 100 };
		if ( infantry_weight < 0 ) then { infantry_weight = 0 };
		if ( armor_weight < 0 ) then { armor_weight = 0 };
		if ( air_weight < 0 ) then { air_weight = 0 };
	};
	
	if ( isPlayer _unit ) then { stats_player_deaths = stats_player_deaths + 1 };
	
	if ( _unit isKindOf "Man" ) then {
		if ( side (group _unit) == CIVILIAN ) then {
			stats_civilians_killed = stats_civilians_killed + 1;
			if ( isPlayer _killer ) then {
				stats_civilians_killed_by_players = stats_civilians_killed_by_players + 1;
			};
		};
	
		if ( side _killer == WEST ) then {
			if ( side (group _unit) == EAST || side (group _unit) == RESISTANCE ) then {
				stats_opfor_soldiers_killed = stats_opfor_soldiers_killed + 1;
				if ( isplayer _killer ) then {
					stats_opfor_killed_by_players = stats_opfor_killed_by_players + 1;
				};
			};
			
			if ( side (group _unit) == WEST ) then {
				stats_blufor_teamkills = stats_blufor_teamkills + 1;
			};
		} else {
			if ( side (group _unit) == WEST ) then {
				stats_blufor_soldiers_killed = stats_blufor_soldiers_killed + 1;
			};
		};
	} else {
		if ( typeof _unit in all_hostile_classnames ) then {
			stats_opfor_vehicles_killed = stats_opfor_vehicles_killed + 1;
			if ( isplayer _killer ) then {
				stats_opfor_vehicles_killed_by_players = stats_opfor_vehicles_killed_by_players + 1;
			};
		} else {
			stats_blufor_vehicles_killed = stats_blufor_vehicles_killed + 1;
		};
	};
};

if( isServer && !isplayer _unit) then {
	sleep _cleanup_delay;
	hidebody _unit;
	sleep 10;
	deleteVehicle _unit;
};