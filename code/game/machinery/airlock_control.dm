var/const/AIRLOCK_CONTROL_RANGE = 5

// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
obj/machinery/door/airlock
	var/id_tag
	var/frequency
	var/shockedby = list()
	var/datum/radio_frequency/radio_connection
	explosion_resistance = 15


obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	switch(signal.data["command"])
		if("open")
			open(1)

		if("close")
			close(1)

		if("unlock")
			locked = 0
			update_icon()

		if("lock")
			locked = 1
			update_icon()

		if("secure_open")
			locked = 0
			update_icon()

			sleep(2)
			open(1)

			locked = 1
			update_icon()

		if("secure_close")
			locked = 0
			close(1)

			locked = 1
			sleep(2)
			update_icon()

	send_status()


obj/machinery/door/airlock/proc/send_status()
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density?("closed"):("open")
		signal.data["lock_status"] = locked?("locked"):("unlocked")

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)


obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


obj/machinery/door/airlock/Bumped(atom/AM)
	..(AM)
	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density && radio_connection && mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time

			signal.data["door_status"] = density?("closed"):("open")
			signal.data["lock_status"] = locked?("locked"):("unlocked")

			signal.data["bumped_with_access"] = 1

			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	return

obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


obj/machinery/door/airlock/initialize()
	if(frequency)
		set_frequency(frequency)

	update_icon()


obj/machinery/door/airlock/New()
	..()

	if(radio_controller)
		set_frequency(frequency)

obj/machinery/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"

	anchored = 1
	power_channel = ENVIRON

	var/id_tag
	var/master_tag
	var/frequency = 1449

	var/datum/radio_frequency/radio_connection

	var/on = 1
	var/alert = 0


obj/machinery/airlock_sensor/update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

obj/machinery/airlock_sensor/attack_hand(mob/user)
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.data["tag"] = master_tag
	signal.data["command"] = "cycle"

	radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("airlock_sensor_cycle", src)

obj/machinery/airlock_sensor/process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()

		var/pressure = round(air_sample.return_pressure(),0.1)
		alert = (pressure < ONE_ATMOSPHERE*0.8)

		signal.data["pressure"] = num2text(pressure)

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)

	update_icon()

obj/machinery/airlock_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)

obj/machinery/airlock_sensor/initialize()
	set_frequency(frequency)

obj/machinery/airlock_sensor/New()
	..()

	if(radio_controller)
		set_frequency(frequency)

obj/machinery/access_button
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	name = "access button"

	anchored = 1
	power_channel = ENVIRON

	var/master_tag
	var/frequency = 1449
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1


obj/machinery/access_button/update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"


obj/machinery/access_button/attack_hand(mob/user)
	add_fingerprint(usr)
	if(!allowed(user))
		user << "\red Access Denied"

	else if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = master_tag
		signal.data["command"] = command

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("access_button_cycle", src)


obj/machinery/access_button/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


obj/machinery/access_button/initialize()
	set_frequency(frequency)


obj/machinery/access_button/New()
	..()

	if(radio_controller)
		set_frequency(frequency)

// PRESETS

// Simple Airlocks
obj/machinery/access_button/virology
	master_tag = "virologyAirlock"
	req_access = list(ACCESS_VIROLOGY)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/bridge1
	master_tag = "bridge1Airlock"
	req_access = list(ACCESS_HEADS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/bridge2
	master_tag = "bridge2Airlock"
	req_access = list(ACCESS_HEADS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/toxins
	master_tag = "toxinsAirlock"
	req_access = list(ACCESS_TOXIN_STORAGE)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/xenobio
	master_tag = "xenobioAirlock"
	req_access = list(ACCESS_XENOBIOLOGY)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/reactor
	master_tag = "reactorAirlock"
	req_access = list(ACCESS_ENGINE_EQUIP)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/atmos
	master_tag = "atmosAirlock"
	req_access = list(ACCESS_ATMOSPHERICS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/telecomms
	master_tag = "telecommsAirlock"
	req_access = list(ACCESS_TCOMSAT)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/researchServer
	master_tag = "researchServerAirlock"
	req_access = list(ACCESS_RD)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/brig
	master_tag = "brigAirlock"
	req_access = list(ACCESS_SEC_DOORS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

// Exterior Airlocks
obj/machinery/access_button/solar1
	master_tag = "solar1Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/solar2
	master_tag = "solar2Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/solar3
	master_tag = "solar3Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/solar4
	master_tag = "solar4Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/reactorExterior1
	master_tag = "reactorExterior1Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/reactorExterior2
	master_tag = "reactorExterior2Airlock"
	req_access = list(ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/toxinsExterior
	master_tag = "toxinsExteriorAirlock"
	req_access = list(ACCESS_TOXIN_STORAGE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/eva
	master_tag = "evaAirlock"
	req_access = list(ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance1
	master_tag = "maintenance1Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance2
	master_tag = "maintenance2Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance3
	master_tag = "maintenance3Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance4
	master_tag = "maintenance4Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance5
	master_tag = "maintenance5Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/maintenance6
	master_tag = "maintenance6Airlock"
	req_access = list(ACCESS_MAINTENANCE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/blueStation
	master_tag = "blueStationAirlock"
	req_access = list(ACCESS_SHUTTLE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/access_button/purpleStation
	master_tag = "purpleStationAirlock"
	req_access = list(ACCESS_SHUTTLE, ACCESS_EXTERNAL_AIRLOCKS)
	exterior
		command = "cycle_exterior"
	inner
		command = "cycle_interior"

obj/machinery/airlock_sensor/solar1
	id_tag = "solar1Sensor"

obj/machinery/airlock_sensor/solar2
	id_tag = "solar2Sensor"

obj/machinery/airlock_sensor/solar3
	id_tag = "solar3Sensor"

obj/machinery/airlock_sensor/solar4
	id_tag = "solar4Sensor"

obj/machinery/airlock_sensor/reactorExterior1
	id_tag = "reactorExterior1Sensor"

obj/machinery/airlock_sensor/reactorExterior2
	id_tag = "reactorExterior2Sensor"

obj/machinery/airlock_sensor/toxinsExterior
	id_tag = "toxinsExteriorSensor"

obj/machinery/airlock_sensor/eva
	id_tag = "evaSensor"

obj/machinery/airlock_sensor/maintenance1
	id_tag = "maintenance1Sensor"

obj/machinery/airlock_sensor/maintenance2
	id_tag = "maintenance2Sensor"

obj/machinery/airlock_sensor/maintenance3
	id_tag = "maintenance3Sensor"

obj/machinery/airlock_sensor/maintenance4
	id_tag = "maintenance4Sensor"

obj/machinery/airlock_sensor/maintenance5
	id_tag = "maintenance5Sensor"

obj/machinery/airlock_sensor/maintenance6
	id_tag = "maintenance6Sensor"

obj/machinery/airlock_sensor/blueStation
	id_tag = "blueStationSensor"

obj/machinery/airlock_sensor/purpleStation
	id_tag = "purpleStationSensor"