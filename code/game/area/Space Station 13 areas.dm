/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	var/eject = null

	var/requires_power = 1
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1

	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

proc/process_teleport_locs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(teleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (teleportlocs.len - 1), i++)
			if(sorttext(teleportlocs[i], teleportlocs[i+1]) == -1)
				teleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)

var/list/ghostteleportlocs = list()

proc/process_ghost_teleport_locs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/derelict))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 5 || picked.z == 3)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	var/not_in_order = 0
	do
		not_in_order = 0
		if(ghostteleportlocs.len <= 1)
			break
		for(var/i = 1, i <= (ghostteleportlocs.len - 1), i++)
			if(sorttext(ghostteleportlocs[i], ghostteleportlocs[i+1]) == -1)
				ghostteleportlocs.Swap(i, i+1)
				not_in_order = 1
	while(not_in_order)

/*-----------------------------------------------------------------------------*/

// ###- SPLASH SCREEN -###

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

/area/turret_protected // ABSTRACT

// ###- SHUTTLES AND SHIPS -###

//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle // ABSTRACT - DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

// ARRIVAL SHUTTLE

/area/shuttle/arrival // ABSTRACT
	name = "\improper Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

// ESCAPE SHUTTLE

/area/shuttle/escape // ABSTRACT
	music = "music/escape.ogg"

/area/shuttle/escape/station
	name = "\improper Emergency Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "\improper Emergency Shuttle Transit"
	icon_state = "shuttle"

// ESCAPE POD 1

/area/shuttle/escape_pod1 // ABSTRACT
	name = "\improper Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"

// ESCAPE POD 2

/area/shuttle/escape_pod2 // ABSTRACT
	name = "\improper Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"

// ESCAPE POD 3

/area/shuttle/escape_pod3 // ABSTRACT
	name = "\improper Escape Pod Three"
	music = "music/escape.ogg"

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"

// ESCAPE POD 4

/area/shuttle/escape_pod4 // ABSTRACT
	name = "\improper Escape Pod Four"
	music = "music/escape.ogg"

/area/shuttle/escape_pod4/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod4/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod4/transit
	icon_state = "shuttle"

// ESCAPE POD 5

/area/shuttle/escape_pod5 // ABSTRACT
	name = "\improper Escape Pod Five"
	music = "music/escape.ogg"

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"

// MINING SHUTTLE

/area/shuttle/mining // ABSTRACT
	name = "\improper Mining Shuttle"
	music = "music/escape.ogg"

/area/shuttle/mining/station
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	icon_state = "shuttle"

// CENTCOM TRANSPORT SHUTTLE

/area/shuttle/transport // ABSTRACT
	name = "\improper CentCom Transport Shuttle"

/area/shuttle/transport/centcom
	icon_state = "shuttle2"

/area/shuttle/transport/station
	icon_state = "shuttle"

// XENO SHUTTLE

/area/shuttle/alien // ABSTRACT
	name = "\improper Alien Shuttle"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1

/area/shuttle/alien/base
	icon_state = "shuttle2"

/area/shuttle/alien/mine
	icon_state = "shuttle"

// ERT SHUTTLE

/area/shuttle/ert // ABSTRACT
	name = "\improper Emergency Response Team Shuttle"

/area/shuttle/ert/centcom
	icon_state = "shuttlered"

/area/shuttle/ert/station
	icon_state = "shuttlered2"

// DEATH SQUAD SHUTTLE

/area/shuttle/death_squad // ABSTRACT
	name = "\improper Emergency Response Team Shuttle"

/area/shuttle/death_squad/centcom
	icon_state = "shuttlered"

/area/shuttle/death_squad/station
	icon_state = "shuttlered2"

// ELITE SYNDICATE SHUTTLE

/area/shuttle/syndicate_elite // ABSTRACT
	name = "\improper Syndicate Elite Shuttle"

/area/shuttle/syndicate_elite/mothership
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	icon_state = "shuttlered2"

// ADMIN SHIP

/area/shuttle/administration // ABSTRACT
	name = "\improper Administration Shuttle"

/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle Centcom"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/administration/southStation
	name = "\improper Admin Shuttle South"
	icon_state = "shuttlered2"

