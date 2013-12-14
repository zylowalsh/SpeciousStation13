//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/secure_data//TODO:SANITY
	var/const/MAIN_MENU = 1
	var/const/SELECTED_RECORD_MENU = 3
	var/const/SEARCH_RESULTS_MENU = 4

	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_one_access = list(access_security, access_forensics_lockers)
	circuit = "/obj/item/weapon/circuitboard/secure_data"
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/screen = null
	var/datum/record/activeRecord = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/perp
	var/tempName = null

	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

/obj/machinery/computer/secure_data/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/weapon/card/id) && !scan)
		usr.drop_item()
		O.loc = src
		scan = O
		user << "You insert [O]."
	..()

/obj/machinery/computer/secure_data/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/secure_data/attack_paw(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	var/dat

	if (temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='?src=\ref[src];choice=Clear Screen'>Clear Screen</A>"
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];choice=Confirm Identity'>[]</A><HR>", src, (scan ? scan.name : "----------"))
		if (authenticated)
			switch(screen)
				if(MAIN_MENU)
					dat += "<p style='text-align:center;'>"
					dat += "<A href='?src=\ref[src];choice=Search Records'>Search Records</A><BR>"
					dat += {"
						</p>
						<table style="text-align:center;" cellspacing="0" width="100%">
						<tr>
						<th>Records</th>
						</tr>
						</table>
						<TABLE style="text-align:center;" border="1" cellspacing="0" width="100%">
						<TR>
							<TH><A href='?src=\ref[src];choice=Sorting;sort=name'>Name</A></TH>
							<TH><A href='?src=\ref[src];choice=Sorting;sort=id'>ID</A></TH>
							<TH><A href='?src=\ref[src];choice=Sorting;sort=rank'>Rank</A></TH>
							<TH><A href='?src=\ref[src];choice=Sorting;sort=fingerprint'>Fingerprints</A></TH>
							<TH>Criminal Status</th>
						</TR>"}
					if(!isnull(dataCore.allRecords))
						for(var/datum/record/R in sortRecord(dataCore.allRecords, sortBy, order))
							var/crimStat = ""
							crimStat = R.criminal
							var/background
							switch(crimStat)
								if("*Arrest*")
									background = "'background-color:#DC143C;'"
								if("Incarcerated")
									background = "'background-color:#CD853F;'"
								if("Parolled")
									background = "'background-color:#CD853F;'"
								if("Released")
									background = "'background-color:#3BB9FF;'"
								if("None")
									background = "'background-color:#00FF7F;'"
							dat += {"
								<TR style=[background]>
									<TD><A href='?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.name]</A></TD>
									<TD>[R.id]</TD>
									<TD>[R.rank]</TD>
									<TD>[R.fingerprint]</TD>
									<TD>[crimStat]</TD>
								</TR>"}
						dat += "</TABLE><BR>"
					dat += "<A href='?src=\ref[src];choice=Log Out'>{Log Out}</A>"
				if(SELECTED_RECORD_MENU)
					dat += "<CENTER><B>Security Record</B></CENTER><BR>"
					var/icon/front = new(activeRecord.photo, dir = SOUTH)
					var/icon/side = new(activeRecord.photo, dir = WEST)
					user << browse_rsc(front, "front.png")
					user << browse_rsc(side, "side.png")
					dat += {"
						<TABLE WIDTH=100% BORDER=1 CELLPADDING=4 CELLSPACING=3 STYLE="page-break-before: always">
							<COL WIDTH=128*>
							<COL WIDTH=128*>
							<TR VALIGN=TOP>
								<TD ROWSPAN=4 WIDTH=40%><img src=front.png height=64 width=64 border=5><img src=side.png height=64 width=64 border=5></TD>
								<TD WIDTH=60%>Name: <A href='?src=\ref[src];choice=Edit Field;field=name'>[activeRecord.name]</A></TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>ID: [activeRecord.id]</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>Sex: <A href='?src=\ref[src];choice=Edit Field;field=sex'>[activeRecord.gender]</A></TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>Age: <A href='?src=\ref[src];choice=Edit Field;field=age'>[activeRecord.age]</A></TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Fingerprint: <A href='?src=\ref[src];choice=Edit Field;field=fingerprint'>[activeRecord.fingerprint]</A></TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Physical Status: [activeRecord.pStat]</TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Mental Status: [activeRecord.mStat]</TD>
							</TR>
						</TABLE>"}

					dat += {"
						<BR><CENTER><B>Security Data</B></CENTER><BR>
						Criminal Status: <A href='?src=\ref[src];choice=Edit Field;field=criminal'>[activeRecord.criminal]</A><BR><BR>
						Minor Crimes: <A href='?src=\ref[src];choice=Edit Field;field=mi_crim'>[activeRecord.minorCrimes]</A><BR>
						Details: <A href='?src=\ref[src];choice=Edit Field;field=mi_crim_d'>[activeRecord.minorCrimesDesc]</A><BR><BR>
						Major Crimes: <A href='?src=\ref[src];choice=Edit Field;field=ma_crim'>[activeRecord.majorCrimes]</A><BR>
						Details: <A href='?src=\ref[src];choice=Edit Field;field=ma_crim_d'>[activeRecord.majorCrimesDesc]</A><BR><BR>
						Important Notes:<BR><A href='?src=\ref[src];choice=Edit Field;field=notes'>[activeRecord.secNotes]</A><BR><BR>"}

					dat += "<A href='?src=\ref[src];choice=Print Record'>Print Record</A><BR>\n \
						<A href='?src=\ref[src];choice=Return'>Back</A><BR>"
				if(SEARCH_RESULTS_MENU)
					if(!perp.len)
						dat += "ERROR.  String could not be located.<br><br><A href='?src=\ref[src];choice=Return'>Back</A>"
					else
						dat += {"
							<table style="text-align:center;" cellspacing="0" width="100%">
							<tr>"}
						dat += "<th>Search Results for '[tempName]':</th>"
						dat += {"
							</tr>
							</table>
							<table style="text-align:center;" border="1" cellspacing="0" width="100%">
							<tr>
							<th>Name</th>
							<th>ID</th>
							<th>Rank</th>
							<th>Fingerprints</th>
							<th>Criminal Status</th>
							</tr>"}
						for(var/i = 1, i <= perp.len, i += 2)
							var/crimStat = ""
							var/datum/record/R = perp[i]
							if(istype(perp[i+1],/datum/record/))
								var/datum/record/E = perp[i+1]
								crimStat = E.criminal
							var/background
							switch(crimStat)
								if("*Arrest*")
									background = "'background-color:#DC143C;'"
								if("Incarcerated")
									background = "'background-color:#CD853F;'"
								if("Parolled")
									background = "'background-color:#CD853F;'"
								if("Released")
									background = "'background-color:#3BB9FF;'"
								if("None")
									background = "'background-color:#00FF7F;'"
								if("")
									background = "'background-color:#FFFFFF;'"
									crimStat = "No Record."
							dat += "<tr style=[background]><td><A href='?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.name]</a></td>"
							dat += "<td>[R.id]</td>"
							dat += "<td>[R.rank]</td>"
							dat += "<td>[R.fingerprint]</td>"
							dat += "<td>[crimStat]</td></tr>"
						dat += "</table><hr width='75%' />"
						dat += "<br><A href='?src=\ref[src];choice=Return'>Return to index.</A>"
		else
			dat += "<A href='?src=\ref[src];choice=Log In'>{Log In}</A>"
	user << browse("<HEAD><TITLE>Security Records</TITLE></HEAD><TT>[dat]</TT>", "window=secure_rec;size=600x400")
	onclose(user, "secure_rec")

/obj/machinery/computer/secure_data/Topic(href, href_list)
	if(..())
		return
	if (!dataCore.allRecords.Find(activeRecord))
		activeRecord = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = MAIN_MENU
				activeRecord = null

			if("Confirm Identity")
				if (scan)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						usr.put_in_hands(scan)
					else
						scan.loc = get_turf(src)
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						usr.drop_item()
						I.loc = src
						scan = I

			if("Log Out")
				authenticated = null
				screen = null
				activeRecord = null

			if("Log In")
				if (istype(usr, /mob/living/silicon/ai))
					src.activeRecord = null
					src.authenticated = usr.name
					src.screen = MAIN_MENU
				else if (istype(usr, /mob/living/silicon/robot))
					src.activeRecord = null
					src.authenticated = usr.name
					src.screen = MAIN_MENU
				else if (istype(scan, /obj/item/weapon/card/id))
					activeRecord = null
					if(check_access(scan))
						authenticated = scan.registered_name
						screen = MAIN_MENU
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Fingerprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || !in_range(src, usr)))
					return
				perp = new/list()
				t1 = lowertext(t1)
				var/list/components = text2list(t1, " ")
				if(components.len > 5)
					return //Lets not let them search too greedily.
				for(var/datum/record/R in dataCore.allRecords)
					var/temptext = R.name + " " + R.id + " " + R.fingerprint+ " " + R.rank
					for(var/i = 1, i <= components.len, i++)
						if(findtext(temptext, components[i]))
							var/prelist = new/list(2)
							prelist[1] = R
							perp += prelist
				for(var/i = 1, i <= perp.len, i+=2)
					for(var/datum/record/E in dataCore.allRecords)
						var/datum/record/R = perp[i]
						if ((E.name == R.name && E.id == R.id))
							perp[i+1] = E
				tempName = t1
				screen = SEARCH_RESULTS_MENU

			if ("Browse Record")
				var/datum/record/R = locate(href_list["d_rec"])
				if (!dataCore.allRecords.Find(R))
					temp = "Record Not Found!"
				else
					activeRecord = R
					screen = SELECTED_RECORD_MENU

			if ("Print Record")
				if (!printing)
					printing = TRUE
					var/tempInfo = "<CENTER><B>Security Record</B></CENTER><BR>"
					tempInfo += {"Name: [activeRecord.name] ID: [activeRecord.id]<BR>
						Sex: [activeRecord.gender]<BR>
						Age: [activeRecord.age]<BR>
						Fingerprint: [activeRecord.fingerprint]<BR>
						Physical Status: [activeRecord.pStat]<BR>
						Mental Status: [activeRecord.mStat]<BR>"}
					tempInfo += {"<BR><CENTER><B>Security Data</B></CENTER><BR>
						Criminal Status: [activeRecord.criminal]<BR><BR>
						Minor Crimes: [activeRecord.minorCrimes]<BR>
						Details: [activeRecord.minorCrimesDesc]<BR><BR>
						Major Crimes: [activeRecord.majorCrimes]<BR>
						Details: [activeRecord.majorCrimesDesc]<BR><BR>
						Important Notes:<BR>[activeRecord.secNotes]<BR>"}
					tempInfo += "</TT>"
					sleep(50)
					var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
					P.name = "paper - 'Security Record'"
					P.info = tempInfo
					printing = FALSE

//FIELD FUNCTIONS
			if ("Edit Field")
				var/tempRecord = activeRecord
				switch(href_list["field"])
					if("name")
						var/t1 = input("Please input name:", "Secure. records", activeRecord.name, null)  as text
						if ((!( t1 ) || !length(trim(t1)) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon)))) || activeRecord != tempRecord)
							return
						activeRecord.name = t1
					if("id")
						var/t1 = copytext(sanitize(input("Please input id:", "Secure. records", activeRecord.id, null)  as text), 1, MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.id = t1
					if("fingerprint")
						var/t1 = copytext(sanitize(input("Please input fingerprint hash:", "Secure. records", activeRecord.fingerprint, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.fingerprint = t1
					if("sex")
						if (activeRecord.gender == "Male")
							activeRecord.gender = "Female"
						else
							activeRecord.gender = "Male"
					if("age")
						var/t1 = input("Please input age:", "Secure. records", activeRecord.age, null)  as num
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.age = t1
					if("mi_crim")
						var/t1 = copytext(sanitize(input("Please input minor disabilities list:", "Secure. records", activeRecord.minorCrimes, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.minorCrimes = t1
					if("mi_crim_d")
						var/t1 = copytext(sanitize(input("Please summarize minor dis.:", "Secure. records", activeRecord.minorCrimesDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.minorCrimesDesc = t1
					if("ma_crim")
						var/t1 = copytext(sanitize(input("Please input major diabilities list:", "Secure. records", activeRecord.majorCrimes, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.majorCrimes = t1
					if("ma_crim_d")
						var/t1 = copytext(sanitize(input("Please summarize major dis.:", "Secure. records", activeRecord.majorCrimesDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.majorCrimesDesc = t1
					if("notes")
						var/t1 = copytext(sanitize(input("Please summarize notes:", "Secure. records", activeRecord.secNotes, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.secNotes = t1
					if("criminal")
						temp = "<h5>Criminal Status:</h5>"
						temp += "<ul>"
						temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=none'>None</a></li>"
						temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=arrest'>*Arrest*</a></li>"
						temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=incarcerated'>Incarcerated</a></li>"
						temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=parolled'>Parolled</a></li>"
						temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=released'>Released</a></li>"
						temp += "</ul>"
					if("species")
						var/t1 = copytext(sanitize(input("Please enter race:", "General records", activeRecord.species, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != tempRecord))
							return
						activeRecord.species = t1

//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp = null
				switch(href_list["choice"])
					if ("Change Criminal Status")
						if (activeRecord)
							switch(href_list["criminal2"])
								if("none")
									activeRecord.criminal = "None"
								if("arrest")
									activeRecord.criminal = "*Arrest*"
								if("incarcerated")
									activeRecord.criminal = "Incarcerated"
								if("parolled")
									activeRecord.criminal = "Parolled"
								if("released")
									activeRecord.criminal = "Released"

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/secure_data/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/record/R in dataCore.allRecords)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.name = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					R.gender	= pick("Male", "Female")
				if(3)
					R.age = rand(5, 85)
				if(4)
					R.criminal = pick("None", "*Arrest*", "Incarcerated", "Parolled", "Released")
				if(5)
					R.pStat = pick("*Unconcious*", "Active", "Physically Unfit")
				if(6)
					R.mStat = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			del(R)
			continue

	..(severity)

/obj/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/computer.dmi'
	icon_state = "messyfiles"
