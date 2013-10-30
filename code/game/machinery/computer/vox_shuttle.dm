#define VOX_SHUTTLE_MOVE_TIME 260
#define VOX_SHUTTLE_COOLDOWN 460

//Copied from Syndicate shuttle.
var/global/vox_shuttle_location

/obj/machinery/computer/vox_station
	name = "vox skipjack terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"
	req_access = list(access_syndicate)
	var/id = null
	var/area/curr_location
	var/moving = 0
	var/lastMove = 0
	var/warning //Warning about the end of the round.

/obj/machinery/computer/vox_station/New()
	curr_location= locate(/area/shuttle/vox/station)


/obj/machinery/computer/vox_station/proc/vox_move_to(area/destination as area)
	if(moving)	return
	if(lastMove + VOX_SHUTTLE_COOLDOWN > world.time)	return
	var/area/dest_location = locate(destination)
	if(curr_location == dest_location)	return

	moving = 1
	lastMove = world.time

	if(curr_location.z != dest_location.z)
		var/area/transit_location = locate(/area/shuttle/vox/transit)
		curr_location.move_contents_to(transit_location)
		curr_location = transit_location
		sleep(VOX_SHUTTLE_MOVE_TIME)

	curr_location.move_contents_to(dest_location)
	curr_location = dest_location
	moving = 0

	return 1


/obj/machinery/computer/vox_station/attackby(obj/item/I as obj, mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/vox_station/attack_hand(mob/user as mob)
	if(!allowed(user))
		user << "\red Access Denied"
		return

	user.set_machine(src)

	var/dat = {"Location: [curr_location]<br>
	Ready to move[max(lastMove + VOX_SHUTTLE_COOLDOWN - world.time, 0) ? " in [max(round((lastMove + VOX_SHUTTLE_COOLDOWN - world.time) * 0.1), 0)] seconds" : ": now"]<br>
	<a href='?src=\ref[src];start=1'>Return to Dark Space Station</a><br>
	<a href='?src=\ref[src];northwest_solars=1'>Northwest Solars</a> |
	<a href='?src=\ref[src];northeast_solars=1'>Northeast Solars</a><br>
	<a href='?src=\ref[src];southwest_solars=1'>Southwest Solars</a> |
	<a href='?src=\ref[src];southeast_solars=1'>Southeast Solars</a><br>
	<a href='?src=\ref[src];mining=1'>Mining Asteroid</a><br>
	<a href='?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return


/obj/machinery/computer/vox_station/Topic(href, href_list)
	if(!isliving(usr))	return
	var/mob/living/user = usr

	if(in_range(src, user) || istype(user, /mob/living/silicon))
		user.set_machine(src)

	vox_shuttle_location = "station"
	if(href_list["start"])
		if(ticker && (istype(ticker.mode,/datum/game_mode/heist)))
			if(!warning)
				user << "\red Returning to dark space will end your raid and report your success or failure. If you are sure, press the button again."
				warning = 1
				return
		open_station_doors()
		vox_move_to(/area/shuttle/vox/station)
		vox_shuttle_location = "start"
	else if(href_list["northeast_solars"])
		close_station_doors()
		vox_move_to(/area/shuttle/vox/northeast_solars)
	else if(href_list["northwest_solars"])
		close_station_doors()
		vox_move_to(/area/shuttle/vox/northwest_solars)
	else if(href_list["southeast_solars"])
		close_station_doors()
		vox_move_to(/area/shuttle/vox/southeast_solars)
	else if(href_list["southwest_solars"])
		close_station_doors()
		vox_move_to(/area/shuttle/vox/southwest_solars)
	else if(href_list["mining"])
		close_station_doors()
		vox_move_to(/area/shuttle/vox/mining)

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/vox_station/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")

/obj/machinery/computer/vox_station/proc/open_station_doors()
	if(!istype(curr_location, /area/shuttle/vox/station))
		for(var/obj/machinery/door/poddoor/M in world)
			if(M.id == id)
				spawn(VOX_SHUTTLE_MOVE_TIME+10)
					M.open()

/obj/machinery/computer/vox_station/proc/close_station_doors()
	if(istype(curr_location, /area/shuttle/vox/station))
		for(var/obj/machinery/door/poddoor/M in world)
			if(M.id == id)
				spawn(0)
					M.close()
				sleep(-1) // To prevent the ship from moving away with its doors open on laggy servers