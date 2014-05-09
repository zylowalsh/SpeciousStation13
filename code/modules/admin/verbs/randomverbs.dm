/client/proc/cmd_admin_drop_everything(mob/M as mob in mob_list)
	set category = null
	set name = "Drop Everything"
	if(!holder)
		src << "Only administrators may use this command."
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		M.drop_from_inventory(W)

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!", 1)

/client/proc/cmd_admin_prison(mob/M as mob in mob_list)
	set category = "Admin"
	set name = "Prison"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if (ismob(M))
		if(istype(M, /mob/living/silicon/ai))
			alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
			return
		//strip their stuff before they teleport into a cell :downs:
		for(var/obj/item/W in M)
			M.drop_from_inventory(W)
		//teleport person to cell
		M.Paralyse(5)
		sleep(5)	//so they black out before warping
		M.loc = pick(prisonwarp)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), slot_w_uniform)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), slot_shoes)
		spawn(50)
			M << "\red You have been sent to the prison station!"
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)

/client/proc/cmd_admin_subtle_message(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Subtle Message"

	if(!ismob(M))	return
	if (!holder)
		src << "Only administrators may use this command."
		return

	var/msg = input("Message:", text("Subtle PM to [M.key]")) as text

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				M << "\bold You hear a voice in your head... \italic [msg]"

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	message_admins("\blue \bold SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] : [msg]", 1)

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special Verbs"
	set name = "Global Narrate"

	if (!holder)
		src << "Only administrators may use this command."
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text

	if (!msg)
		return
	world << "[msg]"
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("\blue \bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR>", 1)

/client/proc/cmd_admin_direct_narrate(var/mob/M)	// Targetted narrate -- TLE
	set category = "Special Verbs"
	set name = "Direct Narrate"

	if(!holder)
		src << "Only administrators may use this command."
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text

	if( !msg )
		return

	M << msg
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	message_admins("\blue \bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]<BR>", 1)

/client/proc/cmd_admin_godmode(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Godmode"
	if(!holder)
		src << "Only administrators may use this command."
		return
	M.status_flags ^= GODMODE
	usr << "\blue Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]"

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]", 1)

proc/cmd_admin_mute(mob/M as mob, mute_type, automute = 0)
	if(automute)
		if(!config.automute_on)	return
	else
		if(!usr || !usr.client)
			return
		if(!usr.client.holder)
			usr << "<font color='red'>Error: cmd_admin_mute: You don't have permission to do this.</font>"
			return
		if(!M.client)
			usr << "<font color='red'>Error: cmd_admin_mute: This mob doesn't have a client tied to it.</font>"
		if(M.client.holder)
			usr << "<font color='red'>Error: cmd_admin_mute: You cannot mute an admin.</font>"
	if(!M.client)		return
	if(M.client.holder)	return

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(M)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
		M << "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin."
		return

	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(M)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	M << "You have been [muteunmute] from [mute_string]."

/client/proc/cmd_admin_add_random_ai_law()
	set category = "Fun"
	set name = "Add Random AI Law"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	log_admin("[key_name(src)] has added a random AI law.")
	message_admins("[key_name_admin(src)] has added a random AI law.", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert")
		world << sound('sound/AI/ionstorm.ogg')

	IonStorm(0)

//I use this proc for respawn character too. /N
/proc/create_xeno(ckey)
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in player_list)
			if(M.stat != DEAD)
				continue	//we are not dead!
			if(!M.client.prefs.beSpecial & BE_ALIEN)
				continue	//we don't want to be an alium
			if(M.client.is_afk())
				continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)
				continue	//we have a live body we are tied to
			candidates += M.ckey
		if(candidates.len)
			ckey = input("Pick the player you want to respawn as a xeno.", "Suitable Candidates") as null|anything in candidates
		else
			usr << "<font color='red'>Error: create_xeno(): no suitable candidates.</font>"
	if(!istext(ckey))	return 0

	var/alien_caste = input(usr, "Please choose which caste to spawn.","Pick a caste",null) as null|anything in list("Queen","Hunter","Sentinel","Drone","Larva")
	var/obj/effect/landmark/spawn_here = xeno_spawn.len ? pick(xeno_spawn) : pick(latejoin)
	var/mob/living/carbon/alien/new_xeno
	switch(alien_caste)
		if("Queen")		new_xeno = new /mob/living/carbon/alien/humanoid/queen(spawn_here)
		if("Hunter")	new_xeno = new /mob/living/carbon/alien/humanoid/hunter(spawn_here)
		if("Sentinel")	new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(spawn_here)
		if("Drone")		new_xeno = new /mob/living/carbon/alien/humanoid/drone(spawn_here)
		if("Larva")		new_xeno = new /mob/living/carbon/alien/larva(spawn_here)
		else			return 0

	new_xeno.ckey = ckey
	message_admins("\blue [key_name_admin(usr)] has spawned [ckey] as a filthy xeno [alien_caste].", 1)
	return 1

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawnCharacter()
	set category = "Special Verbs"
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They must be a ghost for this to work and preferably should not have a body to go back into."
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/dead/observer/observer
	for(var/mob/dead/observer/G in player_list)
		if(G.ckey == input)
			observer = G
			break

	if(!observer)//If a ghost was not found.
		usr << "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>"
		return

	if(observer.mind && !observer.mind.active)	//mind isn't currently in use by someone/something
		//Check if they were an alien
		if(observer.mind.assigned_role=="Alien")
			if(alert("This character appears to have been an alien. Would you like to respawn them as such?",,"Yes","No") == "Yes")
				var/turf/T
				if(xeno_spawn.len)
					T = pick(xeno_spawn)
				else
					T = pick(latejoin)

				var/mob/living/carbon/alien/newXeno
				switch(observer.mind.special_role)//If they have a mind, we can determine which caste they were.
					if("Hunter")
						newXeno = new /mob/living/carbon/alien/humanoid/hunter(T)
					if("Sentinel")
						newXeno = new /mob/living/carbon/alien/humanoid/sentinel(T)
					if("Drone")
						newXeno = new /mob/living/carbon/alien/humanoid/drone(T)
					if("Queen")
						newXeno = new /mob/living/carbon/alien/humanoid/queen(T)
					else//If we don't know what special role they have, for whatever reason, or they're a larva.
						create_xeno(observer.ckey)
						return

				//Now to give them their mind back.
				observer.mind.transfer_to(newXeno)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				newXeno.key = observer.key
				newXeno << "You have been fully respawned. Enjoy the game."
				message_admins("\blue [key_name_admin(usr)] has respawned [newXeno.key] as a filthy xeno.", 1)
				return	//all done. The ghost is auto-deleted

		//check if they were a monkey
		else if(findtext(observer.real_name, "monkey"))
			if(alert("This character appears to have been a monkey. Would you like to respawn them as such?",,"Yes","No") == "Yes")
				var/mob/living/carbon/monkey/newMonkey = new(pick(latejoin))
				observer.mind.transfer_to(newMonkey)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				newMonkey.key = observer.key
				newMonkey << "You have been fully respawned. Enjoy the game."
				message_admins("\blue [key_name_admin(usr)] has respawned [newMonkey.key] as a filthy xeno.", 1)
				return	//all done. The ghost is auto-deleted

	//Ok, it's not a xeno or a monkey. So, spawn a human.
	var/mob/living/carbon/human/newCharacter = new(pick(latejoin))//The mob being spawned.

	var/datum/locked_record/recordFound			//Referenced to later to either randomize or not randomize the character.
	if(observer.mind && !observer.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through dataCore.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[observer.real_name][observer.mind.assigned_role]")
		for(var/datum/locked_record/t in dataCore.lockedRecords)
			if(t.id == id)
				recordFound = t//We shall now reference the record.
				break

	if(recordFound)//If they have a record we can determine a few things.
		newCharacter.real_name = recordFound.name
		newCharacter.gender = recordFound.gender
		newCharacter.age = recordFound.age
		newCharacter.b_type = recordFound.bType
	else
		newCharacter.gender = pick(MALE,FEMALE)
		var/datum/preferences/A = new()
		A.randomize_appearance_for(newCharacter)
		newCharacter.real_name = observer.real_name

	if(!newCharacter.real_name)
		if(newCharacter.gender == MALE)
			newCharacter.real_name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
		else
			newCharacter.real_name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
	newCharacter.name = newCharacter.real_name

	if(observer.mind && !observer.mind.active)
		observer.mind.transfer_to(newCharacter)	//be careful when doing stuff like this! I've already checked the mind isn't in use
		newCharacter.mind.special_verbs = list()
	else
		newCharacter.mind_initialize()
	if(!newCharacter.mind.assigned_role)
		newCharacter.mind.assigned_role = "Assistant"//If they somehow got a null assigned role.

	//DNA
	if(recordFound)//Pull up their name from database records if they did have a mind.
		newCharacter.dna = new()//Let's first give them a new DNA.
		newCharacter.dna.unique_enzymes = recordFound.bDNA //Enzymes are based on real name but we'll use the record for conformity.
		newCharacter.dna.struc_enzymes = recordFound.enzymes //This is the default of enzymes so I think it's safe to go with.
		newCharacter.dna.uni_identity = recordFound.identity //DNA identity is carried over.
		updateappearance(newCharacter, newCharacter.dna.uni_identity) //Now we configure their appearance based on their unique identity, same as with a DNA machine or somesuch.
	else//If they have no records, we just do a random DNA for them, based on their random appearance/savefile.
		newCharacter.dna.ready_dna(newCharacter)

	newCharacter.key = observer.key

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	//Two variables to properly announce later on.
	var/admin = key_name_admin(src)
	var/playerKey = observer.key

	//Now for special roles and equipment.
	switch(newCharacter.mind.special_role)
		if("traitor")
			job_master.equipRank(newCharacter, newCharacter.mind.assigned_role, 1)
			ticker.mode.equip_traitor(newCharacter)
		if("Wizard")
			newCharacter.loc = pick(wizardstart)
			//ticker.mode.learn_basic_spells(new_character)
			ticker.mode.equip_wizard(newCharacter)
		if("Syndicate")
			var/obj/effect/landmark/synd_spawn = locate("landmark*Syndicate-Spawn")
			if(synd_spawn)
				newCharacter.loc = get_turf(synd_spawn)
			ticker.mode.equip_syndicate(newCharacter)
		if("Ninja")
			newCharacter.equip_space_ninja()
			newCharacter.internal = newCharacter.s_store
			newCharacter.internals.icon_state = "internal1"
			if(ninjastart.len == 0)
				newCharacter << "<B>\red A proper starting location for you could not be found, please report this bug!</B>"
				newCharacter << "<B>\red Attempting to place at a carpspawn.</B>"
				for(var/obj/effect/landmark/L in landmarks_list)
					if(L.name == "carpspawn")
						ninjastart.Add(L)
				if(ninjastart.len == 0 && latejoin.len > 0)
					newCharacter << "<B>\red Still no spawneable locations could be found. Defaulting to latejoin.</B>"
					newCharacter.loc = pick(latejoin)
				else if (ninjastart.len == 0)
					newCharacter << "<B>\red Still no spawneable locations could be found. Aborting.</B>"

		if("Death Commando")//Leaves them at late-join spawn.
			newCharacter.equip_death_commando()
			newCharacter.internal = newCharacter.s_store
			newCharacter.internals.icon_state = "internal1"
		else//They may also be a cyborg or AI.
			switch(newCharacter.mind.assigned_role)
				if("Cyborg")//More rigging to make em' work and check if they're traitor.
					newCharacter = newCharacter.Robotize()
					if(newCharacter.mind.special_role == "traitor")
						ticker.mode.add_law_zero(newCharacter)
				if("AI")
					newCharacter = newCharacter.AIize()
					if(newCharacter.mind.special_role == "traitor")
						ticker.mode.add_law_zero(newCharacter)
				//Add aliens.
				else
					job_master.equipRank(newCharacter, newCharacter.mind.assigned_role, 1)//Or we simply equip them.

	//Announces the character on all the systems, based on the record.
	if(!issilicon(newCharacter))//If they are not a cyborg/AI.
		if(!recordFound && newCharacter.mind.assigned_role != "MODE")//If there are no records for them. If they have a record, this info is already in there. MODE people are not announced anyway.
			//Power to the user!
			if(alert(newCharacter,"Warning: No data core entry detected. Would you like to announce the arrival of this character by adding them to various databases, such as medical records?",,"No","Yes")=="Yes")
				dataCore.manifestInject(newCharacter)

			if(alert(newCharacter,"Would you like an active AI to announce this character?",,"No","Yes") == "Yes")
				announceArrival(newCharacter, newCharacter.mind.assigned_role)

	message_admins("\blue [admin] has respawned [playerKey] as [newCharacter.real_name].", 1)

	newCharacter << "You have been fully respawned. Enjoy the game."

	return newCharacter

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Fun"
	set name = "Add Custom AI law"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in mob_list)
		if (M.stat == 2)
			usr << "Upload failed. No signal is being detected from the AI."
		else if (M.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in mob_list)
				O << "\red " + input + "\red...LAWS UPDATED"

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert")
		world << sound('sound/AI/ionstorm.ogg')

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Rejuvenate"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return
	if(config.allow_admin_rev)
		M.revive()

		log_admin("[key_name(usr)] healed / revived [key_name(M)]")
		message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(M)]!", 1)
	else
		alert("Admin revive disabled")

