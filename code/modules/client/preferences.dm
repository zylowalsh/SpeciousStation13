//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/const/GET_RANDOM_JOB = 0
var/const/BE_ASSISTANT = 1
var/const/RETURN_TO_LOBBY = 2

var/datum/preferences/allPreferences[0]

var/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
	//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),             // 0
	"operative" = IS_MODE_COMPILED("nuclear"),           // 1
	"changeling" = IS_MODE_COMPILED("changeling"),       // 2
	"wizard" = IS_MODE_COMPILED("wizard"),               // 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),         // 4
	"revolutionary" = IS_MODE_COMPILED("revolution"),    // 5
	"alien candidate" = 1, //always show                 // 6
	"pAI candidate" = 1, // -- TLE                       // 7
	"cultist" = IS_MODE_COMPILED("cult"),                // 8
	"infested monkey" = IS_MODE_COMPILED("monkey"),      // 9
	"ninja" = "true",									 // 10
	"vox raider" = IS_MODE_COMPILED("heist"),			 // 11
	"diona" = 1,                                         // 12
)

datum/preferences
	var/const/MAX_SAVE_SLOTS = 3

	// Constants for screen
	var/const/CHARACTER_MENU = 1
	var/const/JOB_MENU = 2
	var/const/ANTAG_MENU = 3

	// Constants for previousStatus
	var/const/SURVIVED_AND_RECOVERED = 100
	var/const/SURVIVED = 101
	var/const/BODY_RECOVERED = 102
	var/const/BODY_LOST = 103

	var/screen = CHARACTER_MENU
	var/path

	// INFO AND PREFS ABOUT PLAYER

	//Holds the last character slot used
	var/defaultSlot = 1
	var/savefileVersion = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/lastIP
	var/lastID
	var/firstJoinDate = 0
	var/lastJoinDate = 0

	//The indexs for this list are from var/titleFlag in datum/job
	var/list/numOfJobsPlayed[50]

	//game-preferences
	var/lastChangeLog = ""				//Saved changlog filesize to detect if there was a change
	var/oocColor = "#b82e00"
	var/beSpecial = 0					//Special role selection
	var/uiStyle = "Midnight"
	var/toggles = TOGGLES_DEFAULT

	// INFO AND PREFS ABOUT CURRENT CHARACTER

	var/survivedOneRound = FALSE
	var/list/previousHardcoreJobs = list()
	var/list/previousStatus = list()
	var/timesCloned = 0

	var/realName					//our character's name
	var/gender = MALE				//gender of character (well duh)
	var/age = 30					//age of character
	var/bType = "A+"				//blood type (not-chooseable)
	var/underwear = 1				//underwear type
	var/backbag = 2					//backpack type
	var/hStyle = "Bald"				//Hair type
	var/rHair = 0					//Hair color
	var/gHair = 0					//Hair color
	var/bHair = 0					//Hair color
	var/fStyle = "Shaved"			//Face hair type
	var/rFacial = 0					//Face hair color
	var/gFacial = 0					//Face hair color
	var/bFacial = 0					//Face hair color
	var/sTone = 0					//Skin color
	var/rEyes = 0					//Eye color
	var/gEyes = 0					//Eye color
	var/bEyes = 0					//Eye color
	var/species = "Human"
	var/language = "None"			//Secondary language

	//Mob preview
	var/icon/previewIconFront = null
	var/icon/previewIconSide = null

	var/nanotrasenRelation = "Neutral"

	//Jobs, uses bitflags
	var/jobCivilianHigh = 0
	var/jobCivilianMed = 0
	var/jobCivilianLow = 0

	var/jobMedSciHigh = 0
	var/jobMedSciMed = 0
	var/jobMedSciLow = 0

	var/jobEngSecHigh = 0
	var/jobEngSecMed = 0
	var/jobEngSecLow = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternateOption = 0

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organData = list()

	var/list/playerAltTitles = new()		// the default name of a job like "Medical Doctor"

	var/datum/record/record
	var/disabilities = 0

