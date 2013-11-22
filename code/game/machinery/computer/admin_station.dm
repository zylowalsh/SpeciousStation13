/obj/machinery/computer/admin_station
	var/const/ADMIN_SHUTTLE_MOVE_TIME = 240
	var/const/ADMIN_SHUTTLE_COOLDOWN = 200

	name = "Landale's shuttle terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "escape"
	req_access = list(access_cent_general)
	var/area/curr_location
	var/moving = 0
	var/lastMove = 0

/obj/machinery/computer/admin_station/New()
	curr_location= locate(/area/shuttle/administration/centcom)

/obj/machinery/computer/admin_station/proc/admin_move_to(area/destination as area)
	if(moving)
		return
	if(lastMove + ADMIN_SHUTTLE_COOLDOWN > world.time)
		return
	var/area/dest_location = locate(destination)
	if(curr_location == dest_location)
		return

	moving = 1
	lastMove = world.time

	if(curr_location.z != dest_location.z)
		var/area/transit_location = locate(/area/shuttle/administration/transit)
		curr_location.move_contents_to(transit_location)
		curr_location = transit_location
		sleep(ADMIN_SHUTTLE_MOVE_TIME)

	curr_location.move_contents_to(dest_location)
	curr_location = dest_location
	moving = 0
	return 1

/obj/machinery/computer/admin_station/attackby(obj/item/I as obj, mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/admin_station/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/admin_station/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/admin_station/attack_hand(mob/user as mob)
	if(!allowed(user))
		user << "\red Access Denied"
		return

	user.set_machine(src)

	var/dat = {"Location: [curr_location]<br>
	Ready to move[max(lastMove + ADMIN_SHUTTLE_COOLDOWN - world.time, 0) ? " in [max(round((lastMove + ADMIN_SHUTTLE_COOLDOWN - world.time) * 0.1), 0)] seconds" : ": now"]<br>
	<a href='?src=\ref[src];centcom=1'>CentCom</a><br>
	<a href='?src=\ref[src];station=1'>Dock at Station</a><br>
	<a href='?src=\ref[src];station_s=1'>South of Station</a><br>
	<a href='?src=\ref[src];derelictShip=1'>Derelict Ship</a><br>
	<a href='?src=\ref[src];derelictStation=1'>Derelict Station</a><br>
	<a href='?src=\ref[src];pirateRadio=1'>Pirate DJ Station</a><br>
	<a href='?src=\ref[src];abandonedMining=1'>Abandoned Mining Station</a><br>
	<a href='?src=\ref[src];spaceFarm=1'>Space Farm</a><br>
	<a href='?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")

/obj/machinery/computer/admin_station/Topic(href, href_list)
	if(!isliving(usr))
		return
	var/mob/living/user = usr

	if(in_range(src, user) || istype(user, /mob/living/silicon))
		user.set_machine(src)

	if(href_list["centcom"])
		admin_move_to(/area/shuttle/administration/centcom)
	else if(href_list["station"])
		admin_move_to(/area/shuttle/administration/station)
	else if(href_list["station_s"])
		admin_move_to(/area/shuttle/administration/southStation)
	else if(href_list["derelictShip"])
		admin_move_to(/area/shuttle/administration/derelictShip)
	else if(href_list["derelictStation"])
		admin_move_to(/area/shuttle/administration/derelictStation)
	else if(href_list["pirateRadio"])
		admin_move_to(/area/shuttle/administration/pirateDJStation)
	else if(href_list["abandonedMining"])
		admin_move_to(/area/shuttle/administration/abandonedMiningStation)
	else if(href_list["spaceFarm"])
		admin_move_to(/area/shuttle/administration/spaceFarm)

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/admin_station/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")	//let's not let them fuck themselves in the rear