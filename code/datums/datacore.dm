/datum/datacore
	var/datum/record/allRecords[0]
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/datum/locked_record/lockedRecords[0]

/datum/record
	var/recordName = "Default Record"

	var/id
	var/name
	var/tmp/rank
	var/tmp/realRank
	var/age
	var/fingerprint
	var/gender
	var/species
	var/tmp/pStat = "Active"
	var/mStat = "Stable"
	var/employmentHistory = "No employment History"
	var/generalNotes = "No notes found."
	var/tmp/photo

	var/medNotes = "No notes found."
	var/bType
	var/bDNA
	var/minorDisability = "None"
	var/minorDisabilityDesc = "No minor disabilities have been declared."
	var/majorDisability = "None"
	var/majorDisabilityDesc = "No major disabilities have been diagnosed."
	var/allergies = "None"
	var/allergiesDesc = "No allergies have been detected in this patient."
	var/cdi = "None"
	var/cdiDesc = "No diseases have been diagnosed at the moment."

	var/secNotes = "No notes found."
	var/criminal = "None"
	var/minorCrimes = "None"
	var/minorCrimesDesc = "No minor crime convictions."
	var/majorCrimes = "None"
	var/majorCrimesDesc = "No major crime convictions."

/datum/locked_record
	var/id
	var/name
	var/rank
	var/age
	var/gender
	var/bType
	var/bDNA
	var/enzymes
	var/identity
	var/image

/datum/cloning_record
	var/id
	var/name
	var/ckey
	var/species
	var/identity
	var/enzymes
	var/implant
	var/mind

/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/heads
	var/sec
	var/eng
	var/med
	var/sci
	var/civ
	var/bot
	var/misc

	var/dat = {"
		<head><style>
			.manifest {border-collapse:collapse;}
			.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
			.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
			.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
			.manifest td:first-child {text-align:right}
			.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
		</style></head>
		<table class="manifest" width='350px'>
		<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
		"}

	for(var/datum/record/t in dataCore.allRecords)
		var/isActive = ""
		var/tempString = ""

		var/name = t.name
		var/rank = t.rank
		var/realRank = t.realRank

		if(OOC)
			var/active = 0
			for(var/mob/M in player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 6000)
					active = 1
					break
			isActive = active ? "Active" : "Inactive"
		else
			isActive = t.pStat

		tempString = "<td>[name]</td><td>[rank]</td><td>[isActive]</td></tr>"

		if(realRank in command_positions)
			heads += tempString
		else if(realRank in security_positions)
			sec += tempString
		else if(realRank in engineering_positions)
			eng += tempString
		else if(realRank in medical_positions)
			med += tempString
		else if(realRank in science_positions)
			sci += tempString
		else if(realRank in civilian_positions)
			civ += tempString
		else if(realRank in nonhuman_positions)
			bot += tempString
		else
			misc += tempString

	if(heads)
		dat += "<tr><th colspan=3>Heads</th></tr>"
		dat += heads
	if(sec)
		dat += "<tr><th colspan=3>Security</th></tr>"
		dat += sec
	if(eng)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		dat += eng
	if(med)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		dat += med
	if(sci)
		dat += "<tr><th colspan=3>Science</th></tr>"
		dat += sci
	if(civ)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		dat += civ
	if(bot)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		dat += bot
	if(misc)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		dat += misc

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifestModify(var/name, var/assignment)
	var/datum/record/foundRecord
	var/realTitle = assignment

	for(var/datum/record/r in dataCore.allRecords)
		if (r)
			if(r.name == name)
				foundRecord = r
				break

	var/list/allJobs = get_job_datums()

	for(var/datum/job/J in allJobs)
		var/list/altTitles = get_alternate_titles(J.title)
		if(!J)
			continue
		if(assignment in altTitles)
			realTitle = J.title
			break

	if(foundRecord)
		foundRecord.rank = assignment
		foundRecord.realRank = realTitle

/datum/datacore/proc/manifestInject(var/mob/living/carbon/human/H)
	if(H.mind && (H.mind.assigned_role != "MODE"))
		H.startingName = H.real_name
		H.startingCKey = H.ckey
		var/datum/preferences/P = allPreferences[H.ckey]
		P.saveCharacter()

		var/assignment
		if(H.mind.role_alt_title)
			assignment = H.mind.role_alt_title
		else if(H.mind.assigned_role)
			assignment = H.mind.assigned_role
		else if(H.job)
			assignment = H.job
		else
			assignment = "Unassigned"

		if(isnull(H.client.prefs.record))
			var/id = add_zero(num2hex(rand(1, 1.6777215E7)), 6)	//this was the best they could come up with? A large random number? *sigh*

			//General
			var/datum/record/r = new()
			r.id					= id
			r.name					= H.real_name
			r.rank					= assignment
			r.realRank				= H.mind.assigned_role
			r.age					= H.age
			r.fingerprint			= md5(H.dna.uni_identity)
			r.gender				= H.gender
			r.species				= H.get_species()
			r.photo					= getIDPhoto(H)

			//Medical
			r.bType					= H.b_type
			r.bDNA					= H.dna.unique_enzymes

			allRecords += r
		else
			var/datum/record/r = H.client.prefs.record
			r.rank					= assignment
			r.realRank				= H.mind.assigned_role
			r.photo					= getIDPhoto(H)

			allRecords += r

		//Locked Record
		var/datum/locked_record/l = new()
		l.id				= md5("[H.real_name][H.mind.assigned_role]")
		l.name				= H.real_name
		l.rank		 		= H.mind.assigned_role
		l.age				= H.age
		l.gender			= H.gender
		l.bType				= H.b_type
		l.bDNA				= H.dna.unique_enzymes
		l.enzymes			= H.dna.struc_enzymes
		l.identity			= H.dna.uni_identity
		l.image				= getFlatIcon(H,0)	//This is god-awful
		lockedRecords += l

proc/getIDPhoto(var/mob/living/carbon/human/H)
	var/icon/preview_icon = null

	var/g = "m"
	if (H.gender == FEMALE)
		g = "f"

	var/icon/icobase = H.species.icobase

	preview_icon = new /icon(icobase, "torso_[g]")
	var/icon/temp
	temp = new /icon(icobase, "groin_[g]")
	preview_icon.Blend(temp, ICON_OVERLAY)
	temp = new /icon(icobase, "head_[g]")
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/datum/organ/external/E in H.organs)
		if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
		temp = new /icon(icobase, "[E.name]")
		if(E.status & ORGAN_ROBOT)
			temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	// Skin tone
	if(H.species.flags & HAS_SKIN_TONE)
		if (H.s_tone >= 0)
			preview_icon.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
		else
			preview_icon.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/icon/clothes_s = null
	switch(H.mind.assigned_role)
		if("Head of Personnel")
			clothes_s = new /icon('icons/mob/uniform.dmi', "hop_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Bartender")
			clothes_s = new /icon('icons/mob/uniform.dmi', "ba_suit_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Botanist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "hydroponics_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Chef")
			clothes_s = new /icon('icons/mob/uniform.dmi', "chef_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Janitor")
			clothes_s = new /icon('icons/mob/uniform.dmi', "janitor_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Librarian")
			clothes_s = new /icon('icons/mob/uniform.dmi', "red_suit_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Quartermaster")
			clothes_s = new /icon('icons/mob/uniform.dmi', "qm_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Cargo Technician")
			clothes_s = new /icon('icons/mob/uniform.dmi', "cargotech_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Shaft Miner")
			clothes_s = new /icon('icons/mob/uniform.dmi', "miner_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Lawyer")
			clothes_s = new /icon('icons/mob/uniform.dmi', "internalaffairs_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Chaplain")
			clothes_s = new /icon('icons/mob/uniform.dmi', "chapblack_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Research Director")
			clothes_s = new /icon('icons/mob/uniform.dmi', "director_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		if("Scientist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "toxinswhite_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
		if("Chemist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "chemistrywhite_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
		if("Chief Medical Officer")
			clothes_s = new /icon('icons/mob/uniform.dmi', "cmo_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
		if("Medical Doctor")
			clothes_s = new /icon('icons/mob/uniform.dmi', "medical_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		if("Geneticist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "geneticswhite_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
		if("Virologist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "virologywhite_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
		if("Captain")
			clothes_s = new /icon('icons/mob/uniform.dmi', "captain_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Head of Security")
			clothes_s = new /icon('icons/mob/uniform.dmi', "hosred_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Warden")
			clothes_s = new /icon('icons/mob/uniform.dmi', "warden_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Detective")
			clothes_s = new /icon('icons/mob/uniform.dmi', "detective_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "detective"), ICON_OVERLAY)
		if("Security Officer")
			clothes_s = new /icon('icons/mob/uniform.dmi', "secred_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Chief Engineer")
			clothes_s = new /icon('icons/mob/uniform.dmi', "chief_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Station Engineer")
			clothes_s = new /icon('icons/mob/uniform.dmi', "engine_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "orange"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Atmospheric Technician")
			clothes_s = new /icon('icons/mob/uniform.dmi', "atmos_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Roboticist")
			clothes_s = new /icon('icons/mob/uniform.dmi', "robotics_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		else
			clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	del(eyes_s)
	del(clothes_s)

	return preview_icon