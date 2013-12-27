// shuttleState Flags
var/const/IDLE_AT_CENTCOM = 0
var/const/PREPARING_TO_LAUNCH = 1
var/const/GOING_TO_STATION = 2
var/const/AT_STATION = 3
var/const/RETURNING_FROM_STATION = 4
var/const/RETURNED_FROM_STATION = 5
var/const/SHUTTLE_CANCELED = 6

// evacType Flags
var/const/EMERGENCY = 0
var/const/CREW_CYCLE = 1

var/const/SHUTTLE_TESTING = FALSE

var/datum/shuttle_controller/emergencyShuttle

datum/shuttle_controller

	var/const/SHUTTLE_BASE_PREP_TIME = 480
	var/const/SHUTTLE_BASE_DOCKED_TIME = 180
	var/const/SHUTTLE_BASE_TRANSIT_TIME = 120
	var/const/SHUTTLE_BASE_CANCEL_COOLDOWN = 900
	var/const/SHUTTLE_TESTING_TIME = 15

	var/evacType = EMERGENCY //0 = emergency, 1 = crew cycle

	var/online = FALSE
	var/shuttleState = IDLE_AT_CENTCOM
	var/timeStateChanged
	var/launchEarly = FALSE

	var/timeToFakeRecall = 0 //Used in rounds to prevent "ON NOES, IT MUST [INSERT ROUND] BECAUSE SHUTTLE CAN'T BE CALLED"
	var/denyShuttle = FALSE //for admins not allowing it to be called.

datum/shuttle_controller/proc/callShuttle(typeOfEvac = EMERGENCY, autoRecall = FALSE, forceCall = FALSE)
	evacType = typeOfEvac

	if(shuttleState != IDLE_AT_CENTCOM)
		return

	if(!forceCall)

		if(denyShuttle)
			return

		if(!ticker.mode.canShuttleBeCalled)
			return

		if(ticker.mode.shuttleFakedCalled || autoRecall)
			timeToFakeRecall = rand(SHUTTLE_BASE_PREP_TIME / 10, SHUTTLE_BASE_PREP_TIME / 2)

	timeStateChanged = world.timeofday
	online = TRUE

	//Turning the alert lights on in the hallways
	if(evacType == EMERGENCY)
		for(var/area/A in world)
			if(istype(A, /area/hallway))
				A.readyalert()

datum/shuttle_controller/proc/recall()
	if(shuttleState == PREPARING_TO_LAUNCH)
		if(!ticker.mode.canShuttleBeRecalled)
			return

		if(evacType == EMERGENCY)
			captain_announce("The request for an emergency shuttle has been canceled.")
			world << sound('sound/AI/shuttlerecalled.ogg')

			for(var/area/A in world)
				if(istype(A, /area/hallway))
					A.readyreset()
		else //Makes it possible for an admin stop the shuttle to be launched.
			captain_announce("The request for a crew switch shuttle has been canceled.")

		shuttleState = SHUTTLE_CANCELED
		timeStateChanged = world.timeofday

datum/shuttle_controller/proc/getTimeLeft()
	if(online)
		var/timeDiff = round((world.timeofday - timeStateChanged) / 10, 1)
		var/returnedNum = 0
		if(SHUTTLE_TESTING)
			switch(shuttleState)
				if(PREPARING_TO_LAUNCH)
					returnedNum = SHUTTLE_TESTING_TIME - timeDiff
				if(GOING_TO_STATION)
					returnedNum = SHUTTLE_TESTING_TIME - timeDiff
				if(AT_STATION)
					returnedNum = SHUTTLE_TESTING_TIME - timeDiff
				if(RETURNING_FROM_STATION)
					returnedNum = SHUTTLE_TESTING_TIME - timeDiff
				if(SHUTTLE_CANCELED)
					returnedNum = SHUTTLE_TESTING_TIME - timeDiff
		else
			switch(shuttleState)
				if(PREPARING_TO_LAUNCH)
					returnedNum = SHUTTLE_BASE_PREP_TIME - timeDiff
				if(GOING_TO_STATION)
					returnedNum = SHUTTLE_BASE_TRANSIT_TIME - timeDiff
				if(AT_STATION)
					returnedNum = SHUTTLE_BASE_DOCKED_TIME - timeDiff
				if(RETURNING_FROM_STATION)
					returnedNum = SHUTTLE_BASE_TRANSIT_TIME - timeDiff
				if(SHUTTLE_CANCELED)
					returnedNum = SHUTTLE_BASE_CANCEL_COOLDOWN - timeDiff
		return returnedNum
	else
		return SHUTTLE_BASE_PREP_TIME

