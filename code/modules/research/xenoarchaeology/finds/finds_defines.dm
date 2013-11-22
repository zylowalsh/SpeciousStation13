var/const/ARCHAEO_BOWL = 1
var/const/ARCHAEO_URN = 2
var/const/ARCHAEO_CUTLERY = 3
var/const/ARCHAEO_STATUETTE = 4
var/const/ARCHAEO_INSTRUMENT = 5
var/const/ARCHAEO_KNIFE = 6
var/const/ARCHAEO_COIN = 7
var/const/ARCHAEO_HANDCUFFS = 8
var/const/ARCHAEO_BEARTRAP = 9
var/const/ARCHAEO_LIGHTER = 10
var/const/ARCHAEO_BOX = 11
var/const/ARCHAEO_GASTANK = 12
var/const/ARCHAEO_TOOL = 13
var/const/ARCHAEO_METAL = 14
var/const/ARCHAEO_PEN = 15
var/const/ARCHAEO_CRYSTAL = 16
var/const/ARCHAEO_CULTBLADE = 17
var/const/ARCHAEO_TELEBEACON = 18
var/const/ARCHAEO_CLAYMORE = 19
var/const/ARCHAEO_CULTROBES = 20
var/const/ARCHAEO_SOULSTONE = 21
var/const/ARCHAEO_SHARD = 22
var/const/ARCHAEO_RODS = 23
var/const/ARCHAEO_STOCKPARTS = 24
var/const/ARCHAEO_KATANA = 25
var/const/ARCHAEO_LASER = 26
var/const/ARCHAEO_GUN = 27
var/const/ARCHAEO_UNKNOWN = 28
var/const/ARCHAEO_FOSSIL = 29
var/const/ARCHAEO_SHELL = 30
var/const/ARCHAEO_PLANT = 31
var/const/ARCHAEO_REMAINS_HUMANOID = 32
var/const/ARCHAEO_REMAINS_ROBOT = 33
var/const/ARCHAEO_REMAINS_XENO = 34
var/const/MAX_ARCHAEO = 34
//eggs
//droppings
//footprints
//alien clothing

//DNA sampling from fossils, or a new archaeo type specifically for it?

//descending order of likeliness to spawn
var/const/DIGSITE_GARDEN = 1
var/const/DIGSITE_ANIMAL = 2
var/const/DIGSITE_HOUSE = 3
var/const/DIGSITE_TECHNICAL = 4
var/const/DIGSITE_TEMPLE = 5
var/const/DIGSITE_WAR = 6

/proc/get_responsive_reagent(var/find_type)
	switch(find_type)
		if(ARCHAEO_BOWL)
			return "mercury"
		if(ARCHAEO_URN)
			return "mercury"
		if(ARCHAEO_CUTLERY)
			return "mercury"
		if(ARCHAEO_STATUETTE)
			return "mercury"
		if(ARCHAEO_INSTRUMENT)
			return "mercury"
		if(ARCHAEO_COIN)
			return "iron"
		if(ARCHAEO_KNIFE)
			return "iron"
		if(ARCHAEO_HANDCUFFS)
			return "mercury"
		if(ARCHAEO_BEARTRAP)
			return "mercury"
		if(ARCHAEO_LIGHTER)
			return "mercury"
		if(ARCHAEO_BOX)
			return "mercury"
		if(ARCHAEO_GASTANK)
			return "mercury"
		if(ARCHAEO_TOOL)
			return "iron"
		if(ARCHAEO_METAL)
			return "iron"
		if(ARCHAEO_PEN)
			return "mercury"
		if(ARCHAEO_CRYSTAL)
			return "nitrogen"
		if(ARCHAEO_CULTBLADE)
			return "potassium"
		if(ARCHAEO_TELEBEACON)
			return "potassium"
		if(ARCHAEO_CLAYMORE)
			return "iron"
		if(ARCHAEO_CULTROBES)
			return "potassium"
		if(ARCHAEO_SOULSTONE)
			return "nitrogen"
		if(ARCHAEO_SHARD)
			return "nitrogen"
		if(ARCHAEO_RODS)
			return "iron"
		if(ARCHAEO_STOCKPARTS)
			return "potassium"
		if(ARCHAEO_KATANA)
			return "iron"
		if(ARCHAEO_LASER)
			return "iron"
		if(ARCHAEO_GUN)
			return "iron"
		if(ARCHAEO_UNKNOWN)
			return "mercury"
		if(ARCHAEO_FOSSIL)
			return "carbon"
		if(ARCHAEO_SHELL)
			return "carbon"
		if(ARCHAEO_PLANT)
			return "carbon"
		if(ARCHAEO_REMAINS_HUMANOID)
			return "carbon"
		if(ARCHAEO_REMAINS_ROBOT)
			return "carbon"
		if(ARCHAEO_REMAINS_XENO)
			return "carbon"
	return "plasma"

//see /turf/simulated/mineral/New() in code/modules/mining/mine_turfs.dm
/proc/get_random_digsite_type()
	return pick(100;DIGSITE_GARDEN,95;DIGSITE_ANIMAL,90;DIGSITE_HOUSE,85;DIGSITE_TECHNICAL,80;DIGSITE_TEMPLE,75;DIGSITE_WAR)