/area/shuttle/administration/derelictShip
	name = "\improper Admin Shuttle Derelict Ship"
	icon_state = "shuttlered2"

/area/shuttle/administration/derelictStation
	name = "\improper Admin Shuttle Derelict Station"
	icon_state = "shuttlered2"

/area/shuttle/administration/pirateDJStation
	name = "\improper Admin Shuttle Pirate Radio"
	icon_state = "shuttlered2"

/area/shuttle/administration/abandonedMiningStation
	name = "\improper Admin Shuttle Abandoned Mining Station"
	icon_state = "shuttlered2"

/area/shuttle/administration/spaceFarm
	name = "\improper Admin Shuttle Space Farm"
	icon_state = "shuttlered2"

/area/shuttle/administration/transit
	name = "\improper Admin Shuttle Abandoned Mining Station"
	icon_state = "shuttle"

// RESEARCH SHUTTLE

/area/shuttle/research // ABSTRACT
	name = "\improper Research Shuttle"
	music = "music/escape.ogg"

/area/shuttle/research/station
	icon_state = "shuttle2"

/area/shuttle/research/outpost
	icon_state = "shuttle"

// SYNDICATE SHIP

/area/shuttle/syndicate // ABSTRACT
	name = "\improper Syndicate Station"
	icon_state = "yellow"

/area/shuttle/syndicate/start
	name = "\improper Syndicate Forward Operating Base"
	icon_state = "yellow"

/area/shuttle/syndicate/southwest
	name = "\improper south-west of SS13"
	icon_state = "southwest"

/area/shuttle/syndicate/northwest
	name = "\improper north-west of SS13"
	icon_state = "northwest"

/area/shuttle/syndicate/northeast
	name = "\improper north-east of SS13"
	icon_state = "northeast"

/area/shuttle/syndicate/southeast
	name = "\improper south-east of SS13"
	icon_state = "southeast"

/area/shuttle/syndicate/north
	name = "\improper north of SS13"
	icon_state = "north"

/area/shuttle/syndicate/south
	name = "\improper south of SS13"
	icon_state = "south"

/area/shuttle/syndicate/mining
	name = "\improper north east of the mining asteroid"
	icon_state = "north"

/area/shuttle/syndicate/transit
	name = "\improper hyperspace"
	icon_state = "shuttle"

// VOX SHUTTLE

/area/shuttle/vox // ABSTRACT
	name = "\improper Vox Skipjack"
	icon_state = "yellow"

/area/shuttle/vox/station
	name = "\improper Vox Skipjack"
	icon_state = "yellow"

/area/shuttle/vox/transit
	name = "\improper hyperspace"
	icon_state = "shuttle"

/area/shuttle/vox/southwest_solars
	name = "\improper aft port solars"
	icon_state = "southwest"

/area/shuttle/vox/northwest_solars
	name = "\improper fore port solars"
	icon_state = "northwest"

/area/shuttle/vox/northeast_solars
	name = "\improper fore starboard solars"
	icon_state = "northeast"

/area/shuttle/vox/southeast_solars
	name = "\improper aft starboard solars"
	icon_state = "southeast"

/area/shuttle/vox/mining
	name = "\improper nearby mining asteroid"
	icon_state = "north"

// ###- UNREACHABLE UNSIMULATED AREAS -###

// XENO BASE

/area/alien
	name = "\improper Alien base"
	icon_state = "yellow"
	requires_power = 0

// CENTCOM

/area/centcom // ABSTRACT
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = 0

/area/centcom/control
	name = "\improper Centcom Control"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "\improper Centcom Administration Shuttle"

/area/centcom/death_squad
	name = "\improper Centcom Special Operations"

/area/centcom/living
	name = "\improper Centcom Living Quarters"

/area/centcom/ert
	name = "\improper Centcom ERT"

/area/centcom/zylo
	name = "Zylo's Office"

/area/centcom/holding
	name = "\improper Holding Facility"

// NSS SWORD

// SPACE FARM

/area/space_farm
	name = "\improper Space Farm"
	icon_state = "green"
	requires_power = 0

