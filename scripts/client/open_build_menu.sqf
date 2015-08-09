if ( isNil "buildtype" ) then { buildtype = 1 };
if ( isNil "buildindex" ) then { buildindex = -1 };
dobuild = 0;
_oldbuildtype = -1;
_cfg = configFile >> "cfgVehicles";
_initindex = buildindex;

_dialog = createDialog "liberation_build";
waitUntil { dialog };

_iscommandant = false;
if ( !isNil "commandant" ) then {
	if ( player == commandant ) then {
		_iscommandant = true;
	};
};

ctrlShow [ 108, _iscommandant ];
ctrlShow [ 1085, _iscommandant ];
ctrlShow [ 121, _iscommandant ];

_squadname = "";

while { dialog && alive player && (dobuild == 0 || buildtype == 1)} do {
	_build_list = build_lists select buildtype;
	
	if (_oldbuildtype != buildtype || synchro_done ) then {
		synchro_done = false;
		_oldbuildtype = buildtype;
		
		lbClear 110;
		{	
			if ( buildtype != 8 ) then {
				_classnamevar = (_x select 0);
				_entrytext = getText (_cfg >> _classnamevar >> "displayName");
				if ( _classnamevar == FOB_box_typename ) then {
					_entrytext = localize "STR_FOBBOX";
				};
				if ( _classnamevar == Arsenal_typename ) then {
					_entrytext = localize "STR_ARSENAL_BOX";
				};
				if ( _classnamevar == Respawn_truck_typename ) then {
					_entrytext = localize "STR_RESPAWN_TRUCK";
				};
				if ( _classnamevar == FOB_truck_typename ) then {
					_entrytext = localize "STR_FOBTRUCK";
				};
				((findDisplay 5501) displayCtrl (110)) lnbAddRow [ _entrytext, format [ "%1" ,_x select 1], format [ "%1" ,_x select 2], format [ "%1" ,_x select 3]];

				_icon = getText ( _cfg >> (_x select 0) >> "icon");
				if(isText  (configFile >> "CfgVehicleIcons" >> _icon)) then {
					_icon = (getText (configFile >> "CfgVehicleIcons" >> _icon));
				};
				lnbSetPicture  [110, [((lnbSize 110) select 0) - 1, 0],_icon];
			} else {
				if ( ((lnbSize  110) select 0) <= count squads_names ) then {
					_squadname = squads_names select ((lnbSize  110) select 0);
				} else {
					_squadname = "";
				};
				((findDisplay 5501) displayCtrl (110)) lnbAddRow  [_squadname, format [ "%1" ,_x select 1], format [ "%1" ,_x select 2], format [ "%1" ,_x select 3]];
			};
			
			_affordable = true;
			if( 
				((_x select 1) > (infantry_cap - resources_infantry)) || 
				((_x select 2) > resources_ammo) || 
				((_x select 3) > (fuel_cap - resources_fuel))
				) then {
				_affordable = false;
			};
			
			if ( _affordable ) then {
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 0], [1,1,1,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 1], [1,1,1,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 2], [1,1,1,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 3], [1,1,1,1]];
			} else {
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 0], [0.4,0.4,0.4,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 1], [0.4,0.4,0.4,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 2], [0.4,0.4,0.4,1]];
				((findDisplay 5501) displayCtrl (110)) lnbSetColor  [[((lnbSize 110) select 0) - 1, 3], [0.4,0.4,0.4,1]];
			};
			
		} foreach _build_list;
	};
	
	if(_initindex != -1) then {
		lbSetCurSel [110, _initindex];
		_initindex = -1;
	};
	
	_selected_item = lbCurSel 110;
	_affordable = false;
	if (dobuild == 0 && _selected_item != -1 && (_selected_item < (count _build_list)) && !(buildtype == 1 && (count (units group player)) >= 10 )) then {
		_build_item = _build_list select _selected_item;
		if (
				((_build_item select 1) <= (infantry_cap - resources_infantry)) &&
				((_build_item select 2) <= resources_ammo) &&
				((_build_item select 3) <= (fuel_cap - resources_fuel))
		) then {
			_affordable = true;
		};
	};
	
	_affordable_crew = _affordable;
	if ( unitcap >= ([] call F_localCap)) then {
		_affordable_crew = false;
		if (buildtype == 1 || buildtype == 8) then {
			_affordable = false;
		};
	};
	
	ctrlEnable [120, _affordable];
	ctrlEnable [121, _affordable_crew];

	ctrlSetText [131, format [ "%1 : %2/%3" , localize "STR_MANPOWER" , (floor resources_infantry), infantry_cap]] ;
	ctrlSetText [132, format [ "%1 : %2" , localize "STR_AMMO" , (floor resources_ammo)] ];
	ctrlSetText [133, format [ "%1 : %2/%3" , localize "STR_FUEL" , (floor resources_fuel), fuel_cap] ];
	ctrlSetText [134, format [ "%1 : %2/%3" , localize "STR_UNITCAP" , unitcap, ([] call F_localCap)] ];
	
	buildindex = _selected_item;
	
	if(buildtype == 1 && dobuild != 0) then {
		ctrlEnable [120, false];
		ctrlEnable [121, false];
		sleep 1;
		dobuild = 0;
	};
};

if (!alive player || dobuild != 0) then { closeDialog 0 };