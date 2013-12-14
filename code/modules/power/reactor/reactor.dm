/obj/machinery/atmospherics/unary/reactor
	var/const/MAX_SHEETS = 100
	var/const/CURRENT_HEAT_CAPACITY = 1000

	name = "reactor"
	icon = 'icons/obj/power.dmi'
	icon_state = "potato_cell"
	density = TRUE
	anchored = FALSE
	use_power = 0

	var/on = FALSE
	var/sheets = 0
	var/sheetName = ""
	var/sheetPath = /obj/item/stack/sheet/mineral/uranium
	var/sheetLeft = 0 // How much is left of the sheet
	var/timePerSheet = 100
	var/heat = 0

	var/current_temperature = T20C

/obj/machinery/atmospherics/unary/reactor/New()
	..()
	initialize_directions = dir

/obj/machinery/atmospherics/unary/reactor/Del()

/obj/machinery/atmospherics/unary/reactor/proc/HasFuel()
	return 1

/obj/machinery/atmospherics/unary/reactor/proc/UseFuel()

/obj/machinery/atmospherics/unary/reactor/proc/DropFuel()

/obj/machinery/atmospherics/unary/reactor/proc/handleInactive()

/obj/machinery/atmospherics/unary/reactor/process()
	..()
	if(!on)
		return 0
	var/air_heat_capacity = air_contents.heat_capacity()
	var/combined_heat_capacity = CURRENT_HEAT_CAPACITY + air_heat_capacity
	var/old_temperature = air_contents.temperature

	if(combined_heat_capacity > 0)
		var/combined_energy = current_temperature * CURRENT_HEAT_CAPACITY + air_heat_capacity * air_contents.temperature
		air_contents.temperature = combined_energy/combined_heat_capacity

	if(abs(old_temperature-air_contents.temperature) > 1)
		network.update = 1
	return 1

/obj/machinery/atmospherics/unary/reactor/initialize()
	if(node)
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

	update_icon()

/obj/machinery/atmospherics/unary/reactor/Topic()

/obj/machinery/atmospherics/unary/reactor/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/atmospherics/unary/reactor/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/atmospherics/unary/reactor/attack_hand(mob/user as mob)

/obj/machinery/atmospherics/unary/reactor/attackby(obj/item/W, mob/user)

/obj/machinery/atmospherics/unary/reactor/update_icon()
