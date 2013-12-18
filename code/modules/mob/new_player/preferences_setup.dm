datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		if(H)
			if(H.gender == MALE)
				gender = MALE
			else
				gender = FEMALE
		sTone = random_skin_tone()
		hStyle = random_hair_style(gender, species)
		fStyle = random_facial_hair_style(gender, species)
		randomize_hair_color("hair")
		randomize_hair_color("facial")
		randomize_eyes_color()
		underwear = rand(1,underwear_m.len)
		backbag = 2
		age = rand(AGE_MIN, AGE_MAX)
		if(H)
			copy_to(H,1)


	proc/randomize_hair_color(var/target = "hair")
		if(prob (75) && target == "facial") // Chance to inherit hair color
			rFacial = rHair
			gFacial = gHair
			bFacial = bHair
			return

		var/red
		var/green
		var/blue

		var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
		switch(col)
			if("blonde")
				red = 255
				green = 255
				blue = 0
			if("black")
				red = 0
				green = 0
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 51
			if("copper")
				red = 255
				green = 153
				blue = 0
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("wheat")
				red = 255
				green = 255
				blue = 153
			if("old")
				red = rand (100, 255)
				green = red
				blue = red
			if("punk")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		switch(target)
			if("hair")
				rHair = red
				gHair = green
				bHair = blue
			if("facial")
				rFacial = red
				gFacial = green
				bFacial = blue

	proc/randomize_eyes_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		rEyes = red
		gEyes = green
		bEyes = blue


	proc/update_preview_icon()		//seriously. This is horrendous.
		del(previewIconFront)
		del(previewIconSide)
		var/icon/preview_icon = null

		var/g = "m"
		if(gender == FEMALE)	g = "f"

		var/icon/icobase
		var/datum/species/current_species = all_species[species]

		if(current_species)
			icobase = current_species.icobase
		else
			icobase = 'icons/mob/human_races/r_human.dmi'

		preview_icon = new /icon(icobase, "torso_[g]")
		preview_icon.Blend(new /icon(icobase, "groin_[g]"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "head_[g]"), ICON_OVERLAY)

		for(var/name in list("l_arm","r_arm","l_leg","r_leg","l_foot","r_foot","l_hand","r_hand"))
			// make sure the organ is added to the list so it's drawn
			if(organData[name] == null)
				organData[name] = null

		for(var/name in organData)
			if(organData[name] == "amputated")
				continue

			var/icon/temp = new /icon(icobase, "[name]")
			if(organData[name] == "cyborg")
				temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))

			preview_icon.Blend(temp, ICON_OVERLAY)

		// Skin tone
		if(current_species && (current_species.flags & HAS_SKIN_TONE))
			if (sTone >= 0)
				preview_icon.Blend(rgb(sTone, sTone, sTone), ICON_ADD)
			else
				preview_icon.Blend(rgb(-sTone,  -sTone,  -sTone), ICON_SUBTRACT)

		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
		eyes_s.Blend(rgb(rEyes, gEyes, bEyes), ICON_ADD)

		var/datum/sprite_accessory/hair_style = hair_styles_list[hStyle]
		if(hair_style)
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair_s.Blend(rgb(rHair, gHair, bHair), ICON_ADD)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[fStyle]
		if(facial_hair_style)
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.Blend(rgb(rFacial, gFacial, bFacial), ICON_ADD)
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		var/icon/clothes_s = null
		if(jobCivilianLow & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(jobCivilianHigh)//I hate how this looks, but there's no reason to go through this switch if it's empty
			switch(jobCivilianHigh)
				if(HOP)
					clothes_s = new /icon('icons/mob/uniform.dmi', "hop_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "helmet"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(BARTENDER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "ba_suit_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(BOTANIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "hydroponics_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "ggloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "apron"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-hyd"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHEF)
					clothes_s = new /icon('icons/mob/uniform.dmi', "chef_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "chef"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(JANITOR)
					clothes_s = new /icon('icons/mob/uniform.dmi', "janitor_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(LIBRARIAN)
					clothes_s = new /icon('icons/mob/uniform.dmi', "red_suit_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(QUARTERMASTER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "qm_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sun"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "clipboard"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CARGOTECH)
					clothes_s = new /icon('icons/mob/uniform.dmi', "cargotech_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(MINER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "miner_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(LAWYER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "internalaffairs_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "briefcase"), ICON_UNDERLAY)

					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHAPLAIN)
					clothes_s = new /icon('icons/mob/uniform.dmi', "chapblack_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CLOWN)
					clothes_s = new /icon('icons/mob/uniform.dmi', "clown_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "clown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "clown"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "clownpack"), ICON_OVERLAY)
				if(MIME)
					clothes_s = new /icon('icons/mob/uniform.dmi', "mime_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "lgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "mime"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "beret"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "suspenders"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(jobMedSciHigh)
			switch(jobMedSciHigh)
				if(RD)
					clothes_s = new /icon('icons/mob/uniform.dmi', "director_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "clipboard"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(SCIENTIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "toxinswhite_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHEMIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "chemistrywhite_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-chem"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CMO)
					clothes_s = new /icon('icons/mob/uniform.dmi', "cmo_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_lefthand.dmi', "firstaid"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(DOCTOR)
					clothes_s = new /icon('icons/mob/uniform.dmi', "medical_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_lefthand.dmi', "firstaid"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(GENETICIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "geneticswhite_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-gen"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(VIROLOGIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "virologywhite_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "sterile"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-vir"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ROBOTICIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', "robotics_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "toolbox_blue"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(jobEngSecHigh)
			switch(jobEngSecHigh)
				if(CAPTAIN)
					clothes_s = new /icon('icons/mob/uniform.dmi', "captain_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "captain"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sun"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "caparmor"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-cap"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(HOS)
					clothes_s = new /icon('icons/mob/uniform.dmi', "hosred_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(WARDEN)
					clothes_s = new /icon('icons/mob/uniform.dmi', "warden_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(DETECTIVE)
					clothes_s = new /icon('icons/mob/uniform.dmi', "detective_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "detective"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "detective"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(OFFICER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "secred_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "helmet"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHIEF)
					clothes_s = new /icon('icons/mob/uniform.dmi', "chief_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_white"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ENGINEER)
					clothes_s = new /icon('icons/mob/uniform.dmi', "engine_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "orange"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_yellow"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ATMOSTECH)
					clothes_s = new /icon('icons/mob/uniform.dmi', "atmos_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

				if(AI)//Gives AI and borgs assistant-wear, so they can still customize their character
					clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(backbag == 2)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
					else if(backbag == 3 || backbag == 4)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CYBORG)
					clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(backbag == 2)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
					else if(backbag == 3 || backbag == 4)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon('icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)
		if(clothes_s)
			preview_icon.Blend(clothes_s, ICON_OVERLAY)
		previewIconFront = new(preview_icon, dir = SOUTH)
		previewIconSide = new(preview_icon, dir = WEST)

		del(preview_icon)
		del(eyes_s)
		del(clothes_s)