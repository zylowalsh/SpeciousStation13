var/const/SAVEFILE_VERSION_MIN = 8
var/const/SAVEFILE_VERSION_MAX = 10

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefileUpdate()
	if(savefileVersion < 8)	//lazily delete everything + additional files so they can be saved in the new format
		for(var/ckey in allPreferences)
			var/datum/preferences/D = allPreferences[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return 0

	if(savefileVersion == SAVEFILE_VERSION_MAX)	//update successful.
		savePreferences()
		saveCharacter()
		return 1
	return 0

/datum/preferences/proc/loadPath(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefileVersion = SAVEFILE_VERSION_MAX

/datum/preferences/proc/loadPreferences()
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["version"] >> savefileVersion
	//Conversion
	if(!savefileVersion || !isnum(savefileVersion) || savefileVersion < SAVEFILE_VERSION_MIN || savefileVersion > SAVEFILE_VERSION_MAX)
		if(!savefileUpdate())  //handles updates
			savefileVersion = SAVEFILE_VERSION_MAX
			savePreferences()
			saveCharacter()
			return 0

	//general preferences
	S["ooccolor"]			>> oocColor
	S["lastchangelog"]		>> lastChangeLog
	S["UI_style"]			>> uiStyle
	S["be_special"]			>> beSpecial
	S["default_slot"]		>> defaultSlot
	S["toggles"]			>> toggles

	//Sanitize
	oocColor		= sanitize_hexcolor(oocColor, initial(oocColor))
	lastChangeLog	= sanitize_text(lastChangeLog, initial(lastChangeLog))
	uiStyle			= sanitize_inlist(uiStyle, list("Midnight","Orange","old"), initial(uiStyle))
	beSpecial		= sanitize_integer(beSpecial, 0, 65535, initial(beSpecial))
	defaultSlot		= sanitize_integer(defaultSlot, 1, MAX_SAVE_SLOTS, initial(defaultSlot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))

	return 1

/datum/preferences/proc/savePreferences()
	if(!path)
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["version"] << savefileVersion

	//general preferences
	S["ooccolor"]			<< oocColor
	S["lastchangelog"]		<< lastChangeLog
	S["UI_style"]			<< uiStyle
	S["be_special"]			<< beSpecial
	S["default_slot"]		<< defaultSlot
	S["toggles"]			<< toggles

	return 1

/datum/preferences/proc/loadJoinData()
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["firstJoinDate"]		>> firstJoinDate
	S["lastJoinDate"]		>> lastJoinDate
	S["numOfJobsPlayed"]     >> numOfJobsPlayed
	if(isnull(numOfJobsPlayed))
		numOfJobsPlayed = new /list(50)

	if(isnull(firstJoinDate))
		firstJoinDate = 0
	if(isnull(lastJoinDate))
		lastJoinDate = 0

	return 1

/datum/preferences/proc/saveJoinData()
	if(!path)
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	S["firstJoinDate"]		<< firstJoinDate
	S["lastJoinDate"]		<< lastJoinDate
	S["numOfJobsPlayed"]     << numOfJobsPlayed

	return 1

/datum/preferences/proc/loadCharacter(slot)
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"
	if(!slot)
		slot = defaultSlot
	slot = sanitize_integer(slot, 1, MAX_SAVE_SLOTS, initial(defaultSlot))
	if(slot != defaultSlot)
		defaultSlot = slot
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	//Character
	S["real_name"]			>> realName
	S["gender"]				>> gender
	S["age"]				>> age
	S["species"]			>> species
	S["language"]			>> language

	//colors to be consolidated into hex strings (requires some work with dna code)
	S["hair_red"]			>> rHair
	S["hair_green"]			>> gHair
	S["hair_blue"]			>> bHair
	S["facial_red"]			>> rFacial
	S["facial_green"]		>> gFacial
	S["facial_blue"]		>> bFacial
	S["skin_tone"]			>> sTone
	S["hair_style_name"]	>> hStyle
	S["facial_style_name"]	>> fStyle
	S["eyes_red"]			>> rEyes
	S["eyes_green"]			>> gEyes
	S["eyes_blue"]			>> bEyes
	S["underwear"]			>> underwear
	S["backbag"]			>> backbag
	S["b_type"]				>> bType

	//Jobs
	S["alternate_option"]	>> alternateOption
	S["job_civilian_high"]	>> jobCivilianHigh
	S["job_civilian_med"]	>> jobCivilianMed
	S["job_civilian_low"]	>> jobCivilianLow
	S["job_medsci_high"]	>> jobMedSciHigh
	S["job_medsci_med"]		>> jobMedSciMed
	S["job_medsci_low"]		>> jobMedSciLow
	S["job_engsec_high"]	>> jobEngSecHigh
	S["job_engsec_med"]		>> jobEngSecMed
	S["job_engsec_low"]		>> jobEngSecLow

	//Miscellaneous
	S["be_special"]			>> beSpecial
	S["disabilities"]		>> disabilities
	S["player_alt_titles"]	>> playerAltTitles
	S["organ_data"]			>> organData

	S["nanotrasen_relation"] >> nanotrasenRelation

	//Sanitize
	realName		= reject_bad_name(realName)
	if(isnull(species))
		species = "Human"
	if(isnull(language))
		language = "None"
	if(isnull(nanotrasenRelation))
		nanotrasenRelation = initial(nanotrasenRelation)
	if(!realName)
		realName = random_name(gender)
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	rHair			= sanitize_integer(rHair, 0, 255, initial(rHair))
	gHair			= sanitize_integer(gHair, 0, 255, initial(gHair))
	bHair			= sanitize_integer(bHair, 0, 255, initial(bHair))
	rFacial			= sanitize_integer(rFacial, 0, 255, initial(rFacial))
	gFacial			= sanitize_integer(gFacial, 0, 255, initial(gFacial))
	bFacial			= sanitize_integer(bFacial, 0, 255, initial(bFacial))
	sTone			= sanitize_integer(sTone, -185, 34, initial(sTone))
	hStyle			= sanitize_inlist(hStyle, hair_styles_list, initial(hStyle))
	fStyle			= sanitize_inlist(fStyle, facial_hair_styles_list, initial(fStyle))
	rEyes			= sanitize_integer(rEyes, 0, 255, initial(rEyes))
	gEyes			= sanitize_integer(gEyes, 0, 255, initial(gEyes))
	bEyes			= sanitize_integer(bEyes, 0, 255, initial(bEyes))
	underwear		= sanitize_integer(underwear, 1, underwear_m.len, initial(underwear))
	backbag			= sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))
	bType			= sanitize_text(bType, initial(bType))

	alternateOption = sanitize_integer(alternateOption, 0, 2, initial(alternateOption))
	jobCivilianHigh = sanitize_integer(jobCivilianHigh, 0, 65535, initial(jobCivilianHigh))
	jobCivilianMed 	= sanitize_integer(jobCivilianMed, 0, 65535, initial(jobCivilianMed))
	jobCivilianLow 	= sanitize_integer(jobCivilianLow, 0, 65535, initial(jobCivilianLow))
	jobMedSciHigh	= sanitize_integer(jobMedSciHigh, 0, 65535, initial(jobMedSciHigh))
	jobMedSciMed	= sanitize_integer(jobMedSciMed, 0, 65535, initial(jobMedSciMed))
	jobMedSciLow 	= sanitize_integer(jobMedSciLow, 0, 65535, initial(jobMedSciLow))
	jobEngSecHigh	= sanitize_integer(jobEngSecHigh, 0, 65535, initial(jobEngSecHigh))
	jobEngSecMed 	= sanitize_integer(jobEngSecMed, 0, 65535, initial(jobEngSecMed))
	jobEngSecLow 	= sanitize_integer(jobEngSecLow, 0, 65535, initial(jobEngSecLow))

	if(isnull(disabilities))
		disabilities = 0
	if(!playerAltTitles)
		playerAltTitles = new()
	if(!organData)
		organData = list()

	return 1

