/datum/job/ai
	title = "AI"
	titleFlag = T_AI
	countsAsPlayedInDept = T_SILICON
	minimumTimesAsCivilian = 2
	minimumTimesAsEngineering = 2
	minimumTimesAsSecurity = 2
	minimumTimesAsCommand = 1
	flag = AI
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = 1
	minimal_player_age = 5

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		return 1

/datum/job/cyborg
	title = "Cyborg"
	titleFlag = T_CYBORG
	countsAsPlayedInDept = T_SILICON
	minimumTimesAsCivilian = 1
	minimumTimesAsEngineering = 1
	minimumTimesAsSecurity = 1
	minimumTimesAsMedical = 1
	flag = CYBORG
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"
	minimal_player_age = 4

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		return 1