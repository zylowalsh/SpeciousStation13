//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/var/const/ACCESS_SECURITY = 1 // Security equipment
/var/const/ACCESS_BRIG = 2 // Brig timers and permabrig
/var/const/ACCESS_ARMORY = 3
/var/const/ACCESS_DETECTIVE = 4
/var/const/ACCESS_MEDICAL = 5
/var/const/ACCESS_MORGUE = 6
/var/const/ACCESS_TOXIN = 7
/var/const/ACCESS_TOXIN_STORAGE = 8
/var/const/ACCESS_GENETICS = 9
/var/const/ACCESS_ENGINE = 10
/var/const/ACCESS_ENGINE_EQUIP = 11
/var/const/ACCESS_MAINTENANCE = 12
/var/const/ACCESS_EXTERNAL_AIRLOCKS = 13
//var/const/access_emergency_storage = 14
/var/const/ACCESS_CHANGE_IDS = 15
/var/const/ACCESS_AI_UPLOAD = 16
/var/const/ACCESS_TELEPORTER = 17
/var/const/ACCESS_EVA = 18
/var/const/ACCESS_HEADS = 19
/var/const/ACCESS_CAPTAIN = 20
/var/const/ACCESS_ALL_PERSONAL_LOCKERS = 21
/var/const/ACCESS_CHAPEL_OFFICE = 22
/var/const/ACCESS_TECH_STORAGE = 23
/var/const/ACCESS_ATMOSPHERICS = 24
/var/const/ACCESS_BAR = 25
/var/const/ACCESS_JANITOR = 26
/var/const/ACCESS_CREMATORIUM = 27
/var/const/ACCESS_KITCHEN = 28
/var/const/ACCESS_ROBOTICS = 29
/var/const/ACCESS_RD = 30
/var/const/ACCESS_CARGO = 31
/var/const/ACCESS_CONSTRUCTION = 32
/var/const/ACCESS_CHEMISTRY = 33
//var/const/ACCESS_CARGO_bot = 34
/var/const/ACCESS_HYDROPONICS = 35
//var/const/access_manufacturing = 36
/var/const/ACCESS_LIBRARY = 37
/var/const/ACCESS_LAWYER = 38
/var/const/ACCESS_VIROLOGY = 39
/var/const/ACCESS_CMO = 40
/var/const/ACCESS_QM = 41
/var/const/ACCESS_COURT = 42
/var/const/ACCESS_CLOWN = 43
//var/const/access_mime = 44
/var/const/ACCESS_SURGERY = 45
//var/const/access_theatre = 46
/var/const/ACCESS_RESEARCH = 47
/var/const/ACCESS_MINING = 48
//var/const/ACCESS_MINING_office = 49 //not in use
/var/const/ACCESS_MAIL_SORTING = 50
//var/const/access_mint = 51
//var/const/access_mint_vault = 52
/var/const/ACCESS_HEADS_VAULT = 53
/var/const/ACCESS_MINING_STATION = 54
/var/const/ACCESS_XENOBIOLOGY = 55
/var/const/ACCESS_CE = 56
/var/const/ACCESS_HOP = 57
/var/const/ACCESS_HOS = 58
/var/const/ACCESS_RC_ANNOUNCE = 59 //Request console announcements
/var/const/ACCESS_KEYCARD_AUTH = 60 //Used for events which require at least two people to confirm them
/var/const/ACCESS_TCOMSAT = 61 // has access to the entire telecomms satellite / machinery
//var/const/access_gateway = 62
/var/const/ACCESS_SEC_DOORS = 63 // Security front doors
/var/const/ACCESS_PSYCHIATRIST = 64 // Psychiatrist's office
/var/const/ACCESS_XENOARCH = 65
/var/const/ACCESS_SHUTTLE = 66

	//BEGIN CENTCOM ACCESS
	/*Should leave plenty of room if we need to add more access levels.
/var/const/Mostly for admin fun times.*/
/var/const/ACCESS_CEnt_general = 101//General facilities.
/var/const/ACCESS_CEnt_thunder = 102//Thunderdome.
/var/const/ACCESS_CEnt_specops = 103//Special Ops.
/var/const/ACCESS_CEnt_medical = 104//Medical/Research
/var/const/ACCESS_CEnt_living = 105//Living quarters.
/var/const/ACCESS_CEnt_storage = 106//Generic storage areas.
/var/const/ACCESS_CEnt_teleporter = 107//Teleporter.
/var/const/ACCESS_CEnt_creed = 108//Creed's office.
/var/const/ACCESS_CEnt_captain = 109//Captain's office/ID comp/AI.

	//The Syndicate
