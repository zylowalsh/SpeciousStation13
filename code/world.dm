var/const/RECOMMENDED_VERSION = 501

var/dateAtStart
var/timeAtStart
var/dateAtStartString

/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session

/world/New()
	dateAtStart = world.realtime
	timeAtStart = world.timeofday
	dateAtStartString = time2text(dateAtStart, "YYYY/MM-Month/DD-Day")
	// Setting up logs
	log = file("data/logs/runtime/[time2text(dateAtStart,"YYYY-MM")].log")
	href_logfile = file("data/logs/[dateAtStartString] hrefs.htm")

	diary = file("data/logs/[dateAtStartString].log")
	diaryofmeanpeople = file("data/logs/[dateAtStartString] Attack.log")

	diary << "\n\nStarting up. [time2text(timeAtStart, "hh:mm.ss")]\n---------------------"
	diaryofmeanpeople << "\n\nStarting up. [time2text(timeAtStart, "hh:mm.ss")]\n---------------------"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements. Please update BYOND!"

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	load_configuration()
	load_mode()
	load_motd()
	load_admins()
	load_mods()
	LoadBansjob()
	if(config.usewhitelist)
		load_whitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	jobban_loadbanfile()
	jobban_updatelegacybans()
	LoadBans()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	investigate_reset()
	Get_Holiday()	//~Carn, needs to be here when the station is named so :P

	src.update_status()

	makepowernets()

	sun = new /datum/sun()
	radio_controller = new /datum/controller/radio()
	dataCore = new /datum/datacore()
	paiController = new /datum/paiController()

	plasmaMasterOverlay = new /obj/effect/overlay()
	plasmaMasterOverlay.icon = 'icons/effects/tile_effects.dmi'
	plasmaMasterOverlay.icon_state = "plasma"
	plasmaMasterOverlay.layer = FLY_LAYER
	plasmaMasterOverlay.mouse_opacity = 0

	sleepAgentMasterOverlay = new /obj/effect/overlay()
	sleepAgentMasterOverlay.icon = 'icons/effects/tile_effects.dmi'
	sleepAgentMasterOverlay.icon_state = "sleeping_agent"
	sleepAgentMasterOverlay.layer = FLY_LAYER
	sleepAgentMasterOverlay.mouse_opacity = 0

	master_controller = new /datum/controller/game_controller()
	spawn(-1)
		master_controller.setup()
		lighting_controller.Initialize()

	src.update_status()

	process_teleport_locs()			//Sets up the wizard teleport locations
	process_ghost_teleport_locs()	//Sets up ghost teleport locations.
	sleep_offline = 1

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()
		if(config.kick_inactive)
			KickInactiveClients()

/world/Topic(T, addr, master, key)
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n
		s["admins"] = admins

		return list2params(s)


/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/
	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

	..(reason)

/world/proc/KickInactiveClients()
	var/const/INACTIVITY_KICK = 6000 //10 minutes in ticks (approx.)
	spawn(-1)
		set background = 1
		while(1)
			sleep(INACTIVITY_KICK)
			for(var/client/C in clients)
				if(C.is_afk(INACTIVITY_KICK))
					if(!istype(C.mob, /mob/dead))
						log_access("AFK: [key_name(C)]")
						C << "\red You have been inactive for more than 10 minutes and have been disconnected."
						del(C)

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	// apply some settings from config..
	abandon_allowed = config.respawn

/world/proc/load_mods()
	var/text = file2text("config/moderators.txt")
	if (!text)
		diary << "Failed to load config/mods.txt\n"
	else
		var/list/lines = text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			if (copytext(line, 1, 2) == ";")
				continue

			var/rights = admin_ranks["Moderator"]
			var/ckey = copytext(line, 1, length(line)+1)
			var/datum/admins/D = new /datum/admins("Moderator", rights, ckey)
			D.associate(directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://speciousstation13.forumotions.net/\">"
	s += "Forums"
	s += "</a>"
	s += ")"

	s += " ("
	s += "<a href=\https://github.com/zylowalsh/SpeciousStation13/issues">" //Change this to wherever you want the hub to link to.
	s += "Report Bug"
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		features += "<b>IN GAME</b>"
	else
		features += "<b>STARTING</b>"

	if (!enter_allowed)
		features += "closed"

	features += "Unique Map"
	features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	if (features)
		s += ": [dd_list2text(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s