/proc/get_random_find_type(var/digsite)

	var/find_type = 0
	switch(digsite)
		if(DIGSITE_GARDEN)
			find_type = pick(\
			100;ARCHAEO_PLANT,\
			25;ARCHAEO_SHELL,\
			25;ARCHAEO_FOSSIL,\
			5;ARCHAEO_BEARTRAP\
			)
		if(DIGSITE_ANIMAL)
			find_type = pick(\
			100;ARCHAEO_FOSSIL,\
			50;ARCHAEO_SHELL,\
			50;ARCHAEO_PLANT,\
			25;ARCHAEO_BEARTRAP\
			)
		if(DIGSITE_HOUSE)
			find_type = pick(\
			100;ARCHAEO_BOWL,\
			100;ARCHAEO_URN,\
			100;ARCHAEO_CUTLERY,\
			100;ARCHAEO_STATUETTE,\
			100;ARCHAEO_INSTRUMENT,\
			100;ARCHAEO_PEN,\
			100;ARCHAEO_LIGHTER,\
			100;ARCHAEO_BOX,\
			75;ARCHAEO_COIN,\
			75;ARCHAEO_UNKNOWN,\
			50;ARCHAEO_SHARD,\
			50;ARCHAEO_RODS,\
			25;ARCHAEO_METAL\
			)
		if(DIGSITE_TECHNICAL)
			find_type = pick(\
			100;ARCHAEO_METAL,\
			100;ARCHAEO_GASTANK,\
			100;ARCHAEO_TELEBEACON,\
			100;ARCHAEO_TOOL,\
			100;ARCHAEO_STOCKPARTS,\
			75;ARCHAEO_SHARD,\
			75;ARCHAEO_RODS,\
			75;ARCHAEO_UNKNOWN,\
			50;ARCHAEO_HANDCUFFS,\
			50;ARCHAEO_BEARTRAP,\
			)
		if(DIGSITE_TEMPLE)
			find_type = pick(\
			200;ARCHAEO_CULTROBES,\
			100;ARCHAEO_URN,\
			100;ARCHAEO_BOWL,\
			100;ARCHAEO_KNIFE,\
			100;ARCHAEO_CRYSTAL,\
			75;ARCHAEO_CULTBLADE,\
			50;ARCHAEO_SOULSTONE,\
			50;ARCHAEO_UNKNOWN,\
			25;ARCHAEO_HANDCUFFS,\
			25;ARCHAEO_BEARTRAP,\
			10;ARCHAEO_KATANA,\
			10;ARCHAEO_CLAYMORE,\
			10;ARCHAEO_SHARD,\
			10;ARCHAEO_RODS,\
			10;ARCHAEO_METAL\
			)
		if(DIGSITE_WAR)
			find_type = pick(\
			100;ARCHAEO_GUN,\
			100;ARCHAEO_KNIFE,\
			75;ARCHAEO_LASER,\
			75;ARCHAEO_KATANA,\
			75;ARCHAEO_CLAYMORE,\
			50;ARCHAEO_UNKNOWN,\
			50;ARCHAEO_CULTROBES,\
			50;ARCHAEO_CULTBLADE,\
			25;ARCHAEO_HANDCUFFS,\
			25;ARCHAEO_BEARTRAP,\
			25;ARCHAEO_TOOL\
			)
	return find_type

#undef ARCHAEO_BOWL
#undef ARCHAEO_URN
#undef ARCHAEO_CUTLERY
#undef ARCHAEO_STATUETTE
#undef ARCHAEO_INSTRUMENT
#undef ARCHAEO_KNIFE
#undef ARCHAEO_COIN
#undef ARCHAEO_HANDCUFFS
#undef ARCHAEO_BEARTRAP
#undef ARCHAEO_LIGHTER
#undef ARCHAEO_BOX
#undef ARCHAEO_GASTANK
#undef ARCHAEO_TOOL
#undef ARCHAEO_METAL
#undef ARCHAEO_PEN
#undef ARCHAEO_CRYSTAL
#undef ARCHAEO_CULTBLADE
#undef ARCHAEO_TELEBEACON
#undef ARCHAEO_CLAYMORE
#undef ARCHAEO_CULTROBES
#undef ARCHAEO_SOULSTONE
#undef ARCHAEO_SHARD
#undef ARCHAEO_RODS
#undef ARCHAEO_STOCKPARTS
#undef ARCHAEO_KATANA
#undef ARCHAEO_LASER
#undef ARCHAEO_GUN
#undef ARCHAEO_UNKNOWN
#undef ARCHAEO_FOSSIL
#undef ARCHAEO_SHELL
#undef ARCHAEO_PLANT
#undef ARCHAEO_REMAINS_HUMANOID
#undef ARCHAEO_REMAINS_ROBOT
#undef ARCHAEO_REMAINS_XENO

#undef DIGSITE_GARDEN
#undef DIGSITE_ANIMAL
#undef DIGSITE_HOUSE
#undef DIGSITE_TECHNICAL
#undef DIGSITE_TEMPLE
#undef DIGSITE_WAR
