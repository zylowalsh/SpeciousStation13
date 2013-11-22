var/const/LOC_KITCHEN = 0
var/const/LOC_ATMOS = 1
var/const/LOC_INCIN = 2
var/const/LOC_CHAPEL = 3
var/const/LOC_LIBRARY = 4
var/const/LOC_HYDRO = 5
var/const/LOC_VAULT = 6
var/const/LOC_CONSTR = 7
var/const/LOC_TECH = 8

var/const/VERM_MICE = 0
var/const/VERM_LIZARDS = 1
var/const/VERM_SPIDERS = 2

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/location
	var/locstring
	var/vermin
	var/vermstring

/datum/event/infestation/start()

	location = rand(0,8)
	var/list/turf/simulated/floor/turfs = list()
	var/spawn_area_type
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/civ/kitchen
			locstring = "the kitchen"
		if(LOC_ATMOS)
			spawn_area_type = /area/eng/atmos
			locstring = "atmospherics"
		if(LOC_INCIN)
			spawn_area_type = /area/cargo/incinerator
			locstring = "the incinerator"
		if(LOC_CHAPEL)
			spawn_area_type = /area/civ/chapel/main
			locstring = "the chapel"
		if(LOC_LIBRARY)
			spawn_area_type = /area/civ/library
			locstring = "the library"
		if(LOC_HYDRO)
			spawn_area_type = /area/civ/hydroponics
			locstring = "hydroponics"
		if(LOC_VAULT)
			spawn_area_type = /area/security/nuke_storage
			locstring = "the vault"
		if(LOC_CONSTR)
			spawn_area_type = /area/construction
			locstring = "the construction area"
		if(LOC_TECH)
			spawn_area_type = /area/eng/tech_storage
			locstring = "technical storage"

	//world << "looking for [spawn_area_type]"
	for(var/areapath in typesof(spawn_area_type))
		//world << "	checking [areapath]"
		var/area/A = locate(areapath)
		//world << "	A: [A], contents.len: [A.contents.len]"
		for(var/area/B in A.related)
			//world << "	B: [B], contents.len: [B.contents.len]"
			for(var/turf/simulated/floor/F in B.contents)
				if(!F.contents.len)
					turfs += F

	var/list/spawn_types = list()
	var/max_number
	vermin = rand(0,2)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_animal/mouse/gray, /mob/living/simple_animal/mouse/brown, /mob/living/simple_animal/mouse/white)
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_animal/lizard)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling)
			vermstring = "spiders"

	spawn(0)
		var/num = rand(2,max_number)
		while(turfs.len > 0 && num > 0)
			var/turf/simulated/floor/T = pick(turfs)
			turfs.Remove(T)
			num--


			if(vermin == VERM_SPIDERS)
				var/obj/effect/spider/spiderling/S = new(T)
				S.amount_grown = -1
			else
				var/spawn_type = pick(spawn_types)
				new spawn_type(T)


/datum/event/infestation/announce()
	command_alert("Bioscans indicate that [vermstring] have been breeding in [locstring]. Clear them out, before this starts to affect productivity.", "Vermin infestation")

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_INCIN
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_VAULT
#undef LOC_TECH
#undef LOC_ASSEMBLY

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS