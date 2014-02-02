//States for airlock_control
var/const/AIRLOCK_STATE_INOPEN = -2
var/const/AIRLOCK_STATE_PRESSURIZE = -1
var/const/AIRLOCK_STATE_CLOSED = 0
var/const/AIRLOCK_STATE_DEPRESSURIZE = 1
var/const/AIRLOCK_STATE_OUTOPEN = 2
var/const/AIRLOCK_STATE_BOTHOPEN = 3

datum/computer/file/embedded_program/airlock_controller
	var/id_tag
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	var/sensor_tag_int
	var/sanitize_external

	state = AIRLOCK_STATE_CLOSED
	var/target_state = AIRLOCK_STATE_CLOSED
	var/sensor_pressure = null
	var/int_sensor_pressure = ONE_ATMOSPHERE

	receive_signal(datum/signal/signal, receive_method, receive_param)
		var/receive_tag = signal.data["tag"]
		if(!receive_tag)
			return

		if(receive_tag==sensor_tag)
			if(signal.data["pressure"])
				sensor_pressure = text2num(signal.data["pressure"])
		else if(receive_tag==sensor_tag_int)
			if(signal.data["pressure"])
				int_sensor_pressure = text2num(signal.data["pressure"])

		else if(receive_tag==exterior_door_tag)
			memory["exterior_status"] = signal.data["door_status"]
			if(signal.data["bumped_with_access"])
				target_state = AIRLOCK_STATE_OUTOPEN

		else if(receive_tag==interior_door_tag)
			memory["interior_status"] = signal.data["door_status"]
			if(signal.data["bumped_with_access"])
				target_state = AIRLOCK_STATE_INOPEN

		else if(receive_tag==airpump_tag)
			if(signal.data["power"])
				memory["pump_status"] = signal.data["direction"]
			else
				memory["pump_status"] = "off"

		else if(receive_tag==id_tag)
			switch(signal.data["command"])
				if("cycle_exterior")
					target_state = AIRLOCK_STATE_OUTOPEN
				if("cycle_interior")
					target_state = AIRLOCK_STATE_INOPEN
				if("cycle")
					if(state < AIRLOCK_STATE_CLOSED)
						target_state = AIRLOCK_STATE_OUTOPEN
					else
						target_state = AIRLOCK_STATE_INOPEN
				if("cycle_interior")
					target_state = AIRLOCK_STATE_INOPEN
				if("cycle_exterior")
					target_state = AIRLOCK_STATE_OUTOPEN

	receive_user_command(command)
		switch(command)
			if("cycle_closed")
				target_state = AIRLOCK_STATE_CLOSED
			if("cycle_exterior")
				target_state = AIRLOCK_STATE_OUTOPEN
			if("cycle_interior")
				target_state = AIRLOCK_STATE_INOPEN
			if("abort")
				target_state = AIRLOCK_STATE_CLOSED
			if("force_both")
				target_state = AIRLOCK_STATE_BOTHOPEN
				state = AIRLOCK_STATE_BOTHOPEN
				var/datum/signal/signal = new
				signal.data["tag"] = interior_door_tag
				signal.data["command"] = "secure_open"
				post_signal(signal)
				signal = new
				signal.data["tag"] = exterior_door_tag
				signal.data["command"] = "secure_open"
				post_signal(signal)
			if("force_exterior")
				target_state = AIRLOCK_STATE_OUTOPEN
				state = AIRLOCK_STATE_OUTOPEN
				var/datum/signal/signal = new
				signal.data["tag"] = exterior_door_tag
				signal.data["command"] = "secure_open"
				post_signal(signal)
			if("force_interior")
				target_state = AIRLOCK_STATE_INOPEN
				state = AIRLOCK_STATE_INOPEN
				var/datum/signal/signal = new
				signal.data["tag"] = interior_door_tag
				signal.data["command"] = "secure_open"
				post_signal(signal)
			if("close")
				target_state = AIRLOCK_STATE_CLOSED
				state = AIRLOCK_STATE_CLOSED
				var/datum/signal/signal = new
				signal.data["tag"] = exterior_door_tag
				signal.data["command"] = "secure_close"
				post_signal(signal)
				signal = new
				signal.data["tag"] = interior_door_tag
				signal.data["command"] = "secure_close"
				post_signal(signal)

	process()
		var/process_again = 1
		while(process_again)
			process_again = 0
			switch(state)
				if(AIRLOCK_STATE_INOPEN) // state -2
					if(target_state > state)
						if(memory["interior_status"] == "closed")
							state = AIRLOCK_STATE_CLOSED
							process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = interior_door_tag
							signal.data["command"] = "secure_close"
							post_signal(signal)
					else
						if(memory["pump_status"] != "off")
							var/datum/signal/signal = new
							signal.data = list(
								"tag" = airpump_tag,
								"power" = 0,
								"sigtype"="command"
							)
							post_signal(signal)

				if(AIRLOCK_STATE_PRESSURIZE)
					if(target_state < state)
						if(sensor_pressure >= int_sensor_pressure*0.95)
							if(memory["interior_status"] == "open")
								state = AIRLOCK_STATE_INOPEN
								process_again = 1
							else
								var/datum/signal/signal = new
								signal.data["tag"] = interior_door_tag
								signal.data["command"] = "secure_open"
								post_signal(signal)
						else
							var/datum/signal/signal = new
							signal.data = list(
								"tag" = airpump_tag,
								"sigtype"="command"
							)
							if(memory["pump_status"] == "siphon")
								signal.data["stabalize"] = 1
							else if(memory["pump_status"] != "release")
								signal.data["power"] = 1
							post_signal(signal)
					else if(target_state > state)
						state = AIRLOCK_STATE_CLOSED
						process_again = 1

				if(AIRLOCK_STATE_CLOSED)
					if(target_state > state)
						if(memory["interior_status"] == "closed")
							state = AIRLOCK_STATE_DEPRESSURIZE
							process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = interior_door_tag
							signal.data["command"] = "secure_close"
							post_signal(signal)
					else if(target_state < state)
						if(memory["exterior_status"] == "closed")
							state = AIRLOCK_STATE_PRESSURIZE
							process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = exterior_door_tag
							signal.data["command"] = "secure_close"
							post_signal(signal)

					else
						if(memory["pump_status"] != "off")
							var/datum/signal/signal = new
							signal.data = list(
								"tag" = airpump_tag,
								"power" = 0,
								"sigtype"="command"
							)
							post_signal(signal)

				if(AIRLOCK_STATE_DEPRESSURIZE)
					var/target_pressure = ONE_ATMOSPHERE*0.04
					if(sanitize_external)
						target_pressure = ONE_ATMOSPHERE*0.01

					if(sensor_pressure <= target_pressure)
						if(target_state > state)
							if(memory["exterior_status"] == "open")
								state = AIRLOCK_STATE_OUTOPEN
							else
								var/datum/signal/signal = new
								signal.data["tag"] = exterior_door_tag
								signal.data["command"] = "secure_open"
								post_signal(signal)
						else if(target_state < state)
							state = AIRLOCK_STATE_CLOSED
							process_again = 1
					else if((target_state < state) && !sanitize_external)
						state = AIRLOCK_STATE_CLOSED
						process_again = 1
					else
						var/datum/signal/signal = new
						signal.transmission_method = 1 //radio signal
						signal.data = list(
							"tag" = airpump_tag,
							"sigtype"="command"
						)
						if(memory["pump_status"] == "release")
							signal.data["purge"] = 1
						else if(memory["pump_status"] != "siphon")
							signal.data["power"] = 1
						post_signal(signal)

				if(AIRLOCK_STATE_OUTOPEN) //state 2
					if(target_state < state)
						if(memory["exterior_status"] == "closed")
							if(sanitize_external)
								state = AIRLOCK_STATE_DEPRESSURIZE
								process_again = 1
							else
								state = AIRLOCK_STATE_CLOSED
								process_again = 1
						else
							var/datum/signal/signal = new
							signal.data["tag"] = exterior_door_tag
							signal.data["command"] = "secure_close"
							post_signal(signal)
					else
						if(memory["pump_status"] != "off")
							var/datum/signal/signal = new
							signal.data = list(
								"tag" = airpump_tag,
								"power" = 0,
								"sigtype"="command"
							)
							post_signal(signal)

		memory["sensor_pressure"] = sensor_pressure
		memory["int_sensor_pressure"] = int_sensor_pressure
		memory["processing"] = state != target_state
		//sensor_pressure = null //not sure if we can comment this out. Uncomment in case of problems -rastaf0

		return 1


