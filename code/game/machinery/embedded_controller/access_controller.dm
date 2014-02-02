//States for airlock_control
var/const/ACCESS_STATE_INTERNAL = -1
var/const/ACCESS_STATE_LOCKED = 0
var/const/ACCESS_STATE_EXTERNAL = 1

datum/computer/file/embedded_program/access_controller
	var/id_tag
	var/exterior_door_tag
	var/interior_door_tag

	state = ACCESS_STATE_LOCKED
	var/target_state = ACCESS_STATE_LOCKED

	receive_signal(datum/signal/signal, receive_method, receive_param)
		var/receive_tag = signal.data["tag"]
		if(!receive_tag) return

		if(receive_tag==exterior_door_tag)
			if(signal.data["door_status"] == "closed")
				if(signal.data["lock_status"] == "locked")
					memory["exterior_status"] = "locked"
				else
					memory["exterior_status"] = "closed"
			else
				memory["exterior_status"] = "open"

		else if(receive_tag==interior_door_tag)
			if(signal.data["door_status"] == "closed")
				if(signal.data["lock_status"] == "locked")
					memory["interior_status"] = "locked"
				else
					memory["interior_status"] = "closed"
			else
				memory["interior_status"] = "open"

		else if(receive_tag==id_tag)
			switch(signal.data["command"])
				if("cycle_interior")
					target_state = ACCESS_STATE_INTERNAL
				if("cycle_exterior")
					target_state = ACCESS_STATE_EXTERNAL
				if("cycle")
					if(state < ACCESS_STATE_LOCKED)
						target_state = ACCESS_STATE_EXTERNAL
					else
						target_state = ACCESS_STATE_INTERNAL

	receive_user_command(command)
		switch(command)
			if("cycle_closed")
				target_state = ACCESS_STATE_LOCKED
			if("cycle_exterior")
				target_state = ACCESS_STATE_EXTERNAL
			if("cycle_interior")
				target_state = ACCESS_STATE_INTERNAL

	process()
		var/process_again = 1
		while(process_again)
			process_again = 0
			switch(state)
				if(ACCESS_STATE_INTERNAL) // state -1
					if(target_state > state)
						if(memory["interior_status"] == "locked")
							state = ACCESS_STATE_LOCKED
							process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = interior_door_tag
							if(memory["interior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)

				if(ACCESS_STATE_LOCKED)
					if(target_state < state)
						if(memory["exterior_status"] != "locked")
							var/datum/signal/signal = new
							signal.data["tag"] = exterior_door_tag
							if(memory["exterior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)
						else
							if(memory["interior_status"] == "closed" || memory["interior_status"] == "open")
								state = ACCESS_STATE_INTERNAL
								process_again = 1
							else
								var/datum/signal/signal = new
								signal.data["tag"] = interior_door_tag
								signal.data["command"] = "secure_open"
								post_signal(signal)
					else if(target_state > state)
						if(memory["interior_status"] != "locked")
							var/datum/signal/signal = new
							signal.data["tag"] = interior_door_tag
							if(memory["interior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)
						else
							if(memory["exterior_status"] == "closed" || memory["exterior_status"] == "open")
								state = ACCESS_STATE_EXTERNAL
								process_again = 1
							else
								var/datum/signal/signal = new
								signal.data["tag"] = exterior_door_tag
								signal.data["command"] = "secure_open"
								post_signal(signal)
					else
						if(memory["interior_status"] != "locked")
							var/datum/signal/signal = new
							signal.data["tag"] = interior_door_tag
							if(memory["interior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)
						else if(memory["exterior_status"] != "locked")
							var/datum/signal/signal = new
							signal.data["tag"] = exterior_door_tag
							if(memory["exterior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)

				if(ACCESS_STATE_EXTERNAL) //state 1
					if(target_state < state)
						if(memory["exterior_status"] == "locked")
							state = ACCESS_STATE_LOCKED
							process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = exterior_door_tag
							if(memory["exterior_status"] == "closed")
								signal.data["command"] = "lock"
							else
								signal.data["command"] = "secure_close"
							post_signal(signal)


		return 1


obj/machinery/embedded_controller/radio/access_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_control_standby"

	name = "Access Console"
	density = 0
	power_channel = ENVIRON
	unacidable = 1

	frequency = 1449

	// Setup parameters only
	var/id_tag
	var/exterior_door_tag
	var/interior_door_tag

	initialize()
		..()

		var/datum/computer/file/embedded_program/access_controller/new_prog = new

		new_prog.id_tag = id_tag
		new_prog.exterior_door_tag = exterior_door_tag
		new_prog.interior_door_tag = interior_door_tag

		new_prog.master = src
		program = new_prog

	update_icon()
		if(on && program)
			if(program.memory["processing"])
				icon_state = "access_control_process"
			else
				icon_state = "access_control_standby"
		else
			icon_state = "access_control_off"


	return_text()
		var/state_options = null

		var/state = 0
		var/exterior_status = "----"
		var/interior_status = "----"
		if(program)
			state = program.state
			exterior_status = program.memory["exterior_status"]
			interior_status = program.memory["interior_status"]

		switch(state)
			if(ACCESS_STATE_INTERNAL)
				state_options = {"<A href='?src=\ref[src];command=cycle_closed'>Lock Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_exterior'>Cycle to Exterior Airlock</A><BR>"}
			if(ACCESS_STATE_LOCKED)
				state_options = {"<A href='?src=\ref[src];command=cycle_interior'>Unlock Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_exterior'>Unlock Exterior Airlock</A><BR>"}
			if(ACCESS_STATE_EXTERNAL)
				state_options = {"<A href='?src=\ref[src];command=cycle_interior'>Cycle to Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_closed'>Lock Exterior Airlock</A><BR>"}

		var/output = {"<B>Access Control Console</B><HR>
[state_options]<HR>
<B>Exterior Door: </B> [exterior_status]<BR>
<B>Interior Door: </B> [interior_status]<BR>"}

		return output

obj/machinery/embedded_controller/radio/access_controller/virology
	name = "virology access controller"
	req_access = list(access_virology)
	id_tag = "virologyAirlock"
	exterior_door_tag = "virologyOuter"
	interior_door_tag = "virologyInner"

obj/machinery/embedded_controller/radio/access_controller/bridge1
	name = "bridge bccess controller"
	req_access = list(access_heads)
	id_tag = "bridge1Airlock"
	exterior_door_tag = "bridge1Outer"
	interior_door_tag = "bridge1Inner"

obj/machinery/embedded_controller/radio/access_controller/bridge2
	name = "bridge access controller"
	req_access = list(access_heads)
	id_tag = "bridge2Airlock"
	exterior_door_tag = "bridge2Outer"
	interior_door_tag = "bridge2Inner"

obj/machinery/embedded_controller/radio/access_controller/toxins
	name = "toxins access controller"
	req_access = list(access_tox_storage)
	id_tag = "toxinsAirlock"
	exterior_door_tag = "toxinsOuter"
	interior_door_tag = "toxinsInner"

obj/machinery/embedded_controller/radio/access_controller/xenobio
	name = "xenobiology access controller"
	req_access = list(access_xenobiology)
	id_tag = "xenobioAirlock"
	exterior_door_tag = "xenobioOuter"
	interior_door_tag = "xenobioInner"

obj/machinery/embedded_controller/radio/access_controller/reactor
	name = "reactor access controller"
	req_access = list(access_engine_equip)
	id_tag = "reactorAirlock"
	exterior_door_tag = "reactorOuter"
	interior_door_tag = "reactorInner"

obj/machinery/embedded_controller/radio/access_controller/atmos
	name = "atmospherics access controller"
	req_access = list(access_atmospherics)
	id_tag = "atmosAirlock"
	exterior_door_tag = "atmosOuter"
	interior_door_tag = "atmosInner"

obj/machinery/embedded_controller/radio/access_controller/telecomms
	name = "telecommunications access controller"
	req_access = list(access_tcomsat)
	id_tag = "telecommsAirlock"
	exterior_door_tag = "telecommsOuter"
	interior_door_tag = "telecommsInner"

obj/machinery/embedded_controller/radio/access_controller/researchServer
	name = "research server access controller"
	req_access = list(access_rd)
	id_tag = "researchServerAirlock"
	exterior_door_tag = "researchServerOuter"
	interior_door_tag = "researchServerInner"

obj/machinery/embedded_controller/radio/access_controller/brig
	name = "brig access controller"
	req_access = list(access_sec_doors)
	id_tag = "brigAirlock"
	exterior_door_tag = "brigOuter"
	interior_door_tag = "brigInner"