//SYNDICATE BASE

/area/syndicate_mothership
	name = "\improper Syndicate Mothership"
	icon_state = "syndie-ship"
	requires_power = 0

/area/syndicate_mothership/control
	name = "\improper Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Syndicate Elite Squad"
	icon_state = "syndie-elite"

// WIZARD STATION

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

// VOX STATION

/area/vox_station/dock
	name = "\improper Vox Dock"
	icon_state = "green"
	requires_power = 0

// ###- THE STATION -###

// COMMAND

/area/command/ // ABSTRACT
	name = "Command"
	icon_state = "command_base"

/area/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	music = "signal"

/area/command/emergencyBridge
	name = "\improper Emergency Bridge"
	icon_state = "bridge"

/area/command/meeting_room
	name = "\improper Heads of Staff Meeting Room"
	icon_state = "bridge"
	music = null

/area/command/iaoffice
	name = "\improper Internal Affairs Office"
	icon_state = "law"

// COMMAND'S OFFICES

/area/command/office/ // ABSTRACT
	name = "Command's Offices"

/area/command/office/captain
	name = "\improper Captain's Office"
	icon_state = "captain_office"

/area/command/office/hop
	name = "\improper Head of Personnel's Office"
	icon_state = "personnel_office"

/area/command/office/hos
	name = "\improper Head of Security's Office"
	icon_state = "sec_head_office"

/area/command/office/ce
	name = "\improper Chief Engineer's Office"
	icon_state = "eng_head_office"

/area/command/office/cmo
	name = "\improper Chief Medical Officer's Office"
	icon_state = "med_head_office"

/area/command/office/rd
	name = "\improper Research Director's Office"
	icon_state = "rd_head_office"

// COMMAND'S QUARTERS

/area/command/quarters/ // ABSTRACT
	name = "Command's Quarters"

/area/command/quarters/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain_quarters"

/area/command/quarters/hop
	name = "\improper Head of Personnel's Quarters"
	icon_state = "personnel_quarters"

/area/command/quarters/hos
	name = "\improper Head of Security's Quarters"
	icon_state = "sec_head_quarters"

/area/command/quarters/ce
	name = "\improper Chief Engineer's Quarters"
	icon_state = "eng_head_quarters"

/area/command/quarters/cmo
	name = "\improper Chief Medical Officer's Quarters"
	icon_state = "med_head_quarters"

/area/command/quarters/rd
	name = "\improper Research Director's Quarters"
	icon_state = "rd_head_quarters"

// ENGINEERING

/area/eng //ABSRACT
	name = "\improper Engineering"
	icon_state = "eng_base"

/area/eng/atmos
 	name = "\improper Atmospherics"
 	icon_state = "atmos"

/area/eng/atoms_office
	name = "\improper Atmospherics Office"

/area/eng/comms
	name = "\improper Communications"
	icon_state = "tcomsatcham"

/area/eng/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engine"

/area/eng/reactor
	name = "Power Generator"
	icon_state = "engine_smes"

/area/eng/tech_storage
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/eng/server
	name = "\improper Server Room"
	icon_state = "server"

/area/eng/northwest_solar_access
	name = "Northwest Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/eng/northeast_solar_access
	name = "Northeast Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/eng/southeast_solar_access
	name = "Southeast Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/eng/southwest_solar_access
	name = "Southwest Solar Maintenance"
	icon_state = "SolarcontrolP"

//SOLARS

/area/solar
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/solar/northwest
	name = "\improper Northwest Solar Array"
	icon_state = "panelsA"

/area/solar/northeast
	name = "\improper Northeast Solar Array"
	icon_state = "panelsA"

/area/solar/southeast
	name = "\improper Southeast Solar Array"
	icon_state = "panelsS"

area/solar/southwest
	name = "\improper Southwest Solar Array"
	icon_state = "panelsP"

//MAINTENANCE TUNNELS

/area/maintenance/tunnel1
	name = "EVA Maintenance"
	icon_state = "fpmaint"

/area/maintenance/tunnel2
	name = "Arrivals North Maintenance"
	icon_state = "fpmaint"