/datum/preferences/proc/saveCharacter()
	var/savefile/S
	if(!path)
		return 0
	S = new /savefile(path)

	if(!S)
		return 0
	S.cd = "/character[defaultSlot]"

	//Character
	S["real_name"]			<< realName
	S["gender"]				<< gender
	S["age"]				<< age
	S["species"]			<< species
	S["language"]			<< language
	S["hair_red"]			<< rHair
	S["hair_green"]			<< gHair
	S["hair_blue"]			<< bHair
	S["facial_red"]			<< rFacial
	S["facial_green"]		<< gFacial
	S["facial_blue"]		<< bFacial
	S["skin_tone"]			<< sTone
	S["hair_style_name"]	<< hStyle
	S["facial_style_name"]	<< fStyle
	S["eyes_red"]			<< rEyes
	S["eyes_green"]			<< gEyes
	S["eyes_blue"]			<< bEyes
	S["underwear"]			<< underwear
	S["backbag"]			<< backbag
	S["b_type"]				<< bType

	//Jobs
	S["alternate_option"]	<< alternateOption
	S["job_civilian_high"]	<< jobCivilianHigh
	S["job_civilian_med"]	<< jobCivilianMed
	S["job_civilian_low"]	<< jobCivilianLow
	S["job_medsci_high"]	<< jobMedSciHigh
	S["job_medsci_med"]		<< jobMedSciMed
	S["job_medsci_low"]		<< jobMedSciLow
	S["job_engsec_high"]	<< jobEngSecHigh
	S["job_engsec_med"]		<< jobEngSecMed
	S["job_engsec_low"]		<< jobEngSecLow

	//Miscellaneous
	S["player_alt_titles"]	<< playerAltTitles
	S["be_special"]			<< beSpecial
	S["disabilities"]		<< disabilities
	S["organ_data"]			<< organData

	S["nanotrasen_relation"] << nanotrasenRelation

	return 1

/datum/preferences/proc/deleteCharacter()
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/"

	for(var/i in S.dir)
		if(i == "character[defaultSlot]")
			S.dir.Remove(i)