/datum/preferences/New(client/C)
	if(istype(C))
		if(!IsGuestKey(C.key))
			loadPath(C.ckey)
			if(loadPreferences())
				loadJoinData()
				if(loadCharacter())
					loadRecord()
					return
	gender = pick(MALE, FEMALE)
	realName = random_name(gender)
	bType = pick(8;"O-", 37;"O+", 7;"A-", 33;"A+", 2;"B-", 9;"B+", 1;"AB-", 3;"AB+")

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon()
	user << browse_rsc(previewIconFront, "previewicon.png")
	user << browse_rsc(previewIconSide, "previewicon2.png")
	var/dat = "<HTML><body><CENTER>"

	if(path)
		dat += {"
			Slot <B>[defaultSlot]</B> -
			<A href=\"byond://?src=\ref[user];preference=open_load_dialog\">Load slot</A> -
			<A href=\"byond://?src=\ref[user];preference=save\">Save slot</A> -
			<A href=\"byond://?src=\ref[user];preference=reload\">Reload slot</A> -
			<A href=\"byond://?src=\ref[user];preference=delete\">Delete Character</A>"}

	else
		dat += "<Please create an account to save your preferences."

	dat += "</CENTER><HR><TABLE><TR><TD width='340px' height='320px'>"

	if(!survivedOneRound)
		dat += {"
			<B>Name: <A href='?_src_=prefs;preference=name;task=input'>[realName]</A></B><BR>
			(<A href='?_src_=prefs;preference=name;task=random'>Random Name</A>)<BR>
			Gender: <A href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : "Female"]</A><BR>
			Age: <A href='?_src_=prefs;preference=age;task=input'>[age]</A><BR>
			UI Style: <A href='?_src_=prefs;preference=ui'>[uiStyle]</A><BR>
			Play admin midis: <A href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</A><BR>
			Play lobby music: <A href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</A><BR>
			Ghost ears: <A href='?_src_=prefs;preference=ghost_ears'>[(toggles & CHAT_GHOSTEARS) ? "Nearest Creatures" : "All Speech"]</A><BR>
			Ghost sight: <A href='?_src_=prefs;preference=ghost_sight'>[(toggles & CHAT_GHOSTSIGHT) ? "Nearest Creatures" : "All Emotes"]</A><BR>"}

		dat += {"
			<BR>
			<A href='?_src_=prefs;preference=job;task=menu'><B>Set Job Preferences</B></A><BR>
			<BR>
			<TABLE><TR><TD><B>Body</B> (<A href='?_src_=prefs;preference=all;task=random'>&reg;</A>)<BR>
				Species: <A href='byond://?src=\ref[user];preference=species;task=input'>[species]</A><BR>
				Secondary Language: <A href='byond://?src=\ref[user];preference=language;task=input'>[language]</A><BR>
				Blood Type: <A href='byond://?src=\ref[user];preference=b_type;task=input'>[bType]</A><BR>
				Skin Tone: <A href='?_src_=prefs;preference=s_tone;task=input'>[-sTone + 35]/220</A><BR>
				Needs Glasses: <A href='?_src_=prefs;preference=disabilities'>[disabilities == 0 ? "No" : "Yes"]</A><BR>
				Limbs: <A href='byond://?src=\ref[user];preference=limbs;task=input'>Adjust</A><BR>"}

	else
		dat += {"
			<B>Name: [realName]<B><BR>
			Gender: [gender == MALE ? "Male" : "Female"]<BR>
			Age: [age]<BR>
			UI Style: <A href='?_src_=prefs;preference=ui'>[uiStyle]</A><BR>
			Play admin midis: <A href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</A><BR>
			Play lobby music: <A href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</A><BR>
			Ghost ears: <A href='?_src_=prefs;preference=ghost_ears'>[(toggles & CHAT_GHOSTEARS) ? "Nearest Creatures" : "All Speech"]</A><BR>
			Ghost sight: <A href='?_src_=prefs;preference=ghost_sight'>[(toggles & CHAT_GHOSTSIGHT) ? "Nearest Creatures" : "All Emotes"]</A><BR>"}

		dat += {"
			<BR>
			<A href='?_src_=prefs;preference=job;task=menu'><B>Set Job Preferences</B></A><BR>
			<BR>
			<TABLE><TR><TD><B>Body</B><BR>
				Species: [species]<BR>
				Secondary Language: [language]<BR>
				Blood Type: [bType]<BR>
				Skin Tone: [-sTone + 35]/220<BR>
				Needs Glasses: [disabilities == 0 ? "No" : "Yes"]<BR>
				Limbs: <BR>"}

	var/ind = 0
	for(var/name in organData)
		var/status = organData[name]
		var/organ_name = null
		switch(name)
			if("l_arm")
				organ_name = "Left arm"
			if("r_arm")
				organ_name = "Right arm"
			if("l_leg")
				organ_name = "Left leg"
			if("r_leg")
				organ_name = "Right leg"
			if("l_foot")
				organ_name = "Left foot"
			if("r_foot")
				organ_name = "Right foot"
			if("l_hand")
				organ_name = "Left hand"
			if("r_hand")
				organ_name = "Right hand"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "[organ_name] prothesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "[organ_name] amputated"

	if(!ind)
		dat += "\[...\]<br><br>"
	else
		dat += "<br><br>"

	if(gender == MALE)
		dat += "Underwear: <a href ='?_src_=prefs;preference=underwear;task=input'><b>[underwear_m[underwear]]</b></a><br>"
	else
		dat += "Underwear: <a href ='?_src_=prefs;preference=underwear;task=input'><b>[underwear_f[underwear]]</b></a><br>"

	dat += "Backpack Type:<br><a href ='?_src_=prefs;preference=bag;task=input'><b>[backbaglist[backbag]]</b></a><br>"

	dat += "Nanotrasen Relation:<br><a href ='?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasenRelation]</b></a><br>"

	dat += "</td><td><b>Preview</b><br><img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64></td></tr></table>"

	dat += "</td><td width='300px' height='300px'>"

	//dat += "<b><a href=\"byond://?src=\ref[user];preference=records;record=1\">Employment History</a></b><br>"

	dat += "<br><b>Hair</b><br>"
	dat += "<a href='?_src_=prefs;preference=hair;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(rHair, 2)][num2hex(gHair, 2)][num2hex(bHair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(rHair, 2)][num2hex(gHair, 2)][num2hex(bHair)]'><tr><td>__</td></tr></table></font> "
	dat += " Style: <a href='?_src_=prefs;preference=h_style;task=input'>[hStyle]</a><br>"

	dat += "<br><b>Facial</b><br>"
	dat += "<a href='?_src_=prefs;preference=facial;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(rFacial, 2)][num2hex(gFacial, 2)][num2hex(bFacial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(rFacial, 2)][num2hex(gFacial, 2)][num2hex(bFacial)]'><tr><td>__</td></tr></table></font> "
	dat += " Style: <a href='?_src_=prefs;preference=f_style;task=input'>[fStyle]</a><br>"

	dat += "<br><b>Eyes</b><br>"
	dat += "<a href='?_src_=prefs;preference=eyes;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(rEyes, 2)][num2hex(gEyes, 2)][num2hex(bEyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(rEyes, 2)][num2hex(gEyes, 2)][num2hex(bEyes)]'><tr><td>__</td></tr></table></font>"

	dat += "<br><br>"
	if(jobban_isbanned(user, "Syndicate"))
		dat += "<b>You are banned from antagonist roles.</b>"
		beSpecial = 0
	else
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i))
					dat += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else if(i == "pai candidate")
					if(jobban_isbanned(user, "pAI"))
						dat += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					dat += "<b>Be [i]:</b> <a href='?_src_=prefs;preference=be_special;num=[n]'><b>[beSpecial & (1<<n) ? "Yes" : "No"]</b></a><br>"
			n++
	dat += "</td></tr></table><hr><center>"

	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=load'>Undo</a> - "
		dat += "<a href='?_src_=prefs;preference=save'>Save Setup</a> - "

	dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</center></body></html>"

	user << browse(dat, "window=preferences;size=560x580")

/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Medical Officer"), width = 700, height = 550)
	if(!job_master)
		return

	//limit 	 - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//width	 - Screen' width. Defaults to 550 to make it look nice.
	//height 	 - Screen's height. Defaults to 500 to make it look nice.

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose occupation chances</b><br>Unavailable occupations are in red.<br><br>"
	HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>\[Done\]</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	if (!job_master)
		return
	for(var/datum/job/job in job_master.occupations)
		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		if(jobban_isbanned(user, rank))
			HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[BANNED]</b></font></td></tr>"
			continue
		if(!job.hasMinimumJobExperience(user.client))
			HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[[job.getRequiredJobExperience(user.client)]]</b></font></td></tr>"
			continue
		if((jobCivilianLow & ASSISTANT) && (rank != "Assistant"))
			HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			HTML += "<b>[rank]</b>"
		else
			HTML += "[rank]"

		HTML += "</td><td width='40%'>"

		HTML += "<a href='?_src_=prefs;preference=job;task=input;text=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if(jobCivilianLow & ASSISTANT)
				HTML += " <font color=green>\[Yes]</font>"
			else
				HTML += " <font color=red>\[No]</font>"
			HTML += "</a></td></tr>"
			continue

		if(GetJobDepartment(job, 1) & job.flag)
			HTML += " <font color=blue>\[High]</font>"
		else if(GetJobDepartment(job, 2) & job.flag)
			HTML += " <font color=green>\[Medium]</font>"
		else if(GetJobDepartment(job, 3) & job.flag)
			HTML += " <font color=orange>\[Low]</font>"
		else
			HTML += " <font color=red>\[NEVER]</font>"
		if(job.alt_titles)
			HTML += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'><a>&nbsp</a></td><td><a href=\"byond://?src=\ref[user];preference=job;task=alt_title;job=\ref[job]\">\[[GetPlayerAltTitle(job)]\]</a></td></tr>"
		HTML += "</a></td></tr>"

	HTML += "</td'></tr></table>"

	HTML += "</center></table>"

	switch(alternateOption)
		if(GET_RANDOM_JOB)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=green>Get random job if preferences unavailable</font></a></u></center><br>"
		if(BE_ASSISTANT)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=red>Be assistant if preference unavailable</font></a></u></center><br>"
		if(RETURN_TO_LOBBY)
			HTML += "<center><br><u><a href='?_src_=prefs;preference=job;task=random'><font color=purple>Return to lobby if preference unavailable</font></a></u></center><br>"

	HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>\[Reset\]</a></center>"
	HTML += "</tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=mob_occupation;size=[width]x[height]")