obj/machinery/embedded_controller/radio/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"

	name = "Airlock Console"
	density = 0
	unacidable = 1

	frequency = 1449
	power_channel = ENVIRON

	// Setup parameters only
	var/id_tag
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	var/sensor_tag_int
	var/sanitize_external

	initialize()
		..()

		var/datum/computer/file/embedded_program/airlock_controller/new_prog = new

		new_prog.id_tag = id_tag
		new_prog.exterior_door_tag = exterior_door_tag
		new_prog.interior_door_tag = interior_door_tag
		new_prog.airpump_tag = airpump_tag
		new_prog.sensor_tag = sensor_tag
		new_prog.sensor_tag_int = sensor_tag_int
		new_prog.sanitize_external = sanitize_external

		new_prog.master = src
		program = new_prog

	update_icon()
		if(on && program)
			if(program.memory["processing"])
				icon_state = "airlock_control_process"
			else
				icon_state = "airlock_control_standby"
		else
			icon_state = "airlock_control_off"


	return_text()
		var/state_options = null

		var/state = 0
		var/sensor_pressure = "----"
		var/int_sensor_pressure = "----"
		var/exterior_status = "----"
		var/interior_status = "----"
		var/pump_status = "----"
		if(program)
			state = program.state
			sensor_pressure = program.memory["sensor_pressure"]
			int_sensor_pressure = program.memory["int_sensor_pressure"]
			exterior_status = program.memory["exterior_status"]
			interior_status = program.memory["interior_status"]
			pump_status = program.memory["pump_status"]

		switch(state)
			if(AIRLOCK_STATE_INOPEN)
				state_options = {"<A href='?src=\ref[src];command=cycle_closed'>Close Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_exterior'>Cycle to Exterior Airlock</A><BR>"}
			if(AIRLOCK_STATE_PRESSURIZE)
				state_options = "<A href='?src=\ref[src];command=abort'>Abort Cycling</A><BR>"
			if(AIRLOCK_STATE_CLOSED)
				state_options = {"<A href='?src=\ref[src];command=cycle_interior'>Open Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_exterior'>Open Exterior Airlock</A><BR>"}
			if(AIRLOCK_STATE_DEPRESSURIZE)
				state_options = "<A href='?src=\ref[src];command=abort'>Abort Cycling</A><BR>"
			if(AIRLOCK_STATE_OUTOPEN)
				state_options = {"<A href='?src=\ref[src];command=cycle_interior'>Cycle to Interior Airlock</A><BR>
<A href='?src=\ref[src];command=cycle_closed'>Close Exterior Airlock</A><BR>"}
			if(AIRLOCK_STATE_BOTHOPEN)
				state_options = "<A href='?src=\ref[src];command=close'>Close Airlocks</A><BR>"

		var/output = {"<B>Airlock Control Console</B><HR>
[state_options]<HR>
<B>Chamber Pressure:</B> [sensor_pressure] kPa<BR>
<B>Internal Pressure:</B> [int_sensor_pressure] kPa<BR>
<B>Exterior Door: </B> [exterior_status]<BR>
<B>Interior Door: </B> [interior_status]<BR>
<B>Control Pump: </B> [pump_status]<BR>"}

		if(program && program.state == AIRLOCK_STATE_CLOSED)
			output += {"<A href='?src=\ref[src];command=force_both'>Force Both Airlocks</A><br>
	<A href='?src=\ref[src];command=force_interior'>Force Inner Airlock</A><br>
	<A href='?src=\ref[src];command=force_exterior'>Force Outer Airlock</A>"}

		return output

obj/machinery/embedded_controller/radio/airlock_controller/solar1
	name = "solar access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "solar1Airlock"
	exterior_door_tag = "solar1Outer"
	interior_door_tag = "solar1Inner"
	airpump_tag = "solar1Pump"
	sensor_tag = "solar1Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/solar2
	name = "solar access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "solar2Airlock"
	exterior_door_tag = "solar2Outer"
	interior_door_tag = "solar2Inner"
	airpump_tag = "solar2Pump"
	sensor_tag = "solar2Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/solar3
	name = "solar access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "solar3Airlock"
	exterior_door_tag = "solar3Outer"
	interior_door_tag = "solar3Inner"
	airpump_tag = "solar3Pump"
	sensor_tag = "solar3Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/solar4
	name = "solar access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "solar4Airlock"
	exterior_door_tag = "solar4Outer"
	interior_door_tag = "solar4Inner"
	airpump_tag = "solar4Pump"
	sensor_tag = "solar4Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/reactorExterior1
	name = "reactor exterior access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "reactorExterior1Airlock"
	exterior_door_tag = "reactorExterior1Outer"
	interior_door_tag = "reactorExterior1Inner"
	airpump_tag = "reactorExterior1Pump"
	sensor_tag = "reactorExterior1Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/reactorExterior2
	name = "reactor exterior access controller"
	req_access = list(access_engine_equip, access_external_airlocks)
	id_tag = "reactorExterior2Airlock"
	exterior_door_tag = "reactorExterior2Outer"
	interior_door_tag = "reactorExterior2Inner"
	airpump_tag = "reactorExterior2Pump"
	sensor_tag = "reactorExterior2Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/toxinsExterior
	name = "toxins exterior access controller"
	req_access = list(access_tox_storage, access_external_airlocks)
	id_tag = "toxinsExteriorAirlock"
	exterior_door_tag = "toxinsExteriorOuter"
	interior_door_tag = "toxinsExteriorInner"
	airpump_tag = "toxinsExteriorPump"
	sensor_tag = "toxinsExteriorSensor"

obj/machinery/embedded_controller/radio/airlock_controller/eva
	name = "eva access controller"
	req_access = list(access_eva, access_external_airlocks)
	id_tag = "evaAirlock"
	exterior_door_tag = "evaOuter"
	interior_door_tag = "evaInner"
	airpump_tag = "evaPump"
	sensor_tag = "evaSensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance1
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance1Airlock"
	exterior_door_tag = "maintenance1Outer"
	interior_door_tag = "maintenance1Inner"
	airpump_tag = "maintenance1Pump"
	sensor_tag = "maintenance1Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance2
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance2Airlock"
	exterior_door_tag = "maintenance2Outer"
	interior_door_tag = "maintenance2Inner"
	airpump_tag = "maintenance2Pump"
	sensor_tag = "maintenance2Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance3
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance3Airlock"
	exterior_door_tag = "maintenance3Outer"
	interior_door_tag = "maintenance3Inner"
	airpump_tag = "maintenance3Pump"
	sensor_tag = "maintenance3Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance4
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance4Airlock"
	exterior_door_tag = "maintenance4Outer"
	interior_door_tag = "maintenance4Inner"
	airpump_tag = "maintenance4Pump"
	sensor_tag = "maintenance4Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance5
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance5Airlock"
	exterior_door_tag = "maintenance5Outer"
	interior_door_tag = "maintenance5Inner"
	airpump_tag = "maintenance5Pump"
	sensor_tag = "maintenance5Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/maintenance6
	name = "maintenance access controller"
	req_access = list(access_maint_tunnels, access_external_airlocks)
	id_tag = "maintenance6Airlock"
	exterior_door_tag = "maintenance6Outer"
	interior_door_tag = "maintenance6Inner"
	airpump_tag = "maintenance6Pump"
	sensor_tag = "maintenance6Sensor"

obj/machinery/embedded_controller/radio/airlock_controller/blueStation
	name = "blue station access controller"
	req_access = list(ACCESS_SHUTTLE, access_external_airlocks)
	id_tag = "blueStationAirlock"
	exterior_door_tag = "blueStationOuter"
	interior_door_tag = "blueStationInner"
	airpump_tag = "blueStationPump"
	sensor_tag = "blueStationSensor"

obj/machinery/embedded_controller/radio/airlock_controller/purpleStation
	name = "purple station access controller"
	req_access = list(ACCESS_SHUTTLE, access_external_airlocks)
	id_tag = "purpleStationAirlock"
	exterior_door_tag = "purpleStationOuter"
	interior_door_tag = "purpleStationInner"
	airpump_tag = "purpleStationPump"
	sensor_tag = "purpleStationSensor"