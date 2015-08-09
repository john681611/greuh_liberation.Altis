if ( combat_readiness > 15 ) then {

	_targetsector = _this select 0;
	_init_units_count = ( ([ getmarkerpos _targetsector , capture_size , EAST ] call F_getUnitsCount) + ([ getmarkerpos _targetsector , capture_size , RESISTANCE ] call F_getUnitsCount ) );

	if ( !(_targetsector in sectors_bigtown)) then {
		while { (_init_units_count * 0.85) <= ( ([ getmarkerpos _targetsector , capture_size , EAST ] call F_getUnitsCount) + ([ getmarkerpos _targetsector , capture_size , RESISTANCE ] call F_getUnitsCount ) ) } do { 
			sleep 5; 
		};
	};
	
	if ( _targetsector in active_sectors ) then {
	
		_nearestower = [markerpos _targetsector, EAST, radiotower_size * 1.33] call F_getNearestTower;

		if ( _nearestower != "" ) then {
			_reinforcements_time = ( ((((markerpos _nearestower) distance (markerpos _targetsector)) / 1000) ^ 1.3 ) * 5) * 20;
			_current_timer = time;
			
			waitUntil { sleep 0.3; (_current_timer + _reinforcements_time < time) || (_targetsector in blufor_sectors) || (_nearestower in blufor_sectors) };

			sleep 15;
			
			if ( (_targetsector in active_sectors) && !(_targetsector in blufor_sectors) && !(_nearestower in blufor_sectors) ) then {
				reinforcements_sector_under_attack = _targetsector;
				reinforcements_set = true;
				[ [ "lib_reinforcements" , [ markertext  _targetsector ] ] , "bis_fnc_shownotification" ] call BIS_fnc_MP;
				stats_reinforcements_called = stats_reinforcements_called + 1;
			};
		};
	};
};
	
