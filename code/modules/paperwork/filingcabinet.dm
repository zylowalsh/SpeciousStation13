/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = 1
	anchored = 1


/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/weapon/paper) || istype(I, /obj/item/weapon/folder) || istype(I, /obj/item/weapon/photo))
			I.loc = src


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/paper) || istype(P, /obj/item/weapon/folder) || istype(P, /obj/item/weapon/photo))
		user << "<span class='notice'>You put [P] in [src].</span>"
		user.drop_item()
		P.loc = src
		icon_state = "[initial(icon_state)]-open"
		sleep(5)
		icon_state = initial(icon_state)
		updateUsrDialog()
	else if(istype(P, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user << "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>"
	else
		user << "<span class='notice'>You can't put [P] in [src]!</span>"


/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(contents.len <= 0)
		user << "<span class='notice'>\The [src] is empty.</span>"
		return

	user.set_machine(src)
	var/dat = "<center><table>"
	var/i
	for(i=contents.len, i>=1, i--)
		var/obj/item/P = contents[i]
		dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=350x300")

	return


/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		usr << browse("", "window=filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(P && in_range(src, usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = "[initial(icon_state)]-open"
			sleep(5)
			icon_state = initial(icon_state)


/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = TRUE

/obj/structure/filingcabinet/security/attack_hand(mob/user as mob)
	if(virgin)
		for(var/datum/record/G in dataCore.allRecords)
			var/datum/record/S
			for(var/datum/record/R in dataCore.allRecords)
				if((R.name == G.name || R.id == G.id))
					S = R
					break
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src)
			P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
			P.info += "Name: [G.name] ID: [G.id]<BR>\n \
				Sex: [G.gender]<BR>\n \
				Age: [G.age]<BR>\n \
				Fingerprint: [G.fingerprint]<BR>\n \
				Physical Status: [G.pStat]<BR>\n \
				Mental Status: [G.mStat]<BR>"
			P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\n \
				Criminal Status: [S.criminal]<BR>\n \<BR>\n \
				Minor Crimes: [S.minorCrimes]<BR>\n \
				Details: [S.minorCrimesDesc]<BR>\n<BR>\n \
				Major Crimes: [S.majorCrimes]<BR>\n \
				Details: [S.majorCrimesDesc]<BR>\n<BR>\n \
				Important Notes:<BR>\n\t[S.secNotes]<BR>"
			P.info += "</TT>"
			P.name = "paper - '[G.name]'"
			virgin = FALSE	//tabbing here is correct- it's possible for people to try and use it
							//before the records have been generated, so we do this inside the loop.
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/attack_hand(mob/user as mob)
	if(virgin)
		for(var/datum/record/G in dataCore.allRecords)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(src)
			P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
			P.info += "Name: [G.name] ID: [G.id]<BR>\n \
				Sex: [G.gender]<BR>\n \
				Age: [G.age]<BR>\n \
				Fingerprint: [G.fingerprint]<BR>\n \
				Physical Status: [G.pStat]<BR>\n \
				Mental Status: [G.mStat]<BR>"
			P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\n \
				Blood Type: [G.bType]<BR>\n \
				DNA: [G.bDNA]<BR>\n<BR>\n \
				Minor Disabilities: [G.minorDisability]<BR>\n \
				Details: [G.minorDisabilityDesc]<BR>\n<BR>\n \
				Major Disabilities: [G.majorDisability]<BR>\n \
				Details: [G.majorDisabilityDesc]<BR>\n<BR>\n \
				Allergies: [G.allergies]<BR>\n \
				Details: [G.allergiesDesc]<BR>\n<BR>\n \
				Current Diseases: [G.cdi] (per disease info placed in log/comment section)<BR>\n \
				Details: [G.cdiDesc]<BR>\n<BR>\n \
				Important Notes:<BR>\n\t[G.medNotes]<BR>"

			P.info += "</TT>"
			P.name = "paper - '[G.name]'"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.
	..()