/datum/preferences/proc/SetDisabilities(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Choose disabilities</b><br>"

	HTML += "Need Glasses? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=0\">[disabilities & (1<<0) ? "Yes" : "No"]</a><br>"
	HTML += "Seizures? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=1\">[disabilities & (1<<1) ? "Yes" : "No"]</a><br>"
	HTML += "Coughing? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=2\">[disabilities & (1<<2) ? "Yes" : "No"]</a><br>"
	HTML += "Tourettes/Twitching? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=3\">[disabilities & (1<<3) ? "Yes" : "No"]</a><br>"
	HTML += "Nervousness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=4\">[disabilities & (1<<4) ? "Yes" : "No"]</a><br>"
	HTML += "Deafness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=5\">[disabilities & (1<<5) ? "Yes" : "No"]</a><br>"

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preferences=1;disabilities=-2\">\[Done\]</a>"
	HTML += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=disabil;size=350x300")

/datum/preferences/proc/SetRecords(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Character Records</b><br>"

	HTML += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">Medical Records</a><br>"

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">Employment Records</a><br>"

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">Security Records</a><br>"

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">\[Done\]</a>"
	HTML += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=records;size=350x300")

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	if(playerAltTitles.Find(job.title) > 0)
		return playerAltTitles[job.title]
	else
		return job.title

/datum/preferences/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	if(playerAltTitles.Find(job.title))
		playerAltTitles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		playerAltTitles[job.title] = new_title

/datum/preferences/proc/SetJob(mob/user, role)
	var/datum/job/job = job_master.getJob(role)
	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if(role == "Assistant")
		if(jobCivilianLow & job.flag)
			jobCivilianLow &= ~job.flag
		else
			jobCivilianLow |= job.flag
		SetChoices(user)
		return 1

	if(GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	SetChoices(user)
	return 1

/datum/preferences/proc/ResetJobs()
	jobCivilianHigh = 0
	jobCivilianMed = 0
	jobCivilianLow = 0

	jobMedSciHigh = 0
	jobMedSciMed = 0
	jobMedSciLow = 0

	jobEngSecHigh = 0
	jobEngSecMed = 0
	jobEngSecLow = 0


/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return jobCivilianHigh
				if(2)
					return jobCivilianMed
				if(3)
					return jobCivilianLow
		if(MEDSCI)
			switch(level)
				if(1)
					return jobMedSciHigh
				if(2)
					return jobMedSciMed
				if(3)
					return jobMedSciLow
		if(ENGSEC)
			switch(level)
				if(1)
					return jobEngSecHigh
				if(2)
					return jobEngSecMed
				if(3)
					return jobEngSecLow
	return 0

/datum/preferences/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			jobCivilianHigh = 0
			jobMedSciHigh = 0
			jobEngSecHigh = 0
			return 1
		if(2)//Set current highs to med, then reset them
			jobCivilianMed |= jobCivilianHigh
			jobMedSciMed |= jobMedSciHigh
			jobEngSecMed |= jobEngSecHigh
			jobCivilianHigh = 0
			jobMedSciHigh = 0
			jobEngSecHigh = 0

	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(2)
					jobCivilianHigh = job.flag
					jobCivilianMed &= ~job.flag
				if(3)
					jobCivilianMed |= job.flag
					jobCivilianLow &= ~job.flag
				else
					jobCivilianLow |= job.flag
		if(MEDSCI)
			switch(level)
				if(2)
					jobMedSciHigh = job.flag
					jobMedSciMed &= ~job.flag
				if(3)
					jobMedSciMed |= job.flag
					jobMedSciLow &= ~job.flag
				else
					jobMedSciLow |= job.flag
		if(ENGSEC)
			switch(level)
				if(2)
					jobEngSecHigh = job.flag
					jobEngSecMed &= ~job.flag
				if(3)
					jobEngSecMed |= job.flag
					jobEngSecLow &= ~job.flag
				else
					jobEngSecLow |= job.flag
	return 1

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)
		return

	if(!istype(user, /mob/new_player))
		return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				if(alternateOption == GET_RANDOM_JOB || alternateOption == BE_ASSISTANT)
					alternateOption += 1
				else if(alternateOption == RETURN_TO_LOBBY)
					alternateOption = 0
				else
					return 0
				SetChoices(user)
			if ("alt_title")
				var/datum/job/job = locate(href_list["job"])
				if (job)
					var/choices = list(job.title) + job.alt_titles
					var/choice = input("Pick a title for [job.title].", "Character Generation", GetPlayerAltTitle(job)) as anything in choices | null
					if(choice)
						SetPlayerAltTitle(job, choice)
						SetChoices(user)
			if("input")
				SetJob(user, href_list["text"])
			else
				SetChoices(user)
		return 1

	/*
	else if(href_list["preference"] == "records")
		if(text2num(href_list["record"]) >= 1)
			SetRecords(user)
			return
		else
			user << browse(null, "window=records")
		if(href_list["task"] == "med_record")
			var/medmsg = input(usr,"Set your medical notes here.","Medical Records",html_decode(med_record)) as message

			if(medmsg != null)
				medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
				medmsg = html_encode(medmsg)

				med_record = medmsg
				SetRecords(user)

		if(href_list["task"] == "sec_record")
			var/secmsg = input(usr,"Set your security notes here.","Security Records",html_decode(sec_record)) as message

			if(secmsg != null)
				secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
				secmsg = html_encode(secmsg)

				sec_record = secmsg
				SetRecords(user)
		if(href_list["task"] == "gen_record")
			var/genmsg = input(usr,"Set your employment notes here.","Employment Records",html_decode(gen_record)) as message

			if(genmsg != null)
				genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
				genmsg = html_encode(genmsg)

				gen_record = genmsg
				SetRecords(user)
	*/
	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					realName = random_name(gender)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					rHair = rand(0,255)
					gHair = rand(0,255)
					bHair = rand(0,255)
				if("h_style")
					hStyle = random_hair_style(gender, species)
				if("facial")
					rFacial = rand(0,255)
					gFacial = rand(0,255)
					bFacial = rand(0,255)
				if("f_style")
					fStyle = random_facial_hair_style(gender, species)
				if("underwear")
					underwear = rand(1,underwear_m.len)
					ShowChoices(user)
				if("eyes")
					rEyes = rand(0,255)
					gEyes = rand(0,255)
					bEyes = rand(0,255)
				if("s_tone")
					sTone = random_skin_tone()
				if("bag")
					backbag = rand(1,4)
				/*if("skin_style")
					h_style = random_skin_style(gender)*/
				if("all")
					randomize_appearance_for()	//no params needed
		if("input")
			switch(href_list["preference"])
				if("name")
					var/new_name = reject_bad_name( input(user, "Choose your character's name:", "Character Preference")  as text|null )
					if(new_name)
						realName = new_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)
				if("species")

					var/list/new_species = list("Human")
					var/prev_species = species
					var/whitelisted = 0

					if(config.usealienwhitelist) //If we're using the whitelist, make sure to check it!
						for(var/S in whitelisted_species)
							if(is_alien_whitelisted(user,S))
								new_species += S
								whitelisted = 1
						if(!whitelisted)
							alert(user, "You cannot change your species as you need to be whitelisted. If you wish to be whitelisted contact an admin in-game, on the forums, or on IRC.")
					else //Not using the whitelist? Aliens for everyone!
						new_species = whitelisted_species

					species = input("Please select a species", "Character Generation", null) in new_species

					if(prev_species != species)
						//grab one of the valid hair styles for the newly chosen species
						var/list/valid_hairstyles = list()
						for(var/hairstyle in hair_styles_list)
							var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
							if(gender == MALE && S.gender == FEMALE)
								continue
							if(gender == FEMALE && S.gender == MALE)
								continue
							if( !(species in S.species_allowed))
								continue
							valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

						if(valid_hairstyles.len)
							hStyle = pick(valid_hairstyles)
						else
							//this shouldn't happen
							hStyle = hair_styles_list["Bald"]

						//grab one of the valid facial hair styles for the newly chosen species
						var/list/valid_facialhairstyles = list()
						for(var/facialhairstyle in facial_hair_styles_list)
							var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
							if(gender == MALE && S.gender == FEMALE)
								continue
							if(gender == FEMALE && S.gender == MALE)
								continue
							if( !(species in S.species_allowed))
								continue

							valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

						if(valid_facialhairstyles.len)
							fStyle = pick(valid_facialhairstyles)
						else
							//this shouldn't happen
							fStyle = facial_hair_styles_list["Shaved"]

						//reset hair colour and skin colour
						rHair = 0//hex2num(copytext(new_hair, 2, 4))
						gHair = 0//hex2num(copytext(new_hair, 4, 6))
						bHair = 0//hex2num(copytext(new_hair, 6, 8))

						sTone = 0

				if("language")
					var/languages_available
					var/list/new_languages = list("None")

					if(config.usealienwhitelist)
						for(var/L in all_languages)
							var/datum/language/lang = all_languages[L]
							if((!(lang.flags & RESTRICTED_LANG)) && (is_alien_whitelisted(user, L)||(!( lang.flags & WHITELISTED_LANG ))))
								new_languages += lang
								languages_available = 1

						if(!(languages_available))
							alert(user, "There are not currently any available secondary languages.")
					else
						for(var/L in all_languages)
							var/datum/language/lang = all_languages[L]
							if(!(lang.flags & RESTRICTED_LANG))
								new_languages += lang

					language = input("Please select a secondary language", "Character Generation", null) in new_languages

				if("b_type")
					var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )
					if(new_b_type)
						bType = new_b_type

				if("hair")
					if(species == "Human" || species == "Unathi")
						var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as color|null
						if(new_hair)
							rHair = hex2num(copytext(new_hair, 2, 4))
							gHair = hex2num(copytext(new_hair, 4, 6))
							bHair = hex2num(copytext(new_hair, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in hair_styles_list)
						var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
						if( !(species in S.species_allowed))
							continue

						valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

					var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in valid_hairstyles
					if(new_h_style)
						hStyle = new_h_style

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as color|null
					if(new_facial)
						rFacial = hex2num(copytext(new_facial, 2, 4))
						gFacial = hex2num(copytext(new_facial, 4, 6))
						bFacial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
					var/list/valid_facialhairstyles = list()
					for(var/facialhairstyle in facial_hair_styles_list)
						var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
						if(gender == MALE && S.gender == FEMALE)
							continue
						if(gender == FEMALE && S.gender == MALE)
							continue
						if( !(species in S.species_allowed))
							continue

						valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

					var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in valid_facialhairstyles
					if(new_f_style)
						fStyle = new_f_style

				if("underwear")
					var/list/underwear_options
					if(gender == MALE)
						underwear_options = underwear_m
					else
						underwear_options = underwear_f

					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_options
					if(new_underwear)
						underwear = underwear_options.Find(new_underwear)
					ShowChoices(user)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
					if(new_eyes)
						rEyes = hex2num(copytext(new_eyes, 2, 4))
						gEyes = hex2num(copytext(new_eyes, 4, 6))
						bEyes = hex2num(copytext(new_eyes, 6, 8))

				if("s_tone")
					if(species != "Human")
						return
					var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference")  as num|null
					if(new_s_tone)
						sTone = 35 - max(min( round(new_s_tone), 220),1)

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
					if(new_ooccolor)
						oocColor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
					if(new_backbag)
						backbag = backbaglist.Find(new_backbag)

				if("nt_relation")
					var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						nanotrasenRelation = new_relation

				if("disabilities")
					if(text2num(href_list["disabilities"]) >= -1)
						if(text2num(href_list["disabilities"]) >= 0)
							disabilities ^= (1<<text2num(href_list["disabilities"])) //MAGIC
						SetDisabilities(user)
						return
					else
						user << browse(null, "window=disabil")

				if("limbs")
					var/limb_name = input(user, "Which limb do you want to change?") as null|anything in list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
					if(!limb_name) return

					var/limb = null
					var/second_limb = null // if you try to change the arm, the hand should also change
					var/third_limb = null  // if you try to unchange the hand, the arm should also change
					switch(limb_name)
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							third_limb = "r_arm"

					var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in list("Normal","Amputated","Prothesis")
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organData[limb] = null
							if(third_limb)
								organData[third_limb] = null
						if("Amputated")
							organData[limb] = "amputated"
							if(second_limb)
								organData[second_limb] = "amputated"
						if("Prothesis")
							organData[limb] = "cyborg"
							if(second_limb)
								organData[second_limb] = "cyborg"

				if("skin_style")
					var/skin_style_name = input(user, "Select a new skin style") as null|anything in list("default1", "default2", "default3")
					if(!skin_style_name) return

		else
			switch(href_list["preference"])
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE

				if("disabilities")				//please note: current code only allows nearsightedness as a disability
					disabilities = !disabilities//if you want to add actual disabilities, code that selects them should be here

				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP

				if("ui")
					switch(uiStyle)
						if("Midnight")
							uiStyle = "Orange"
						if("Orange")
							uiStyle = "old"
						else
							uiStyle = "Midnight"

				if("be_special")
					var/num = text2num(href_list["num"])
					beSpecial ^= (1<<num)

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if(toggles & SOUND_LOBBY)
						user << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

				if("ghost_ears")
					toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles ^= CHAT_GHOSTSIGHT

				if("save")
					savePreferences()
					saveCharacter()

				if("reload")
					loadPreferences()
					loadJoinData()
					loadCharacter()
					loadRecord()

				if("delete")
					deleteCharacter()

					loadPreferences()
					loadJoinData()
					loadCharacter()
					loadRecord()

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)

				if("close_load_dialog")
					close_load_dialog(user)

				if("changeslot")
					loadCharacter(text2num(href_list["num"]))
					loadRecord(text2num(href_list["num"]))
					close_load_dialog(user)

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, safety = 0)
	if(config.humans_need_surnames)
		var/firstspace = findtext(realName, " ")
		var/name_length = length(realName)
		if(!firstspace)	//we need a surname
			realName += " [pick(last_names)]"
		else if(firstspace == name_length)
			realName += "[pick(last_names)]"

	character.real_name = realName
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.gender = gender
	character.age = age
	character.b_type = bType

	character.r_eyes = rEyes
	character.g_eyes = gEyes
	character.b_eyes = bEyes

	character.r_hair = rHair
	character.g_hair = gHair
	character.b_hair = bHair

	character.r_facial = rFacial
	character.g_facial = gFacial
	character.b_facial = bFacial

	character.s_tone = sTone

	character.h_style = hStyle
	character.f_style = fStyle

	// Destroy/cyborgize organs
	for(var/name in organData)
		var/datum/organ/external/O = character.organs_by_name[name]
		if(!O) continue

		var/status = organData[name]
		if(status == "amputated")
			O.amputated = 1
			O.status |= ORGAN_DESTROYED
			O.destspawn = 1
		else if(status == "cyborg")
			O.status |= ORGAN_ROBOT
	if(underwear > underwear_m.len || underwear < 1)
		underwear = 1 //I'm sure this is 100% unnecessary, but I'm paranoid... sue me.
	character.underwear = underwear

	if(backbag > 4 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i <= MAX_SAVE_SLOTS, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i == defaultSlot)
				name = "<b>[name]</b>"
			dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>Close</a><br>"
	dat += "</center></tt>"
	user << browse(dat, "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")

/datum/preferences/proc/getTotalJoins()
	var/returnedNum = 0
	var/tmpNumPlayed = null
	for(var/i = 1, i <= numOfJobsPlayed.len, i++)
		tmpNumPlayed = numOfJobsPlayed[i]
		if(tmpNumPlayed)
			returnedNum += tmpNumPlayed
	return returnedNum

/datum/preferences/proc/getDeptJoins(department)
	var/returnedNum = 0
	var/datum/job/tmpJob
	for(var/i = 1, i <= job_master.occupations.len, i++)
		tmpJob = job_master.occupations[i]
		if(tmpJob.countsAsPlayedInDept == department)
			returnedNum += numOfJobsPlayed[tmpJob.titleFlag]
	return returnedNum

/datum/preferences/proc/getAllJobJoins()
	var/returnedText = ""
	var/datum/job/tmpJob = null
	var/tmpNumPlayed = null
	for(var/i = 1, i <= job_master.occupations.len, i++)
		tmpJob = job_master.occupations[i]
		tmpNumPlayed = numOfJobsPlayed[tmpJob.titleFlag]
		if(tmpNumPlayed)
			returnedText += "[tmpJob.title]: <b>[tmpNumPlayed]</b> "
	return returnedText