/var/const/access_syndicate = 150//General Syndicate Access

	//MONEY
/var/const/access_crate_cash = 200

/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/var/list/req_one_access = null
/obj/var/req_one_access_txt = "0"

/obj/New()
	..()
	//NOTE: If a room requires more than one access (IE: Morgue + medbay) set the req_acesss_txt to "5;6" if it requires 5 and 6
	if(src.req_access_txt)
		var/list/req_access_str = text2list(req_access_txt,";")
		if(!req_access)
			req_access = list()
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				req_access += n

	if(src.req_one_access_txt)
		var/list/req_one_access_str = text2list(req_one_access_txt,";")
		if(!req_one_access)
			req_one_access = list()
		for(var/x in req_one_access_str)
			var/n = text2num(x)
			if(n)
				req_one_access += n



//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(istype(M, /mob/living/silicon))
		//AI can do whatever he wants
		return 1
	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.get_active_hand()) || src.check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/living/carbon/monkey) || istype(M, /mob/living/carbon/alien/humanoid))
		var/mob/living/carbon/george = M
		//they can only hold things :(
		if(src.check_access(george.get_active_hand()))
			return 1
	return 0

/obj/item/proc/GetAccess()
	return list()

/obj/item/proc/GetID()
	return null

/obj/proc/check_access(obj/item/I)

	if(!src.req_access && !src.req_one_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len && (!src.req_one_access || !src.req_one_access.len)) //no requirements
		return 1
	if(!I)
		return 0
	for(var/req in src.req_access)
		if(!(req in I.GetAccess())) //doesn't have this access
			return 0
	if(src.req_one_access && src.req_one_access.len)
		for(var/req in src.req_one_access)
			if(req in I.GetAccess()) //has an access from the single access list
				return 1
		return 0
	return 1


/obj/proc/check_access_list(var/list/L)
	if(!src.req_access  && !src.req_one_access)	return 1
	if(!istype(src.req_access, /list))	return 1
	if(!src.req_access.len && (!src.req_one_access || !src.req_one_access.len))	return 1
	if(!L)	return 0
	if(!istype(L, /list))	return 0
	for(var/req in src.req_access)
		if(!(req in L)) //doesn't have this access
			return 0
	if(src.req_one_access && src.req_one_access.len)
		for(var/req in src.req_one_access)
			if(req in L) //has an access from the single access list
				return 1
		return 0
	return 1

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(ACCESS_CEnt_general)
		if("Custodian")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_living, ACCESS_CEnt_storage)
		if("Thunderdome Overseer")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_thunder)
		if("Intel Officer")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_living)
		if("Medical Officer")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_living, ACCESS_CEnt_medical)
		if("Death Commando")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_specops, ACCESS_CEnt_living, ACCESS_CEnt_storage)
		if("Research Officer")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_specops, ACCESS_CEnt_medical, ACCESS_CEnt_teleporter, ACCESS_CEnt_storage)
		if("BlackOps Commander")
			return list(ACCESS_CEnt_general, ACCESS_CEnt_thunder, ACCESS_CEnt_specops, ACCESS_CEnt_living, ACCESS_CEnt_storage, ACCESS_CEnt_creed)
		if("Supreme Commander")
			return get_all_centcom_access()

/proc/get_all_accesses()
	return list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_DETECTIVE, ACCESS_COURT,
	            ACCESS_MEDICAL, ACCESS_GENETICS, ACCESS_MORGUE, ACCESS_RD,
	            ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_CHEMISTRY, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MAINTENANCE,
	            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD,
	            ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_HEADS, ACCESS_CAPTAIN, ACCESS_ALL_PERSONAL_LOCKERS,
	            ACCESS_TECH_STORAGE, ACCESS_CHAPEL_OFFICE, ACCESS_ATMOSPHERICS, ACCESS_KITCHEN,
	            ACCESS_BAR, ACCESS_JANITOR, ACCESS_CREMATORIUM, ACCESS_ROBOTICS, ACCESS_CARGO, ACCESS_CONSTRUCTION,
	            ACCESS_HYDROPONICS, ACCESS_LIBRARY, ACCESS_LAWYER, ACCESS_VIROLOGY, ACCESS_PSYCHIATRIST,
	            ACCESS_CMO, ACCESS_QM, ACCESS_CLOWN, ACCESS_SURGERY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAIL_SORTING,
	            ACCESS_HEADS_VAULT, ACCESS_MINING_STATION, ACCESS_XENOBIOLOGY, ACCESS_CE, ACCESS_HOP, ACCESS_HOS, ACCESS_RC_ANNOUNCE,
	            ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_XENOARCH, ACCESS_SHUTTLE)

/proc/get_all_centcom_access()
	return list(ACCESS_CEnt_general, ACCESS_CEnt_thunder, ACCESS_CEnt_specops, ACCESS_CEnt_medical, ACCESS_CEnt_living, ACCESS_CEnt_storage, ACCESS_CEnt_teleporter, ACCESS_CEnt_creed, ACCESS_CEnt_captain)

/proc/get_all_syndicate_access()
	return list(access_syndicate)

/proc/get_region_accesses(var/code)
	switch(code)
		if(0)
			return get_all_accesses()
		if(1) //security
			return list(ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_SECURITY, ACCESS_BRIG, ACCESS_DETECTIVE,
					ACCESS_ARMORY, ACCESS_HOS)
		if(2) //medbay
			return list(ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_PSYCHIATRIST, ACCESS_SURGERY, ACCESS_GENETICS, ACCESS_CHEMISTRY,
					ACCESS_VIROLOGY, ACCESS_CMO)
		if(3) //research
			return list(ACCESS_RESEARCH, ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY,
					ACCESS_XENOARCH, ACCESS_RD)
		if(4) //engineering and maintenance
			return list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_TECH_STORAGE, ACCESS_CONSTRUCTION,
					ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TCOMSAT, ACCESS_ATMOSPHERICS, ACCESS_CE)
		if(5) //command
			return list(ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD,
					ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_HEADS_VAULT,
					ACCESS_HOP, ACCESS_CAPTAIN)
		if(6) //station general
			return list(ACCESS_KITCHEN,ACCESS_BAR, ACCESS_HYDROPONICS, ACCESS_JANITOR, ACCESS_CHAPEL_OFFICE,
					ACCESS_CREMATORIUM, ACCESS_LIBRARY, ACCESS_LAWYER, ACCESS_CLOWN)
		if(7) //supply
			return list(ACCESS_MAIL_SORTING, ACCESS_SHUTTLE, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_CARGO, ACCESS_QM)

/proc/get_region_accesses_name(var/code)
	switch(code)
		if(0)
			return "All"
		if(1) //security
			return "Security"
		if(2) //medbay
			return "Medbay"
		if(3) //research
			return "Research"
		if(4) //engineering and maintenance
			return "Engineering"
		if(5) //command
			return "Command"
		if(6) //station general
			return "Station General"
		if(7) //supply
			return "Supply"


/proc/get_access_desc(A)
	switch(A)
		//Security
		if(ACCESS_SEC_DOORS)
			return "Brig"
		if(ACCESS_SECURITY)
			return "Security"
		if(ACCESS_BRIG)
			return "Holding Cells"
		if(ACCESS_ARMORY)
			return "Armory"
		if(ACCESS_DETECTIVE)
			return "Forensics"
		if(ACCESS_COURT)
			return "Courtroom"
		if(ACCESS_HOS)
			return "Head of Security"
		//Medbay
		if(ACCESS_MEDICAL)
			return "Medical"
		if(ACCESS_GENETICS)
			return "Genetics Lab"
		if(ACCESS_MORGUE)
			return "Morgue"
		if(ACCESS_CHEMISTRY)
			return "Pharmacy"
		if(ACCESS_PSYCHIATRIST)
			return "Psychiatry"
		if(ACCESS_VIROLOGY)
			return "Virology"
		if(ACCESS_SURGERY)
			return "Surgery"
		if(ACCESS_CMO)
			return "Chief Medical Officer"
		//Research
		if(ACCESS_RESEARCH)
			return "Research"
		if(ACCESS_TOXIN)
			return "Research Lab"
		if(ACCESS_TOXIN_STORAGE)
			return "Toxins"
		if(ACCESS_ROBOTICS)
			return "Robotics"
		if(ACCESS_XENOBIOLOGY)
			return "Xenobiology"
		if(ACCESS_XENOARCH)
			return "Xenoarchaeology"
		if(ACCESS_RD)
			return "Research Director"
		//Engineering
		if(ACCESS_CONSTRUCTION)
			return "Construction Areas"
		if(ACCESS_MAINTENANCE)
			return "Maintenance"
		if(ACCESS_ENGINE)
			return "Engineering"
		if(ACCESS_ENGINE_EQUIP)
			return "Power Equipment"
		if(ACCESS_EXTERNAL_AIRLOCKS)
			return "External Airlocks"
		if(ACCESS_TECH_STORAGE)
			return "Technical Storage"
		if(ACCESS_ATMOSPHERICS)
			return "Atmospherics"
		if(ACCESS_TCOMSAT)
			return "Telecommunications"
		if(ACCESS_CE)
			return "Chief Engineer"
		//Command
		if(ACCESS_HEADS)
			return "Bridge"
		if(ACCESS_RC_ANNOUNCE)
			return "RC Announcements"
		if(ACCESS_KEYCARD_AUTH)
			return "Keycard Auth. Device"
		if(ACCESS_CHANGE_IDS)
			return "Identification Computer"
		if(ACCESS_AI_UPLOAD)
			return "AI Upload"
		if(ACCESS_TELEPORTER)
			return "Teleporter"
		if(ACCESS_EVA)
			return "EVA"
		if(ACCESS_ALL_PERSONAL_LOCKERS)
			return "Personal Lockers"
		if(ACCESS_HEADS_VAULT)
			return "Vault"
		if(ACCESS_HOP)
			return "Head of Personnel"
		if(ACCESS_CAPTAIN)
			return "Captain"
		//General
		if(ACCESS_KITCHEN)
			return "Kitchen"
		if(ACCESS_BAR)
			return "Bar"
		if(ACCESS_HYDROPONICS)
			return "Hydroponics"
		if(ACCESS_JANITOR)
			return "Custodial Closet"
		if(ACCESS_CHAPEL_OFFICE)
			return "Chapel Office"
		if(ACCESS_CREMATORIUM)
			return "Crematorium"
		if(ACCESS_LIBRARY)
			return "Library"
		if(ACCESS_LAWYER)
			return "Internal Affairs"
		if(ACCESS_CLOWN)
			return "HONK!"
		//Cargo
		if(ACCESS_MAIL_SORTING)
			return "Cargo"
		if(ACCESS_MINING)
			return "Smelter"
		if(ACCESS_MINING_STATION)
			return "Mining"
		if(ACCESS_CARGO)
			return "Cargo Bay"
		if(ACCESS_SHUTTLE)
			return "Shuttles"
		if(ACCESS_QM)
			return "Quartermaster"