/area/maintenance/tunnel3
	name = "Dormitory Maintenance"
	icon_state = "fsmaint"

/area/maintenance/tunnel4
	name = "Bar Maintenance"
	icon_state = "fsmaint"

/area/maintenance/tunnel5
	name = "Medbay Maintenance"
	icon_state = "asmaint"

/area/maintenance/tunnel6
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/tunnel7
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/tunnel8
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/tunnel9
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/tunnel10
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/tunnel11
	name = "Locker Room Maintenance"
	icon_state = "pmaint"

/area/maintenance/tunnel12
	name = "Engineering Maintenance"
	icon_state = "amaint"

/area/maintenance/tunnel13
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/tunnel14
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/tunnel15
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/tunnel16
	name = "Atmospherics"
	icon_state = "green"

// HALLWAYS

/area/hallway/primary/north
	name = "\improper North Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/east
	name = "\improper East Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/south
	name = "\improper South Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/west
	name = "\improper West Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "\improper Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/secondary/exit
	name = "\improper Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/arrivals
	name = "\improper Arrivals Hallway"
	icon_state = "entry"

/area/hallway/secondary/shuttle
	name = "\improper Shuttle Dock"
	icon_state = "green"

// CIVILIAN AREAS

/area/civ
	name = "Civilian Areas"
	icon_state = "civ_base"

/area/civ/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/civ/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/civ/bar
	name = "\improper Bar"
	icon_state = "bar"

/area/civ/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/civ/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/civ/clown
	name = "\improper Clown's Office"
	icon_state = "Theatre"

/area/civ/library
 	name = "\improper Library"
 	icon_state = "library"

/area/civ/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"

/area/civ/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

// MISC STATION AREAS

/area/misc
	name = "Misc. Areas"
	icon_state = "misc_base"

/area/misc/dorms
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/misc/lockers
	name = "\improper Locker Room"
	icon_state = "locker"

/area/misc/restroom1
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"

/area/misc/restroom2
	name = "\improper Locker Toilets"
	icon_state = "toilet"

/area/misc/restroom3
	name = "\improper Toilets"
	icon_state = "toilet"

/area/misc/restroom4
	name = "\improper Toilets"
	icon_state = "toilet"

/area/misc/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/eng/server
	name = "\improper Server Room"
	icon_state = "server"


// HOLODECK

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	luminosity = 1
	lighting_use_dynamic = 0

/area/holodeck/alphadeck
	name = "\improper Holodeck Alpha"

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"
	icon_state = "Holodeck"

/area/holodeck/source_emptycourt
	name = "\improper Holodeck - Empty Court"

/area/holodeck/source_boxingcourt
	name = "\improper Holodeck - Boxing Court"

/area/holodeck/source_basketball
	name = "\improper Holodeck - Basketball Court"

/area/holodeck/source_thunderdomecourt
	name = "\improper Holodeck - Thunderdome Court"

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach"
	icon_state = "Holodeck" // Lazy.

/area/holodeck/source_burntest
	name = "\improper Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "\improper Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "\improper Holodeck - Meeting Hall"

/area/holodeck/source_theatre
	name = "\improper Holodeck - Theatre"

/area/holodeck/source_picnicarea
	name = "\improper Holodeck - Picnic Area"

/area/holodeck/source_snowfield
	name = "\improper Holodeck - Snow Field"

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"

/area/holodeck/source_space
	name = "\improper Holodeck - Space"

// RESEARCH

/area/research
	name = "\improper Research Dept."

/area/research/mech_bay
	name = "\improper Mech Bay"
	icon_state = "rd_mech"

/area/research/robotics
	name = "\improper Robotics Lab"
	icon_state = "rd_robotics"

/area/research/hallway
	name = "\improper Research Hallway"
	icon_state = "rd_hallway"

/area/research/lab
	name = "\improper Research Lab"
	icon_state = "rd_lab"

/area/research/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "rd_misc"

/area/research/rdoffice
	name = "\improper Research Director's Office"
	icon_state = "rd_head_office"

/area/research/server
	name = "\improper Server Room"
	icon_state = "server"

/area/research/toxin_mixing
	name = "\improper Toxins Mixing Room"
	icon_state = "rd_toxin"