/client/proc/cmd_admin_create_centcom_report()
	set category = "Special Verbs"
	set name = "Create Command Report"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/input = input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as message|null
	var/customname = input(usr, "Pick a title for the report.", "Title") as text|null
	if(!input)
		return
	if(!customname)
		customname = "NanoTrasen Update"
	for (var/obj/machinery/computer/communications/C in machines)
		if(! (C.stat & (BROKEN|NOPOWER) ) )
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( C.loc )
			P.name = "'[command_name()] Update.'"
			P.info = input
			P.update_icon()
			C.messagetitle.Add("[command_name()] Update")
			C.messagetext.Add(P.info)

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			command_alert(input, customname);
		if("No")
			world << "\red New NanoTrasen Update available at all communication consoles."

	world << sound('commandreport.ogg')
	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report", 1)

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in world)
	set category = "Admin"
	set name = "Delete"

	if (!holder)
		src << "Only administrators may use this command."
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)
		del(O)

/client/proc/cmd_admin_list_open_jobs()
	set category = "Admin"
	set name = "List free slots"

	if (!holder)
		src << "Only administrators may use this command."
		return
	if(job_master)
		for(var/datum/job/job in job_master.occupations)
			src << "[job.title]: [job.total_positions]"

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = "Special Verbs"
	set name = "Explosion"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null) return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null) return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null) return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])", 1)
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = "Special Verbs"
	set name = "EM Pulse"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null) return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])", 1)

		return
	else
		return