/proc/get_centcom_access_desc(A)
	switch(A)
		if(ACCESS_CEnt_general)
			return "Code Grey"
		if(ACCESS_CEnt_thunder)
			return "Code Yellow"
		if(ACCESS_CEnt_storage)
			return "Code Orange"
		if(ACCESS_CEnt_living)
			return "Code Green"
		if(ACCESS_CEnt_medical)
			return "Code White"
		if(ACCESS_CEnt_teleporter)
			return "Code Blue"
		if(ACCESS_CEnt_specops)
			return "Code Black"
		if(ACCESS_CEnt_creed)
			return "Code Silver"
		if(ACCESS_CEnt_captain)
			return "Code Gold"

/proc/get_all_jobs()
	var/list/all_jobs = list()
	var/list/all_datums = typesof(/datum/job)
	all_datums.Remove(list(/datum/job,/datum/job/ai,/datum/job/cyborg))
	var/datum/job/jobdatum
	for(var/jobtype in all_datums)
		jobdatum = new jobtype
		all_jobs.Add(jobdatum.title)
	return all_jobs

/proc/get_all_centcom_jobs()
	return list("VIP Guest","Custodian","Thunderdome Overseer","Intel Officer","Medical Officer","Death Commando","Research Officer","BlackOps Commander","Supreme Commander","Inspector")

//gets the actual job rank (ignoring alt titles)
//this is used solely for sechuds
/obj/proc/GetJobRealName()
	if (!istype(src, /obj/item/device/pda) && !istype(src,/obj/item/weapon/card/id))
		return

	var/rank
	var/assignment
	if(istype(src, /obj/item/device/pda))
		if(src:id)
			rank = src:id:rank
			assignment = src:id:assignment
	else if(istype(src, /obj/item/weapon/card/id))
		rank = src:rank
		assignment = src:assignment

	if( rank in get_all_jobs() )
		return rank

	if( assignment in get_all_jobs() )
		return assignment

	return "Unknown"

//gets the alt title, failing that the actual job rank
//this is unused
/obj/proc/sdsdsd()	//GetJobDisplayName
	if (!istype(src, /obj/item/device/pda) && !istype(src,/obj/item/weapon/card/id))
		return

	var/assignment
	if(istype(src, /obj/item/device/pda))
		if(src:id)
			assignment = src:id:assignment
	else if(istype(src, /obj/item/weapon/card/id))
		assignment = src:assignment

	if(assignment)
		return assignment

	return "Unknown"

proc/FindNameFromID(var/mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/weapon/card/id/C = H.get_active_hand()
	if( istype(C) || istype(C, /obj/item/device/pda) )
		var/obj/item/weapon/card/id/ID = C

		if( istype(C, /obj/item/device/pda) )
			var/obj/item/device/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(ID)
			return ID.registered_name

	C = H.wear_id

	if( istype(C) || istype(C, /obj/item/device/pda) )
		var/obj/item/weapon/card/id/ID = C

		if( istype(C, /obj/item/device/pda) )
			var/obj/item/device/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(ID)
			return ID.registered_name

proc/get_all_job_icons() //For all existing HUD icons
	return get_all_jobs() + list("Prisoner")

/obj/proc/GetJobName() //Used in secHUD icon generation
	if (!istype(src, /obj/item/device/pda) && !istype(src,/obj/item/weapon/card/id))
		return

	var/jobName

	if(istype(src, /obj/item/device/pda))
		if(src:id)
			jobName = src:id:assignment
	if(istype(src, /obj/item/weapon/card/id))
		jobName = src:assignment

	if(jobName in get_all_job_icons()) //Check if the job has a hud icon
		return jobName
	if(jobName in get_all_centcom_jobs()) //Return with the NT logo if it is a Centcom job
		return "[HEADQUARTERS_NAME]"
	return "Unknown" //Return unknown if none of the above apply

