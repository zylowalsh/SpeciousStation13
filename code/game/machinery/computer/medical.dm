//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/med_data
	var/const/MAIN_MENU = 1
	var/const/SEARCH_RESULTS_MENU = 3
	var/const/SELECTED_RECORD_MENU = 4
	var/const/VIRUS_DB_MENU = 5
	var/const/MEDICAL_ROBOT_MENU = 6

	name = "Medical Records"
	desc = "This can be used to check medical records."
	icon_state = "medcomp"
	req_one_access = list(access_medical, access_forensics_lockers)
	circuit = "/obj/item/weapon/circuitboard/med_data"
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/screen = null
	var/datum/record/activeRecord = null
	var/temp = null
	var/printing = null

	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

/obj/machinery/computer/med_data/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/med_data/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/med_data/attack_hand(mob/user as mob)
	if(..())
		return
	var/dat
	if (temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>"
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];scan=1'>[]</A><HR>", src, (src.scan ? text("[]", src.scan.name) : "----------"))

		if (authenticated)
			switch(screen)
				if(MAIN_MENU)
					dat += "<CENTER><A href='?src=\ref[src];search=1'>Search Records</A></CENTER><BR>"

					dat += {"
						<TABLE style="text-align:center;" border="1" cellspacing="0" width="100%">
							<TR>
								<TH><A href='?src=\ref[src];sort=name'>Name</A></TH>
								<TH><A href='?src=\ref[src];sort=id'>ID</A></TH>
								<TH><A href='?src=\ref[src];sort=rank'>Rank</A></TH>
								<TH>Physical Status</TH>
								<TH>Mental Status</TH>
							</TR>"}
					if(!isnull(dataCore.allRecords))
						for(var/datum/record/R in sortRecord(dataCore.allRecords, sortBy, order))
							var/pStat = ""
							pStat = R.pStat
							var/background
							switch(pStat)
								if("Active")
									background = "'background-color:#00FF7F;'"
								if("*SSD*")
									background = "'background-color:#3BB9FF;'"
								if("*Deceased*")
									background = "'background-color:#666666;'"
								if("Physically Unfit")
									background = "'background-color:#CD853F;'"
								if("Disabled")
									background = "'background-color:#CD853F;'"
							dat += {"
								<TR style=[background]>
									<TD><A href='?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.name]</A></TD>
									<TD>[R.id]</TD>
									<TD>[R.rank]</TD>
									<TD>[pStat]</TD>
									<TD>[R.mStat]</TD>
								</TR>"}
						dat += "</TABLE><BR>"
					dat += {"
						<A href='?src=\ref[src];screen=5'>Virus Database</A><BR>
						<A href='?src=\ref[src];screen=6'>Medbot Tracking</A><BR>
						<BR>
						<A href='?src=\ref[src];logout=1'>{Log Out}</A><BR>"}

				if(SELECTED_RECORD_MENU)
					var/icon/front = new(activeRecord.photo, dir = SOUTH)
					var/icon/side = new(activeRecord.photo, dir = WEST)
					user << browse_rsc(front, "front.png")
					user << browse_rsc(side, "side.png")
					dat += "<CENTER><B>Medical Record</B></CENTER><BR>"
					dat += {"
						<TABLE WIDTH=100% BORDER=1 CELLPADDING=4 CELLSPACING=3 STYLE="page-break-before: always">
							<COL WIDTH=128*>
							<COL WIDTH=128*>
							<TR VALIGN=TOP>
								<TD ROWSPAN=4 WIDTH=40%><img src=front.png height=64 width=64 border=5><img src=side.png height=64 width=64 border=5></TD>
								<TD WIDTH=60%>Name: [activeRecord.name]</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>ID: [activeRecord.id]</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>Sex: <A href='?src=\ref[src];field=sex'>[activeRecord.gender]</A></TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>Age: <A href='?src=\ref[src];field=age'>[activeRecord.age]</A></TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Fingerprint: <A href='?src=\ref[src];field=fingerprint'>[activeRecord.fingerprint]</A></TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Physical Status: <A href='?src=\ref[src];field=p_stat'>[activeRecord.pStat]</A></TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>Mental Status: <A href='?src=\ref[src];field=m_stat'>[activeRecord.mStat]</A></TD>
							</TR>
						</TABLE>"}
					dat += {"
						<BR><CENTER><B>Medical Data</B></CENTER><BR>
						Blood Type: <A href='?src=\ref[src];field=b_type'>[activeRecord.bType]</A><BR>
						DNA: <A href='?src=\ref[src];field=b_dna'>[activeRecord.bDNA]</A><BR><BR>
						Minor Disabilities: <A href='?src=\ref[src];field=mi_dis'>[activeRecord.minorDisability]</A><BR>
						Details: <A href='?src=\ref[src];field=mi_dis_d'>[activeRecord.minorDisabilityDesc]</A><BR><BR>
						Major Disabilities: <A href='?src=\ref[src];field=ma_dis'>[activeRecord.majorDisability]</A><BR>
						Details: <A href='?src=\ref[src];field=ma_dis_d'>[activeRecord.majorDisabilityDesc]</A><BR><BR>
						Allergies: <A href='?src=\ref[src];field=alg'>[activeRecord.allergies]</A><BR>
						Details: <A href='?src=\ref[src];field=alg_d'>[activeRecord.allergiesDesc]</A><BR><BR>
						Current Diseases: <A href='?src=\ref[src];field=cdi'>[activeRecord.cdi]</A> (per disease info placed in log/comment section)<BR>
						Details: <A href='?src=\ref[src];field=cdi_d'>[activeRecord.cdiDesc]</A><BR><BR>
						Important Notes:<BR>\n\t<A href='?src=\ref[src];field=notes'>[activeRecord.medNotes]</A><BR><BR>"}
					dat += "<A href='?src=\ref[src];print_p=1'>Print Record</A><BR><A href='?src=\ref[src];return=1'>Back</A><BR>"
				if(VIRUS_DB_MENU)
					dat += "<CENTER><B>Virus Database</B></CENTER>"
					for(var/Dt in typesof(/datum/disease/))
						var/datum/disease/Dis = new Dt(0)
						if(istype(Dis, /datum/disease/advance))
							continue
						if(!Dis.desc)
							continue
						dat += "<br><a href='?src=\ref[src];vir=[Dt]'>[Dis.name]</a>"

					dat += "<br><a href='?src=\ref[src];screen=1'>Back</a>"
				if(MEDICAL_ROBOT_MENU)
					dat += "<center><b>Medical Robot Monitor</b></center>"
					dat += "<a href='?src=\ref[src];screen=1'>Back</a>"
					dat += "<br><b>Medical Robots:</b>"
					var/bdat = null
					for(var/obj/machinery/bot/medbot/M in world)

						if(M.z != src.z)
							continue	//only find medibots on the same z-level as the computer
						var/turf/bl = get_turf(M)
						if(bl)	//if it can't find a turf for the medibot, then it probably shouldn't be showing up
							bdat += "[M.name] - <b>\[[bl.x],[bl.y]\]</b> - [M.on ? "Online" : "Offline"]<br>"
							if((!isnull(M.reagent_glass)) && M.use_beaker)
								bdat += "Reservoir: \[[M.reagent_glass.reagents.total_volume]/[M.reagent_glass.reagents.maximum_volume]\]<br>"
							else
								bdat += "Using Internal Synthesizer.<br>"
					if(!bdat)
						dat += "<br><center>None detected</center>"
					else
						dat += "<br>[bdat]"
		else
			dat += "<A href='?src=\ref[src];login=1'>{Log In}</A>"
	user << browse("<HEAD><TITLE>Medical Records</TITLE></HEAD><TT>[dat]</TT>", "window=med_rec")
	onclose(user, "med_rec")

/obj/machinery/computer/med_data/Topic(href, href_list)
	if(..())
		return

	if (!dataCore.allRecords.Find(activeRecord))
		activeRecord = null

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if (href_list["temp"])
			temp = null

		if (href_list["scan"])
			if (scan)
				if(ishuman(usr))
					scan.loc = usr.loc

					if(!usr.get_active_hand())
						usr.put_in_hands(scan)

					scan = null

				else
					scan.loc = src.loc
					scan = null

			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					scan = I

		else if (href_list["logout"])
			authenticated = null
			screen = null
			activeRecord = null

		else if (href_list["login"])

			if (istype(usr, /mob/living/silicon/ai))
				activeRecord = null
				authenticated = usr.name
				screen = MAIN_MENU

			else if (istype(usr, /mob/living/silicon/robot))
				activeRecord = null
				authenticated = usr.name
				screen = MAIN_MENU

			else if (istype(src.scan, /obj/item/weapon/card/id))
				activeRecord = null

				if (src.check_access(scan))
					authenticated = scan.registered_name
					screen = MAIN_MENU

		if (authenticated)

			if(href_list["screen"])
				screen = text2num(href_list["screen"])
				if(screen < MAIN_MENU)
					src.screen = MAIN_MENU

				activeRecord= null

			if(href_list["return"])
				screen = MAIN_MENU
				activeRecord = null

			if(href_list["sort"])
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
					sortBy = href_list["sort"]
					order = initial(order)

			if(href_list["vir"])
				var/type = href_list["vir"]
				var/datum/disease/Dis = new type(0)
				var/AfS = ""
				for(var/Str in Dis.affected_species)
					AfS += " [Str];"
				src.temp = {"
					<b>Name:</b> [Dis.name]<BR>
					<b>Number of stages:</b> [Dis.max_stages]<BR>
					<b>Spread:</b> [Dis.spread] Transmission<BR>
					<b>Possible Cure:</b> [(Dis.cure||"none")]<BR>
					<b>Affected Species:</b>[AfS]<BR><BR>
					<b>Notes:</b> [Dis.desc]<BR><BR>
					<b>Severity:</b> [Dis.severity]"}

			if (href_list["field"])
				var/datum/record/tmpRecord = activeRecord
				switch(href_list["field"])
					if("fingerprint")
						var/userInput = copytext(sanitize(input("Please input fingerprint hash:", "Med. records", tmpRecord.fingerprint, null)  as text), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.fingerprint = userInput
					if("sex")
						if (tmpRecord.gender == "Male")
							tmpRecord.gender = "Female"
						else
							tmpRecord.gender = "Male"
					if("age")
						var/userInput = input("Please input age:", "Med. records", tmpRecord.age, null)  as num
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.age = userInput
					if("mi_dis")
						var/userInput = copytext(sanitize(input("Please input minor disabilities list:", "Med. records", tmpRecord.minorDisability, null)  as text), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.minorDisability = userInput
					if("mi_dis_d")
						var/userInput = copytext(sanitize(input("Please summarize minor dis.:", "Med. records", tmpRecord.minorDisabilityDesc, null)  as message), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.minorDisabilityDesc = userInput
					if("ma_dis")
						var/userInput = copytext(sanitize(input("Please input major diabilities list:", "Med. records", tmpRecord.majorDisability, null)  as text), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.majorDisability = userInput
					if("ma_dis_d")
						var/userInput = copytext(sanitize(input("Please summarize major dis.:", "Med. records", tmpRecord.majorDisabilityDesc, null)  as message), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.majorDisabilityDesc = userInput
					if("alg")
						var/userInput = copytext(sanitize(input("Please state allergies:", "Med. records", tmpRecord.allergies, null)  as text), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.allergies = userInput
					if("alg_d")
						var/userInput = copytext(sanitize(input("Please summarize allergies:", "Med. records", tmpRecord.allergiesDesc, null)  as message), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.allergiesDesc = userInput
					if("cdi")
						var/userInput = copytext(sanitize(input("Please state diseases:", "Med. records", tmpRecord.cdi, null)  as text), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.cdi = userInput
					if("cdi_d")
						var/userInput = copytext(sanitize(input("Please summarize diseases:", "Med. records", tmpRecord.cdiDesc, null)  as message), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.cdiDesc = userInput
					if("notes")
						var/userInput = copytext(sanitize(input("Please summarize notes:", "Med. records", tmpRecord.medNotes, null)  as message), 1, MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.medNotes = userInput
					if("p_stat")
						temp = {"
							<B>Physical Condition:</B><BR>
							<A href='?src=\ref[src];temp=1;p_stat=deceased'>*Deceased*</A><BR>
							<A href='?src=\ref[src];temp=1;p_stat=ssd'>*SSD*</A><BR>
							<A href='?src=\ref[src];temp=1;p_stat=active'>Active</A><BR>
							<A href='?src=\ref[src];temp=1;p_stat=unfit'>Physically Unfit</A><BR>
							<A href='?src=\ref[src];temp=1;p_stat=disabled'>Disabled</A><BR>"}
					if("m_stat")
						temp = {"
							<B>Mental Condition:</B><BR>
							<A href='?src=\ref[src];temp=1;m_stat=insane'>*Insane*</A><BR>
							<A href='?src=\ref[src];temp=1;m_stat=unstable'>*Unstable*</A><BR>
							<A href='?src=\ref[src];temp=1;m_stat=watch'>*Watch*</A><BR>
							<A href='?src=\ref[src];temp=1;m_stat=stable'>Stable</A><BR>"}
					if("b_type")
						temp = {"
							<B>Blood Type:</B><BR>
							<A href='?src=\ref[src];temp=1;b_type=an'>A-</A> <A href='?src=\ref[src];temp=1;b_type=ap'>A+</A><BR>
							<A href='?src=\ref[src];temp=1;b_type=bn'>B-</A> <A href='?src=\ref[src];temp=1;b_type=bp'>B+</A><BR>
							<A href='?src=\ref[src];temp=1;b_type=abn'>AB-</A> <A href='?src=\ref[src];temp=1;b_type=abp'>AB+</A><BR>
							<A href='?src=\ref[src];temp=1;b_type=on'>O-</A> <A href='?src=\ref[src];temp=1;b_type=op'>O+</A><BR>"}
					if("b_dna")
						var/userInput = copytext(sanitize(input("Please input DNA hash:", "Med. records", tmpRecord.bDNA, null)  as text),1,MAX_MESSAGE_LEN)
						if (!userInput || !authenticated || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))))
							return
						tmpRecord.bDNA = userInput

			if (href_list["p_stat"])
				if (activeRecord)
					switch(href_list["p_stat"])
						if("deceased")
							activeRecord.pStat = "*Deceased*"
						if("ssd")
							activeRecord.pStat = "*SSD*"
						if("active")
							activeRecord.pStat = "Active"
						if("unfit")
							activeRecord.pStat = "Physically Unfit"
						if("disabled")
							activeRecord.pStat = "Disabled"

			if (href_list["m_stat"])
				if (activeRecord)
					switch(href_list["m_stat"])
						if("insane")
							activeRecord.mStat = "*Insane*"
						if("unstable")
							activeRecord.mStat = "*Unstable*"
						if("watch")
							activeRecord.mStat = "*Watch*"
						if("stable")
							activeRecord.mStat = "Stable"

			if (href_list["b_type"])
				if (activeRecord)
					switch(href_list["b_type"])
						if("an")
							activeRecord.bType = "A-"
						if("bn")
							activeRecord.bType = "B-"
						if("abn")
							activeRecord.bType = "AB-"
						if("on")
							activeRecord.bType = "O-"
						if("ap")
							activeRecord.bType = "A+"
						if("bp")
							activeRecord.bType = "B+"
						if("abp")
							activeRecord.bType = "AB+"
						if("op")
							activeRecord.bType = "O+"

			if (href_list["d_rec"])
				var/datum/record/r = locate(href_list["d_rec"])
				if (!dataCore.allRecords.Find(r))
					temp = "Record Not Found!"
					return
				activeRecord = r
				src.screen = 4

			if (href_list["search"])
				var/t1 = input("Search String: (Name, DNA, or ID)", "Med. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( src.authenticated ) || usr.restrained() || ((!in_range(src, usr)) && (!istype(usr, /mob/living/silicon)))))
					return
				activeRecord = null
				t1 = lowertext(t1)
				for(var/datum/record/r in dataCore.allRecords)
					if ((lowertext(r.name) == t1 || t1 == lowertext(r.id) || t1 == lowertext(r.bDNA)))
						activeRecord = r
				if (!activeRecord)
					src.temp = text("Could not locate record [].", t1)
				else
					for(var/datum/record/e in dataCore.allRecords)
						if ((e.name == activeRecord.name || e.id == activeRecord.id))
							activeRecord = e
					screen = SELECTED_RECORD_MENU

			if (href_list["print_p"])
				if (!( src.printing ))
					src.printing = 1
					sleep(50)
					var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( src.loc )
					P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
					if ((istype(activeRecord, /datum/record) && dataCore.allRecords.Find(activeRecord)))
						P.info += "Name: [activeRecord.name] ID: [activeRecord.id]<BR>\n \
							Sex: [activeRecord.gender]<BR>\n \
							Age: [activeRecord.age]<BR>\n \
							Fingerprint: [activeRecord.fingerprint]<BR>\n \
							Physical Status: [activeRecord.pStat]<BR>\n \
							Mental Status: [activeRecord.mStat]<BR>"
					else
						P.info += "<B>General Record Lost!</B><BR>"
					if ((istype(activeRecord, /datum/record) && dataCore.allRecords.Find(activeRecord)))
						P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\n \
							Blood Type: [activeRecord.bType]<BR>\n \
							DNA: [activeRecord.bDNA]<BR>\n<BR>\n \
							Minor Disabilities: [activeRecord.minorDisability]<BR>\n \
							Details: [activeRecord.minorDisabilityDesc]<BR>\n<BR>\n \
							Major Disabilities: [activeRecord.majorDisability]<BR>\n \
							Details: [activeRecord.majorDisabilityDesc]<BR>\n<BR>\n \
							Allergies: [activeRecord.allergies]<BR>\n \
							Details: [activeRecord.allergiesDesc]<BR>\n<BR>\n \
							Current Diseases: [activeRecord.cdi] (per disease info placed in log/comment section)<BR>\n \
							Details: [activeRecord.cdiDesc]<BR>\n<BR>\n \
							Important Notes:<BR>\n\t[activeRecord.medNotes]<BR>\n"

					else
						P.info += "<B>Medical Record Lost!</B><BR>"
					P.info += "</TT>"
					P.name = "paper- 'Medical Record'"
					src.printing = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()

/obj/machinery/computer/med_data/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/record/r in dataCore.allRecords)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					r.name = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					r.gender = pick("Male", "Female")
				if(3)
					r.age = rand(5, 85)
				if(4)
					r.bType = pick("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
				if(5)
					r.pStat = pick("*SSD*", "Active", "Physically Unfit", "Disabled")
				if(6)
					r.mStat = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			del(r)
			continue

	..(severity)


/obj/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Nanotrasen Laptop."
	icon_state = "medlaptop"