/client/proc/cmd_admin_gib(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Gib"

	if(!check_rights(R_ADMIN|R_FUN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)	return

	log_admin("[key_name(usr)] has gibbed [key_name(M)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]", 1)

	if(istype(M, /mob/dead/observer))
		gibs(M.loc, M.viruses)
		return

	M.gib()

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Fun"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		if (istype(mob, /mob/dead/observer)) // so they don't spam gibs everywhere
			return
		else
			mob.gib()

		log_admin("[key_name(usr)] used gibself.")
		message_admins("\blue [key_name_admin(usr)] used gibself.", 1)

/*
/client/proc/cmd_manual_ban()
	set name = "Manual Ban"
	set category = "Special Verbs"
	if(!authenticated || !holder)
		src << "Only administrators may use this command."
		return
	var/mob/M = null
	switch(alert("How would you like to ban someone today?", "Manual Ban", "Key List", "Enter Manually", "Cancel"))
		if("Key List")
			var/list/keys = list()
			for(var/mob/M in world)
				keys += M.client
			var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
			if(!selection)
				return
			M = selection:mob
			if ((M.client && M.client.holder && (M.client.holder.level >= holder.level)))
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

	switch(alert("Temporary Ban?",,"Yes","No"))
	if("Yes")
		var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num
		if(!mins)
			return
		if(mins >= 525600) mins = 525599
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		if(M)
			AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
			M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
			M << "\red This is a temporary ban, it will be removed in [mins] minutes."
			M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
			log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			world.Export("http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=[mins]&server=[replacetext(config.server_name, "#", "")]")
			del(M.client)
			del(M)
		else

	if("No")
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0)
		M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
		M << "\red This is a permanent ban."
		M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
		log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		world.Export("http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=perma&server=[replacetext(config.server_name, "#", "")]")
		del(M.client)
		del(M)
*/

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		usr << "[t]"

/* This proc is DEFERRED. Does not do anything.
/client/proc/cmd_admin_remove_plasma()
	set category = "Debug"
	set name = "Stabilize Atmos."
	if(!holder)
		src << "Only administrators may use this command."
		return
	feedback_add_details("admin_verb","STATM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
// DEFERRED
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
			T.otemp = 293.15
			T.ttemp = 293.15
*/

/client/proc/toggle_view_range()
	set category = "Special Verbs"
	set name = "Change View Range"
	set desc = "switches between 1x and custom views"

	if(view == world.view)
		view = input("Select view range:", "ALERT!", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128)
	else
		view = world.view

	log_admin("[key_name(usr)] changed their view range to [view].")
	//message_admins("\blue [key_name_admin(usr)] changed their view range to [view].", 1)	//why? removed by order of XSI

/client/proc/adminCallShuttle()
	set category = "Admin"
	set name = "Call Shuttle"

	if (!ticker)
		return

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes")
		return

	if(!ticker.mode.canShuttleBeCalled)
		var/confirm2 = alert(src, "This gamemode cannot call the shuttle.  Force call the shuttle?", "ALERT!", "Yes", "No")
		if(confirm2 != "Yes")
			return

	if(ticker.mode.shuttleFakedCalled)
		var/confirm3 = alert(src, "This gamemode fakes calls the shuttle.  Force call the shuttle?", "ALERT!", "Yes", "No")
		if(confirm3 != "Yes")
			return

	emergencyShuttle.callShuttle(EMERGENCY, FALSE, TRUE)
	log_admin("[key_name(usr)] admin-called the emergency shuttle.")
	message_admins("\blue [key_name_admin(usr)] admin-called the emergency shuttle.", 1)

/client/proc/adminCancelShuttle()
	set category = "Admin"
	set name = "Cancel Shuttle"

	if(!ticker)
		return

	if(!check_rights(R_ADMIN))
		return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	emergencyShuttle.recall()
	log_admin("[key_name(usr)] admin-recalled the emergency shuttle.")
	message_admins("\blue [key_name_admin(usr)] admin-recalled the emergency shuttle.", 1)

/client/proc/adminDenyShuttle()
	set category = "Admin"
	set name = "Toggle Deny Shuttle"

	if (!ticker)
		return

	if(!check_rights(R_ADMIN))
		return

	emergencyShuttle.denyShuttle = !emergencyShuttle.denyShuttle

	log_admin("[key_name(src)] has [emergencyShuttle.denyShuttle ? "denied" : "allowed"] the shuttle to be called.")
	message_admins("[key_name_admin(usr)] has [emergencyShuttle.denyShuttle ? "denied" : "allowed"] the shuttle to be called.")

/client/proc/cmd_admin_attack_log(mob/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Attack Log"

	usr << text("\red <b>Attack Log for []</b>", mob)
	for(var/t in M.attack_log)
		usr << t

/client/proc/everyone_random()
	set category = "Fun"
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(!check_rights(R_FUN))
		return

	if (ticker && ticker.mode)
		usr << "Nope you can't do this, the game's already started. This only works before rounds!"
		return

	if(ticker.random_players)
		ticker.random_players = 0
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.", 1)
		usr << "Disabled."
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.", 1)

	if(notifyplayers == "Yes")
		world << "\blue <b>Admin [usr.key] has forced the players to have completely random identities!"

	usr << "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>."

	ticker.random_players = 1

/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"

	set desc = "Toggles random events such as meteors, black holes, blob (but not space dust) on/off"
	if(!check_rights(R_SERVER))	return

	if(!config.allow_random_events)
		config.allow_random_events = 1
		usr << "Random events enabled"
		message_admins("Admin [key_name_admin(usr)] has enabled random events.", 1)
	else
		config.allow_random_events = 0
		usr << "Random events disabled"
		message_admins("Admin [key_name_admin(usr)] has disabled random events.", 1)