/area/research/toxin_storage
	name = "\improper Toxins Storage"
	icon_state = "rd_toxin_storage"

/area/research/toxin_test_area
	name = "\improper Toxins Test Area"
	icon_state = "toxtest"

/area/research/xenobiology
	name = "\improper Xenobiology"
	icon_state = "rd_xenobio"

//TELEPORTER

/area/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/teleporter_storage
	name = "\improper Teleporter"
	icon_state = "green"

/area/gateway
	name = "\improper Gateway"
	icon_state = "teleporter"
	music = "signal"

//MEDICAL

/area/medical
	name = "Medical Department"
	icon_state = "med_base"

/area/medical/hallway
	name = "\improper Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"

/area/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"

/area/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/virology
	name = "\improper Virology"
	icon_state = "virology"

/area/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/biostorage
	name = "\improper Secondary Storage"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbreak
	name = "\improper Break Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/reception
	name = "\improper Medbay Reception"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/patients_rooms
	name = "\improper Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "\improper Medbay Patient Ward"
	icon_state = "patients"

/area/medical/surgery
	name = "\improper Surgery"
	icon_state = "surgery"

/area/medical/surgeryobs
	name = "\improper Surgery Observation"
	icon_state = "surgery"

/area/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

//SECURITY

/area/security/main
	name = "\improper Security Office"
	icon_state = "security"

/area/security/courtroom
	name = "\improper Courtroom"
	icon_state = "courtroom"

/area/security/dorms
	name = "\improper Security Dorms"
	icon_state = "sec_base"

/area/security/lobby
	name = "\improper Security lobby"
	icon_state = "security"

/area/security/brig
	name = "\improper Brig"
	icon_state = "brig"

/area/security/prison
	name = "\improper Prison Wing"
	icon_state = "sec_prison"

/area/security/warden
	name = "\improper Warden"
	icon_state = "Warden"

/area/security/armoury
	name = "\improper Armory"
	icon_state = "armory"

/area/security/det_office
	name = "\improper Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "\improper Firing Range"
	icon_state = "firingrange"

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"

/area/security/checkpoint // ABSTRACT
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint/arrivals
	name = "\improper Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/mining
	name = "\improper Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/research
	name = "\improper Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/mining
	name = "Security Post - Mining Station"
	icon_state = "checkpoint1"

/area/security/checkpoint/research
	name = "Security Post - Research"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "\improper Vacant Office"
	icon_state = "security"

// CARGO

/area/cargo // ABSTRACT
	name = "Cargo"
	icon_state = "cargo_base"

/area/cargo/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/cargo/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/cargo/office
	name = "\improper Cargo Office"
	icon_state = "quartoffice"

/area/cargo/supply_dock
	name = "\improper Cargo Bay"
	icon_state = "quartstorage"

/area/cargo/qm_office
	name = "\improper Quartermaster's Office"
	icon_state = "quart"

/area/cargo/mining_storage
	name = "\improper Mining Storage"
	icon_state = "green"

//STORAGE

/area/storage/aux_tool
	name = "Auxiliary Tool Storage"
	icon_state = "storage"

/area/storage/primary_tool
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

//CONSTRUCTION AREAS

/area/construction/constr1
	name = "\improper Construction Area"
	icon_state = "yellow"

/area/construction/constr2
	name = "\improper Construction Area"
	icon_state = "yellow"

/area/construction/constr3
	name = "\improper Construction Area"
	icon_state = "yellow"

/area/construction/constr4
	name = "\improper Construction Area"
	icon_state = "yellow"

//AI MONITORED

/area/ai_monitored/command/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/cyborg
	name = "\improper Cyborg Station"
	icon_state = "green"

/area/ai_monitored/eng/secure_storage
	name = "Secure Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"

// ASTEROID

/area/asteroid
	name = "\improper Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave
	name = "\improper Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/asteroid/artifactroom
	name = "\improper Asteroid - Artifact"
	icon_state = "cave"

//DJSTATION

/area/djstation
	name = "\improper Ruskie DJ Station"
	icon_state = "DJ"

/area/djstation/solars
	name = "\improper DJ Station Solars"
	icon_state = "DJ"

