//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/med_data
	var/const/MAIN_MENU = 1
	var/const/RECORD_LIST_MENU = 2
	var/const/RECORD_MAINT_MENU = 3
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
	var/rank = null
	var/screen = null
	var/datum/record/activeRecord = null
	var/a_id = null
	var/temp = null
	var/printing = null

/obj/machinery/computer/med_data/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/med_data/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/med_data/attack_hand(mob/user as mob)
	if(..())
		return
	var/dat
	if (src.temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='?src=\ref[src];temp=1'>Clear Screen</A>"
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];scan=1'>[]</A><HR>", src, (src.scan ? text("[]", src.scan.name) : "----------"))
		if (src.authenticated)
			switch(screen)
				if(MAIN_MENU)
					dat += {"
						<A href='?src=\ref[src];search=1'>Search Records</A><BR>
						<A href='?src=\ref[src];screen=2'>List Records</A><BR>
						<BR>
						<A href='?src=\ref[src];screen=5'>Virus Database</A><BR>
						<A href='?src=\ref[src];screen=6'>Medbot Tracking</A><BR>
						<BR>
						<A href='?src=\ref[src];logout=1'>{Log Out}</A><BR>
						"}
				if(RECORD_LIST_MENU)
					dat += "<B>Record List</B>:<HR>"
					if(!isnull(dataCore.allRecords))
						for(var/datum/record/r in sortRecord(dataCore.allRecords))
							dat += text("<A href='?src=\ref[];d_rec=\ref[]'>[]: []<BR>", src, r, r.id, r.name)
							//Foreach goto(132)
					dat += text("<HR><A href='?src=\ref[];screen=1'>Back</A>", src)
				if(RECORD_MAINT_MENU)
					dat += text("<B>Records Maintenance</B><HR>\n<A href='?src=\ref[];back=1'>Backup To Disk</A><BR>\n<A href='?src=\ref[];u_load=1'>Upload From disk</A><BR>\n<A href='?src=\ref[];del_all=1'>Delete All Records</A><BR>\n<BR>\n<A href='?src=\ref[];screen=1'>Back</A>", src, src, src, src)
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
								<TD ROWSPAN=4 WIDTH=40%>
									<P><img src=front.png height=64 width=64 border=5><img src=side.png height=64 width=64 border=5></P>
								</TD>
								<TD WIDTH=60%>
									<P>Name: [activeRecord.name]</P>
								</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>
									<P>ID: [activeRecord.id]</P>
								</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>
									<P>Sex: <A href='?src=\ref[src];field=sex'>[activeRecord.gender]</A></P>
								</TD>
							</TR>
							<TR VALIGN=TOP>
								<TD WIDTH=60%>
									<P>Age: <A href='?src=\ref[src];field=age'>[activeRecord.age]</A></P>
								</TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>
									<P>Fingerprint: <A href='?src=\ref[src];field=fingerprint'>[activeRecord.fingerprint]</A></P>
								</TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>
									<P>Physical Status: <A href='?src=\ref[src];field=p_stat'>[activeRecord.pStat]</A></P>
								</TD>
							</TR>
							<TR>
								<TD COLSPAN=2 WIDTH=100% VALIGN=TOP>
									<P>Mental Status: <A href='?src=\ref[src];field=m_stat'>[activeRecord.mStat]</A></P>
								</TD>
							</TR>
						</TABLE>
					"}
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
						Important Notes:<BR>\n\t<A href='?src=\ref[src];field=notes'>[activeRecord.medNotes]</A><BR><BR>
					"}
					dat += "<A href='?src=\ref[src];print_p=1'>Print Record</A><BR>\n<A href='?src=\ref[src];screen=2'>Back</A><BR>"
				if(VIRUS_DB_MENU)
					dat += "<CENTER><B>Virus Database</B></CENTER>"
					for(var/Dt in typesof(/datum/disease/))
						var/datum/disease/Dis = new Dt(0)
						if(istype(Dis, /datum/disease/advance))
							continue // TODO (tm): Add advance diseases to the virus database which no one uses.
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

						if(M.z != src.z)	continue	//only find medibots on the same z-level as the computer
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
		else
			dat += text("<A href='?src=\ref[];login=1'>{Log In}</A>", src)
	user << browse(text("<HEAD><TITLE>Medical Records</TITLE></HEAD><TT>[]</TT>", dat), "window=med_rec")
	onclose(user, "med_rec")
	return

/obj/machinery/computer/med_data/Topic(href, href_list)
	if(..())
		return

	if (!( dataCore.allRecords.Find(activeRecord) ))
		activeRecord = null

	if (!( dataCore.allRecords.Find(activeRecord) ))
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
				rank = "AI"
				screen = 1

			else if (istype(usr, /mob/living/silicon/robot))
				activeRecord = null
				authenticated = usr.name
				var/mob/living/silicon/robot/R = usr
				rank = R.braintype
				screen = MAIN_MENU

			else if (istype(src.scan, /obj/item/weapon/card/id))
				activeRecord = null

				if (src.check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
					screen = MAIN_MENU

		if (authenticated)

			if(href_list["screen"])
				screen = text2num(href_list["screen"])
				if(screen < MAIN_MENU)
					src.screen = MAIN_MENU

				activeRecord= null

			if(href_list["vir"])
				var/type = href_list["vir"]
				var/datum/disease/Dis = new type(0)
				var/AfS = ""
				for(var/Str in Dis.affected_species)
					AfS += " [Str];"
				src.temp = {"<b>Name:</b> [Dis.name]
					<BR><b>Number of stages:</b> [Dis.max_stages]
					<BR><b>Spread:</b> [Dis.spread] Transmission
					<BR><b>Possible Cure:</b> [(Dis.cure||"none")]
					<BR><b>Affected Species:</b>[AfS]
					<BR>
					<BR><b>Notes:</b> [Dis.desc]
					<BR>
					<BR><b>Severity:</b> [Dis.severity]"}

			if (href_list["field"])
				var/a1 = activeRecord
				switch(href_list["field"])
					if("fingerprint")
						var/t1 = copytext(sanitize(input("Please input fingerprint hash:", "Med. records", activeRecord.fingerprint, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.fingerprint = t1
					if("sex")
						if (activeRecord.gender == "Male")
							activeRecord.gender = "Female"
						else
							activeRecord.gender = "Male"
					if("age")
						var/t1 = input("Please input age:", "Med. records", activeRecord.age, null)  as num
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.age = t1
					if("mi_dis")
						var/t1 = copytext(sanitize(input("Please input minor disabilities list:", "Med. records", activeRecord.minorDisability, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.minorDisability = t1
					if("mi_dis_d")
						var/t1 = copytext(sanitize(input("Please summarize minor dis.:", "Med. records", activeRecord.minorDisabilityDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.minorDisabilityDesc = t1
					if("ma_dis")
						var/t1 = copytext(sanitize(input("Please input major diabilities list:", "Med. records", activeRecord.majorDisability, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.majorDisability = t1
					if("ma_dis_d")
						var/t1 = copytext(sanitize(input("Please summarize major dis.:", "Med. records", activeRecord.majorDisabilityDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.majorDisabilityDesc = t1
					if("alg")
						var/t1 = copytext(sanitize(input("Please state allergies:", "Med. records", activeRecord.allergies, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.allergies = t1
					if("alg_d")
						var/t1 = copytext(sanitize(input("Please summarize allergies:", "Med. records", activeRecord.allergiesDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.allergiesDesc = t1
					if("cdi")
						var/t1 = copytext(sanitize(input("Please state diseases:", "Med. records", activeRecord.cdi, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.cdi = t1
					if("cdi_d")
						var/t1 = copytext(sanitize(input("Please summarize diseases:", "Med. records", activeRecord.cdiDesc, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.cdiDesc = t1
					if("notes")
						var/t1 = copytext(sanitize(input("Please summarize notes:", "Med. records", activeRecord.medNotes, null)  as message),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.medNotes = t1
					if("p_stat")
						temp = text("<B>Physical Condition:</B><BR>\n\t<A href='?src=\ref[];temp=1;p_stat=deceased'>*Deceased*</A><BR>\n\t<A href='?src=\ref[];temp=1;p_stat=ssd'>*SSD*</A><BR>\n\t<A href='?src=\ref[];temp=1;p_stat=active'>Active</A><BR>\n\t<A href='?src=\ref[];temp=1;p_stat=unfit'>Physically Unfit</A><BR>\n\t<A href='?src=\ref[];temp=1;p_stat=disabled'>Disabled</A><BR>", src, src, src, src, src)
					if("m_stat")
						temp = text("<B>Mental Condition:</B><BR>\n\t<A href='?src=\ref[];temp=1;m_stat=insane'>*Insane*</A><BR>\n\t<A href='?src=\ref[];temp=1;m_stat=unstable'>*Unstable*</A><BR>\n\t<A href='?src=\ref[];temp=1;m_stat=watch'>*Watch*</A><BR>\n\t<A href='?src=\ref[];temp=1;m_stat=stable'>Stable</A><BR>", src, src, src, src)
					if("b_type")
						temp = text("<B>Blood Type:</B><BR>\n\t<A href='?src=\ref[];temp=1;b_type=an'>A-</A> <A href='?src=\ref[];temp=1;b_type=ap'>A+</A><BR>\n\t<A href='?src=\ref[];temp=1;b_type=bn'>B-</A> <A href='?src=\ref[];temp=1;b_type=bp'>B+</A><BR>\n\t<A href='?src=\ref[];temp=1;b_type=abn'>AB-</A> <A href='?src=\ref[];temp=1;b_type=abp'>AB+</A><BR>\n\t<A href='?src=\ref[];temp=1;b_type=on'>O-</A> <A href='?src=\ref[];temp=1;b_type=op'>O+</A><BR>", src, src, src, src, src, src, src, src)
					if("b_dna")
						var/t1 = copytext(sanitize(input("Please input DNA hash:", "Med. records", activeRecord.bDNA, null)  as text),1,MAX_MESSAGE_LEN)
						if ((!( t1 ) || !( src.authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || activeRecord != a1))
							return
						activeRecord.bDNA = t1

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
					else
						//Foreach continue //goto(3229)
				if (!activeRecord)
					src.temp = text("Could not locate record [].", t1)
				else
					for(var/datum/record/e in dataCore.allRecords)
						if ((e.name == activeRecord.name || e.id == activeRecord.id))
							activeRecord = e
						else
							//Foreach continue //goto(3334)
					src.screen = 4

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
