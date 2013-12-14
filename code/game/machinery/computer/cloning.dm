/obj/machinery/computer/scan_consolenew
	name = "DNA Modifier Access Console"
	desc = "Scand DNA."
	icon = 'icons/obj/computer.dmi'
	icon_state = "scanner"
	density = 1
	var/uniblock = 1.0
	var/strucblock = 1.0
	var/subblock = 1.0
	var/unitarget = 1
	var/unitargethex = 1
	var/status = null
	var/radduration = 2.0
	var/radstrength = 1.0
	var/radacc = 1.0
	var/buffer1 = null
	var/buffer2 = null
	var/buffer3 = null
	var/buffer1owner = null
	var/buffer2owner = null
	var/buffer3owner = null
	var/buffer1label = null
	var/buffer2label = null
	var/buffer3label = null
	var/buffer1type = null
	var/buffer2type = null
	var/buffer3type = null
	var/buffer1iue = 0
	var/buffer2iue = 0
	var/buffer3iue = 0
	var/delete = 0
	var/injectorready = 0	//Quick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/temphtml = null
	var/obj/machinery/dna_scannernew/connected = null
	var/obj/item/weapon/disk/data/diskette = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 400

/obj/machinery/computer/scan_consolenew/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/scan_consolenew/M = new /obj/item/weapon/circuitboard/scan_consolenew( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/scan_consolenew/M = new /obj/item/weapon/circuitboard/scan_consolenew( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	if (istype(I, /obj/item/weapon/disk/data)) //INSERT SOME DISKETTES
		if (!src.diskette)
			user.drop_item()
			I.loc = src
			src.diskette = I
			user << "You insert [I]."
			src.updateUsrDialog()
			return
	else
		src.attack_hand(user)
	return

/obj/machinery/computer/cloning
	var/const/MAIN_MENU = 1
	var/const/RECORD_LIST_MENU = 2
	var/const/SELECTED_RECORD_MENU = 3
	var/const/CONFIRM_MENU = 4

	name = "Cloning console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "dna"
	circuit = "/obj/item/weapon/circuitboard/cloning"
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/obj/machinery/clonepod/cloningPod = null //Linked cloning pod.
	var/temp = ""
	var/tempScan = "Scanner unoccupied"
	var/menu = MAIN_MENU //Which menu screen to display
	var/datum/cloning_record/records[0]
	var/datum/cloning_record/activeRecord = null
	var/obj/item/weapon/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = 0 // Nice loading text

/obj/machinery/computer/cloning/New()
	..()
	spawn(5)
		updatemodules()
		return
	return

/obj/machinery/computer/cloning/proc/updatemodules()
	src.scanner = findscanner()
	src.cloningPod = findcloner()

	if (!isnull(src.cloningPod))
		src.cloningPod.connected = src // Some variable the pod needs

/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	// Loop through every direction
	for(dir in list(NORTH,EAST,SOUTH,WEST))

		// Try to find a scanner in that direction
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, dir))

		// If found, then we break, and return the scanner
		if (!isnull(scannerf))
			break

	// If no scanner was found, it will return null
	return scannerf

/obj/machinery/computer/cloning/proc/findcloner()
	var/obj/machinery/clonepod/podf = null

	for(dir in list(NORTH,EAST,SOUTH,WEST))

		podf = locate(/obj/machinery/clonepod, get_step(src, dir))

		if (!isnull(podf))
			break

	return podf

/obj/machinery/computer/cloning/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/disk/data)) //INSERT SOME DISKETTES
		if (!src.diskette)
			user.drop_item()
			W.loc = src
			src.diskette = W
			user << "You insert [W]."
			src.updateUsrDialog()
			return
	else
		..()