datum/shuttle_controller/proc/process()
	if(!online)
		return 0
	var/timeLeft = getTimeLeft()
	if(timeLeft > 1e5)		// midnight rollover protection
		timeLeft = 0
	switch(shuttleState)
		if(IDLE_AT_CENTCOM)
			shuttleState = PREPARING_TO_LAUNCH
			timeStateChanged = world.timeofday

			if(evacType == EMERGENCY)
				captain_announce("The emergency shuttle has been called. It is preparing to leave [HEADQUARTERS_NAME] in [round(SHUTTLE_BASE_PREP_TIME / 60, 1)] minutes.")
				world << sound('sound/AI/shuttlecalled.ogg')
			else if(evacType == CREW_CYCLE)
				captain_announce("A crew transfer has been initiated. The shuttle has been called. It will arrive in [round(SHUTTLE_BASE_PREP_TIME / 60, 1)] minutes.")

			return 1

		if(PREPARING_TO_LAUNCH)
			if((timeToFakeRecall != 0) && (timeLeft <= timeToFakeRecall))
				recall()
				return 0

			if(timeLeft <= 0)
				shuttleState = GOING_TO_STATION
				timeStateChanged = world.timeofday

				captain_announce("The emergency shuttle has left [HEADQUARTERS_NAME]. Estimate [round(SHUTTLE_BASE_TRANSIT_TIME / 60, 1)] minutes until the shuttle docks at station.")
				return 1

		if(GOING_TO_STATION)
			if(timeLeft <= 0)
				shuttleState = AT_STATION
				timeStateChanged = world.timeofday
				captain_announce("The emergency shuttle has docked with the station. You have [round(SHUTTLE_BASE_DOCKED_TIME / 60, 1)] minutes to board.")
				world << sound('sound/AI/shuttledock.ogg')

				var/area/startLocation = locate(/area/shuttle/escape/centcom)
				var/area/endLocation = locate(/area/shuttle/escape/station)

				var/list/dstturfs = list()
				var/throwy = world.maxy

				for(var/turf/T in endLocation)
					dstturfs += T
					if(T.y < throwy)
						throwy = T.y

				//Clearing out where the shuttle will be
				for(var/turf/T in dstturfs)
					// find the turf to move things to
					var/turf/D = locate(T.x, throwy - 1, 1)
					//var/turf/E = get_step(D, SOUTH)
					for(var/atom/movable/AM as mob|obj in T)
						AM.Move(D)

					if(istype(T, /turf/simulated))
						del(T)

				for(var/mob/living/carbon/bug in endLocation) // If someone somehow is still in the shuttle's docking area...
					bug.gib()

				for(var/mob/living/simple_animal/pest in endLocation) // And for the other kind of bug...
					pest.gib()

				startLocation.move_contents_to(endLocation)
				return 1

		if(AT_STATION)
			if(launchEarly)
				launchEarly = FALSE
				timeStateChanged = world.timeofday - ((SHUTTLE_BASE_DOCKED_TIME * 10) - 100)
			if(timeLeft < 3)
				var/area/startLocation[0]

				startLocation.Add(locate(/area/shuttle/escape/station))
				startLocation.Add(locate(/area/shuttle/escape_pod1/station))
				startLocation.Add(locate(/area/shuttle/escape_pod2/station))
				startLocation.Add(locate(/area/shuttle/escape_pod3/station))
				startLocation.Add(locate(/area/shuttle/escape_pod4/station))
				startLocation.Add(locate(/area/shuttle/escape_pod5/station))

				var/area/endLocation[0]

				endLocation.Add(locate(/area/shuttle/escape/transit))
				endLocation.Add(locate(/area/shuttle/escape_pod1/transit))
				endLocation.Add(locate(/area/shuttle/escape_pod2/transit))
				endLocation.Add(locate(/area/shuttle/escape_pod3/transit))
				endLocation.Add(locate(/area/shuttle/escape_pod4/transit))
				endLocation.Add(locate(/area/shuttle/escape_pod5/transit))

				var/transitDirection[0]

				transitDirection.Add(NORTH)
				transitDirection.Add(NORTH)
				transitDirection.Add(NORTH)
				transitDirection.Add(EAST)
				transitDirection.Add(EAST)
				transitDirection.Add(EAST)

				//Closing doors
				if(timeLeft > 0 && timeLeft < 3)
					for(var/i = 1, i <= startLocation.len, i++)
						for(var/obj/machinery/door/unpowered/shuttle/D in startLocation[i])
							spawn(0)
								D.close()
								D.locked = 1
				else if(timeLeft > 0)
					return 0
				else
					shuttleState = RETURNING_FROM_STATION
					timeStateChanged = world.timeofday
					captain_announce("The emergency shuttle has left the station. Estimate [round(SHUTTLE_BASE_TRANSIT_TIME / 60, 1)] minutes until the shuttle docks at [HEADQUARTERS_NAME].")

					var/area/tmpLocation
					for(var/i = 1, i <= startLocation.len, i++)
						tmpLocation = startLocation[i]
						tmpLocation.move_contents_to(endLocation[i], null, transitDirection[i])

					for(var/i = 1, i <= endLocation.len, i++)
						for(var/mob/M in endLocation[i])
							if(M.client)
								spawn(0)
									if(M.buckled)
										shake_camera(M, 4, 1)
									else
										shake_camera(M, 10, 2)
							if(istype(M, /mob/living/carbon))
								if(!M.buckled)
									M.Weaken(5)
				return 1

		if(RETURNING_FROM_STATION)
			if(timeLeft >= 0)
				return 0
			else
				shuttleState = RETURNED_FROM_STATION
				timeStateChanged = 0
				online = FALSE

				var/area/startLocation[0]

				startLocation.Add(locate(/area/shuttle/escape/transit))
				startLocation.Add(locate(/area/shuttle/escape_pod1/transit))
				startLocation.Add(locate(/area/shuttle/escape_pod2/transit))
				startLocation.Add(locate(/area/shuttle/escape_pod3/transit))
				startLocation.Add(locate(/area/shuttle/escape_pod4/transit))
				startLocation.Add(locate(/area/shuttle/escape_pod5/transit))

				var/area/endLocation[0]

				endLocation.Add(locate(/area/shuttle/escape/centcom))
				endLocation.Add(locate(/area/shuttle/escape_pod1/centcom))
				endLocation.Add(locate(/area/shuttle/escape_pod2/centcom))
				endLocation.Add(locate(/area/shuttle/escape_pod3/centcom))
				endLocation.Add(locate(/area/shuttle/escape_pod4/centcom))
				endLocation.Add(locate(/area/shuttle/escape_pod5/centcom))

				var/transitDirection[0]

				transitDirection.Add(NORTH)
				transitDirection.Add(NORTH)
				transitDirection.Add(NORTH)
				transitDirection.Add(EAST)
				transitDirection.Add(EAST)
				transitDirection.Add(EAST)

				var/area/tmpLocation
				for(var/i = 1, i <= startLocation.len, i++)
					tmpLocation = startLocation[i]
					tmpLocation.move_contents_to(endLocation[i], null, transitDirection[i])

				for(var/i = 1, i <= endLocation.len, i++)
					for(var/obj/machinery/door/unpowered/shuttle/D in endLocation[i])
						spawn(0)
							D.locked = 0
							D.open()

				for(var/i = 1, i <= endLocation.len, i++)
					for(var/mob/M in endLocation[i])
						if(M.client)
							spawn(0)
								if(M.buckled)
									shake_camera(M, 4, 1)
								else
									shake_camera(M, 10, 2)
						if(istype(M, /mob/living/carbon))
							if(!M.buckled)
								M.Weaken(5)
				return 1

		if(RETURNED_FROM_STATION)

		if(SHUTTLE_CANCELED)
			if(timeLeft >= 0)
				return 0
			else
				shuttleState = IDLE_AT_CENTCOM
				online = FALSE
				timeStateChanged = 0



