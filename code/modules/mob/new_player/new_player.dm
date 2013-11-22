//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0 //Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

/mob/new_player/New()
	mob_list += src

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(!ready)
			output += "<p><a href='byond://?src=\ref[src];ready=1'>Declare Ready</A></p>"
		else
			output += "<p><b>You are ready</b> (<a href='byond://?src=\ref[src];ready=2'>Cancel</A>)</p>"
	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	output += "</div>"

	src << browse(output,"window=playersetup;size=210x240;can_close=0")
	return

/mob/new_player/Stat()
	..()

	statpanel("Status")
	if (client.statpanel == "Status" && ticker)
		if (ticker.current_state != GAME_STATE_PREGAME)
			stat(null, "Station Time: [worldtime2text()]")
	statpanel("Lobby")
	if(client.statpanel=="Lobby" && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			stat("Game Mode:", "[master_mode]")

		if((ticker.current_state == GAME_STATE_PREGAME) && going)
			stat("Time To Start:", ticker.pregame_timeleft)
		if((ticker.current_state == GAME_STATE_PREGAME) && !going)
			stat("Time To Start:", "DELAYED")

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in player_list)
				stat("[player.key]", (player.ready)?("(Playing)"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		ready = !ready

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/dead/observer/observer = new()

			spawning = 1
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			src << "\blue Now teleporting."
			observer.loc = O.loc
			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			observer.key = key

			del(src)
			return 1

	if(href_list["late_join"])
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			usr << "\red The round is either not ready, or has already finished..."
			return

		if(client.prefs.species != "Human")

			if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		if(!enter_allowed)
			usr << "\blue There is an administrative lock on entering the game!"
			return

		if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)
		return 0
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		return 0
	if(jobban_isbanned(src,rank))
		return 0
	if(!job.hasMinimumJobExperience(src.client))
		return 0
	return 1

/mob/new_player/proc/AttemptLateSpawn(rank)
	if (src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		usr << "\red The round is either not ready, or has already finished..."
		return 0
	if(!enter_allowed)
		usr << "\blue There is an administrative lock on entering the game!"
		return 0
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0

	job_master.AssignRole(src, rank, 1)

	var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
	job_master.EquipRank(character, rank, 1)					//equips the human
	EquipCustomItems(character)
	character.loc = pick(latejoin)
	character.lastarea = get_area(loc)

	ticker.mode.latespawn(character)

	//ticker.mode.latespawn(character)

	if(character.mind.assigned_role != "Cyborg")
		dataCore.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
		AnnounceArrival(character, rank)
	else
		character.Robotize()
	del(src)

/mob/new_player/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		a.autosay("[character.real_name],[rank ? " [rank]," : " visitor," ] has arrived on the station.", "Arrivals Announcement Computer")
		del(a)

/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<html><body><center>"
	dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"

	if(emergency_shuttle) //In case Nanotrasen decides reposess CentComm's shuttles.
		if(emergency_shuttle.direction == 2) //Shuttle is going to centcomm, not recalled
			dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
		if(emergency_shuttle.direction == 1 && emergency_shuttle.timeleft() < 300 && emergency_shuttle.alert == 0) // Emergency shuttle is past the point of no recall
			dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"
		if(emergency_shuttle.direction == 1 && emergency_shuttle.alert == 1) // Crew transfer initiated
			dat += "<font color='red'>The station is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open positions:<br>"
	for(var/datum/job/job in job_master.occupations)
		if(job && IsJobAvailable(job.title))
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list)
				if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
					active++
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=320x640;can_close=1")

/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character = new(loc)
	new_character.lastarea = get_area(loc)

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
	if(chosen_species)
		if(is_alien_whitelisted(src, client.prefs.species) || !config.usealienwhitelist || !(chosen_species.flags & WHITELISTED) || (client.holder.rights & R_ADMIN) )// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
			new_character.set_species(client.prefs.species)
			if(chosen_species.language)
				new_character.add_language(chosen_species.language)

	var/datum/language/chosen_language
	if(client.prefs.language)
		chosen_language = all_languages[client.prefs.language]
	if(chosen_language)
		if(is_alien_whitelisted(src, client.prefs.language) || !config.usealienwhitelist || !(chosen_language.flags & WHITELISTED_LANG))
			new_character.add_language(client.prefs.language)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		if(mind.assigned_role == "Clown")				//give them a clownname if they are a clown
			new_character.real_name = pick(clown_names)	//I hate this being here of all places but unfortunately dna is based on real_name!
			new_character.rename_self("clown")
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type

	if(client.prefs.disabilities)
		new_character.dna.struc_enzymes = setblock(new_character.dna.struc_enzymes,GLASSESBLOCK,toggledblock(getblock(new_character.dna.struc_enzymes,GLASSESBLOCK,3)),3)
		new_character.disabilities |= NEARSIGHTED

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Crew Manifest</h4>"
	dat += dataCore.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