/obj/machinery/computer/cloning/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/cloning/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	var/dat = "<h3>Cloning System Control</h3>"
	dat += "<font size=-1><a href='byond://?src=\ref[src];refresh=1'>Refresh</a></font>"

	dat += "<br><tt>[temp]</tt><br>"

	switch(src.menu)
		if(MAIN_MENU)
			// Modules
			dat += "<h4>Modules</h4>"
			//dat += "<a href='byond://?src=\ref[src];relmodules=1'>Reload Modules</a>"
			if (isnull(scanner))
				dat += " <font color=red>Scanner-ERROR</font><br>"
			else
				dat += " <font color=green>Scanner-Found!</font><br>"
			if (isnull(cloningPod))
				dat += " <font color=red>Pod-ERROR</font><br>"
			else
				dat += " <font color=green>Pod-Found!</font><br>"

			// Scanner
			dat += "<h4>Scanner Functions</h4>"

			if(loading)
				dat += "<b>Scanning...</b><br>"
			else
				dat += "<b>[tempScan]</b><br>"

			if (isnull(scanner))
				dat += "No scanner connected!<br>"
			else
				if (scanner.occupant)
					if(tempScan == "Scanner unoccupied")
						tempScan = "" // Stupid check to remove the text

					dat += "<a href='byond://?src=\ref[src];scan=1'>Scan - [src.scanner.occupant]</a><br>"
				else
					tempScan = "Scanner unoccupied"

				dat += "Lock status: <a href='byond://?src=\ref[src];lock=1'>[src.scanner.locked ? "Locked" : "Unlocked"]</a><br>"

			if (!isnull(src.cloningPod))
				dat += "Biomass: <i>[src.cloningPod.biomass]</i><br>"

			// Database
			dat += "<h4>Database Functions</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=2'>View Records</a><br>"
			if (src.diskette)
				dat += "<a href='byond://?src=\ref[src];disk=eject'>Eject Disk</a>"

		if(RECORD_LIST_MENU)
			dat += "<h4>Current records</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=1'>Back</a><br><br>"
			for(var/datum/cloning_record/r in records)
				dat += "<a href='byond://?src=\ref[src];view_rec=\ref[r]'>[r.id]-[r.name]</a><br>"

		if(SELECTED_RECORD_MENU)
			dat += "<h4>Selected Record</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=2'>Back</a><br>"

			if (!activeRecord)
				dat += "<font color=red>ERROR: Record not found.</font>"
			else
				dat += "<br><font size=1><a href='byond://?src=\ref[src];del_rec=1'>Delete Record</a></font><br>"
				dat += "<b>Name:</b> [activeRecord.name]<br>"

				var/obj/item/weapon/implant/health/H = locate(activeRecord.implant)

				if ((H) && (istype(H)))
					dat += "<b>Health:</b> [H.senseHealth()] | OXY-BURN-TOX-BRUTE<br>"
				else
					dat += "<font color=red>Unable to locate implant.</font><br>"

				if (!isnull(src.diskette))
					dat += "<a href='byond://?src=\ref[src];disk=load'>Load from disk.</a>"

					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=ue'>UI + UE</a>"
					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=ui'>UI</a>"
					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=se'>SE</a>"
					dat += "<br>"
				else
					dat += "<br>" //Keeping a line empty for appearances I guess.

				dat += {"<b>UI:</b> [activeRecord.identity]<br>
					<b>SE:</b> [activeRecord.enzymes]<br><br>"}

				if(cloningPod && cloningPod.biomass >= CLONE_BIOMASS)
					dat += {"<a href='byond://?src=\ref[src];clone=\ref[src.activeRecord]'>Clone</a><br>"}
				else
					dat += {"<b>Unsufficient biomass</b><br>"}

		if(CONFIRM_MENU)
			if (!src.activeRecord)
				src.menu = RECORD_LIST_MENU
			dat = "[src.temp]<br>"
			dat += "<h4>Confirm Record Deletion</h4>"

			dat += "<b><a href='byond://?src=\ref[src];del_rec=1'>Scan card to confirm.</a></b><br>"
			dat += "<b><a href='byond://?src=\ref[src];menu=3'>No</a></b>"


	user << browse(dat, "window=cloning")
	onclose(user, "cloning")
	return

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return

	if(loading)
		return

	if ((href_list["scan"]) && (!isnull(src.scanner)))
		tempScan = ""

		loading = 1
		src.updateUsrDialog()

		spawn(20)
			src.scanMob(src.scanner.occupant)

			loading = 0
			src.updateUsrDialog()


		//No locking an open scanner.
	else if ((href_list["lock"]) && (!isnull(src.scanner)))
		if ((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = TRUE
		else
			src.scanner.locked = FALSE

	else if (href_list["view_rec"])
		src.activeRecord = locate(href_list["view_rec"])
		if(istype(activeRecord, /datum/cloning_record))
			if ((isnull(activeRecord.ckey)) || (activeRecord.ckey == ""))
				del(activeRecord)
				src.temp = "ERROR: Record Corrupt"
			else
				src.menu = SELECTED_RECORD_MENU
		else
			activeRecord = null
			temp = "Record missing."

	else if (href_list["del_rec"])
		if ((!src.activeRecord) || (src.menu < SELECTED_RECORD_MENU))
			return
		if (src.menu == SELECTED_RECORD_MENU) //If we are viewing a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = CONFIRM_MENU

		else if (src.menu == CONFIRM_MENU)
			var/obj/item/weapon/card/id/C = usr.get_active_hand()
			if (istype(C)||istype(C, /obj/item/device/pda))
				if(check_access(C))
					src.records.Remove(activeRecord)
					del(activeRecord)
					temp = "Record deleted."
					menu = RECORD_LIST_MENU
				else
					temp = "Access Denied."

	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if ((isnull(diskette)) || (diskette.data == ""))
					temp = "Load error."
					src.updateUsrDialog()
					return
				if (isnull(src.activeRecord))
					temp = "Record error."
					menu = MAIN_MENU
					src.updateUsrDialog()
					return

				if (diskette.data_type == "ui")
					activeRecord.identity = diskette.data
					if (diskette.ue)
						activeRecord.name = src.diskette.owner
				else if (diskette.data_type == "se")
					activeRecord.enzymes = src.diskette.data

				temp = "Load successful."
			if("eject")
				if (!isnull(diskette))
					diskette.loc = src.loc
					diskette = null

	else if (href_list["save_disk"]) //Save to disk!
		if ((isnull(diskette)) || (diskette.read_only) || (isnull(activeRecord)))
			src.temp = "Save error."
			src.updateUsrDialog()
			return

		switch(href_list["save_disk"]) //Save as Ui/Ui+Ue/Se
			if("ui")
				src.diskette.data = src.activeRecord.identity
				src.diskette.ue = 0
				src.diskette.data_type = "ui"
			if("ue")
				src.diskette.data = src.activeRecord.identity
				src.diskette.ue = 1
				src.diskette.data_type = "ui"
			if("se")
				src.diskette.data = src.activeRecord.enzymes
				src.diskette.ue = 0
				src.diskette.data_type = "se"
		src.diskette.owner = src.activeRecord.name
		src.diskette.name = "data disk - '[src.diskette.owner]'"
		src.temp = "Save \[[href_list["save_disk"]]\] successful."

	else if (href_list["refresh"])
		src.updateUsrDialog()

	else if (href_list["clone"])
		var/datum/cloning_record/c = locate(href_list["clone"])
		//Look for that player! They better be dead!
		if(istype(c))
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
			if(!cloningPod)
				temp = "Error: No Clonepod detected."
			else if(cloningPod.occupant)
				temp = "Error: Clonepod is currently occupied."
			else if(cloningPod.biomass < CLONE_BIOMASS)
				temp = "Error: Not enough biomass."
			else if(cloningPod.mess)
				temp = "Error: Clonepod malfunction."
			else if(!config.revival_cloning)
				temp = "Error: Unable to initiate cloning cycle."

			else if(cloningPod.growClone(c.ckey, c.name, c.identity, c.enzymes, c.mind, c.species))
				temp = "Initiating cloning cycle..."
				records.Remove(c)
				del(c)
				menu = MAIN_MENU
			else

				var/mob/selected = findDeadPlayer(c.ckey)
				selected << 'chime.ogg'	//probably not the best sound but I think it's reasonable
				var/answer = alert(selected,"Do you want to return to life?","Cloning","Yes","No")
				if(answer != "No" && cloningPod.growClone(c.ckey, c.name, c.identity, c.enzymes, c.mind, c.species))
					temp = "Initiating cloning cycle..."
					records.Remove(c)
					del(c)
					menu = 1
				else
					temp = "Initiating cloning cycle...<br>Error: Post-initialisation failed. Cloning cycle aborted."

		else
			temp = "Error: Data corruption."

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/machinery/computer/cloning/proc/scanMob(mob/living/carbon/human/subject as mob)
	if ((isnull(subject)) || (!(ishuman(subject))) || (!subject.dna))
		tempScan = "Error: Unable to locate valid genetic data."
		return
	if (subject.brain_op_stage == 4.0)
		tempScan = "Error: No signs of intelligence detected."
		return
	if (subject.suiciding == 1)
		tempScan = "Error: Subject's brain is not responding to scanning stimuli."
		return
	if ((!subject.ckey) || (!subject.client))
		tempScan = "Error: Mental interface failure."
		return
	if (NOCLONE in subject.mutations)
		tempScan = "Error: Mental interface failure."
		return
	if (!isnull(findRecord(subject.ckey)))
		tempScan = "Subject already in database."
		return

	subject.dna.check_integrity()

	var/datum/cloning_record/r = new()
	r.species 		= subject.species
	r.ckey 			= subject.ckey
	r.name 			= subject.real_name
	r.id 			= copytext(md5(subject.real_name), 2, 6)
	r.identity	 	= subject.dna.uni_identity
	r.enzymes	 	= subject.dna.struc_enzymes

	//Add an implant if needed
	var/obj/item/weapon/implant/health/imp = locate(/obj/item/weapon/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/weapon/implant/health(subject)
		imp.implanted = subject
		r.implant = "\ref[imp]"
	//Update it if needed
	else
		r.implant = "\ref[imp]"

	if (!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		r.mind = "\ref[subject.mind]"

	src.records += r
	tempScan = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/findRecord(var/findKey)
	var/selectedRecord = null
	for(var/datum/cloning_record/r in records)
		if (r.ckey == findKey)
			selectedRecord = r
			break
	return selectedRecord

/obj/machinery/computer/cloning/update_icon()

	if(stat & BROKEN)
		icon_state = "commb"
	else
		if(stat & NOPOWER)
			src.icon_state = "c_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