//DERELICT

/area/derelict
	name = "\improper Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "\improper Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "\improper Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "\improper Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "\improper Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "\improper Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "\improper Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "\improper Derelict Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "\improper Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "\improper Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "\improper Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "\improper Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "\improper Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "\improper Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "\improper Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "\improper Derelict Singularity Engine"
	icon_state = "engine"

/area/destroyed_teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	music = "signal"

// Away Missions
/area/awaymission
	name = "\improper Strange Location"
	icon_state = "away"

/area/awaymission/example
	name = "\improper Strange Station"
	icon_state = "away"

/area/awaymission/wwmines
	name = "\improper Wild West Mines"
	icon_state = "away1"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwgov
	name = "\improper Wild West Mansion"
	icon_state = "away2"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwrefine
	name = "\improper Wild West Refinery"
	icon_state = "away3"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwvault
	name = "\improper Wild West Vault"
	icon_state = "away3"
	luminosity = 0

/area/awaymission/wwvaultdoors
	name = "\improper Wild West Vault Doors"  // this is to keep the vault area being entirely lit because of requires_power
	icon_state = "away2"
	requires_power = 0
	luminosity = 0

/area/awaymission/desert
	name = "Mars"
	icon_state = "away"

/area/awaymission/BMPship1
	name = "\improper Aft Block"
	icon_state = "away1"

/area/awaymission/BMPship2
	name = "\improper Midship Block"
	icon_state = "away2"

/area/awaymission/BMPship3
	name = "\improper Fore Block"
	icon_state = "away3"

/area/awaymission/spacebattle
	name = "\improper Space Battle"
	icon_state = "away"
	requires_power = 0

/area/awaymission/spacebattle/cruiser
	name = "\improper Nanotrasen Cruiser"

/area/awaymission/spacebattle/syndicate1
	name = "\improper Syndicate Assault Ship 1"

/area/awaymission/spacebattle/syndicate2
	name = "\improper Syndicate Assault Ship 2"

/area/awaymission/spacebattle/syndicate3
	name = "\improper Syndicate Assault Ship 3"

/area/awaymission/spacebattle/syndicate4
	name = "\improper Syndicate War Sphere 1"

/area/awaymission/spacebattle/syndicate5
	name = "\improper Syndicate War Sphere 2"

/area/awaymission/spacebattle/syndicate6
	name = "\improper Syndicate War Sphere 3"

/area/awaymission/spacebattle/syndicate7
	name = "\improper Syndicate Fighter"

/area/awaymission/spacebattle/secret
	name = "\improper Hidden Chamber"

/area/awaymission/listeningpost
	name = "\improper Listening Post"
	icon_state = "away"
	requires_power = 0

/area/awaymission/beach
	name = "Beach"
	icon_state = "null"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()

	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0
		if(prob(25))
			S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
			sound_delay = rand(0, 50)

		for(var/mob/living/carbon/human/H in src)
			if(H.s_tone > -55)
				H.s_tone--
				H.update_body()
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S

		spawn(60) .()

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod4/centcom,
	/area/shuttle/escape_pod5/centcom,
	/area/shuttle/transport/centcom,
	/area/shuttle/ert/centcom,
	/area/shuttle/death_squad/centcom,
	/area/shuttle/administration/centcom,
	/area/centcom
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival/station,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod4/station,
	/area/shuttle/escape_pod5/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport/station,
	/area/shuttle/ert/station,
	/area/shuttle/death_squad/station,
	/area/shuttle/administration/station,
	/area/shuttle/research/station,
	/area/command,
	/area/eng,
	/area/solar,
	/area/maintenance,
	/area/hallway,
	/area/civ,
	/area/misc,
	/area/holodeck,
	/area/research/mech_bay,
	/area/research/robotics,
	/area/teleporter,
	/area/gateway,
	/area/medical,
	/area/security,
	/area/cargo,
	/area/storage,
	/area/construction,
	/area/ai_monitored/command/eva,
	/area/ai_monitored/cyborg,
	/area/turret_protected/ai_upload,
	/area/turret_protected/ai_upload_foyer,
	/area/turret_protected/ai
)



