/datum/job

	//The name of the job
	var/title = "ERROR var/title"

	//titleFlag is used in the savefiles. It must use constants from jobs.dm  Each constant one needs to be unique from other
	//	jobs. They are also locations in the list numOfJobsPlayed.  It is in the modules/client/preferences.dm file.
	var/titleFlag = 0

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Selection screen color
	var/selection_color = "#ffffff"

	//the type of the ID the player will have
	var/idtype = /obj/item/weapon/card/id

	//List of alternate titles, if any
	var/list/alt_titles

	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	//If a player has not played greater than or equal to these vars then they cannot play the job.  This is to prevent people
	//  from getting on once and waiting a week and getting all access to all jobs.
	var/minimumTimesAsCivilian = 0
	var/minimumTimesAsEngineering = 0
	var/minimumTimesAsSecurity = 0
	var/minimumTimesAsMedical = 0
	var/minimumTimesAsResearch = 0
	var/minimumTimesAsCommand = 0
	var/minimumTimesAsSilicon = 0

	//A bitflag to tell what dept the job counts as.
	var/countsAsPlayedInDept = 0

/datum/job/proc/equip(var/mob/living/carbon/human/H)
	return 1

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	if(config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

/datum/job/proc/hasMinimumJobExperience(client/C)
	if(minimumTimesAsCivilian)
		if(minimumTimesAsCivilian > C.prefs.getDeptJoins(T_CIVILIAN))
			return 0
	if(minimumTimesAsSecurity)
		if(minimumTimesAsSecurity > C.prefs.getDeptJoins(T_SECURITY))
			return 0
	if(minimumTimesAsMedical)
		if(minimumTimesAsMedical > C.prefs.getDeptJoins(T_MEDICAL))
			return 0
	if(minimumTimesAsEngineering)
		if(minimumTimesAsEngineering > C.prefs.getDeptJoins(T_ENGINEERING))
			return 0
	if(minimumTimesAsCommand)
		if(minimumTimesAsCommand > C.prefs.getDeptJoins(T_COMMAND))
			return 0
	if(minimumTimesAsResearch)
		if(minimumTimesAsResearch > C.prefs.getDeptJoins(T_RESEARCH))
			return 0
	// At this moment, there are no checks for silicon but it is here just in case someone wants it.
	/*
	if(minimumTimesAsSilicon)
		if(minimumTimesAsSilicon > C.prefs.getDeptJoins(T_SILICON))
			return 0
	*/
	return 1

/datum/job/proc/getRequiredJobExperience(client/C)
	var/returnedText = ""
	var/tmpDeptJoins = 0
	if(minimumTimesAsCivilian)
		tmpDeptJoins = C.prefs.getDeptJoins(T_CIVILIAN)
		if(minimumTimesAsCivilian > tmpDeptJoins)
			returnedText += "CIV: [minimumTimesAsCivilian - tmpDeptJoins] "
	if(minimumTimesAsSecurity)
		tmpDeptJoins = C.prefs.getDeptJoins(T_SECURITY)
		if(minimumTimesAsSecurity > tmpDeptJoins)
			returnedText += "SEC: [minimumTimesAsSecurity - tmpDeptJoins] "
	if(minimumTimesAsMedical)
		tmpDeptJoins = C.prefs.getDeptJoins(T_MEDICAL)
		if(minimumTimesAsMedical > tmpDeptJoins)
			returnedText += "MED: [minimumTimesAsMedical - tmpDeptJoins] "
	if(minimumTimesAsEngineering)
		tmpDeptJoins = C.prefs.getDeptJoins(T_ENGINEERING)
		if(minimumTimesAsEngineering > tmpDeptJoins)
			returnedText += "ENG: [minimumTimesAsEngineering - tmpDeptJoins] "
	if(minimumTimesAsCommand)
		tmpDeptJoins = C.prefs.getDeptJoins(T_COMMAND)
		if(minimumTimesAsCommand > tmpDeptJoins)
			returnedText += "COMM: [minimumTimesAsCommand - tmpDeptJoins] "
	if(minimumTimesAsResearch)
		tmpDeptJoins = C.prefs.getDeptJoins(T_RESEARCH)
		if(minimumTimesAsResearch > tmpDeptJoins)
			returnedText += "RES: [minimumTimesAsResearch - tmpDeptJoins] "
	// At this moment, there are no checks for silicon but it is here just in case someone wants it.
	/*
	if(minimumTimesAsSilicon)
		tmpDeptJoins = C.prefs.getDeptJoins(T_SILICON)
		if(minimumTimesAsSilicon > tmpDeptJoins)
			returnedText += "RES: [minimumTimesAsSilicon - tmpDeptJoins] "
	*/
	return returnedText