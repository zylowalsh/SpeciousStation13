//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/skills//TODO:SANITY
	name = "Employment Records"
	desc = "Used to view personnel's employment records"
	icon_state = "medlaptop"
	req_one_access = list(access_heads)
	circuit = "/obj/item/weapon/circuitboard/skills"
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/record/active1 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending


/obj/machinery/computer/skills/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/weapon/card/id) && !scan)
		usr.drop_item()
		O.loc = src
		scan = O
		user << "You insert [O]."
	..()

/obj/machinery/computer/skills/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/skills/attack_paw(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/skills/attack_hand(mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	var/dat

	if (temp)
		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];choice=Confirm Identity'>[]</A><HR>", src, (scan ? text("[]", scan.name) : "----------"))
		if (authenticated)
			switch(screen)
				if(1.0)
					dat += {"<p style='text-align:center;'>"}
					dat += text("<A href='?src=\ref[];choice=Search Records'>Search Records</A><BR>", src)
					dat += text("<A href='?src=\ref[];choice=New Record (General)'>New Record</A><BR>", src)
					dat += {"
						</p>
						<table style="text-align:center;" cellspacing="0" width="100%">
						<tr>
						<th>Records:</th>
						</tr>
						</table>
						<table style="text-align:center;" border="1" cellspacing="0" width="100%">
						<tr>
						<th><A href='?src=\ref[src];choice=Sorting;sort=name'>Name</A></th>
						<th><A href='?src=\ref[src];choice=Sorting;sort=id'>ID</A></th>
						<th><A href='?src=\ref[src];choice=Sorting;sort=rank'>Rank</A></th>
						<th><A href='?src=\ref[src];choice=Sorting;sort=fingerprint'>Fingerprints</A></th>
						</tr>"}
					if(!isnull(dataCore.allRecords))
						for(var/datum/record/R in sortRecord(dataCore.allRecords, sortBy, order))
							for(var/datum/record/E in dataCore.allRecords)
							var/background
							dat += "<tr style=[background]><td><A href='?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.name]</a></td>"
							dat += "<td>[R.id]</td>"
							dat += "<td>[R.rank]</td>"
							dat += "<td>[R.fingerprint]</td>"
						dat += "</table><hr width='75%' />"
					dat += "<A href='?src=\ref[src];choice=Record Maintenance'>Record Maintenance</A><br><br>"
					dat += "<A href='?src=\ref[src];choice=Log Out'>{Log Out}</A>"
				if(2.0)
					dat += "<B>Records Maintenance</B><HR>"
					dat += "<BR><A href='?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='?src=\ref[src];choice=Return'>Back</A>"
				if(3.0)
					dat += "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(active1, /datum/record) && dataCore.allRecords.Find(active1)))
						var/icon/front = new(active1.photo, dir = SOUTH)
						var/icon/side = new(active1.photo, dir = WEST)
						user << browse_rsc(front, "front.png")
						user << browse_rsc(side, "side.png")
						dat += text("<table><tr><td>	\
							Name: <A href='?src=\ref[src];choice=Edit Field;field=name'>[active1.name]</A><BR> \
							ID: <A href='?src=\ref[src];choice=Edit Field;field=id'>[active1.id]</A><BR>\n	\
							Sex: <A href='?src=\ref[src];choice=Edit Field;field=sex'>[active1.gender]</A><BR>\n	\
							Age: <A href='?src=\ref[src];choice=Edit Field;field=age'>[active1.age]</A><BR>\n	\
							Rank: <A href='?src=\ref[src];choice=Edit Field;field=rank'>[active1.rank]</A><BR>\n	\
							Fingerprint: <A href='?src=\ref[src];choice=Edit Field;field=fingerprint'>[active1.fingerprint]</A><BR>\n	\
							Physical Status: [active1.pStat]<BR>\n	\
							Mental Status: [active1.mStat]<BR><BR>\n	\
							Employment/skills summary:<BR> [active1.generalNotes]<BR></td>	\
							<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4>	\
							<img src=side.png height=80 width=80 border=4></td></tr></table>")
					else
						dat += "<B>General Record Lost!</B><BR>"
					dat += "\n<A href='?src=\ref[src];choice=Delete Record (ALL)'>Delete Record (ALL)</A><BR><BR>\n \
					<A href='?src=\ref[src];choice=Print Record'>Print Record</A><BR>\n \
					<A href='?src=\ref[src];choice=Return'>Back</A><BR>"
				if(4.0)
					if(!Perp.len)
						dat += "ERROR.  String could not be located.<br><br><A href='?src=\ref[src];choice=Return'>Back</A>"
					else
						dat += {"
							<table style="text-align:center;" cellspacing="0" width="100%">
							<tr>"}
						dat += "<th>Search Results for '[tempname]':</th>"
						dat += {"
							</tr>
							</table>
							<table style="text-align:center;" border="1" cellspacing="0" width="100%">
							<tr>
							<th>Name</th>
							<th>ID</th>
							<th>Rank</th>
							<th>Fingerprints</th>
							</tr>					"}
						for(var/i=1, i<=Perp.len, i += 2)
							var/crimStat = ""
							var/datum/record/R = Perp[i]
							if(istype(Perp[i+1],/datum/record/))
								var/datum/record/E = Perp[i+1]
								crimStat = E.criminal
							var/background = "'background-color:#00FF7F;'"
							dat += "<tr style=[background]><td><A href='?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.name]</a></td>"
							dat += "<td>[R.id]</td>"
							dat += "<td>[R.rank]</td>"
							dat += "<td>[R.fingerprint]</td>"
							dat += "<td>[crimStat]</td></tr>"
						dat += "</table><hr width='75%' />"
						dat += "<br><A href='?src=\ref[src];choice=Return'>Return to index.</A>"
		else
			dat += "<A href='?src=\ref[src];choice=Log In'>{Log In}</A>"
	user << browse("<HEAD><TITLE>Employment Records</TITLE></HEAD><TT>[dat]</TT>", "window=secure_rec;size=600x400")
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/machinery/computer/skills/Topic(href, href_list)
	if(..())
		return
	if (!( dataCore.allRecords.Find(active1) ))
		active1 = null
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
				screen = 1
				active1 = null

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
				active1 = null

			if("Log In")
				if (istype(usr, /mob/living/silicon/ai))
					src.active1 = null
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if (istype(usr, /mob/living/silicon/robot))
					src.active1 = null
					src.authenticated = usr.name
					var/mob/living/silicon/robot/R = usr
					src.rank = R.braintype
					src.screen = 1
				else if (istype(scan, /obj/item/weapon/card/id))
					active1 = null
					if(check_access(scan))
						authenticated = scan.registered_name
						rank = scan.assignment
						screen = 1
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Fingerprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || !in_range(src, usr)))
					return
				Perp = new/list()
				t1 = lowertext(t1)
				var/list/components = text2list(t1, " ")
				if(components.len > 5)
					return //Lets not let them search too greedily.
				for(var/datum/record/R in dataCore.allRecords)
					var/temptext = R.name + " " + R.id + " " + R.fingerprint + " " + R.rank
					for(var/i = 1, i<=components.len, i++)
						if(findtext(temptext,components[i]))
							var/prelist = new/list(2)
							prelist[1] = R
							Perp += prelist
				for(var/i = 1, i<=Perp.len, i+=2)
					for(var/datum/record/E in dataCore.allRecords)
						var/datum/record/R = Perp[i]
						if ((E.name == R.name && E.id == R.id))
							Perp[i+1] = E
				tempname = t1
				screen = 4

			if("Record Maintenance")
				screen = 2
				active1 = null

			if ("Browse Record")
				var/datum/record/R = locate(href_list["d_rec"])
				if (!( dataCore.allRecords.Find(R) ))
					temp = "Record Not Found!"
				else
					for(var/datum/record/E in dataCore.allRecords)
					active1 = R
					screen = 3

/*			if ("Search Fingerprints")
				var/t1 = input("Search String: (Fingerprint)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || (!in_range(src, usr)) && (!istype(usr, /mob/living/silicon))))
					return
				active1 = null
				t1 = lowertext(t1)
				for(var/datum/record/R in dataCore.general)
					if (lowertext(R.fields["fingerprint"]) == t1)
						active1 = R
				if (!( active1 ))
					temp = text("Could not locate record [].", t1)
				else
					for(var/datum/record/E in dataCore.security)
						if ((E.fields["name"] == active1.fields["name"] || E.fields["id"] == active1.fields["id"]))
					screen = 3	*/

			if ("Print Record")
				if (!( printing ))
					printing = 1
					sleep(50)
					var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( loc )
					P.info = "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(active1, /datum/record) && dataCore.allRecords.Find(active1)))
						P.info += "Name: [active1.name] ID: [active1.id]<BR>\n \
							Sex: [active1.gender]<BR>\n \
							Age: [active1.age]<BR>\n \
							Fingerprint: [active1.fingerprint]<BR>\n \
							Physical Status: [active1.pStat]<BR>\n \
							Mental Status: [active1.mStat]<BR>\n \
							Employment/Skills Summary: [active1.generalNotes]<BR>"
					else
						P.info += "<B>General Record Lost!</B><BR>"
					P.info += "</TT>"
					P.name = "paper - 'Employment Record'"
					printing = null
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Employment records?<br>"
				temp += "<a href='?src=\ref[src];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='?src=\ref[src];choice=Clear Screen'>No</a>"

			if ("Purge All Records")
				for(var/datum/record/R in dataCore.allRecords)
					del(R)
				temp = "All Employment records deleted."

			if ("Delete Record (ALL)")
				if (active1)
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='?src=\ref[src];choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='?src=\ref[src];choice=Clear Screen'>No</a>"
//RECORD CREATE
			if ("New Record (General)")
				var/datum/record/G = new /datum/record()
				G.name = "New Record"
				G.id = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
				G.rank = "Unassigned"
				G.realRank = "Unassigned"
				G.gender = "Male"
				G.age = "Unknown"
				G.fingerprint = "Unknown"
				G.pStat = "Active"
				G.mStat = "Stable"
				G.species = "Human"

				dataCore.allRecords += G
				active1 = G

//FIELD FUNCTIONS
			if ("Edit Field")
				var/a1 = active1
				switch(href_list["field"])
					if("name")
						if (istype(active1, /datum/record))
							var/t1 = input("Please input name:", "Secure. records", active1.name, null)  as text
							if ((!( t1 ) || !length(trim(t1)) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon)))) || active1 != a1)
								return
							active1.name = t1
					if("id")
						if (istype(active1, /datum/record))
							var/t1 = copytext(sanitize(input("Please input id:", "Secure. records", active1.id, null)  as text),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.id = t1
					if("fingerprint")
						if (istype(active1, /datum/record))
							var/t1 = copytext(sanitize(input("Please input fingerprint hash:", "Secure. records", active1.fingerprint, null)  as text),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.fingerprint = t1
					if("sex")
						if (istype(active1, /datum/record))
							if (active1.gender == "Male")
								active1.gender = "Female"
							else
								active1.gender = "Male"
					if("age")
						if (istype(active1, /datum/record))
							var/t1 = input("Please input age:", "Secure. records", active1.age, null)  as num
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.age = t1
					if("rank")
						var/list/L = list( "Head of Personnel", "Captain", "AI" )
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
						if ((istype(active1, /datum/record) && L.Find(rank)))
							temp = "<h5>Rank:</h5>"
							temp += "<ul>"
							for(var/rank in get_all_jobs())
								temp += "<li><a href='?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
							temp += "</ul>"
						else
							alert(usr, "You do not have the required rank to do this!")
					if("species")
						if (istype(active1, /datum/record))
							var/t1 = copytext(sanitize(input("Please enter race:", "General records", active1.species, null)  as message),1,MAX_MESSAGE_LEN)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.species = t1

//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list["choice"])
					if ("Change Rank")
						if (active1)
							active1.rank = href_list["rank"]
							if(href_list["rank"] in get_all_jobs())
								active1.realRank = href_list["real_rank"]

					if ("Delete Record (ALL) Execute")
						if (active1)
							for(var/datum/record/R in dataCore.allRecords)
								if ((R.name == active1.name || R.id == active1.id))
									del(R)
								else
							del(active1)
					else
						temp = "This function does not appear to be working at the moment. Our apologies."

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/skills/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/record/R in dataCore.allRecords)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.name = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					R.gender = pick("Male", "Female")
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